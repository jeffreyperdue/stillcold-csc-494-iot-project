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

# **StillCold** — Final Presentation
## Environmental monitoring without opening the door
### Jeffrey Perdue · CSC 494 · Spring 2026

---

# What is StillCold?

**The problem:** Every time you open a refrigerated enclosure to check the temperature, you change what you are measuring — and hide what is actually happening over time.

**The solution:** An HTU21D sensor wired to a Seeed XIAO ESP32-C6 exposes live temperature and humidity as BLE characteristics. A Flutter companion app polls those characteristics, persists readings locally, and provides a dashboard with alerts and trend charts.


---

# Final system architecture

```
HTU21D ──I²C──▶ ESP32-C6 ──BLE──▶ Flutter App ──▶ User
```

| Layer | Component |
|-------|-----------|
| Sensor | HTU21D temperature + humidity (I²C, 3.3 V) |
| MCU / BLE server | Seeed XIAO ESP32-C6 |
| Transport | BLE GATT (custom service + characteristics) |
| App + storage | Flutter · Drift (SQLite) · fl_chart |

*Single-MCU design finalised in Sprint 2 — Arduino Nano and level shifter removed.*

---

# Live Demonstration

**What you will see:**

- StillCold advertising as **STILLCOLD** over BLE
- Flutter app discovering, connecting, and displaying live temperature and humidity
- Settings
- Trend charts

---

# Demo Video

<p style="text-align:center; font-size:22px;">
<a href="https://www.youtube.com/shorts/DTpED5YB1A8">Link to Demo Video</a>
</p>

---

# Progress since S1P — Overview (Weeks 10–14)

| Week | Theme | Outcome |
|------|-------|---------|
| **10** | Stabilise & Plan | Architecture docs, SRS gap analysis, Sprint 2 backlog |
| **11** | Cold-Environment Testing | 3 scenarios validated; BLE stable through fridge door |
| **12** | Flutter Must + Should | 7 features shipped + DB migrations; all core SRS done |
| **13** | Single-MCU Migration | Nano + level shifter removed; unified ESP32-C6 firmware |
| **14** | Trend Charts | 1h/24h/7d charts, downsampling, retention; all SRS tiers complete |

**All Must + Should + Stretch SRS requirements complete.**

---

# What I Learned with AI — Topic 1
## Hardware: A Sensor Output Is an Interpretation

The HTU21D does not hand you "the temperature." It:

1. Capacitively senses a physical property
2. Runs an internal ADC conversion
3. Applies a compensation algorithm defined in its datasheet
4. Delivers a formatted value over I²C

Every step shapes what the number actually means. AI helped me work through the datasheet — conversion timing, the CRC error byte, the compensation curves — and connect classroom theory (ADC, sampling) to what I was observing on the bench.

> *The number is only as trustworthy as the chain that produced it.*

---

# What I Learned with AI — Topic 1 (continued)
## Cold Testing Made This Concrete

I wrapped the sensor in bubble wrap to protect it during the refrigerator test. The readings took far longer than expected to match the fridge air temperature.

**Why:** The bubble wrap insulated the sensor from the ambient air. The reading was accurate — for the sensor's immediate thermal environment. Not for the open fridge.

This was not a sensor malfunction. It was a measurement boundary problem.

**Design consequence:** A reading stamped "2 seconds ago" can still be wrong for the current state of the environment. That insight directly produced the stale-data indicator — an amber warning when no fresh reading has arrived in more than two minutes.

> *Testing is the only way to know whether an interpretation is actually useful.*

---

# What I Learned with AI — Topic 2
## BLE GATT Is a Read Model, Not a Push Model

Early in the project I thought of BLE like a network subscription — you connect, you get events. AI helped me understand how GATT actually works:

- The **client** (app) reads characteristics on demand
- The **server** (MCU) holds values and waits
- Notify/Indicate *are* possible but require explicit setup — and still depend on a live connection

**This drove every connection design decision:**

| Decision | Because |
|----------|---------|
| 2-second polling timer | Client must pull; server never pushes |
| Stale indicator | If polling stops, the last reading silently ages |
| Reconnect-on-disconnect | MCU can lose power at any time; app must recover gracefully |
| Re-advertise in `onDisconnect` | MCU must be ready when the app comes back |

---

# What I Learned with AI — Topic 2 (continued)
## Interface Stability Made a Hardware Refactor Invisible

From early in the project, AI helped me think about the BLE contract — service UUID, characteristic UUIDs, and ASCII value format — as a stable interface, independent of the hardware behind it.

**Sprint 1:** HTU21D → Nano → level shifter → ESP32-C6 → BLE

**Sprint 2 Week 13:** Entire hardware stack below the BLE layer was replaced.

```
Before: HTU21D → Nano (5 V) → level shifter → ESP32-C6 → BLE
After:  HTU21D → ESP32-C6 (3.3 V, I²C direct) → BLE
```

**The Flutter app required zero changes.**

Because the interface never changed, the app had no way to know the Nano ever existed. A complete hardware refactor was invisible to the software.

> *Good interface design is what makes components independently changeable.*

---

# Issues Encountered — Hardware & Firmware

**Issue 1: Wrong I²C pins in the migration plan**

The architecture document listed the wrong GPIO numbers for I²C on the XIAO ESP32-C6. Before writing any firmware, I verified the actual pinout against the hardware diagram.

- The correct pins are **GPIO 22 (SDA / D4)** and **GPIO 23 (SCL / D5)**
- Because this was caught before wiring, the first compile was correct

There was also a subtle firmware trap: the SparkFun HTU21D library calls `Wire.begin()` internally. Using `Wire.begin(SDA, SCL)` in the sketch would have been silently overwritten. The correct call is `Wire.setPins()` *before* the library initializes — it stores the pin values without starting the bus.

**Issue 2: Sensor error codes 998 / 999 not caught by the guard**

The Sprint 1 firmware used `isnan()` to detect bad sensor reads. The SparkFun library does not return NaN on error — it returns the numeric values `998` (I²C timeout) and `999` (bad CRC) as ordinary floats. The old guard let these through to BLE as `"998.00"`.

AI helped me find this by reading the library source. Fix: `temperature >= 998 || isnan(temperature)`.

---

# Issues Encountered — Testing Revealed a UX Gap

**Cold-environment test results (Week 11):**

| Scenario | Result |
|----------|--------|
| Steady-state (~1 h) | 37.7–38.2 °F; BLE stable throughout |
| Door open 35 s | +0.9 °F; recovered in ~12 min |
| Door open 3 min | +2.6 °F; recovered in ~23 min |

**The problem testing revealed:**

After a door event, the sensor continued reporting readings that were timestamped as "just now" — but those readings reflected a disrupted environment, not steady-state cold. The app had no way to signal this to the user.

The same problem applies to disconnects: if the device goes offline for ten minutes and then reconnects, the first fresh reading looks fine, but the user has no visibility into the gap.

**Solution:** Stale-data indicator — an amber "Stale · last updated X min ago" banner that appears whenever no reading has arrived in more than two minutes. This feature was not in the original spec. It came entirely from running the test.

---

# Issues Encountered — Database

**Issue 1: Migration crash on first deploy**

After shipping new schema changes, the app crashed on startup for anyone who had the existing database. The root cause: Drift's migration strategy was not handling every version transition explicitly. Version 2→3 had no defined path.

Fix: explicit `MigrationStrategy` with `fromVersion`/`toVersion` pairs for every schema version (v1→v2, v2→v3, v3→v4). Settings and alert history were preserved through all migrations.

**Issue 2: 24h min/max query returning empty**

The dashboard's 24-hour min/max display returned no data for all users. Root cause: the timestamp range condition used an incorrect unit in the `now - 86400` calculation — the comparison was off by a factor of 1000 (milliseconds vs. seconds). SQL rewrite resolved it.

**Issue 3: min/max aggregating across all paired devices**

The same min/max queries had no `WHERE deviceId = ?` filter — they returned the extremes across every device ever paired. Harmless for single-device users, but wrong by design. Added `deviceId` scoping to the repository methods and updated the dashboard controller to pass it.

---

# Links

| Resource | URL |
|----------|-----|
| **Canvas** | https://nku.instructure.com/courses/88152/pages/individual-project-jeffrey-perdue |
| **GitHub** | https://github.com/jeffreyperdue/stillcold-csc-494-iot-project |
| **Learning with AI** | https://github.com/jeffreyperdue/csc-494-learning-with-ai |
| **Demo Video** | https://www.youtube.com/shorts/DTpED5YB1A8 |

*All weekly presentations, firmware, Flutter source, architecture docs, and cold-test reports are in the GitHub repository.*

---

# NKU Celebration of Student Research and Creativity

**Thursday, April 23, 2026**

StillCold will be presented as a live demonstration at the **NKU Celebration of Student Research and Creativity**.

---

# StillCold Research Poster

![StillCold Research Poster h:480](../../project_context/StillCold_Poster_2.0-1.png)

---

# Thank you

**StillCold** — *Environmental monitoring without opening the door*

- **Canvas:** https://nku.instructure.com/courses/88152/pages/individual-project-jeffrey-perdue
- **GitHub:** https://github.com/jeffreyperdue/stillcold-csc-494-iot-project

*Questions?*
