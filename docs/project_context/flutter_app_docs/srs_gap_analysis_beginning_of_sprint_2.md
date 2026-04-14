# StillCold Flutter App — SRS Gap Analysis (Sprint 2 Week 1)

> Source: `flutter_app_srs.md` and `SRS_status_week7.md`.
> Focus: connection lifecycle, polling, trend/history — the three areas called out in the Sprint 2 Week 1 plan.

---

## 1. Connection Lifecycle Gaps

These are the most critical gaps for Sprint 2. The app has BLE reads working but no real connection state machine.

| ID | Requirement | Current status | What's missing |
|----|-------------|---------------|----------------|
| FR-1.3 | Display connection status (disconnected / connecting / connected) | **Partial** — `StatusChip` hard-coded to `connected` | Live state machine driven by actual BLE connection events |
| FR-1.4 | Explicit Disconnect action → return to Discovery | **Partial** — back navigation only | A "Disconnect" button that cancels the active connection and routes to Discovery with clear copy |
| FR-1.5 | Handle connection loss gracefully; inform user | **Partial** — errors shown, no dedicated flow | "Connection lost" UX driven by BLE disconnect callbacks; offer to reconnect |
| FR-1.6 | Remember last device; offer auto-connect | **Partial** — `lastConnectedDeviceId` stored, hint shown | Actual auto-connect logic when last device is found in scan |
| NFR-2.1 | Recover from disconnection without app restart | **Partial** — no crash, but recovery is manual | Connection-driven recovery flow (retry / back to Discovery) |

**Sprint 2 priority:** All of the above are **Must** for Sprint 2 polish. FR-1.3, FR-1.4, and FR-1.5 are the highest-impact and should be addressed in Week 3 together as a single connection lifecycle pass.

---

## 2. Polling Interval Gaps

| ID | Requirement | Current status | What's missing |
|----|-------------|---------------|----------------|
| FR-2.5 | Periodic polling while connected (configurable, 5–30 s) | **Not started** — `pollingIntervalSeconds` in settings but no timer | Wire a periodic `Timer` (or equivalent Riverpod async pattern) to call `DashboardController.refresh()` on the configured interval |
| FR-5.3 | Indicate stale readings (older than threshold) | **Not started** — "Last updated" text exists, no stale styling | Add a staleness threshold (e.g. 2× polling interval); change "Last updated" color/style and optionally show a warning icon |
| NFR-3.2 | Polling must not significantly impact battery | **Not applicable yet** | Validate once polling is wired; use a reasonable minimum interval (≥ 10 s) and cancel timer when app is backgrounded |

**Sprint 2 priority:** FR-2.5 is **Must** (core SRS gap). FR-5.3 is **Should** (directly useful once polling is working). NFR-3.2 is **Should** (validate during Week 3 or 5).

---

## 3. Trend / History Gaps

| ID | Requirement | Current status | What's missing |
|----|-------------|---------------|----------------|
| FR-3.6 | Trend chart (temperature/humidity, 24h / 7d) | **Not started** — placeholder card only | Add a charting library (e.g. `fl_chart`); query `ReadingsRepository` for time range; render line chart |
| FR-3.7 | Min/max summary for a period (e.g. last 24h) | **Planned** — backend query methods exist | Surface `getMinTemperatureSince` / `getMaxTemperatureSince` results in the Dashboard UI |
| FR-2.7 | "Last updated" indicator | **Done** | — |
| FR-3.5 | SQLite storage for readings | **Done** | — |

**Sprint 2 priority:** FR-3.7 (min/max) is **Should** — backend is ready, it's a UI wiring task. FR-3.6 (trend chart) is **Stretch** — requires a new dependency and more design work.

---

## 4. Other Partial / Missing Items (Lower Priority)

These were noted in the SRS status but are lower urgency than the three focus areas above.

| ID | Requirement | Status | Sprint 2 priority |
|----|-------------|--------|-------------------|
| FR-1.7 | RSSI on Dashboard (not just Discovery list) | Partial | Should |
| FR-1.8 | Device label editing UI | Partial — backend ready | Should |
| FR-4.3 | Threshold default rationale shown in UI | Partial | Should |
| FR-5.1 | Explicit Bluetooth-off detection and copy | Partial | Must |
| FR-5.2 | Dedicated "Connection lost" empty state | Partial | Must (overlaps FR-1.5) |
| FR-5.5 | Onboarding first-run gating and full copy | Partial | Should |

---

## 5. Summary: Prioritized Gap List

### Must (address in Sprint 2 before demo)

1. **FR-1.3 / FR-1.4 / FR-1.5** — Full connection lifecycle: live state machine, explicit Disconnect, connection-lost UX
2. **FR-2.5** — Periodic polling timer wired to configurable interval
3. **FR-5.1 / FR-5.2** — Bluetooth-off detection; "Connection lost" dedicated state

### Should (aim for, can trim if time is short)

4. **FR-5.3** — Stale reading indication (depends on FR-2.5 being done)
5. **FR-3.7** — Min/max summary on Dashboard (backend already ready)
6. **FR-1.6 / NFR-2.1** — Auto-connect + connection recovery
7. **FR-1.7** — RSSI on Dashboard
8. **FR-1.8** — Device label editing UI
9. **FR-5.5** — Onboarding polish

### Stretch (only if time remains)

10. **FR-3.6** — Trend chart (24h / 7d)
11. **NFR-3.2** — Polling battery impact validation
