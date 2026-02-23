## StillCold Flutter Companion – SRS Status (Week 7)

This document summarizes the current implementation status of the StillCold Flutter companion app relative to the SRS in `flutter_app_srs.md`, as of Week 7.

Legend:
- **Done** – implemented and exercised on device
- **Partial** – some aspects implemented, others missing
- **Planned** – architecture/hooks present but not yet wired
- **Not started** – no meaningful implementation yet

---

## 1. Functional Requirements

### 1.1 Device Discovery and Connection (FR‑1.\*)

| ID     | Summary                                                                                                                                    | Status    | Notes |
|--------|--------------------------------------------------------------------------------------------------------------------------------------------|----------|-------|
| FR-1.1 | Scan for BLE devices and identify StillCold by name `StillCold`.                                                                          | **Done** | `DiscoveryController` + `BleClient.scanForStillColdDevices()` filter by `BleConfig.deviceName == "StillCold"`. |
| FR-1.2 | Select StillCold device from scan results and initiate connection.                                                                        | **Done** | Tapping a device in `DiscoveryScreen` navigates to `DashboardScreen` for that `deviceId`; BLE reads use that ID. |
| FR-1.3 | Display connection status (disconnected, connecting, connected).                                                                          | **Partial** | `StatusChip` exists and is shown on Dashboard, but state is currently hard‑coded to `connected`; no live connection state machine yet. |
| FR-1.4 | Allow user to disconnect from device and return to discovery.                                                                             | **Partial** | User can navigate back manually; no explicit "Disconnect" action that cancels an active connection and routes to Discovery with clear copy. |
| FR-1.5 | Handle connection loss gracefully and inform user.                                                                                        | **Partial** | Scan and read errors show clear error/empty states, but there is no dedicated "Connection lost" UX driven by BLE connection updates. |
| FR-1.6 | Remember last connected device and offer to auto‑connect when in range.                                                                   | **Partial** | `Settings` table has `lastConnectedDeviceId`; `DashboardController` updates it on successful refresh and `DiscoveryScreen` shows a last‑device hint. No actual auto‑connect logic yet. |
| FR-1.7 | Display RSSI (signal strength) when connected.                                                                                            | **Partial** | RSSI shown for devices in Discovery list; not yet surfaced on the Dashboard while connected. |
| FR-1.8 | Allow custom labels for devices (e.g., "Kitchen fridge") for multi‑device support.                                                        | **Partial** | `DeviceLabels` Drift table and `DeviceLabelsRepository` exist; `DiscoveryScreen` shows saved labels. UI for creating/editing/removing labels is still missing. |

### 1.2 Sensor Data Display (FR‑2.\*)

| ID     | Summary                                                                                              | Status    | Notes |
|--------|------------------------------------------------------------------------------------------------------|----------|-------|
| FR-2.1 | Read temperature characteristic and display current temperature.                                     | **Done** | `BleClient.readTemperature()` + `DashboardController.refresh()` + Dashboard temperature card. |
| FR-2.2 | Display temperature in °C with appropriate precision (e.g., one decimal place).                     | **Done** | `_formatTemperature` returns 1 decimal; °C/°F conversion based on settings. |
| FR-2.3 | Display humidity when hardware exposes humidity characteristic (Sprint 2).                          | **Done** | `BleClient.readHumidity()` and Dashboard humidity card (integer display). |
| FR-2.4 | Manual refresh control to request updated reading.                                                   | **Done** | Floating action button "Refresh" calls `DashboardController.refresh()`. |
| FR-2.5 | Periodically poll for updated readings when connected (configurable interval, 5–30s).               | **Not started** | `pollingIntervalSeconds` exists in settings and UI, but no periodic timer wired to refresh yet. |
| FR-2.6 | Attach client‑side timestamp to each reading.                                                        | **Done** | `DashboardController.refresh()` uses `DateTime.now()` for both in‑memory reading and DB insert. |
| FR-2.7 | Prominent "last updated" indicator for current reading.                                              | **Done** | Dashboard header shows "Last updated" with human‑friendly "Just now / Xs / Xm / Xh ago" text. |

### 1.3 Data Storage and History (FR‑3.\*)

| ID     | Summary                                                                                          | Status    | Notes |
|--------|--------------------------------------------------------------------------------------------------|----------|-------|
| FR-3.5 | Store timestamped temperature (and humidity) readings in local SQLite DB.                       | **Done** | Drift `Readings` table + `ReadingsRepository.addReading()` invoked on each successful refresh. |
| FR-3.6 | Display simple trend chart of temperature/humidity (24h, 7d).                                   | **Not started (UI placeholder)** | Dashboard shows a "Trend chart placeholder (24h/7d)" card; no charting logic or time‑range filter yet. |
| FR-3.7 | Display min/max summary for a period (e.g., last 24h).                                          | **Planned / backend‑ready** | `ReadingsRepository` exposes `getMinTemperatureSince`/`getMaxTemperatureSince`; not yet surfaced in UI. |

### 1.4 Threshold Alerts (FR‑4.\*)

| ID     | Summary                                                                                     | Status    | Notes |
|--------|---------------------------------------------------------------------------------------------|----------|-------|
| FR-4.1 | Allow customizable high and low temperature thresholds.                                    | **Done** | Settings card "Temperature thresholds" with dialog; persisted via `SettingsRepository.update()`. |
| FR-4.2 | Trigger in‑app and local notifications when temperature crosses a threshold.               | **Done** | `AlertEvaluator.evaluateAndAlert()` logs `AlertEvent` and calls `LocalNotificationsService.showThresholdAlert()`. |
| FR-4.3 | Provide suggested default thresholds with brief rationale.                                 | **Partial** | Defaults (0.0°C / 4.0°C) baked into schema; rationale text is not explicitly surfaced in the UI yet. |
| FR-4.4 | Support quiet hours to suppress notifications during configured windows.                    | **Done** | Quiet hours picker in Settings; `AlertEvaluator` checks `_isWithinQuietHours` before emitting alerts. |
| FR-4.5 | Maintain alert history (log of when thresholds were crossed and readings).                 | **Done** | Drift `AlertEvents` table + `AlertsRepository` + `AlertHistoryScreen` routed from Settings. |

### 1.5 User Experience and Feedback (FR‑5.\*)

| ID     | Summary                                                                                                           | Status    | Notes |
|--------|-------------------------------------------------------------------------------------------------------------------|----------|-------|
| FR-5.1 | Clear feedback when Bluetooth is disabled or unavailable.                                                        | **Partial** | Permission denial and scan errors show actionable messages; explicit BT‑off detection/copy is limited. |
| FR-5.2 | Dedicated empty/error states: "No devices found" and "Connection lost" with next steps.                          | **Partial** | "No devices found" and scan errors handled via `EmptyState`; no dedicated "Connection lost" flow yet. |
| FR-5.3 | Indicate when last reading is stale (older than threshold).                                                      | **Not started** | "Last updated" text exists but no explicit stale styling/threshold handling. |
| FR-5.4 | Guidance/error messages for common failure modes (permissions, connection failed, read failed).                  | **Done** | Discovery and Dashboard surfaces clear error strings for permission denial, scan failure, and read failure. |
| FR-5.5 | Simple onboarding flow explaining BLE, permissions, and first‑time connection.                                   | **Partial** | `OnboardingScreen` exists and is routable; first‑run gating and full explanatory content still need refinement. |
| FR-5.6 | Toggle temperature units (°C/°F) in settings.                                                                    | **Done** | "Use Fahrenheit" switch in Settings; Dashboard reads setting and converts value + unit label accordingly. |

---

## 2. Non‑Functional Requirements (NFR‑\*)

### 2.1 Usability / UI/UX (NFR‑1.\*)

| ID      | Summary                                                                                | Status    | Notes |
|---------|----------------------------------------------------------------------------------------|----------|-------|
| NFR-1.1 | UI intuitive; primary actions discoverable without documentation.                      | **Largely met** | Clear buttons for Scan, Refresh, Settings; straightforward flows. |
| NFR-1.2 | Clean UI with minimal clutter, clear typography, adequate contrast.                    | **Met** | Custom theme, card‑based layout, clear hierarchy. |
| NFR-1.3 | Simple flows; avoid unnecessary screens/steps.                                         | **Met** | Small set of screens (Onboarding, Discovery, Dashboard, Settings, Alerts). |
| NFR-1.4 | Temperature/humidity as visual focus when connected.                                   | **Met** | Large temperature typography and primary card at top of Dashboard. |
| NFR-1.5 | Consistent terminology ("StillCold", "Temperature", "Humidity").                       | **Met** | Consistent naming across screens and widgets. |

### 2.2 Reliability (NFR‑2.\*)

| ID      | Summary                                                                                      | Status    | Notes |
|---------|----------------------------------------------------------------------------------------------|----------|-------|
| NFR-2.1 | Recover from BLE disconnection without requiring app restart.                                | **Partial** | Errors are handled without crashes, and user can manually navigate back; connection‑driven recovery still minimal. |
| NFR-2.2 | Handle invalid/malformed BLE data gracefully.                                                | **Met** | BLE reads parse strings via `double.tryParse`; invalid data results in error/empty states, not crashes. |

### 2.3 Performance (NFR‑3.\*)

| ID      | Summary                                                                                                  | Status    | Notes |
|---------|----------------------------------------------------------------------------------------------------------|----------|-------|
| NFR-3.1 | Respond to user actions (scan, connect, refresh) promptly; long ops show progress.                      | **Met** | Scanning and refresh show progress indicators and disabled states as appropriate. |
| NFR-3.2 | Polling should not significantly impact battery when implemented.                                       | **Not applicable yet** | Periodic polling not yet wired; to be validated once implemented. |

### 2.4 Compatibility (NFR‑4.\*)

| ID      | Summary                                                                                          | Status    | Notes |
|---------|--------------------------------------------------------------------------------------------------|----------|-------|
| NFR-4.1 | Run on Android and iOS with BLE support.                                                         | **Android: Met; iOS: unverified** | App runs on Android device now; no iOS‑specific issues anticipated but not yet tested. |
| NFR-4.2 | Request and handle runtime permissions (Bluetooth, location, notifications) per platform.       | **Met (Android)** | Uses `permission_handler`; Android manifest and runtime flows implemented. |

### 2.5 Maintainability (NFR‑5.\*)

| ID      | Summary                                                                                         | Status    | Notes |
|---------|-------------------------------------------------------------------------------------------------|----------|-------|
| NFR-5.1 | BLE service/characteristic UUIDs configurable via constants.                                    | **Met** | `BleConfig` centralizes UUIDs; values updated to match firmware. |
| NFR-5.2 | App structure supports incremental feature addition (alerts, history, multi‑device, etc.).      | **Met** | Feature‑oriented architecture with Riverpod DI and repositories; already extended with alerts/history/labels. |

---

## 3. UI Screens and Navigation (Section 5 of SRS)

| Screen       | SRS Expectation                                                                                         | Status    | Notes |
|--------------|---------------------------------------------------------------------------------------------------------|----------|-------|
| Onboarding   | First‑time BLE explanation, permission rationale, how to connect.                                      | **Partial** | Screen exists; needs stronger first‑run gating and copy aligned to SRS. |
| Discovery    | Scan and connect; device list with RSSI; StillCold filter; last‑device auto‑connect.                  | **Partial** | Scan, RSSI in list, StillCold filter, and last‑device hint implemented; auto‑connect and connection‑lost flows pending. |
| Dashboard    | Live readings, last updated, RSSI, connection status, refresh, disconnect, trend chart, min/max.      | **Partial** | Live readings + last updated + refresh done; RSSI, disconnect action, trend chart, and min/max summaries still missing. |
| Settings     | Polling interval, °C/°F toggle, thresholds, quiet hours, device labels, alert history.                 | **Mostly done** | All items represented; polling not wired yet, device labels editable UX missing, others complete. |

Navigation graph (`GoRouter`) reflects the intended paths (Onboarding → Discovery → Dashboard → Settings/Alerts and back), though first‑run branching and connection‑error routing still need refinement.

---

## 4. Summary and Next Steps

- **Sprint 1 (Must‑have) coverage is strong**: core BLE discovery, single‑device connection, manual reading, storage, thresholding, notifications, alert history, and basic UX are in place and working on real hardware.
- **Remaining gaps for Must‑level polish** mainly involve a richer connection lifecycle (connect/connecting/disconnected states, explicit disconnect, connection‑lost handling), and a more guided first‑run onboarding experience.
- **Sprint 2 (Should‑have) items** such as periodic polling, trend chart + min/max summaries, device label editing UI, dashboard RSSI, stale‑reading indication, and auto‑connect logic are partially scaffolded but not yet complete.

This status can be revisited in future weeks as the remaining Sprint 2 and polish items are implemented and verified against the SRS.

