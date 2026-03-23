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

# **StillCold** — Week 10 Progress
## Sprint 2, Week 1: Stabilize, Document, and Plan

*Laying the foundation before building anything new*

---

# What Week 10 Was About

**Goal:** Before writing a single new line of code for Sprint 2, take stock of exactly where the project stands.

- **Document** the hardware architecture that was proven in Sprint 1.
- **Analyze** what the Flutter app is still missing relative to the formal SRS.
- **Prioritize** a concrete backlog for the full 6-week sprint ahead.

*This was a planning and documentation week — deliberately no new feature development.*

---

# Where We Left Off (End of Sprint 1)

The StillCold system reached a working end-to-end state by Week 7:

- **Hardware:** HTU21D sensor → Arduino Nano → ESP32-C6 → BLE advertising as `StillCold`.
- **App:** Flutter companion app discovers the device, reads live temperature and humidity, stores readings, and fires threshold alerts.
- **Gap:** Several SRS requirements were only partially implemented — connection lifecycle, polling, and trend charts were left as Sprint 2 targets.

Sprint 2 starts from this stable foundation and closes those gaps.

---

# The Two-MCU Hardware Architecture

The hardware design uses two microcontrollers with clearly separated roles:

- **Arduino Nano (5 V)** — Acts as the sensor host: polls the HTU21D over I²C, formats the reading, and sends it over UART.
- **ESP32-C6 (3.3 V)** — Acts as the communication host: receives UART data, parses it, and exposes it over BLE as a GATT server.

A **logic level shifter** bridges the 5 V Nano I²C bus down to the 3.3 V sensor.  
A **shared ground** between both boards is required for the UART link to work correctly.

*This split — "one board measures, one board shares" — was validated throughout Sprint 1.*

---

# Data Flow: Sensor to Phone

Every few seconds, data travels through four hops:

1. **HTU21D sensor** measures temperature and humidity (I²C, 3.3 V).
2. **Arduino Nano** reads the values and sends a short text message over UART:  
   → `T=20.6,H=28.7`
3. **ESP32-C6** receives the line, splits on `,`, parses the floats, and updates its BLE characteristics.
4. **Flutter app** reads those characteristics over BLE and displays them on the Dashboard.

The text format (`T=<float>,H=<float>`, newline-terminated, 9600 baud) was chosen because it is easy to validate by eye during debugging.

---

# BLE Layer: What the Phone Sees

The ESP32-C6 advertises a GATT server that the Flutter app connects to:

| Element | Detail |
|---------|--------|
| Advertised name | `StillCold` |
| Temperature characteristic | ASCII string, e.g. `"21.4"` — read-only |
| Humidity characteristic | ASCII string, e.g. `"34.2"` — read-only |
| After disconnect | Advertising restarts automatically |

BLE notify (push rather than poll) is a Sprint 2 stretch item — the app currently reads on demand.

---

# SRS Gap Analysis: What the App Is Still Missing

Three areas were identified as the highest-priority gaps entering Sprint 2:

**1. Connection Lifecycle**
- The connection status chip is hard-coded to `connected` — there is no live state machine.
- No explicit **Disconnect** button; the user can only navigate away.
- No dedicated **"Connection lost"** flow when BLE drops unexpectedly.

**2. Polling**
- `pollingIntervalSeconds` is stored in Settings but no timer is wired to it.
- The app only refreshes when the user taps the manual **Refresh** button.

**3. Trend / History**
- The trend chart is a placeholder card — no charting library is integrated yet.
- Min/max query methods exist in the backend but are not surfaced in the UI.

---

# Why the Connection Lifecycle Matters Most

Of the three gap areas, **connection lifecycle** has the widest visible impact:

- A user who walks away from the device and comes back has no clear indication the app has lost its reading source.
- Navigating "back" from the Dashboard does not cancel the BLE connection — the app is left in an ambiguous state.
- The SRS requires the app to offer a reconnect path without restarting.

**FR-1.3 + FR-1.4 + FR-1.5** will be addressed together in Week 12 as a single, focused pass — the most impactful thing Sprint 2 can deliver.

---

# Sprint 2 Backlog: Must Items

These are committed for the sprint — the demo must show all of them working:

| # | Item | Relevant SRS |
|---|------|-------------|
| M1 | Cold-environment testing on baseline hardware | — |
| M2 | Live connection state machine (connecting / connected / disconnected) | FR-1.3 |
| M3 | Explicit Disconnect action → routes to Discovery | FR-1.4 |
| M4 | Connection-lost UX + offer to reconnect | FR-1.5, FR-5.2 |
| M5 | Periodic polling timer wired to configured interval | FR-2.5 |
| M6 | Bluetooth-off detection with clear actionable copy | FR-5.1 |
| M7 | Regression and stability checks after each major change | — |

---

# Sprint 2 Backlog: Should and Stretch Items

**Should** (aim for, can trim if time is short):

- Stale reading indication once polling is wired (FR-5.3)
- Min/max 24h summary on Dashboard — backend already ready (FR-3.7)
- Auto-connect to last known device (FR-1.6)
- RSSI shown on Dashboard, device label editing, onboarding polish

**Stretch** (only if time remains):

- ESP32-only refactor — remove the Nano and wire the HTU21D directly (time-boxed spike)
- Trend chart with `fl_chart` — 24h / 7d temperature and humidity (FR-3.6)
- Polling battery-impact validation

---

# Sprint 2 Week-by-Week Plan (High Level)

| Week | Focus |
|------|-------|
| **10** (this week) | Stabilize, document, plan — no new code |
| **11** | Cold-environment testing; confirm BLE stability under temperature stress |
| **12** | Connection lifecycle pass (M2, M3, M4) |
| **13** | Polling + stale readings (M5, S3); hardware packaging decision |
| **14** | Min/max UI, UX polish, error states (S4, S7–S11) |
| **15** | Buffer, stretch items, demo prep |

*This schedule keeps Must items front-loaded and leaves room for hardware surprises.*

---

# Open Items Going Into Week 11

A few details still need to be confirmed from the physical hardware:

- **Pin numbers** — Nano TX pin and ESP32-C6 RX pin are not yet recorded in documentation.
- **BLE UUIDs** — Service and characteristic UUIDs need to be pulled from the firmware `BleConfig`.
- **Polling interval** — The exact interval the Nano uses to read the sensor is assumed but not yet documented.

These are low-risk items that will be captured during the cold-testing session in Week 11.

---

# Week 10 Summary

| Area | Status |
|------|--------|
| Hardware architecture documented | Done — two-MCU diagram, UART protocol, BLE GATT table |
| SRS gap analysis | Done — connection lifecycle, polling, trend/history prioritized |
| Sprint 2 backlog | Done — 7 Must, 11 Should, 4 Stretch items |
| New feature code written | None — intentionally |

*Week 10 was about knowing exactly what needs to be built before building it.*  
Sprint 2 now has a clear plan, a documented baseline, and a prioritized list of work to close the remaining SRS gaps.

---

# Thank you

**StillCold** — *Environmental monitoring without opening the door*

Questions?
