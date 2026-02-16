# StillCold — Week 6 Execution Plan  
**Sprint 1 – Week 3 (BLE Implementation)**

## Objective

Implement a BLE service and readable temperature characteristic on the ESP32-C6, exposing the most recent temperature value to a nearby device.

This fulfills the Sprint 1 milestone:

> Week 3 — BLE service and characteristic implementation with readable temperature data

Validation tool for this week:  
**nRF Connect (mobile app)** — assumed installed on your phone.

---

# Overview of the Week

By the end of Week 6, you will have:

- A BLE server running on the ESP32-C6  
- A custom BLE service  
- A readable temperature characteristic  
- Verified discoverability and reconnection behavior  
- Confirmed real sensor values accessible over BLE  

This week completes the final link in the Sprint 1 data pipeline:

Sensor → Arduino Nano → ESP32-C6 → BLE → External Device

---

# Phase 0 — Baseline Confirmation (Before BLE Work)

**Time: 30–60 minutes**

Before writing BLE code:

1. Upload your current working ESP32-C6 firmware.
2. Confirm:
   - Nano sends temperature/humidity data.
   - ESP32 parses and stores it.
   - Serial Monitor updates reliably.
3. Let system run for 5 minutes.

## Baseline Acceptance Criteria

- No crashes
- No corrupted data
- Stable temperature updates

If unstable, fix before continuing.

---

# Day 1 — BLE Skeleton (Advertising Only)

## Goal
Make the ESP32-C6 advertise as a BLE device named `StillCold`.

---

## Step 1 — Create Minimal BLE Server

Temporarily:

- Comment out UART parsing logic.
- Remove sensor integration.
- Keep code minimal.

Implement:

- BLE initialization
- Device name: `"StillCold"`
- Start advertising

No services yet. No characteristics yet.

---

## Step 2 — Verify Discoverability (Using nRF Connect)

On your phone:

1. Open **nRF Connect**
2. Start scanning
3. Look for device named `StillCold`
4. Confirm:
   - RSSI is visible
   - Advertising persists
   - Device reappears after power cycle

### Day 1 Acceptance Criteria

- Device consistently appears in scan list
- Advertising restarts after reset
- No random disappearance

If discoverability is unreliable, fix before moving on.

---

# Day 2 — Add Service + Characteristic (Hardcoded Value)

## Goal
Add structure to BLE and validate readable characteristic behavior.

---

## Step 3 — Define Custom Service

Create:

- Custom 128-bit Service UUID
- Custom 128-bit Characteristic UUID

Example naming (for clarity, not literal names):

- Service: StillCold Temperature Service
- Characteristic: Temperature Read Characteristic

Characteristic properties:
- Readable
- No notify yet

---

## Step 4 — Hardcode Temperature Value

Inside the characteristic read handler:

Return a simple string:

```
21.4
```

No sensor binding yet.

---

## Step 5 — Validate Characteristic in nRF Connect

Using nRF Connect:

1. Scan and connect to `StillCold`
2. Discover services
3. Locate your custom service
4. Expand characteristic
5. Perform a read

### Day 2 Acceptance Criteria

- Service visible
- Characteristic visible
- Read returns `21.4`
- Disconnect and reconnect works
- No crashes
- Advertising resumes after disconnect

Do not proceed if reconnection is unstable.

---

# Day 3 — Bind Real Temperature Data

## Goal
Expose actual live temperature value.

---

## Step 6 — Restore UART + Parsing Logic

Re-enable:

- Nano communication
- Temperature parsing
- `latestTemperature` variable storage

Confirm via Serial Monitor:

- Temperature updates properly
- No blocking behavior

---

## Step 7 — Replace Hardcoded Value

Instead of:

```
21.4
```

Return:

```
String(latestTemperature)
```

Or properly formatted equivalent.

Keep formatting simple.

---

## Step 8 — Validate End-to-End Flow

Using nRF Connect:

1. Connect
2. Read temperature characteristic
3. Compare with Serial Monitor
4. Wait for next sensor update
5. Read again

### Day 3 Acceptance Criteria

- BLE value matches Serial value
- Value updates as sensor updates
- No corrupted strings
- No UART disruption
- No BLE crashes

If BLE breaks UART timing, adjust loop design.

---

# Day 4 — Stability & Edge Testing

## Goal
Ensure system behaves reliably over time.

---

## Step 9 — Extended Run Test

Let system run 15–30 minutes.

Monitor:

- Advertising stability
- Reconnection behavior
- Temperature accuracy
- Memory or freezing issues

---

## Step 10 — Reconnection Stress Test

Using nRF Connect:

- Connect
- Read value
- Disconnect
- Repeat 10 times

### Acceptance Criteria

- No crashes
- No stuck advertising
- No incorrect values after reconnect
- No manual reset required

---

## Step 11 — Environmental Variation Test (Optional but Strong)

If possible:

- Briefly cool sensor
- Observe change on Serial
- Confirm same change via BLE read

This validates real-world data integrity.

---

# Final Week 6 Acceptance Criteria

Week 6 is complete when all are true:

## BLE Behavior

- Device advertises reliably
- Service visible
- Characteristic readable
- Reconnect stable

## Data Integrity

- BLE value matches Serial
- Value updates correctly
- No corruption
- No parsing failures

## System Stability

- UART unaffected by BLE
- No freezing during extended run
- No manual resets required

## Architecture Integrity

- Nano handles sensing
- ESP32 handles communication + BLE
- No role overlap introduced

When these are satisfied, the Sprint 1 BLE milestone is achieved.

---

# Demonstration Checklist (For Professor)

You should be able to:

1. Power on device
2. Show Serial updating temperature
3. Open nRF Connect
4. Scan and discover `StillCold`
5. Connect
6. Read temperature
7. Show match with Serial
8. Disconnect
9. Reconnect successfully

That demonstrates a complete embedded data pipeline.

---

# Stretch Goals (Only After Core Is Stable)

Optional improvements:

- Add humidity as second characteristic
- Add BLE notify support
- Format payload as `T=21.4,H=34.2`
- Improve advertising intervals

These are refinements, not requirements.

---

# End State of Week 6

At completion, StillCold will have:

- Reliable internal data acquisition
- BLE exposure of live temperature
- A validated end-to-end system
- No external infrastructure dependency

Sprint 1 will be functionally complete.
