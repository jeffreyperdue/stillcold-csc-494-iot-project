# StillCold — Cold-Environment Test Scenarios
## Sprint 2, Week 2

---

## Overview

These scenarios test the two-MCU baseline (HTU21D → Arduino Nano → ESP32-C6 → BLE) in realistic cold conditions. The Flutter companion app is the primary capture tool — readings are collected via manual refresh and stored in the app's local SQLite history. A reference thermometer provides an independent temperature check where noted.

**Hardware under test:** Two-MCU prototype (breadboard), powered by Anker power bank  
**Containment:** Breadboard + power bank in a Ziploc bag, wrapped in bubble wrap with silica gel packets  
**Primary capture tool:** StillCold Flutter companion app (manual refresh)  
**Secondary tool:** nRF Connect (BLE connectivity spot-checks)  
**Reference:** No external thermometer — plausibility check against expected fridge range (~2–6°C)

> **Note on bubble wrap insulation:** The bubble wrap acts as a mild thermal insulator. The sensor may take longer to reach true fridge temperature than the surrounding air, and door open/close response may appear slower than it would in an uninsulated deployment. Note this as a test condition in the report rather than a hardware limitation.

> **Note on polling:** Periodic polling (FR-2.5) is not yet wired in the app. Refresh manually at regular intervals — roughly every 1–2 minutes — to keep the reading history populated during longer scenarios.

---

## Scenario 1 — Steady-State Refrigeration

**Goal:** Confirm the system produces stable, plausible readings over an extended period in a closed cold environment, and that BLE remains connectable throughout.

**Setup**
- Place the bagged assembly (breadboard + power bank) inside a standard household refrigerator (target ~4°C).
- Power on the power bank and confirm the app is connected and reading before closing the door.
- Close the fridge door fully — nothing needs to be routed outside.

**Steps**
1. Take an initial reading via manual refresh. Note the value and timestamp.
2. Close the fridge door.
3. Refresh manually every 1–2 minutes for **30–60 minutes**, keeping the app open.
4. At the end of the period, take a final reading and note whether it is in a plausible fridge range (~2–6°C).
5. Review the alert history and reading history in the app to confirm continuous capture.

**What to watch for**
- Does the reported temperature gradually drop and stabilize at a plausible fridge value (~2–6°C)?
- Are there any gaps in the reading history suggesting a BLE read failure?
- Does the app surface any connection errors or require manual reconnection at any point?

**Pass criteria**
- Reading history shows continuous data with no large unexplained gaps.
- Temperature stabilizes within a plausible fridge range (~2–6°C).
- App remains connected throughout without requiring a manual reconnect.

---

## Scenario 2 — Door Open/Close Events

**Goal:** Observe how quickly the sensor responds to temperature changes and how the app reading history reflects those changes.

**Setup**
- Run Scenario 1 first and allow the bagged assembly to reach steady state (~15–20 minutes in fridge).
- Continue refreshing manually every 1–2 minutes throughout this scenario.

**Part A — Short open (~30 seconds)**
1. Note the current reading before opening the door.
2. Open the fridge door for approximately 30 seconds, then close it.
3. Continue refreshing every 1–2 minutes for 5 minutes after closing.
4. Review the reading history to observe the temperature rise and recovery.

**Part B — Prolonged open (~3–5 minutes)**
1. Note the current reading before opening the door.
2. Open the fridge door for 3–5 minutes, then close it.
3. Continue refreshing every 1–2 minutes for 10 minutes after closing.
4. Review the reading history to observe the full recovery curve.

**What to watch for**
- How many readings does it take before the temperature noticeably rises after the door opens?
- After the door closes, how long (in minutes / number of readings) until the temperature returns to the previous steady-state value? This directly informs the stale data threshold in the Week 3 app work.
- Any implausible values in the reading history (sudden large spike or drop inconsistent with the event)?
- Does BLE remain stable while the door is open?

**Pass criteria**
- Reading history shows a visible temperature rise after the door opens.
- No implausible values (e.g., sudden jump to 40°C or below 0°C without cause).
- Temperature recovers toward steady-state after the door closes.
- App remains connected and readable whether the door is open or closed.

---

## Scenario 3 — Power Cycle at Cold Temperature

**Goal:** Confirm the system initializes correctly when powered on cold, and that the app can connect and obtain a valid reading shortly after boot.

**Setup**
- The bagged assembly is already in the fridge from Scenario 2. Allow it to remain at steady state.
- Locate the USB cable connecting the power bank to the breadboard — you'll be unplugging and replugging it to simulate a power interruption.
- Have the app open and connected before cycling power.

**Steps**
1. Note the current reading in the app.
2. Open the fridge, unplug the USB cable from the power bank, wait 5 seconds, then plug it back in. Close the door.
3. In the app, observe the connection state — note whether it surfaces a "connection lost" indication or silently shows stale data.
4. Attempt to reconnect via the app (return to Discovery if needed) and take a fresh reading via manual refresh.
5. Note the time from power-on to when a valid reading is available in the app.
6. Repeat once more for a second data point.

**What to watch for**
- Does the app surface a clear "connection lost" state after the power cycle, or does it silently show the last reading as if it were current?
- How long after power-on can the app successfully reconnect and obtain a fresh reading?
- Does the first reading after boot match the expected fridge temperature, or does it look like a warm/transitional value suggesting a sensor warm-up period?
- Does BLE advertising restart automatically, or does the app fail to find the device without a manual reset?

**Pass criteria**
- App can reconnect and obtain a valid reading without requiring a device manual reset.
- First reading after boot is a plausible cold temperature (not a room-temperature artifact).
- Time from power-on to valid app reading is reasonable (target: under 15 seconds).


---

## Before You Start — Checklist

- [ ] Power bank is charged
- [ ] App is installed and connected to the device at room temperature
- [ ] Breadboard + power bank are in the Ziploc bag with silica gel packets, bubble wrap ready
- [ ] You can easily access the USB cable connecting the power bank to the breadboard (needed for Scenario 3)
- [ ] App reading history is clear (or you've noted the baseline state)
- [ ] You have noted the current firmware version / build date

## After Each Scenario

- Screenshot the app reading history and alert history
- Note the reference thermometer reading
- Note any moments where the app behaved unexpectedly
- Record findings in `cold_env_test_report.md`
