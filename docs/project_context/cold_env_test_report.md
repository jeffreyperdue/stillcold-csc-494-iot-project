# StillCold — Cold-Environment Test Report
## Sprint 2, Week 2

**Date executed:** March 26, 2026  
**Hardware under test:** Two-MCU prototype (HTU21D → Arduino Nano → ESP32-C6 → BLE), breadboard assembly  
**Power source:** Anker power bank  
**Containment:** Breadboard + power bank in a Ziploc bag, wrapped in bubble wrap with silica gel packets  
**Primary capture tool:** StillCold Flutter companion app (manual refresh, ~1–2 min intervals)  
**Secondary tool:** nRF Connect (BLE connectivity spot-checks)  
**Temperature units logged:** °F (Fahrenheit); Celsius equivalents provided inline for reference  

---

## Scenario 1 — Steady-State Refrigeration

### Setup and Conditions

The bagged assembly was powered on at room temperature and confirmed connected in the app before being placed in a standard household refrigerator. The door was closed and the system was monitored via manual refresh for approximately one hour.

**Thermal note:** The bubble wrap insulation acts as a mild thermal buffer. The cooldown curve observed here is expected to be slower than it would be in an uninsulated production deployment. This is documented as a test condition, not a hardware limitation.

### Readings

| Time     | Temp (°F) | Temp (°C) | Notes                          |
|----------|-----------|-----------|-------------------------------|
| 5:46 PM  | 75.5      | 24.2      | Initial reading, room temp     |
| 5:50 PM  | 68.4      | 20.2      | Cooldown in progress           |
| 5:52 PM  | 65.6      | 18.7      |                                |
| 5:55 PM  | 63.2      | 17.3      |                                |
| 5:58 PM  | 60.6      | 15.9      |                                |
| 6:01 PM  | 57.7      | 14.3      |                                |
| 6:04 PM  | 55.0      | 12.8      |                                |
| 6:06 PM  | 52.8      | 11.6      |                                |
| 6:09 PM  | 49.4      | 9.7       |                                |
| 6:12 PM  | 47.3      | 8.5       |                                |
| 6:15 PM  | 45.0      | 7.2       |                                |
| 6:18 PM  | 42.2      | 5.7       |                                |
| 6:21 PM  | 40.4      | 4.7       |                                |
| 6:24 PM  | 39.2      | 4.0       |                                |
| 6:27 PM  | 38.1      | 3.4       |                                |
| 6:30 PM  | 37.7      | 3.2       | First stable-band reading      |
| 6:33 PM  | 37.9      | 3.3       | Stable                         |
| 6:36 PM  | 37.7      | 3.2       | Stable                         |
| 6:39 PM  | 38.2      | 3.4       | Stable                         |
| 6:42 PM  | 38.0      | 3.3       | Stable                         |
| 6:46 PM  | 37.9      | 3.3       | Final reading; session ended   |

### Observations

- **Cooldown duration:** The sensor reached the stable fridge band (37.7–38.2 °F / 3.2–3.4 °C) approximately **44 minutes** after initial placement. The majority of this time is attributable to bubble wrap thermal mass — the surrounding air would have reached steady state considerably sooner.
- **Steady-state value:** Readings stabilized in the range **37.7–38.2 °F (3.2–3.4 °C)**, which falls comfortably within the expected plausible fridge range of ~2–6 °C.
- **Stability in steady state:** Over the final 16-minute monitoring window (6:30–6:46 PM), the reading band was ±0.25 °F (±0.14 °C). No unexplained spikes or drops were observed.
- **BLE connectivity:** The app remained connected and responsive throughout the full session with no reconnection required. No gaps in reading history were noted.
- **Sensor misreads:** None detected. The cooldown curve is monotonically decreasing and smooth, consistent with expected thermal behavior.

### Pass / Fail

| Criterion | Result |
|-----------|--------|
| Continuous reading history with no large unexplained gaps | **Pass** |
| Temperature stabilizes in plausible fridge range (~2–6 °C) | **Pass** |
| App remains connected without requiring manual reconnect | **Pass** |

---

## Scenario 2 — Door Open/Close Events

### Setup and Conditions

Run immediately following Scenario 1. The assembly had been at steady state for approximately 15 minutes before the first door event. Manual refresh continued at ~1–2 minute intervals throughout.

### Part A — Short Open (~35 seconds)

| Time       | Event / Reading (°F) | Temp (°C) | Notes                          |
|------------|----------------------|-----------|-------------------------------|
| 7:02:00 PM | 38.1 (DC)            | 3.4       | Baseline before event; door closed |
| 7:02:35 PM | DO                   | —         | Door opened                    |
| 7:03:10 PM | DC                   | —         | Door closed (~35 s open)       |
| 7:05:00 PM | 38.8                 | 3.8       | First reading after close      |
| 7:07:00 PM | 39.0                 | 3.9       | Peak reading                   |
| 7:09:00 PM | 38.8                 | 3.8       | Recovery in progress           |
| 7:11:00 PM | 38.6                 | 3.7       |                                |
| 7:13:00 PM | 38.3                 | 3.5       |                                |
| 7:15:00 PM | 38.1                 | 3.4       | Returned to pre-event baseline |

**Recovery time (Part A):** ~12 minutes from door close to return to baseline (38.1 °F / 3.4 °C).  
**Peak excursion:** +0.9 °F (+0.5 °C) above baseline.

### Part B — Prolonged Open (~3 minutes)

| Time       | Event / Reading (°F) | Temp (°C) | Notes                           |
|------------|----------------------|-----------|--------------------------------|
| 7:22:00 PM | 38.2 (DC)            | 3.4       | Baseline before event; door closed |
| 7:23:00 PM | DO                   | —         | Door opened                     |
| 7:25:00 PM | 40.1                 | 4.5       | Reading taken while door still open |
| 7:26:00 PM | DC                   | —         | Door closed (~3 min open)       |
| 7:27:00 PM | 40.8                 | 4.9       | Peak reading (just after close) |
| 7:29:00 PM | 40.5                 | 4.7       | Recovery in progress            |
| 7:31:00 PM | 40.0                 | 4.4       |                                 |
| 7:33:00 PM | 39.7                 | 4.3       |                                 |
| 7:35:00 PM | 39.4                 | 4.1       |                                 |
| 7:37:00 PM | 39.2                 | 3.9       |                                 |
| 7:39:00 PM | 39.0                 | 3.9       |                                 |
| 7:41:00 PM | 38.8                 | 3.8       |                                 |
| 7:43:00 PM | 38.7                 | 3.7       |                                 |
| 7:45:00 PM | 38.5                 | 3.6       |                                 |
| 7:47:00 PM | 38.3                 | 3.5       |                                 |
| 7:49:00 PM | 38.2                 | 3.4       | Returned to pre-event baseline  |

**Recovery time (Part B):** ~23 minutes from door close to return to baseline (38.2 °F / 3.4 °C).  
**Peak excursion:** +2.6 °F (+1.5 °C) above baseline.

### Observations

- **Sensor responsiveness:** The sensor registered a measurable rise within the first 2-minute polling interval after the door-open event in both parts. Response appeared gradual rather than abrupt, consistent with the bubble wrap insulation dampening rapid ambient changes.
- **Recovery profile:** Recovery followed a smooth, monotonically decreasing curve in both cases with no oscillation or instability. Part A recovered in ~12 minutes; Part B recovered in ~23 minutes. These figures serve as baseline estimates for the stale-data threshold design in Week 3.
- **Peak behavior:** In Part B, the peak reading (40.8 °F / 4.9 °C) was observed immediately after door close rather than during the open period, suggesting a slight thermal lag through the insulation packaging. This is expected behavior given the test setup.
- **No implausible values:** All readings fell within a physically reasonable range. No sudden spikes or sub-zero artifacts were observed.
- **BLE connectivity:** The app remained connected and returned readings normally with the door both open and closed. No disconnects or reconnection events were required.

### Pass / Fail

| Criterion | Result |
|-----------|--------|
| Reading history shows a visible temperature rise after door opens | **Pass** |
| No implausible values in reading history | **Pass** |
| Temperature recovers toward steady-state after door closes | **Pass** |
| App remains connected and readable with door open or closed | **Pass** |

---

## Scenario 3 — Power Cycle at Cold Temperature

### Setup and Conditions

The assembly remained in the fridge from Scenario 2 at steady state. Power was cycled by unplugging and replugging the USB cable connecting the power bank to the breadboard. The Flutter app was used to monitor reconnection and time-to-first-valid-reading.

### Results

| Metric | Value |
|--------|-------|
| Number of trials | 10 |
| Average time from power-on to valid reading in app | **10.8 seconds** |
| Target (Sprint 2 pass criterion) | < 15 seconds |

### Observations

- **Time-to-valid-reading:** The system averaged 10.8 seconds across 10 power cycle tests, comfortably below the 15-second target. No trial required a manual device reset to re-establish BLE advertising.
- **BLE re-advertisement:** The ESP32-C6 resumed BLE advertising automatically after each power cycle. The app was able to reconnect without returning to the Discovery screen in all observed cases.
- **First-reading plausibility:** First readings after reboot were consistent with the expected cold fridge temperature, indicating no extended sensor warm-up period at cold operating temperatures. No room-temperature artifacts were observed in post-cycle readings.
- **App connection-state surfacing:** The app surfaced a connection-lost state after the power cycle, allowing the user to identify that the device was temporarily unavailable. Detailed notes on the connection-state UX are deferred to the Week 3 app work.

### Pass / Fail

| Criterion | Result |
|-----------|--------|
| App can reconnect and obtain a valid reading without manual device reset | **Pass** |
| First reading after boot is a plausible cold temperature | **Pass** |
| Time from power-on to valid app reading ≤ 15 seconds (avg 10.8 s) | **Pass** |

---

## Summary of Findings

All three scenarios passed their defined criteria. The two-MCU baseline (HTU21D → Nano → ESP32-C6 → BLE) demonstrated stable, plausible operation across steady-state, door-event, and cold-boot conditions.

### Key Findings Table

| Area | Observation |
|------|-------------|
| Steady-state accuracy | Stabilizes at 37.7–38.2 °F (3.2–3.4 °C), consistent with expected fridge temp |
| Steady-state stability | ±0.25 °F (±0.14 °C) band over 16+ min once stable |
| Cooldown time (insulated) | ~44 min from room temp to steady state with bubble wrap packaging |
| Short door-open recovery | ~12 min, +0.9 °F peak excursion |
| Prolonged door-open recovery | ~23 min, +2.6 °F peak excursion |
| Power cycle boot time | 10.8 s average to valid reading (target: < 15 s) |
| BLE stability | No disconnects or reconnections required across any scenario |
| Sensor misreads / artifacts | None detected |

---

## Implications

### Retries and Reconnection
No retry failures were observed. BLE re-advertisement after power cycle was automatic and consistent. The current boot-to-reading time of ~10.8 seconds is within user-acceptable bounds, but the Week 3 connection lifecycle work should ensure the app clearly surfaces the transitional state rather than displaying the last stale reading.

### Warm-Up Time
No sensor warm-up delay was observed at cold temperatures. The first reading post-boot reflected the ambient cold temperature without a transitional warm period. Warm-up time does not appear to be a concern for the current hardware at refrigerator temperatures.

### Stale Data Threshold (App UX)
The door-event recovery times (12 min for short open, 23 min for prolonged open) provide concrete guidance for the Week 3 stale-data threshold design:
- A reading older than **~5 minutes** during normal use could meaningfully lag behind a door-open event.
- The app's staleness indicator (e.g., "Last updated X min ago") should be surfaced when readings are more than **2–3 minutes** old to give the user actionable signal.
- Alert thresholds for "door left open" behavior can be calibrated knowing that a 3-minute open raises temperature by ~2.6 °F (1.5 °C) and recovery takes ~23 minutes.

### Calibration
The sensor's steady-state readings (3.2–3.4 °C) are plausible against a known household fridge range. No external reference thermometer was used in this test run, so absolute calibration offset cannot be established. If calibration becomes a concern in later sprints, a simultaneous reference reading should be captured.

### Bubble Wrap Insulation — Test vs. Production
The 44-minute cooldown time and dampened door-response observed here are artifacts of the bubble wrap packaging used to protect the breadboard prototype. In a production enclosure with less thermal mass, cooldown would be faster and door-event response would be sharper. This should be revisited after the Week 5 packaging work.

### BLE Reliability
BLE remained fully stable across all scenarios — no disconnects, no instability while the fridge door was open, and no brownout or reset behavior observed. No changes to the BLE layer are indicated by these results.
