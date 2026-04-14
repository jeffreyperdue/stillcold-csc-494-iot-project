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

# **StillCold** — Week 12 Progress
## Sprint 2, Week 3: Flutter Companion App

*Closing the gap between what the app does and what the spec requires*

---

# Context: Where We Left Off

After last week's cold-environment hardware testing, the app could:

- Scan for and connect to a StillCold device over Bluetooth
- Display live temperature and humidity readings
- Trigger alerts when thresholds are crossed
- Persist settings and alert history between sessions

**What was still missing:**

The app met the minimum bar, but a defined set of "should have" features from the requirements spec had not yet been built. Week 12 was about implementing all of them.

---

# What Was Built This Week

Seven features from the requirements spec, plus two bug fixes and two small enhancements driven by testing feedback.

| Category | Items |
|----------|-------|
| New features | 7 spec requirements |
| Bug fixes | 2 |
| Enhancements | 2 |

All changes are in the Flutter companion app. No hardware changes this week.

---

# Feature: Auto-Connect

**What it does:** When the user opens the app and starts scanning, if their previously connected device appears in range, the app automatically navigates to the dashboard — no manual tap required.

**Why it matters:** Every session previously required the user to find their device in the list and tap it. With auto-connect, returning users get directly to their readings as soon as the device is detected.

**User control:** Auto-connect can be turned off in Settings for users who prefer to always choose manually.

---

# Feature: First-Run Onboarding Gate

**What it does:** The app now detects whether a user has ever connected to a device before.

- **First-time users** are shown the onboarding screen
- **Returning users** go directly to the device discovery screen

**Why it matters:** Previously, every launch started at the onboarding screen regardless of whether the user had set up the app before. This removes unnecessary friction for returning users while preserving the setup experience for new ones.

---

# Feature: Signal Strength Display

**What it does:** When viewing a connected device on the dashboard, the screen now shows the Bluetooth signal strength at the time of connection (e.g., "Signal: -64 dBm").

**Why it matters:** Signal strength gives the user context for connection reliability. A weak signal explains why readings may be slow or unreliable without requiring a technical diagnosis.

*Lower (more negative) dBm = weaker signal. -50 is strong; -90 is weak.*

---

# Feature: Device Label Editing

**What it does:** In the device list, a user can **long-press** any device to assign it a friendly name — for example, "Kitchen fridge" or "Garage freezer."

- The label appears in the device list instead of the raw device ID
- The label also appears on the dashboard header once connected

**Why it matters:** Device Bluetooth IDs are meaningless strings. Labels let users manage multiple StillCold devices without confusion.

---

# Feature: 24-Hour Min/Max Temperature

**What it does:** The dashboard readings card now shows the lowest and highest temperatures recorded over the past 24 hours, alongside the current reading.

> ↓ 2.1 °C    ↑ 4.8 °C    *24h range*

**Why it matters:** A single point-in-time reading tells you the current state. The 24h range tells you whether the environment has been stable — particularly useful for catching door-open events or overnight temperature swings that happen between manual checks.

---

# Feature: Stale Data Indicator

**What it does:** If a reading hasn't been refreshed within a reasonable time window (based on the configured polling interval), the "Last updated" timestamp turns **amber** and the connection chip changes to "Stale."

**Why it matters:** A connected device isn't the same as a healthy data feed. Without this indicator, the user has no way to tell whether they're looking at current data or something that's several minutes old — which matters if the fridge door was left open.

---

# Feature: Temperature Threshold Improvements

Two improvements to the threshold settings dialog:

**Rationale text** — The dialog now explains what thresholds to use:
> *Recommended: 0–4 °C (32–39 °F) for refrigeration; below 0 °C (32 °F) for freezers.*

**Unit consistency fix** — Previously, the threshold dialog always displayed values in Celsius even when the app was set to Fahrenheit. The dialog now shows, accepts, and saves values in whichever unit the user has selected.

---

# Bug Fix: Data Not Loading After Update

**What happened:** After deploying the week's changes, readings stopped loading entirely and the app showed an error message.

**Root cause:** The app stores readings in a local database. The database structure had evolved since it was first installed on the test device, but the app had no instructions for how to upgrade the existing database — so the old structure and new code were incompatible.

**Resolution:** Added a proper database upgrade path. Existing user data (settings, thresholds, preferences) was preserved. Readings history was cleared as part of the upgrade, since the old records were in an incompatible format.

---

# Bug Fix: 24h Min/Max Returning No Value

**What happened:** Even after the database was fixed, the 24h min/max row was not appearing on the dashboard.

**Root cause:** The database queries for minimum and maximum temperature were written incorrectly — a subtle technical error caused them to always return empty results rather than the stored readings.

**Resolution:** Rewrote both queries correctly. The fix also prevented a scenario where the minimum and maximum values could silently swap or return null in edge cases.

---

# Enhancement: Device Label on Dashboard

Previously the dashboard header always read "StillCold device" — a hardcoded placeholder.

It now shows the **user-assigned label** for the connected device (e.g., "Kitchen fridge"), and falls back to "StillCold device" only if no label has been set.

This required sharing the label-lookup logic between the device list screen and the dashboard screen — both now use the same underlying data source.

---

# Enhancement: Auto-Connect Toggle

Auto-connect (navigating directly to the dashboard when a known device is found) is useful by default but may not suit all users or workflows.

A new toggle in Settings — **"Auto-connect"** — lets the user enable or disable this behavior:

> *Automatically connect to your last device when it appears during a scan.*

On by default. When off, the user scans and taps manually as before.

---

# Database: Handling Upgrades Safely

The local database has now been through three structural versions:

| Version | What changed |
|---------|-------------|
| v1 | Original schema |
| v2 | Corrected readings and alert history tables |
| v3 | Added auto-connect preference to settings |

Each upgrade is applied incrementally — the app detects which version is installed and applies only the steps needed. User preferences and settings are preserved across all upgrades.

---

# SRS Requirement Coverage After Week 12

| Requirement Area | Status |
|-----------------|--------|
| Device discovery and connection | Complete |
| Auto-connect to last device | **Complete — this week** |
| Signal strength display | **Complete — this week** |
| Device labels | **Complete — this week** |
| Live readings (temperature + humidity) | Complete |
| 24h min/max temperature range | **Complete — this week** |
| Settings (units, polling, thresholds, quiet hours) | Complete |
| Threshold alerts with notifications | Complete |
| Alert history with timestamps | Complete |
| Stale-data detection and styling | **Complete — this week** |
| First-run onboarding gate | **Complete — this week** |
| Trend chart (7d / 30d) | Not yet started — Stretch |

---

# Looking Ahead

**Must** and **Should** requirements from the spec are now fully implemented.

Remaining items fall into two categories:

**Stretch (app):**
- Historical trend chart (7-day / 30-day sparkline)
- Data export

**Hardware:**
- One-MCU migration (plan is drafted and ready)
- Moving off the breadboard into a more durable enclosure

*The app is now feature-complete relative to the core spec. The next major milestone is the hardware consolidation.*

---

# Week 12 Summary

| Area | Status |
|------|--------|
| 7 "Should" spec requirements | Done |
| Database compatibility fixes | Done — no user data lost |
| Min/max query bug | Fixed |
| Device label on dashboard | Done |
| Auto-connect toggle in Settings | Done |
| Must + Should SRS coverage | **Complete** |

*The companion app now meets all Must and Should requirements in the spec.*

---

# Thank you

**StillCold** — *Environmental monitoring without opening the door*

Questions?
