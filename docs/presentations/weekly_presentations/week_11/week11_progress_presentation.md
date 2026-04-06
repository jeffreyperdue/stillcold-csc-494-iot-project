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

# **StillCold** — Week 11 Progress
## Sprint 2, Week 2: Cold-Environment Testing

*Putting the hardware under real conditions*

---

# What Week 11 Was About

**Goal:** Validate the two-MCU baseline in realistic cold conditions before building on top of it.

- **Design** three test scenarios covering steady-state, door events, and cold boot.
- **Execute** the full test pass with the hardware sealed inside a household refrigerator.
- **Document** observed behavior, recovery times, and implications for the Week 12 app work.

*This was a hardware validation week — the Flutter app was used as the primary data capture tool.*

---

# Test Setup

The hardware was prepared for cold-environment operation:

| Item | Detail |
|------|--------|
| Hardware | HTU21D → Arduino Nano → ESP32-C6 → BLE (breadboard) |
| Power | Anker power bank |
| Containment | Breadboard + power bank in a Ziploc bag, wrapped in bubble wrap with silica gel packets |
| Primary capture | StillCold Flutter companion app (manual refresh, ~1–2 min intervals) |
| Secondary check | nRF Connect (BLE spot-checks) |
| Reference | Plausibility check against known fridge range (~2–6 °C) |

---

# Three Test Scenarios

| # | Scenario | Goal |
|---|----------|------|
| 1 | **Steady-state refrigeration** | Confirm stable, plausible readings over ~1 hour in a closed fridge |
| 2 | **Door open/close events** | Observe sensor response and recovery after short (~35 s) and prolonged (~3 min) door opens |
| 3 | **Power cycle at cold temperature** | Confirm the system initializes correctly from cold and reconnects within target time |

All three scenarios ran on **March 26, 2026**.

---

# Scenario 1 — Steady-State Refrigeration

The assembly was placed in the fridge at room temperature and monitored for approximately one hour.

| Phase | Reading |
|-------|---------|
| Start (room temp) | 75.5 °F (24.2 °C) |
| Cooldown duration | ~44 minutes to reach stable band |
| Stable band | **37.7–38.2 °F (3.2–3.4 °C)** |
| Stability over final 16 min | ±0.25 °F (±0.14 °C) |

The 44-minute cooldown is largely attributable to the bubble wrap packaging acting as a thermal buffer — expected for the test setup, not a hardware limitation.

---

# Scenario 1 — Cooldown Curve

Selected readings from the cooldown:

| Time | °F | °C | |
|------|----|----|---|
| 5:46 PM | 75.5 | 24.2 | Room temp (start) |
| 6:09 PM | 49.4 | 9.7 | Midpoint of cooldown |
| 6:30 PM | 37.7 | 3.2 | First stable-band reading |
| 6:42 PM | 38.0 | 3.3 | Stable |
| 6:46 PM | 37.9 | 3.3 | Final reading |

Curve is **monotonically decreasing** with no spikes or sensor artifacts — clean and smooth throughout.

---

# Scenario 1 — Results

| Criterion | Result |
|-----------|--------|
| Continuous reading history with no large unexplained gaps | **Pass** |
| Temperature stabilizes in plausible fridge range (~2–6 °C) | **Pass** |
| App remains connected without requiring manual reconnect | **Pass** |

**BLE:** The app stayed connected for the entire session with no disconnects or reconnections required.

---

# Scenario 2 — Door Open/Close Events

Run immediately after Scenario 1, starting from steady state.

**Two parts:**
- **Part A** — Short open (~35 seconds)
- **Part B** — Prolonged open (~3 minutes)

Readings taken every 1–2 minutes throughout to capture the full response and recovery curve.

---

# Scenario 2 — Part A: Short Open (~35 s)

| Time | Reading | Notes |
|------|---------|-------|
| 7:02:00 PM | 38.1 °F (3.4 °C) | Baseline; door closed |
| 7:02:35 PM | — | **Door opened** |
| 7:03:10 PM | — | **Door closed** (~35 s) |
| 7:07:00 PM | 39.0 °F (3.9 °C) | Peak excursion |
| 7:15:00 PM | 38.1 °F (3.4 °C) | Returned to baseline |

**Recovery time:** ~12 minutes  
**Peak excursion:** +0.9 °F (+0.5 °C)

---

# Scenario 2 — Part B: Prolonged Open (~3 min)

| Time | Reading | Notes |
|------|---------|-------|
| 7:22:00 PM | 38.2 °F (3.4 °C) | Baseline; door closed |
| 7:23:00 PM | — | **Door opened** |
| 7:26:00 PM | — | **Door closed** (~3 min) |
| 7:27:00 PM | 40.8 °F (4.9 °C) | Peak reading (just after close) |
| 7:49:00 PM | 38.2 °F (3.4 °C) | Returned to baseline |

**Recovery time:** ~23 minutes  
**Peak excursion:** +2.6 °F (+1.5 °C)

*The peak occurred just after door close — consistent with thermal lag through the bubble wrap insulation.*

---

# Scenario 2 — Results

| Criterion | Result |
|-----------|--------|
| Reading history shows a visible temperature rise after door opens | **Pass** |
| No implausible values in reading history | **Pass** |
| Temperature recovers toward steady-state after the door closes | **Pass** |
| App remains connected and readable with door open or closed | **Pass** |

Recovery followed a **smooth, monotonically decreasing curve** in both parts — no oscillation, no instability.

---

# Scenario 3 — Power Cycle at Cold Temperature

With the assembly at steady state in the fridge, power was cycled 10 times by unplugging and replugging the USB cable.

| Metric | Value |
|--------|-------|
| Trials | 10 |
| Average time: power-on → valid reading in app | **10.8 seconds** |
| Target | < 15 seconds |

**BLE re-advertisement** resumed automatically after every cycle — no manual device reset was required in any trial.

---

# Scenario 3 — Results

| Criterion | Result |
|-----------|--------|
| App can reconnect and obtain a valid reading without manual device reset | **Pass** |
| First reading after boot is a plausible cold temperature | **Pass** |
| Time from power-on to valid app reading ≤ 15 seconds (avg 10.8 s) | **Pass** |

**First-reading plausibility:** All post-cycle readings reflected the expected cold fridge temperature immediately — no transitional warm-up period observed at refrigerator operating temperatures.

---

# Summary: All Three Scenarios Passed

| Area | Observation |
|------|-------------|
| Steady-state accuracy | 37.7–38.2 °F (3.2–3.4 °C) — consistent with expected fridge temp |
| Steady-state stability | ±0.25 °F (±0.14 °C) band over 16+ min once stable |
| Cooldown time (insulated) | ~44 min from room temp to steady state |
| Short door-open recovery | ~12 min, +0.9 °F (+0.5 °C) peak excursion |
| Prolonged door-open recovery | ~23 min, +2.6 °F (+1.5 °C) peak excursion |
| Power cycle boot time | 10.8 s average (target: < 15 s) |
| BLE stability | No disconnects across any scenario |
| Sensor misreads / artifacts | None detected |

---

# Implication 1: Stale-Data Threshold Design

The door-event recovery times give **concrete guidance** for the Week 12 stale-data work:

- A reading older than **~5 minutes** during normal use could meaningfully lag behind a door-open event.
- The app's "Last updated X min ago" indicator should become visually prominent once readings are more than **2–3 minutes** old.
- A "door left open" alert can be calibrated knowing that a 3-minute open raises temperature by ~2.6 °F (1.5 °C) and recovery takes ~23 minutes.

*Recovery timing from this test is now a concrete design input — not a guess.*

---

# Implication 2: Connection Lifecycle UX

The power-cycle test exposed an existing app gap:

- After a power cycle, the app **surfaced a connection-lost state** — the user could tell the device was temporarily unavailable.
- However, the current app does not offer a clear **reconnect path** without returning to the Discovery screen.
- The Week 12 connection lifecycle pass (M2, M3, M4) is the right place to address this: the hardware already re-advertises automatically; the app just needs to surface that cleanly.

*The firmware behaves correctly — the gap is entirely in the app layer.*

---

# Implication 3: Bubble Wrap vs. Production

The 44-minute cooldown and dampened door-event response are artifacts of the **bubble wrap test packaging**:

- In a production enclosure with less thermal mass, cooldown would be faster and door-open response would be sharper.
- The current results set a **conservative baseline** — real-world behavior will be more responsive.
- This should be revisited after the Week 5 packaging work when hardware moves off the breadboard.

*These are test conditions, not hardware limitations.*

---

# What the Testing Confirmed

Three things were validated that were previously assumed:

1. **The two-MCU baseline is stable under cold conditions.** No brownouts, no BLE instability, no sensor anomalies across ~2 hours of total operation in a fridge.

2. **BLE penetrates the fridge door reliably.** The app connected and read data through the closed refrigerator door throughout every scenario.

3. **The hardware is ready to build on.** Sprint 2 can now proceed to the app work with confidence that the underlying platform is solid.

---

# Looking Ahead: Week 12

With the cold-environment baseline validated, Week 12 turns to the highest-priority app gap:

**Connection Lifecycle Pass (M2, M3, M4)**

- **M2** — Live connection state machine: connecting / connected / disconnected
- **M3** — Explicit Disconnect action → routes back to Discovery
- **M4** — Connection-lost UX + offer to reconnect without restarting the app

The recovery data from this week's testing directly informs the connection-state timing and the stale-data threshold that will be implemented alongside the lifecycle work.

---

# Week 11 Summary

| Area | Status |
|------|--------|
| Cold-environment test scenarios designed | Done — 3 scenarios, defined pass criteria |
| Test execution (March 26, 2026) | Done — all three scenarios passed |
| Test report written | Done — `cold_env_test_report.md` |
| BLE stability under cold conditions | Confirmed — no disconnects across all scenarios |
| Stale-data threshold guidance | Derived — 2–3 min indicator, ~5 min meaningful lag |
| Hardware baseline for Sprint 2 | Confirmed — two-MCU prototype is ready for the app work ahead |

*The hardware is proven. Week 12 builds the app layer on top of it.*

---

# Thank you

**StillCold** — *Environmental monitoring without opening the door*

Questions?
