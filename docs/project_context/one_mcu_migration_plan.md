# StillCold — Single-MCU Migration Plan (ESP32-C6 Only)

> Assessed at Sprint 2. Corresponds to backlog item **X1**: "ESP32-only refactor (remove Nano; HTU21D direct to ESP32-C6)."

---

## 1. Viability Assessment

### What the current two-MCU split is actually doing

| Layer | Device | Responsibility |
|---|---|---|
| Sensing | Arduino Nano (5V) | I²C master → HTU21D; formats `T=XX.XX,H=XX.XX\n`; sends over UART TX at 9600 baud |
| Level translation | Bi-directional level shifter | Bridges 5V Nano I²C lines down to 3.3V for the HTU21D |
| Communication | ESP32-C6 (3.3V) | UART RX (GPIO17) → `sscanf` parse → update BLE GATT characteristics → re-advertise on disconnect |

The Nano is performing three trivial tasks: poll an I²C sensor, format two floats as a string, and send that string over a serial line. The level shifter exists solely because the Nano is a 5V device.

### Why the migration is fully viable

**1. The voltage mismatch problem disappears entirely.**
The HTU21D is a 3.3V I²C device. The Nano is 5V, so the level shifter is mandatory with it. The ESP32-C6 is natively 3.3V logic. Connecting the HTU21D directly to ESP32-C6 I²C pins requires zero level translation — one entire component is eliminated.

**2. The ESP32-C6 has hardware I²C (Wire.h).**
The SparkFun HTU21D library's `begin()` signature is `void begin(TwoWire &wirePort = Wire)` — it accepts any `TwoWire` instance and calls `wirePort.begin()` internally. It is already abstracted away from AVR. Its `library.properties` declares `architectures=*`.

**3. BLE and I²C coexist comfortably.**
The ESP32-C6 BLE stack runs in its own FreeRTOS task. A `loop()`-based sensor poll with `delay(2000)` does not interfere; the BLE stack is preemptive underneath.

**4. The entire UART pipeline becomes dead code.**
`Serial1`, the `incoming` string buffer, `sscanf`, and all the `T=/H=` framing are not needed. Sensor data can be written directly to BLE characteristic values without serializing to a string and parsing it back.

**5. The Flutter app requires zero changes.**
The BLE service UUID (`12345678-1234-1234-1234-1234567890ab`), both characteristic UUIDs, and the ASCII string value format (e.g. `"21.40"`) are defined entirely in the ESP32 firmware. As long as those are preserved, the app never knows the Nano was removed.

### Pre-existing bug to fix during migration

The current `stillcold_sensing_node.ino` uses `isnan()` to guard against bad sensor reads:

```cpp
if (isnan(temperature) || isnan(humidity)) {
    Serial.println("HTU21D read fail, skip");
    ...
}
```

The SparkFun HTU21D library returns **998** (I²C timeout) or **999** (bad CRC) as numeric float values — not `NaN`. `isnan(998.0f)` evaluates to `false`, so those error values propagate through to the BLE characteristics and the app would display `"998.00"`. The correct guard is shown in Phase 1, Step 1.3 below.

### What is eliminated vs. what is added

| Removed | Added / Changed |
|---|---|
| Arduino Nano (5V board) | Nothing — ESP32-C6 absorbs its role |
| Bi-directional logic level shifter | Nothing — voltage match is native |
| UART wiring (2 wires + shared GND across boards) | I²C wiring on same board (2 wires, already present) |
| `Serial1` UART receive logic | Direct `Wire`/I²C in main sketch |
| `sscanf` string parser | Direct float-to-`String` conversion |
| `incoming` string buffer | Nothing |
| `T=XX.XX,H=XX.XX\n` serial protocol | Nothing (internal representation only) |
| `isnan`-only error guard (buggy) | `>= 998` check (correct) |

---

## 2. Step-by-Step Migration Plan

### Phase 0 — Preparation

**Step 0.1 — Identify your ESP32-C6 board's default I²C pins.**
The ESP32-C6 silicon has flexible GPIO routing. The Arduino-ESP32 core default for most C6 dev boards is **SDA = GPIO6, SCL = GPIO7** (e.g. SparkFun Thing Plus C6). The Seeed XIAO ESP32-C6 uses GPIO5/GPIO6. Check your board's pinout diagram and confirm which physical header pins correspond to those GPIOs before writing any code.

**Step 0.2 — Confirm Arduino IDE board package.**
You need the `esp32` board package v3.x (by Espressif) installed via Boards Manager. Confirm you can select your board and successfully compile `stillcold_comm_node.ino` as-is before making any changes.

**Step 0.3 — Archive the working two-MCU firmware.**
Both `stillcold_sensing_node/` and `stillcold_comm_node/` are the known-good baseline. Do not modify them. They remain as rollback artifacts.

---

### Phase 1 — Create the new single-MCU sketch

**Step 1.1 — Create the sketch folder and file.**
Create `Arduino/stillcold_esp32_only/stillcold_esp32_only.ino`. This is a new file; it does not replace the existing sketches.

**Step 1.2 — Write the merged `setup()` block.**
Combine the BLE initialization from `stillcold_comm_node.ino` with the sensor initialization from `stillcold_sensing_node.ino`. Call `Wire.setPins()` with explicit pin arguments before `mySensor.begin()`. Do **not** call `Wire.begin(SDA, SCL)` — the SparkFun HTU21D library calls `Wire.begin()` internally with no arguments inside its own `begin()`, which would overwrite any pins set by a prior `Wire.begin(SDA, SCL)` call. `Wire.setPins()` (ESP32 Arduino core v3.x) stores the SDA/SCL values without initializing the bus, so the library's internal `Wire.begin()` picks them up correctly.

```cpp
#include <Wire.h>
#include <SparkFunHTU21D.h>
#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>

#define SDA_PIN 6   // confirm against your board pinout
#define SCL_PIN 7   // confirm against your board pinout

HTU21D mySensor;

BLECharacteristic *pTemperatureCharacteristic;
BLECharacteristic *pHumidityCharacteristic;
BLEServer *pServer;
bool deviceConnected = false;

class MyServerCallbacks : public BLEServerCallbacks {
  void onConnect(BLEServer* pServer) {
    deviceConnected = true;
    Serial.println("Client connected.");
  }
  void onDisconnect(BLEServer* pServer) {
    deviceConnected = false;
    Serial.println("Client disconnected. Restarting advertising...");
    BLEDevice::startAdvertising();
  }
};

void setup() {
  Serial.begin(115200);
  // Wire.setPins() stores the custom SDA/SCL before mySensor.begin() calls
  // Wire.begin() internally with no arguments. Calling Wire.begin(SDA, SCL)
  // here instead would be overwritten by that internal call on ESP32 Arduino core.
  Wire.setPins(SDA_PIN, SCL_PIN);
  mySensor.begin(Wire);
  delay(1000);
  Serial.println("StillCold — ESP32-only starting...");

  BLEDevice::init("StillCold");
  pServer = BLEDevice::createServer();
  pServer->setCallbacks(new MyServerCallbacks());

  BLEService *pService = pServer->createService("12345678-1234-1234-1234-1234567890ab");

  pTemperatureCharacteristic = pService->createCharacteristic(
    "abcd1234-5678-1234-5678-abcdef123456",
    BLECharacteristic::PROPERTY_READ
  );
  pHumidityCharacteristic = pService->createCharacteristic(
    "abcd5678-1234-5678-1234-abcdef654321",
    BLECharacteristic::PROPERTY_READ
  );

  pTemperatureCharacteristic->setValue("0.00");
  pHumidityCharacteristic->setValue("0.00");

  pService->start();

  BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID("12345678-1234-1234-1234-1234567890ab");
  pAdvertising->start();

  Serial.println("BLE Ready.");
}
```

**Step 1.3 — Write the merged `loop()` block with the error-code fix.**
Remove the UART ingestion pipeline entirely. Read the sensor directly and update BLE characteristics. Fix the `isnan`-only guard to also catch the library's numeric error codes.

```cpp
void loop() {
  float temperature = mySensor.readTemperature();
  float humidity    = mySensor.readHumidity();

  // Library returns 998 (I2C timeout) or 999 (bad CRC) as float — isnan() alone does not catch these.
  if (temperature >= 998 || humidity >= 998 || isnan(temperature) || isnan(humidity)) {
    Serial.println("HTU21D read error — skipping");
    delay(2000);
    return;
  }

  Serial.print("T="); Serial.print(temperature, 2);
  Serial.print(" C | H="); Serial.print(humidity, 2);
  Serial.println(" %");

  pTemperatureCharacteristic->setValue(String(temperature, 2).c_str());
  pHumidityCharacteristic->setValue(String(humidity, 2).c_str());

  delay(2000);
}
```

---

### Phase 2 — Bench validation (pre-rewire)

**Step 2.1 — Compile and flash the new sketch to the ESP32-C6 before touching any wiring.**
With the Nano and existing ESP32 connections still intact, flash `stillcold_esp32_only.ino` to the ESP32-C6 via USB. The BLE stack will start. Because the HTU21D is not yet wired to the ESP32-C6, `readTemperature()` will return 998 (I²C timeout) and the serial monitor will show "HTU21D read error — skipping" on every cycle. This is the expected result — it confirms the BLE side compiles correctly and the error guard fires as intended.

**Step 2.2 — Power everything down and rewire the HTU21D to the ESP32-C6.**

| HTU21D pin | Was connected to | Now connect to |
|---|---|---|
| VCC | Nano 3.3V out | ESP32-C6 3.3V pin |
| GND | Nano GND | ESP32-C6 GND |
| SDA | Level shifter LV → Nano A4 | ESP32-C6 SDA pin (e.g. GPIO6) directly |
| SCL | Level shifter LV → Nano A5 | ESP32-C6 SCL pin (e.g. GPIO7) directly |

Remove the Arduino Nano, level shifter, and all UART wiring. The only remaining connections on the ESP32-C6 are: USB power in, GND, SDA, SCL.

**Step 2.3 — Power on and verify the serial monitor.**
Expected output at ~2-second intervals:

```
StillCold — ESP32-only starting...
BLE Ready.
T=21.40 C | H=34.70 %
T=21.41 C | H=34.68 %
...
```

If you see repeated "HTU21D read error — skipping" messages, check:
- `SDA_PIN` / `SCL_PIN` constants match the actual wired GPIO numbers
- HTU21D VCC is receiving 3.3V (verify with a multimeter)
- Shared GND is confirmed between sensor and ESP32-C6

**Step 2.4 — Verify BLE with nRF Connect.**
Scan for "StillCold", connect, and read the temperature and humidity characteristics. Values should match what the serial monitor is showing. Disconnect and confirm the device re-appears in the scan list (advertising restart confirmed).

**Step 2.5 — Verify Flutter app compatibility.**
Open the Flutter app. It should discover StillCold, connect, and display live readings identically to Sprint 1 behavior. No app code changes are required — BLE service UUID, characteristic UUIDs, and value format are all unchanged.

---

### Phase 3 — Cold-environment validation

**Step 3.1 — Re-run cold-environment test scenarios against the single-MCU setup.**
Use the scenarios defined in `cold_env_test_scenarios (2).md` that were previously run against the two-MCU baseline (Sprint 2 Week 2). Specifically look for:

- Consistent I²C reads at low temperature (HTU21D is rated to −40°C; verify empirically)
- BLE advertising and connection stability inside a refrigerated enclosure
- Any change in error rate or reading cadence compared to the two-MCU baseline
- Brownout or reset behavior at cold temperatures

**Step 3.2 — Document results.**
Add a short markdown report under `docs/project_context/` noting single-MCU cold-environment behavior and any deviations from the two-MCU baseline results.

---

### Phase 4 — Cleanup and documentation

**Step 4.1 — Update the architecture document.**
Update `architecture_sprint2_week1.md` or create a new successor doc reflecting the simplified single-MCU architecture. The Mermaid diagram simplifies to:

```
HTU21D --I²C (3.3V)--> ESP32-C6 --BLE (GATT)--> Flutter App
```

Fill in the previously `[TODO]` SDA/SCL pin numbers now that they are confirmed. Remove the Nano, level shifter, and UART protocol sections.

**Step 4.2 — Retire or archive no-longer-relevant test sketches.**
The following sketches tested the two-MCU UART link and are not applicable to the single-MCU design:

- `sketch_initial/minimal_nano_transmitter.ino`
- `sketch_initial/minimal_esp32_receiver.ino`
- `nano_uart_test/nano_uart_test.ino`
- `esp32_uart_test/esp32_uart_test.ino`

Consider moving them to an `Arduino/archive/` subfolder to preserve the Sprint 1 development history without cluttering the active sketch tree.

**Step 4.3 — Update the Sprint 2 backlog.**
Mark backlog item **X1** ("ESP32-only refactor") as complete and record the Week 4 go/no-go decision outcome.

---

## 3. Rollback Plan

If the ESP32-only design proves unstable at any point, the rollback is:

1. Flash `stillcold_sensing_node.ino` back onto the Arduino Nano.
2. Flash `stillcold_comm_node.ino` back onto the ESP32-C6.
3. Reconnect the level shifter and UART wiring per the wiring recorded in `architecture_sprint2_week1.md`.
4. Confirm end-to-end behavior is restored before resuming any other Sprint 2 work.

Both original sketches remain untouched throughout this migration.
