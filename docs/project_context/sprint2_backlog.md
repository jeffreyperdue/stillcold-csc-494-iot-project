# StillCold Sprint 2 Backlog

> Finalized at end of Week 1 (Stabilize and Plan).
> Tags: **Must** / **Should** / **Stretch**
> Source: `sprint_2_plan.md`, `SRS_status_week7.md`, `srs_gap_analysis_week1.md`

---

## Must (Commit)

| # | Item | Category | Notes |
|---|------|----------|-------|
| M1 | Cold-environment testing on two-MCU baseline | Hardware / Testing | Fridge + freezer; BLE stability; serial logs; short report |
| M2 | Connection lifecycle: live state machine (connecting / connected / disconnected) | Flutter / BLE | FR-1.3; replace hard-coded `StatusChip` |
| M3 | Explicit Disconnect action → routes to Discovery | Flutter / BLE | FR-1.4 |
| M4 | Connection-lost UX: dedicated state + offer to reconnect | Flutter / BLE | FR-1.5, FR-5.2 |
| M5 | Periodic polling timer wired to `pollingIntervalSeconds` | Flutter / BLE | FR-2.5 |
| M6 | Bluetooth-off detection with clear actionable copy | Flutter / UX | FR-5.1 |
| M7 | Regression and stability checks after each major change | Testing | Confirm Sprint 1 behavior intact |

## Should (Aim For, Can Trim)

| # | Item | Category | Notes |
|---|------|----------|-------|
| S1 | Move off breadboard → perfboard or simple PCB | Hardware / Packaging | After Week 4 decision on two-MCU vs ESP32-only |
| S2 | Re-run cold tests on packaged hardware | Hardware / Testing | Confirm packaging didn't introduce instability |
| S3 | Stale reading indication in UI | Flutter / UX | FR-5.3; depends on M5 (polling) being done |
| S4 | Min/max summary on Dashboard (24h) | Flutter / Data | FR-3.7; backend query methods already exist |
| S5 | Auto-connect to last known device | Flutter / BLE | FR-1.6; `lastConnectedDeviceId` already stored |
| S6 | Connection-driven recovery (retry without restart) | Flutter / BLE | NFR-2.1 |
| S7 | RSSI shown on Dashboard (not just Discovery) | Flutter / UX | FR-1.7 |
| S8 | Device label editing UI | Flutter / UX | FR-1.8; Drift table and repository already exist |
| S9 | Threshold default rationale text in UI | Flutter / UX | FR-4.3 |
| S10 | Onboarding first-run gating and copy refinement | Flutter / UX | FR-5.5 |
| S11 | Flutter error/empty state polish (permissions, scan fail, read fail) | Flutter / UX | Builds on existing `EmptyState` component |

## Stretch (Only If Time Remains)

| # | Item | Category | Notes |
|---|------|----------|-------|
| X1 | ESP32-only refactor (remove Nano; HTU21D direct to ESP32-C6) | Hardware / Firmware | Time-boxed spike; Week 4 go/no-go decision |
| X2 | Trend chart — temperature/humidity over 24h / 7d | Flutter / Data | FR-3.6; requires charting library (`fl_chart`) |
| X3 | Polling battery impact validation | Flutter / Testing | NFR-3.2; validate once M5 is complete |
| X4 | Advanced app analytics (multi-day summaries, export) | Flutter / Data | Beyond SRS essentials |

