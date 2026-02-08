# Sprint 1 – Week 2 Plan

**Focus:** Reliable temperature data acquisition and transfer between system components

**README Traceability:** Aligns with Week 2 milestone — *"Reliable temperature data acquisition and transfer between system components."* — and supports Sprint 1 testing goal of *"Inter-component data transfer — Verify that temperature data is correctly transmitted from the sensing component to the communication component."*

---

## Week 2 Objective (Restated Clearly)

By the end of Week 2, you should be able to confidently say:

> "Temperature (and optionally humidity) is collected reliably on the sensing board, and that data is successfully passed to the communication board. Data flows from sensor → sensing MCU → communication MCU; I can observe it at each step."

No BLE exposure yet. No Flutter yet. This week is about making the *internal* pipeline reliable and observable so that Week 3 can focus on exposing the same data over BLE.

---

## 1. Inter-Component Communication Channel

### 1.1 Choose and Wire the Link Between MCUs

**Context:** The sensing component (Arduino Nano) and the communication component (ESP32-C6) must exchange data. The README does not prescribe a protocol; choose one that is simple to implement and easy to debug.

**Typical option:** UART (Serial) between Nano and ESP32-C6 — one TX/RX pair, common ground, and optionally logic-level alignment if needed (Nano 5 V vs ESP32-C6 3.3 V).

**Actions:**

- Decide on the inter-MCU link (e.g. UART/Serial) and document the choice.
- Wire the link between the Arduino Nano and the ESP32-C6 (TX → RX, RX → TX, GND shared). Use a logic level shifter if crossing 5 V / 3.3 V boundaries.
- Power both MCUs and confirm neither board is damaged and there are no unexpected resets.

**Outcome checkpoint:** You can explain how the two boards are connected and why that connection is safe and correct.

---

### 1.2 Define a Simple Data Format

**Context:** The sensing component will send readings to the communication component. A minimal, parseable format keeps the system understandable and testable.

**Actions:**

- Define a simple text or binary format for "latest temperature" (and optionally humidity) that the Nano will send and the ESP32-C6 will receive (e.g. `T=21.5,H=45.2` or a small fixed struct).
- Document the format and any timing assumptions (e.g. one message per reading cycle).

**Outcome checkpoint:** The format is written down and both sides can be implemented against the same spec.

---

## 2. Reliable Temperature Collection (Sensing Component)

### 2.1 Scheduled Reading and Send

**Context:** Week 1 established that the Nano can read the HTU21D and print to Serial. Week 2 extends this so the Nano also sends the same data over the inter-MCU link on a schedule.

**Actions:**

- Keep (or refine) the existing sensor read loop on the Arduino Nano so temperature (and optionally humidity) is read at a regular interval.
- After each successful read, send the reading to the ESP32-C6 using the chosen protocol and format.
- Retain serial output for observability (e.g. print the same values you send, or a clear "sent" indicator).

**Outcome checkpoint:** The Nano periodically reads the sensor and transmits those readings to the ESP32-C6; you can see this in serial output from the Nano.

---

### 2.2 Error Handling and Observability

**Actions:**

- Handle sensor read failures gracefully (e.g. skip send, retry, or send a sentinel value) and make failures visible (e.g. serial message or counter).
- Ensure serial output remains readable so you can confirm "sensor read → format → send" without guessing.

**Outcome checkpoint:** You can tell from logs/serial whether the last reading succeeded or failed and whether it was sent.

---

## 3. Receiving and Holding Data (Communication Component)

### 3.1 Receive and Parse on the ESP32-C6

**Actions:**

- On the ESP32-C6, implement reception of the data sent by the Nano (e.g. read from UART, buffer until a complete message).
- Parse the agreed format and store the latest temperature (and optionally humidity) in memory (e.g. global variables or a small struct).

**Outcome checkpoint:** The ESP32-C6 receives messages from the Nano and updates its internal "latest reading" state.

---

### 3.2 Observability on the Communication Side

**Actions:**

- Expose the received data so you can verify correctness without BLE (e.g. print to USB serial when a new reading is received, or on a timer).
- Confirm that values on the ESP32-C6 match what the Nano is sending and that they update when the environment changes.

**Outcome checkpoint:** You can observe on the ESP32-C6 serial output that it is holding the same temperature values the Nano is sending; end-to-end data flow from sensor → Nano → ESP32-C6 is visible.

---

## 4. Integration and Sanity Checks

**Actions:**

- Run both boards together: Nano reading sensor and sending; ESP32-C6 receiving and storing (and printing).
- Verify over several minutes that values stay in sync and remain plausible (e.g. room temperature range).
- Test behavior when one board is reset (e.g. ESP32-C6 resets and starts receiving again; or Nano resets and ESP32-C6 continues with last value until new data arrives). Document what you observe.

**Outcome checkpoint:** Inter-component data transfer is working and repeatable; you have notes or screenshots showing sensor → Nano → ESP32-C6 consistency.

---

## 5. Week 2 Testing (Manual but Intentional)

Per README: *"Testing during Sprint 1 will primarily be manual and exploratory, using serial output ... and direct observation to confirm correct behavior."*

**Perform and document:**

- Temperature values match across Nano serial, Nano→ESP32-C6 transfer, and ESP32-C6 serial (or equivalent observability).
- Behavior when sensor is warmed/cooled (e.g. breath, different room).
- Behavior on power cycle or single-MCU reset.

**Artifacts to capture:**

- Serial output from both MCUs showing the same reading at both ends.
- Short notes on format choice, timing, and any surprises.

---

## 6. Week 2 Deliverables (Concrete)

By the end of Week 2, you should have:

1. A working inter-MCU link (wired and documented).
2. A defined and documented data format for temperature (and optionally humidity).
3. The Arduino Nano reading the sensor on a schedule and sending readings to the ESP32-C6.
4. The ESP32-C6 receiving, parsing, and storing the latest reading, with observable output (e.g. serial).
5. Evidence that data flows correctly from sensor → sensing component → communication component (e.g. serial logs, screenshots).
6. A short written summary: what worked, what was confusing, what assumptions were validated or broken.

This sets up Week 3, where the ESP32-C6 will expose the same stored reading via a BLE service and characteristic.

---

## Coach's Reality Check

**If you do only one thing this week, do this:**

> Get one number from the sensor to appear on both sides of the wire.

Once one temperature value flows reliably from Nano to ESP32-C6, the rest is formatting, scheduling, and polish. If the link is flaky or unobservable, Week 3 (BLE) will be much harder to debug.

---

## README Cross-Reference

| Plan Section                    | README Reference                                                                 |
|---------------------------------|-----------------------------------------------------------------------------------|
| Inter-component channel         | §5 System Architecture — Sensing vs Communication components; data flow         |
| Data format                     | §5 Data Model — temperature (and humidity); simple, human-readable               |
| Reliable collection             | §4 Sprint 1 FR — "periodically collect temperature"; §6 Sensor data acquisition  |
| Transfer verification           | §6 Sprint 1 Testing — Inter-component data transfer                              |
| Observability                   | §4 Sprint 1 NFR — "understandable and observable"                               |
| Manual testing                  | §6 "manual and exploratory ... serial output ... direct observation"            |
