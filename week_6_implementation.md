# StillCold — Week 6 Implementation Summary  
**Sprint 1 – Week 3 Completion (BLE Integration)**

## Overview

Week 6 completed the BLE exposure milestone for Sprint 1. The StillCold system now exposes live environmental data (temperature and humidity) over Bluetooth Low Energy (BLE) from the ESP32-C6 communication component.

This document describes exactly what was implemented, how the system behaves, and the final validated state so that another LLM with access to the codebase can fully understand the current architecture and responsibilities.

---

# Architectural Context

StillCold uses a two-component embedded architecture:

## 1. Sensing Component (Arduino Nano)

Responsibilities:
- Interface with HTU21D sensor over I²C.
- Periodically measure temperature and humidity.
- Transmit structured data via UART.

Data format transmitted to ESP32:

```
T=<temperature>,H=<humidity>\n
```

Example:
```
T=18.59,H=39.22
```

---

## 2. Communication Component (ESP32-C6)

Responsibilities:
- Receive structured UART data from Nano.
- Parse temperature and humidity values.
- Store latest valid readings.
- Expose live readings over BLE.
- Maintain BLE advertising lifecycle.

Week 6 implemented the BLE exposure layer.

---

# BLE Implementation Details

## Device Configuration

- BLE Device Name: `StillCold`
- Custom 128-bit Service UUID:
  ```
  12345678-1234-1234-1234-1234567890ab
  ```

---

## Characteristics

Two readable characteristics were implemented under the same service.

### 1. Temperature Characteristic

UUID:
```
abcd1234-5678-1234-5678-abcdef123456
```

Properties:
- READ

Behavior:
- Returns latest parsed temperature as string with 2 decimal precision.
- Updated immediately after successful UART parse.

Example value:
```
18.59
```

---

### 2. Humidity Characteristic

UUID:
```
abcd5678-1234-5678-1234-abcdef654321
```

Properties:
- READ

Behavior:
- Returns latest parsed humidity as string with 2 decimal precision.
- Updated immediately after successful UART parse.

Example value:
```
39.22
```

---

# Data Flow (End-to-End)

The complete data pipeline now operates as follows:

1. HTU21D measures environment.
2. Arduino Nano formats reading:
   ```
   T=<temp>,H=<hum>\n
   ```
3. ESP32 reads UART input.
4. ESP32 parses using:
   ```
   sscanf("T=%f,H=%f", &latestTemp, &latestHum)
   ```
5. Parsed values stored in:
   - `latestTemp`
   - `latestHum`
6. BLE characteristic values updated via:
   ```
   pTemperatureCharacteristic->setValue(...)
   pHumidityCharacteristic->setValue(...)
   ```
7. BLE client (nRF Connect or future Flutter app) reads values.

This produces real-time consistency between:

Serial Monitor  
BLE Client  
Actual sensor state  

---

# BLE Lifecycle Handling

A custom `BLEServerCallbacks` class was implemented to ensure correct advertising behavior.

## On Connect
- Sets `deviceConnected = true`
- Logs event to Serial

## On Disconnect
- Sets `deviceConnected = false`
- Calls:
  ```
  BLEDevice::startAdvertising();
  ```
- Restores discoverability immediately

This prevents the device from becoming invisible after disconnect.

---

# Stability and Validation Testing Performed

The following validation tests were completed successfully:

## 1. Advertising Stability
- Device advertises continuously.
- Reappears after power cycle.
- Remains visible during idle state.

## 2. Characteristic Validation
- Temperature and humidity both readable.
- Values match Serial output exactly.
- Values update when environment changes.

## 3. Reconnect Stress Test
- 10+ connect/disconnect cycles performed.
- Advertising restarted automatically.
- No crashes or resets observed.

## 4. Extended Idle Test
- Device left running for extended period.
- Successful connection after idle.
- Values accurate and up-to-date.

## 5. Environmental Variation Test
- Sensor warmed/cooled slightly.
- Serial reflected change.
- BLE reads reflected same change.

---

# Final State After Week 6

The StillCold prototype now satisfies the Sprint 1 BLE milestone:

- Reliable sensor acquisition.
- Structured UART transfer.
- Correct parsing.
- Live BLE exposure.
- Multi-characteristic support.
- Proper advertising lifecycle.
- No Wi-Fi or external infrastructure required.

The system architecture remains modular:

Nano = sensing  
ESP32 = communication + BLE  

No architectural refactor was required to add humidity support.

---

# Current Limitations

- BLE characteristics are READ-only.
- No notification support yet.
- No historical data storage.
- No mobile app integration yet.
- No MTU optimization.
- No power optimization tuning.

These are reserved for later milestones.

---

# Codebase Impact Summary

Files modified:
- `stillcold_comm_node.ino`

Key additions:
- BLE library includes.
- Custom service creation.
- Two characteristics.
- Advertising callback handler.
- Dynamic `setValue()` updates after UART parse.

No changes were made to:
- Nano sensing logic.
- UART data format.
- Overall system architecture.

---

# System Status

Sprint 1 BLE milestone: COMPLETE  
Week 6 implementation: LOCKED  

System is stable, validated, and ready to proceed to:

- Flutter BLE client groundwork (Sprint 1 Week 4)
- Optional BLE notify enhancement
- Extended reliability testing
- Packaging and enclosure refinement

StillCold now operates as a functional embedded environmental monitoring prototype.
