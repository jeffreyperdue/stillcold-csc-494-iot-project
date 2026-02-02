# Sprint 1 – Week 1 Plan (Revised)

**Focus:** Hardware setup and verification

**README Traceability:** Aligns with Week 1 milestone — *"Hardware setup and verification, including sensor communication and microcontroller integration."* — and supports Sprint 1 testing goal of *"Sensor data acquisition verification."*

---

## Week 1 Objective (Restated Clearly)

By the end of Week 1, you should be able to confidently say:

> "The hardware is wired correctly, powered safely, and capable of producing real, trustworthy temperature data that I can observe and reason about."

No BLE yet. No Flutter yet. No optimization. This week is about establishing physical and electrical truth.

---

## 1. Hardware Assembly and Physical Validation

### 1.1 Assemble the Core Hardware Stack

**Components involved (Sprint 1 only):**

- ESP32-C6
- Arduino Nano
- HTU21D I²C temperature/humidity sensor
- Bidirectional logic level shifter
- Breadboard, jumper wires, pin headers
- USB power

**Actions:**

- Mount both MCUs on the breadboard in a way that keeps signal paths visible and traceable.
- Wire the HTU21D to the sensing MCU (Arduino Nano) using I²C:
  - SDA
  - SCL
  - VCC
  - GND
- Insert the logic level shifter between any 5 V and 3.3 V signal boundaries.
- Label or document every connection (even informally).

**Outcome checkpoint:** You can visually trace every wire and explain what it does without guessing.

---

## 2. Power and Voltage Sanity Checks

Before writing meaningful code, eliminate silent hardware failure modes.

**Actions:**

- Confirm:
  - Which MCU is running at 5 V vs 3.3 V
  - Sensor voltage requirements (HTU21D is 2.1–3.6 V; use 3.3 V)
- Power each MCU independently first.
- Power the full system only after verifying:
  - No excessive heat
  - No unexpected resets
  - Stable power delivery

**Outcome checkpoint:** Both MCUs power on reliably. No brownouts or unexplained resets.

---

## 3. Sensor Communication Verification (Critical Week 1 Task)

This is the single most important technical task of the week. Directly supports README: *"Sensor data acquisition verification — confirm that temperature readings are successfully retrieved from the internal sensor at regular intervals."*

### 3.1 I²C Detection

**Actions:**

- Use a minimal Arduino sketch to:
  - Initialize I²C
  - Scan for devices
  - Confirm the HTU21D appears at the expected I²C address (typically **0x40**).
- If this fails:
  - Do not proceed.
  - Debug wiring, pull-ups, voltage levels, and bus configuration first.

### 3.2 Raw Sensor Reading Validation

**Actions:**

- Read temperature and humidity values from the sensor (humidity is secondary per README but available from HTU21D).
- Print values to serial output.
- Take multiple readings over time.
- What you are checking for:
  - Values change when you:
    - Touch the sensor
    - Move it to a cooler/warmer environment
  - Values are plausible (not random, not fixed, not NaN).

**Outcome checkpoint:** You trust the numbers enough to say "this reflects reality."

---

## 4. Microcontroller Role Confirmation

Sprint 1 assumes clear separation of responsibilities per README architecture.

**Actions:**

- Decide and document:
  - **Sensing component:** Arduino Nano (interfaces with HTU21D, collects readings)
  - **Communication component:** ESP32-C6 (will expose data via BLE in Week 3)
- For Week 1:
  - The BLE MCU (ESP32-C6) can remain idle or run a placeholder sketch
  - Focus stays on sensing correctness

**Outcome checkpoint:** You can articulate why two MCUs exist and what each will do later. *"Microcontroller integration"* for Week 1 means sensing MCU + sensor; full inter-component integration is Week 2.

---

## 5. Observability and Debug Infrastructure

Aligns with README NFR: *"The system should be understandable and observable during development and testing."*

**Actions:**

- Ensure:
  - Serial output is clean, readable, and labeled
  - Sensor readings include timestamps or loop counters
- Optionally log:
  - Sensor read failures
  - Initialization status

**Outcome checkpoint:** You can "see" the system working without inference.

---

## 6. Week 1 Testing (Manual but Intentional)

Per README testing philosophy: *"Testing during Sprint 1 will primarily be manual and exploratory, using serial output ... and direct observation to confirm correct behavior."*

**Perform and document:**

- Sensor read success over several minutes
- Behavior when:
  - Power is disconnected and restored
  - Sensor is moved between environments

**Artifacts to capture:**

- Photos of the wired setup
- Serial output screenshots
- Notes on anything unexpected

---

## 7. Week 1 Deliverables (Concrete)

By the end of Week 1, you should have:

1. A fully wired and powered hardware prototype
2. Confirmed I²C communication with the HTU21D
3. Reliable temperature readings (and optionally humidity) observable via serial output
4. A short written summary:
   - What worked
   - What was confusing
   - What assumptions were validated or broken

This summary becomes the foundation for Week 2, where data starts flowing between system components.

---

## Coach's Reality Check

**If you do only one thing this week, do this:**

> Make the sensor boring.

Once temperature readings are boring and predictable, everything else in the project gets easier. If they are flaky, Sprint 2 will be painful.

---

## README Cross-Reference

| Plan Section                 | README Reference                                                |
|-----------------------------|-----------------------------------------------------------------|
| Hardware assembly           | §1 Hardware Components; §5 System Architecture                  |
| Sensor verification         | §6 Sprint 1 Testing — Sensor data acquisition verification      |
| MCU role separation         | §5 System Architecture — Sensing vs Communication components    |
| Observability               | §4 Sprint 1 NFR — "understandable and observable"               |
| Manual testing              | §6 "manual and exploratory ... serial output ... direct observation" |
