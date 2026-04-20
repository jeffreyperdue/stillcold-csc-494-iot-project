# StillCold

## Current Status — 4.19.26

Both sprints are complete. The project is fully delivered.

The final system is a single-MCU design: an HTU21D sensor wired directly to a Seeed XIAO ESP32-C6 exposes live temperature and humidity as BLE GATT characteristics. A Flutter companion app discovers, connects, polls, stores readings in SQLite, and provides a full-featured dashboard with alerts, settings, and trend charts.

**All Must, Should, and Stretch SRS requirements are implemented.**

The project will be presented as a live demonstration at the **NKU Celebration of Student Research and Creativity on Thursday, April 23, 2026**.

- **[Demo Video](https://www.youtube.com/shorts/DTpED5YB1A8)**
- **[Final Presentation](docs/presentations/final_marp_presentation/final_presentation.md)**

---

## 1. Hardware Components

The final hardware is a simplified single-MCU design. The Arduino Nano, logic level shifter, and UART wiring from Sprint 1 have been removed.

| Category | Components |
|----------|------------|
| MCU | Seeed XIAO ESP32-C6 |
| Sensor | HTU21D I²C temperature and humidity sensor (3.3 V) |
| Wiring | Breadboard, 4 jumper wires |
| Power | USB cable, 5 V USB wall adapter or power bank |
| Packaging | Silica gel, bag or basic enclosure |

**Removed in Sprint 2:** Arduino Nano, bidirectional logic level shifter, UART wiring.

---

## 2. Project Title and Description

StillCold is an educational IoT prototype focused on collecting environmental sensor data and exposing it wirelessly using Bluetooth Low Energy (BLE). The project explores how real-world measurements can move through an embedded system — from sensing to wireless access to a mobile UI — in a way that is easy to observe and reason about.

The final system connects an HTU21D temperature and humidity sensor directly to an ESP32-C6 microcontroller. The ESP32-C6 hosts a BLE GATT server that exposes live readings as readable characteristics. A Flutter companion app acts as the BLE client, polling readings, persisting them locally in SQLite, and providing a dashboard with alerts, trend charts, and settings.

While developed as a learning-focused prototype, StillCold is grounded in a real-world scenario: monitoring the temperature inside a refrigerated enclosure without opening it.

---

## 3. Problem Domain and Motivation

Monitoring the temperature inside a refrigerated or enclosed environment often requires opening that environment to check conditions. Doing so disrupts the internal temperature and makes it harder to understand what is actually happening over time.

Many existing monitoring solutions rely on Wi-Fi or cellular connectivity. Wi-Fi-based systems may depend on the same power source as the refrigerated environment, making them unreliable during power interruptions. Cellular solutions avoid this dependency but introduce ongoing costs and added complexity.

StillCold is motivated by a simple problem: measuring the temperature inside a refrigerated environment without having to access the inside of that environment directly, while avoiding reliance on Wi-Fi or cellular infrastructure. By using Bluetooth Low Energy (BLE), the system allows nearby devices to retrieve sensor data without disturbing the environment and without requiring continuous network connectivity.

---

## 4. Features and Requirements

### Sprint 1 Goal — achieved

Establish a reliable end-to-end data pipeline that measures internal temperature and exposes it via BLE, demonstrating a functional embedded prototype.

### Sprint 1 Features — delivered (Weeks 4–7)

- **Internal temperature and humidity measurement** via HTU21D sensor
- **BLE GATT service** on ESP32-C6 exposing temperature and humidity as readable characteristics
- **End-to-end data flow** from sensor through two-MCU pipeline to BLE
- **Flutter companion app MVP** — BLE discovery, connection, live dashboard, thresholds, quiet hours, alert history, local storage

### Sprint 2 Goal — achieved

Refine StillCold into a reliable, tested system that behaves well in realistic cold environments, with a companion app fully aligned to the SRS and a simplified single-MCU hardware design.

### Sprint 2 Features — delivered (Weeks 10–14)

- **Cold-environment validation** — Three test scenarios run in a real refrigerator: steady-state readings, door-event recovery, and power-cycle boot time. BLE stable throughout.
- **Auto-connect** — App reconnects to the last known device on launch.
- **Onboarding gate** — First-run walkthrough; returning users skip to dashboard.
- **RSSI display** — Live signal strength shown on the dashboard.
- **Device labels** — Long-press to rename a paired device.
- **24h min/max** — Shown at a glance on the dashboard.
- **Stale-data indicator** — Amber "Stale · last updated X min ago" warning when readings age past ~2–3 minutes.
- **Threshold unit consistency** — °C / °F alignment in threshold dialog.
- **Single-MCU migration** — Arduino Nano, level shifter, and UART pipeline removed; ESP32-C6 now reads HTU21D directly over I²C. Flutter app required zero changes.
- **Trend charts** — 1h / 24h / 7d line charts with temperature / humidity toggle, downsampling, gap visualization, outlier clamping, and Y-axis nice-number algorithm.
- **30-day data retention** — Rolling pruning policy on every insert; no background scheduler needed.
- **Database schema v4** — Composite index on `(deviceId, timestamp)`.

### Functional Requirements — all complete

- The system shall periodically collect temperature and humidity readings from the sensor.
- The system shall expose the most recent readings via BLE GATT characteristics readable by a nearby device.
- The system shall allow data to be accessed without opening the monitored environment.
- The system shall operate independently of internet connectivity.
- The system shall persist readings locally and support trend visualization over selectable time ranges.
- The system shall alert the user when readings cross configurable thresholds.

### Non-Functional Requirements — all met

- The system exposes data in a simple, human-readable format.
- The system prioritizes correctness and reliability over optimization.
- The system remains aligned with its original problem scope throughout both sprints.

---

## 5. System Architecture

### Final Architecture (Single-MCU)

```
HTU21D ──I²C (3.3 V)──▶ ESP32-C6 ──BLE (GATT)──▶ Flutter App ──▶ User
```

| Layer | Component |
|-------|-----------|
| Sensor | HTU21D temperature + humidity (I²C, 3.3 V, address `0x40`) |
| MCU / BLE server | Seeed XIAO ESP32-C6 — reads sensor, hosts GATT server, re-advertises on disconnect |
| Transport | BLE GATT — custom service UUID; temperature + humidity as read-only ASCII characteristics |
| App | Flutter — BLE client, live dashboard, threshold alerts, trend charts |
| App storage | Drift (SQLite) — schema v4, 30-day retention, composite index on `(deviceId, timestamp)` |
| Charting | fl_chart — 1h / 24h / 7d trend with downsampling, gap detection, outlier clamping |

### BLE GATT Table

| Element | Value |
|---------|-------|
| Advertised name | `StillCold` |
| Service UUID | `12345678-1234-1234-1234-1234567890ab` |
| Temperature characteristic UUID | `abcd1234-5678-1234-5678-abcdef123456` |
| Humidity characteristic UUID | `abcd5678-1234-5678-1234-abcdef654321` |
| Data format | ASCII string, 2 decimal places (e.g. `"23.54"`) |
| Access | Read-only (polled by app) |

### Data Model

The system works with a small, well-defined set of values:

- **Temperature** — primary measurement; exposed via BLE and stored in SQLite.
- **Humidity** — secondary measurement; exposed via BLE, stored, and visualized alongside temperature.

The app maintains a rolling 30-day history. Only the most recent reading is held in memory by the firmware; no historical data is stored on the device.

---

## 6. Sprint Progress Summary

| Week | Theme | Key Outcome |
|------|-------|-------------|
| **4** | Hardware setup | HTU21D ↔ Nano ↔ ESP32-C6 pipeline verified |
| **5** | Data acquisition | Reliable sensor reads and UART transfer |
| **6** | BLE | GATT service and characteristics implemented |
| **7** | End-to-end + app MVP | Full pipeline validated; Flutter MVP delivered |
| **10** | Stabilise and plan | Architecture docs, SRS gap analysis, Sprint 2 backlog |
| **11** | Cold-environment testing | 3 scenarios validated; BLE stable through fridge door |
| **12** | Flutter Must + Should | 7 features shipped; DB migrations; all core SRS done |
| **13** | Single-MCU migration | Nano + level shifter removed; unified ESP32-C6 firmware |
| **14** | Trend charts | 1h/24h/7d charts, downsampling, retention; all SRS tiers complete |

---

## 7. Links to Code, Documentation, and Presentations

### Source Code

- **[StillCold GitHub Repository](https://github.com/jeffreyperdue/stillcold-csc-494-iot-project)** — firmware, Flutter app source, architecture docs, cold-test reports, and all presentations.
- **[Learning with AI Repository](https://github.com/jeffreyperdue/csc-494-learning-with-ai)** — notes and reflections on AI-assisted learning throughout the project.
- **[Canvas Project Page](https://nku.instructure.com/courses/88152/pages/individual-project-jeffrey-perdue)**

### Presentations

| Presentation | Link |
|--------------|------|
| Project Preparation Presentation (PPP) | [docs/presentations/ppp/project_preparation_presentation.md](docs/presentations/ppp/project_preparation_presentation.md) |
| Sprint 1 Presentation (S1P) | [docs/presentations/s1p/s1p.md](docs/presentations/s1p/s1p.md) |
| Week 10 Progress | [docs/presentations/weekly_presentations/week_10/week10_progress_presentation.md](docs/presentations/weekly_presentations/week_10/week10_progress_presentation.md) |
| Week 11 Progress | [docs/presentations/weekly_presentations/week_11/week11_progress_presentation.md](docs/presentations/weekly_presentations/week_11/week11_progress_presentation.md) |
| Week 12 Progress | [docs/presentations/weekly_presentations/week_12/week12_progress_presentation.md](docs/presentations/weekly_presentations/week_12/week12_progress_presentation.md) |
| Week 13 Progress | [docs/presentations/weekly_presentations/week_13/week13_progress_presentation.md](docs/presentations/weekly_presentations/week_13/week13_progress_presentation.md) |
| Week 14 Progress | [docs/presentations/weekly_presentations/week_14/week14_progress_presentation.md](docs/presentations/weekly_presentations/week_14/week14_progress_presentation.md) |
| **Final Presentation** | [docs/presentations/final_marp_presentation/final_presentation.md](docs/presentations/final_marp_presentation/final_presentation.md) |
| **Demo Video** | [YouTube Short](https://www.youtube.com/shorts/DTpED5YB1A8) |

### Key Documentation

- **[Single-MCU Architecture](docs/project_context/architecture_docs/architecture_sprint2_single_mcu.md)** — Final hardware design, wiring table, BLE GATT table, I²C configuration, and firmware sketch reference.
- **[Flutter App SRS](docs/project_context/flutter_app_docs/flutter_app_srs.md)** — Full software requirements specification for the companion app.
- **[Sprint 2 Plan](docs/project_context/flutter_app_docs/sprint_2_plan.md)** — Sprint 2 objectives, scope (Must/Should/Stretch), and week-by-week schedule.
- **[Sprint 2 Backlog](docs/project_context/flutter_app_docs/sprint2_backlog.md)** — Detailed backlog items and completion status.
- **[Cold-Environment Test Report](docs/project_context/cold_environment_testing/cold_env_test_report.md)** — Week 11 test scenarios, results, and key findings.
- **[SRS Gap Analysis (Sprint 2 Start)](docs/project_context/flutter_app_docs/srs_gap_analysis_beginning_of_sprint_2.md)** — Baseline gap analysis that drove the Sprint 2 backlog.
