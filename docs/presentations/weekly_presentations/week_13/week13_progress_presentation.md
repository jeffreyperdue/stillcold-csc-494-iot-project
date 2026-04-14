---
marp: true
theme: default
paginate: true
backgroundColor: #fff
style: |
  section {
    font-size: 28px;
  }
  h1, h2 {
    color: #1a365d;
  }
  strong {
    color: #2c5282;
  }
  section img {
    max-height: 70vh;
    max-width: 100%;
    width: auto;
    height: auto;
    object-fit: contain;
  }
---

# **StillCold** — Week 13 Progress
## Sprint 2, Week 4: Single-MCU Migration

*Removing a board, a level shifter, and a communication protocol*

---

# Context: Where We Left Off

At the end of Week 12, the app was feature-complete against all Must and Should requirements.

The hardware was still the original two-MCU design:

- An **Arduino Nano** read the temperature/humidity sensor and sent data over a serial wire
- An **ESP32-C6** received that data and broadcast it over Bluetooth to the app
- A **logic level shifter** sat between the two, translating voltage levels

**The plan for Week 13:** eliminate the Nano, the level shifter, and the wire between them — and have the ESP32-C6 do it all.

---
<style scoped>section { font-size: 115%; }</style>
# Why Simplify to One MCU?

The original two-board design was a practical starting point, but it carried unnecessary complexity:

| Problem | Detail |
|---------|--------|
| Voltage mismatch | The Nano runs at 5 V; the sensor runs at 3.3 V — requiring a level shifter |
| Extra component | The level shifter adds wiring, failure points, and cost |
| Redundant communication | The Nano formatted data as text and sent it over a wire; the ESP32 parsed it back |
| Unnecessary board | The Nano's only job was to read a sensor and send two numbers |

The ESP32-C6 is natively 3.3 V — the same voltage as the sensor. The level shifter and the Nano become unnecessary the moment you wire the sensor directly to the ESP32.

---

# The Goal: A Simpler Stack

**Before:**

```
HTU21D → Level Shifter → Arduino Nano → UART wire → ESP32-C6 → BLE → App
```

**After:**

```
HTU21D → ESP32-C6 → BLE → App
```

Four components become two. The app sees no difference — the same Bluetooth service, the same data format, the same behavior.

---

# Step 1: Identifying the Right Pins

The migration plan contained an error: it listed the wrong I²C pin numbers for the XIAO ESP32-C6.

The board's actual pinout was verified against the hardware diagram:

| Function | Header Label | GPIO Number |
|----------|-------------|-------------|
| SDA (data) | D4 | GPIO 22 |
| SCL (clock) | D5 | GPIO 23 |

This was caught before writing any firmware — which meant the sketch was correct from the first compile.

---

# Step 2: Writing the New Sketch

A single new sketch replaced both the Nano firmware and the ESP32 firmware.

Key design decisions:

- **`Wire.setPins(22, 23)`** is called before the sensor initializes — this is the correct way to assign I²C pins on the ESP32 Arduino core. Calling `Wire.begin(SDA, SCL)` instead would have been silently overwritten by the sensor library.
- **Error guard fixed** — the original Nano code used `isnan()` to detect bad sensor reads. The sensor library actually returns `998` or `999` as numeric values for errors — not NaN. The new sketch checks for both.
- **UART pipeline gone** — no string formatting, no serial parsing, no `T=XX.XX,H=XX.XX` framing. The sensor values go directly into the Bluetooth characteristics.

---

# Step 3: Flashing and First Validation
<style scoped>section { font-size: 115%; }</style>
The sketch was flashed to the ESP32-C6 **before touching any wiring** — this is intentional.

With the HTU21D not yet connected, the expected behavior is a read error on every cycle. Opening the Serial Monitor confirmed:

```
StillCold — ESP32-only starting...
BLE Ready.
HTU21D read error — skipping
HTU21D read error — skipping
HTU21D read error — skipping
```

This is a pass — it confirms the Bluetooth stack started correctly and the error guard fires as intended. The hardware can be rewired with confidence.

> **Note:** Getting the Serial Monitor working required enabling "USB CDC on Boot" in the Arduino IDE board settings — a non-obvious but one-time configuration step specific to the ESP32-C6's native USB interface.

---

# Step 4: Rewiring the Sensor

With everything powered down, the HTU21D was disconnected from the Nano and level shifter, and reconnected directly to the ESP32-C6.

| HTU21D Pin | Connects to |
|------------|-------------|
| VIN | ESP32-C6 3.3 V |
| GND | ESP32-C6 GND |
| SDA | ESP32-C6 D4 (GPIO 22) |
| SCL | ESP32-C6 D5 (GPIO 23) |

The Arduino Nano, logic level shifter, and all UART wiring were removed entirely.

**Total remaining connections:** 4 wires. One board. One power source.

---

# The New Setup

![The single-MCU StillCold hardware: XIAO ESP32-C6 and HTU21D sensor on a breadboard](images/stillcold_single_mcu.jpg)

---

# Step 5: Live Readings Confirmed

After rewiring, the Serial Monitor immediately showed live sensor data:

```
StillCold — ESP32-only starting...
BLE Ready.
T=23.54 C | H=60.09 %
T=23.53 C | H=59.90 %
T=23.52 C | H=59.76 %
T=23.50 C | H=59.77 %
```

Readings are stable, plausible, and updating every 2 seconds. The error guard is silent — the sensor is healthy.

---

# Step 6: Bluetooth Validation

**nRF Connect** (a Bluetooth diagnostic app) was used to verify the GATT service independently of the companion app:

- Device appeared in scan as **"STILLCOLD"**
- Connected successfully
- The custom service UUID (`12345678-...`) was present
- Reading each characteristic returned the current temperature and humidity values

This confirms the Bluetooth layer is functioning correctly before involving the Flutter app.

---

# Step 7: Companion App Validation

The Flutter companion app was tested against the new single-MCU hardware.

| Check | Result |
|-------|--------|
| App discovers "StillCold" during scan | ✅ Pass |
| App connects and displays live readings | ✅ Pass |
| Temperature and humidity values match Serial Monitor | ✅ Pass |
| Behavior equivalent to the two-MCU baseline | ✅ Pass |

**No app changes were required.** The Bluetooth service UUID, characteristic UUIDs, and value format are identical to the Sprint 1 design — the app never knew the Nano was there.

---

# What Was Eliminated
<style scoped>section { font-size: 115%; }</style>
| Removed | Why it's gone |
|---------|--------------|
| Arduino Nano | ESP32-C6 reads the sensor directly |
| Logic level shifter | ESP32-C6 and HTU21D are both 3.3 V — no translation needed |
| UART serial wire | No second board to communicate with |
| Serial receive logic (`Serial1`, `sscanf`) | Sensor data goes straight to BLE characteristics |
| `T=XX.XX,H=XX.XX` text protocol | Internal representation — no longer serialized |
| `isnan()`-only error guard | Replaced with correct `>= 998` check |

---

# Architecture: Before and After

**Before (two-MCU):**

```
HTU21D ──I²C──> Level Shifter ──I²C──> Nano ──UART──> ESP32-C6 ──BLE──> App
```

**After (single-MCU):**

```
HTU21D ──I²C (3.3 V)──> ESP32-C6 ──BLE──> App
```

The architecture document has been updated to reflect the new design, with all pin numbers filled in and all placeholder values resolved.

---

# Documentation Updated
<style scoped>section { font-size: 115%; }</style>
A new architecture document — `architecture_sprint2_single_mcu.md` — was created to capture the consolidated design.

It includes:

- Updated system diagram (Mermaid)
- Confirmed I²C pin assignments (GPIO 22 / GPIO 23)
- All BLE service and characteristic UUIDs (no more placeholders)
- Wiring table for the four-wire HTU21D connection
- Explanation of the `Wire.setPins()` approach and the error guard fix
- Simplified power section (one USB source, one board)
- Rollback instructions referencing the archived original sketches

The original two-MCU architecture document is preserved as the Sprint 2 Week 1 baseline.

---

# Week 13 Summary

| Area | Status |
|------|--------|
| Single-MCU firmware written and flashed | Done |
| I²C pin discrepancy identified and corrected | Done |
| Pre-rewire validation (BLE up, error guard fires) | Done |
| HTU21D rewired directly to ESP32-C6 | Done |
| Live serial readings confirmed | Done |
| Bluetooth validated via nRF Connect | Done |
| Flutter app behavior confirmed equivalent | Done |
| Architecture document updated | Done |
| Arduino Nano, level shifter, UART wiring | **Removed** |

---

# Looking Ahead

With the hardware consolidated, the remaining Sprint 2 items are:

**App (stretch):**
- Historical trend chart (7-day / 30-day)
- Data export

*The system is now simpler, more reliable, and easier to package.*

---

# Thank you

**StillCold** — *Environmental monitoring without opening the door*

Questions?
