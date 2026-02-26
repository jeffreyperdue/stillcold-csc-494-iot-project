## StillCold Sprint 2 Plan

### 1. Context

- **Project**: StillCold — environmental monitoring without opening the door.
- **Current state (after Sprint 1)**:
  - Full end‑to‑end embedded pipeline working: HTU21D sensor → Arduino Nano → ESP32‑C6 → BLE → external device.
  - BLE service on ESP32‑C6 exposes temperature and humidity as readable characteristics.
  - Flutter companion app MVP:
    - Discovers StillCold over BLE.
    - Connects and reads live temperature/humidity.
    - Displays readings in a dashboard.
    - Supports thresholds, quiet hours, and alert history.
- **Sprint 2 duration**: 6 weeks.
- **Proposed themes**:
  - Test in cold environments.
  - Move off breadboard.
  - Remove Nano (use ESP32‑C6 only).
  - Continue developing the Flutter app to align with the SRS.

### 2. Sprint 2 Goal and Objectives

**Sprint 2 goal**  
Refine StillCold into a reliable, tested system that behaves well in realistic cold environments and has a companion app aligned with the SRS, while cautiously exploring hardware consolidation.

**Primary objectives**

1. **Cold‑environment validation**
   - Demonstrate that the system behaves predictably in realistic refrigerated conditions.
   - Document observed behavior, limitations, and any required adjustments.

2. **Flutter app–SRS alignment**
   - Close the main gaps between the current Flutter app and the SRS.
   - Focus on connection lifecycle, polling, stale data indication, and core UX flows.

3. **Hardware consolidation and packaging (controlled risk)**
   - Explore moving from a two‑MCU design (Nano + ESP32‑C6) to an ESP32‑only design.
   - Move off the breadboard to a more robust assembly.
   - Keep changes time‑boxed and reversible.

### 3. Scope and Priorities

#### 3.1 Must‑Have (Commit)

- **Cold‑environment testing on current baseline**
  - Use the existing two‑MCU prototype for initial fridge/freezer tests.
  - Identify sensor behavior, BLE stability, and any power or reliability issues.
- **Flutter app aligned with core SRS requirements**
  - Discovery, connection, live readings, thresholds/alerts, local history.
  - Solid connection lifecycle and basic polling/staleness behavior.
- **Regression and stability checks**
  - Ensure Sprint 1 behavior remains intact as refinements are added.

#### 3.2 Should‑Have (Aim For, Can Trim)

- **Move off breadboard**
  - Transfer the chosen baseline design to perfboard or a simple PCB.
  - Improve physical robustness for repeated use in cold environments.
- **Flutter UX polish**
  - Better error handling for BLE and permissions.
  - Clearer indicators for connection status and stale readings.

#### 3.3 Stretch (Only If Time Remains)

- **Full Nano removal**
  - HTU21D sensor connected directly to ESP32‑C6 (single‑MCU design).
  - Achieve parity with previous behavior and use it as the main hardware path.
- **Advanced app features**
  - Charts, multi‑day summaries, and additional analytics beyond SRS essentials.

#### 3.4 Power and Form Factor

- **Sprint 2 approach**: Reduce form factor by using a **smaller 5 V source** (e.g. slim USB power bank or 5 V wall adapter) and/or neater cable placement when moving off breadboard. No change to power architecture this sprint.
- **Documentation**: Document power as "5 V USB; optional power bank for backup when refrigeration loses power." Treat integrated battery as a future improvement.
- **Deferred**: Full integrated battery options (1S LiPo, 18650, 2× AA + boost, etc.) are assessed in **Power options** (`docs/project_context/power_options.md`). Revisit after the Week 4 ESP32‑only decision and cold-environment testing, to avoid overloading this sprint and to choose a single architecture (two‑MCU vs ESP32‑only) before committing to a battery solution.

### 4. Week‑by‑Week Plan (6 Weeks)

#### Week 1 — Stabilize and Plan in Detail

- **Hardware & firmware**
  - Review current two‑MCU design: wiring, responsibilities, data formats.
  - Capture a concise architecture sketch (even informal) showing:
    - Sensor ↔ Nano responsibilities.
    - Nano ↔ ESP32‑C6 UART protocol.
    - ESP32‑C6 BLE service and characteristics.
- **App & SRS alignment**
  - Revisit the SRS and existing status notes.
  - Extract a prioritized list of missing or partial Flutter requirements:
    - Connection lifecycle.
    - Polling interval behavior.
    - Basic trend/history behavior required by the SRS.
- **Output**
  - Finalize a Sprint 2 backlog with items tagged as Must/Should/Stretch based on this plan.

#### Week 2 — Cold‑Environment Test Pass (Two‑MCU Baseline)

- **Test design**
  - Define 2–4 realistic test scenarios such as:
    - Fridge at steady state for extended time.
    - Door open/close events (short and long).
    - Power cycles at cold temperature.
- **Execution**
  - Use the existing Nano + ESP32‑C6 prototype.
  - Capture:
    - Serial logs from Nano/ESP32‑C6.
    - BLE readings via nRF Connect and/or Flutter app.
  - Look for:
    - Sensor misreads or slow response.
    - BLE instability or disconnect patterns.
    - Any brownout or reset behavior.
- **Documentation**
  - Write a short markdown report (e.g., under `docs/`) summarizing:
    - Test setups and conditions.
    - Observed behavior and anomalies.
    - Implications for retries, warm‑up time, calibration, and app UX.

#### Week 3 — Flutter Companion App Core Gaps

- **Connection lifecycle**
  - Implement clear states: *connecting*, *connected*, *disconnected*, *connection lost*.
  - Provide an explicit **Disconnect** action to return to device discovery.
  - Add a user‑facing flow for unexpected BLE drops (e.g., “Connection lost — tap to reconnect”).
- **Polling and stale data**
  - Implement a configurable or fixed polling interval for refreshing readings while connected.
  - Surface “staleness” in the UI (e.g., “Last updated 5 min ago” and/or visual hint).
- **Verification**
  - Run SRS‑derived acceptance scenarios to confirm:
    - Discovery and connection work reliably.
    - Readings refresh as intended.
    - Alerts and quiet hours behave as specified.

#### Week 4 — ESP32‑Only Refactor (Time‑Boxed Spike)

- **Goal**
  - Reproduce current system behavior using a single ESP32‑C6 (sensor host + BLE) while minimizing scope creep.

- **Tasks**
  - Bring up the HTU21D sensor directly on ESP32‑C6 using I²C.
  - Recreate the Nano’s logic on ESP32‑C6:
    - Periodic readings.
    - Simple formatting (e.g., `T=… H=…` style or equivalent internal representation).
  - Preserve existing BLE service and characteristic formats so the Flutter app does not need changes.
  - Bench‑test on breadboard at room temperature until:
    - Readings match expectations.
    - BLE exposure is as stable as the two‑MCU setup.

- **Decision point (end of Week 4)**
  - If ESP32‑only is **stable and trustworthy**:
    - Adopt it as the new baseline for packaging and later cold testing.
  - If not:
    - Keep the two‑MCU design as the main path.
    - Treat the ESP32‑only work as a documented experiment rather than a deliverable.

#### Week 5 — Move Off Breadboard + App Polish

- **Hardware packaging**
  - For the chosen baseline (two‑MCU or ESP32‑only):
    - Migrate to perfboard or a simple PCB.
    - Label key connections (sensor, power, microcontroller pins) for clarity.
    - Ensure basic strain relief and cable management for fridge/freezer use.
  - Re‑run a subset of Week 2 cold tests to confirm that packaging has not introduced:
    - Intermittent connections.
    - Additional noise or instability.

- **Flutter polish**
  - Refine:
    - Error messages and empty states for BLE scans and connections.
    - Threshold/alert UX based on insights from real cold‑environment usage (Week 2).
    - Any remaining high‑impact rough edges surfaced by SRS review.

#### Week 6 — Integrated Regression and Final Artifacts

- **Integrated regression testing**
  - With the packaged hardware (baseline chosen in Week 4):
    - Perform end‑to‑end runs at room temperature and in cold environments.
    - Exercise connection/disconnection sequences via the Flutter app.
    - Trigger threshold alerts both inside and outside quiet hours.
  - Confirm that:
    - Behavior matches or exceeds Sprint 1 reliability.
    - Critical Sprint 2 changes did not introduce regressions.

- **Documentation and presentations**
  - Update `README` to capture:
    - Final hardware architecture (two‑MCU vs ESP32‑only).
    - Key cold‑environment findings.
    - Final Flutter companion app capabilities relative to the SRS.
  - Prepare Sprint 2 presentation materials showing:
    - Evolution from breadboard prototype to packaged system.
    - Cold‑environment results and what they mean.
    - App behavior and user experience.

### 5. Risks, Trade‑Offs, and De‑Scoping Strategy

- **Risk: ESP32‑only migration overruns time**
  - Mitigation: Treat it as a spike with a clear Week 4 decision gate.
  - De‑scope path: Keep two‑MCU architecture and focus on reliability and documentation.

- **Risk: Hardware packaging consumes too much effort**
  - Mitigation: Prefer perfboard and simple mechanical solutions over full custom PCB.
  - De‑scope path: Deliver a tidy but still “prototype‑looking” assembly rather than a production enclosure.

- **Risk: App feature creep**
  - Mitigation: Restrict app work to SRS‑driven requirements plus a small set of UX improvements that directly support cold‑environment use.
  - De‑scope path: Drop advanced analytics (charts, long‑term summaries) if schedule tightens.

### 6. Expected Outcomes

By the end of Sprint 2, regardless of whether the Nano is fully removed, the project should have:

- A **tested, documented system** that has been exercised in realistic cold conditions.
- A **Flutter companion app** that:
  - Aligns with the SRS for core monitoring, alerts, and local storage.
  - Handles connection lifecycle and stale data in a user‑understandable way.
- A **clear narrative of engineering decisions and trade‑offs**, especially around:
  - Two‑MCU vs single‑MCU design.
  - Hardware robustness vs time.
  - Reliability and usability in the actual target environment.