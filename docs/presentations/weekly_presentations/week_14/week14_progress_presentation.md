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

# **StillCold** — Week 14 Progress
## Sprint 2, Week 5: Trend Charts & Bug Clean-Upcd 

*The last stretch requirement — turning stored readings into a live, interactive chart*

---

# Context: Where We Left Off

After Week 13's single-MCU hardware migration, the system was clean end-to-end:

- The ESP32-C6 reads the HTU21D sensor directly and broadcasts over BLE
- The companion app connects, polls, stores readings in SQLite, and alerts on threshold crossings

**One item remained from the spec marked as Stretch:**

> *FR-3.6 — Display a simple trend chart of temperature and humidity over selectable time ranges (last 24h, 7 days).*

The `fl_chart` dependency was already in the project and a placeholder was visible on the dashboard. Week 14 was about replacing that placeholder with a real, production-quality chart.

---

# What Was Built This Week

| Category | Items |
|----------|-------|
| New feature | Trend chart with 1h / 24h / 7d range selection |
| New feature | Temperature / Humidity metric toggle |
| New feature | 30-day data retention policy |
| Data layer | Reactive Drift stream, composite DB index |
| Bug fix | Landscape overflow on dashboard and onboarding |
| Bug fix | deviceId scoping on min/max queries |
| Polish | Right-overflow fix on chart controls |
| Polish | Y-axis label bunching — nice-number interval algorithm |

---

# Design Considerations Before Building

Before writing any code, a planning phase identified the key decisions and edge cases:

- **Data volume** — at 30-second polling, 7 days = ~20,000 rows. Rendering all of them in a chart is unnecessary and slow. Downsampling is required.
- **Gaps in the line** — if the device was disconnected, the chart should show a visual break rather than drawing a straight line across the gap, which would imply data that doesn't exist.
- **No retention policy** — the database only ever inserted, never deleted. Without pruning, the database would grow indefinitely.
- **deviceId scoping** — the existing min/max queries aggregated readings across all devices. A latent bug if two devices are ever used.
- **Y-axis legibility** — auto-scaled axes on small data ranges produce crowded, non-round labels.

Each of these was addressed in the implementation.

---

# The Data Pipeline

The chart is driven by a **reactive Drift stream**, not a one-time query.

```
BLE poll → DashboardController → ReadingsRepository.addReading()
                                        ↓
                               Drift emits updated stream
                                        ↓
                          trendDataProvider (StreamProvider)
                                        ↓
                     bucket average → gap detect → TrendChartCard
```

Drift's `.watch()` API emits a new list whenever a row is inserted. This means the chart updates automatically after every poll cycle — no coordination with the dashboard controller required.

---

# Data Retention

**Problem:** The database had no pruning logic — it grew forever with every reading.

**Solution:** A rolling 30-day retention window, applied lazily on every insert.

When `addReading()` is called:
1. The new reading is inserted as normal
2. Any row older than 30 days is deleted

This approach requires no background task, no scheduler, and no app-startup overhead. The pruning cost is negligible — it runs in the same database transaction window as the insert, and the new composite index on `(deviceId, timestamp)` makes the delete fast.

**Database schema bumped to v4.** The migration adds the index without touching any existing data.

---

# Downsampling

Rendering 20,000 raw points in a chart is unnecessary. The data is **bucketed into averages** before it reaches the chart:

| Range | Bucket size | Max points rendered |
|-------|-------------|---------------------|
| 1h | 1-minute averages | 60 |
| 24h | 5-minute averages | 288 |
| 7d | 1-hour averages | 168 |

Buckets are computed in Dart, not SQL — this keeps the repository simple and the logic easy to adjust. Within each bucket, temperature and humidity values are averaged across all readings that fall in that window.

---

# Gap Visualization

When the device is disconnected for an extended period, there are no readings for that window. Connecting those points with a line would imply the environment was stable — which may not be true.

**How it works:** After bucketing, consecutive points are compared. If the time gap between them exceeds the gap threshold for the selected range, a special `nan` spot is inserted between them. `fl_chart` treats `nan` spots as line breaks — the line stops and restarts, leaving a visible gap.

| Range | Gap threshold |
|-------|--------------|
| 1h | 5 minutes |
| 24h | 15 minutes |
| 7d | 3 hours |

---

# The Chart UI

The trend chart card replaces the dashboard placeholder entirely.

**Controls (stacked full-width):**
- Range selector: **1h / 24h / 7d**
- Metric selector: **Temperature / Humidity**

**Chart features:**
- X-axis labels adapt to the selected range (clock times for 1h/24h, day names for 7d)
- Y-axis auto-scales to the data range, always landing on round numbers
- Area fill below the line with light opacity
- Tap any point to see an exact value and timestamp in a tooltip
- Temperature respects the user's °C / °F preference throughout

---

# Edge State Handling

The chart handles every state a user might encounter:

| State | What the user sees |
|-------|-------------------|
| Loading | Centered progress indicator |
| No readings at all | "No data yet — connect your device to start collecting" |
| Only one reading | "Not enough data — keep the device connected to build history" |
| Partial window | Amber notice: "Showing partial data — not enough history yet" |
| Humidity not available | "Humidity readings are not available for this period" |
| Query error | Error message with icon |
| Full data | Interactive line chart |

The "partial" state is detected by checking whether the oldest stored point is significantly newer than the start of the selected window — meaning the app hasn't been collecting long enough to fill the range.

---

# Outlier Guard

The BLE parser uses `double.tryParse()` — it handles malformed strings, but a sensor glitch can still return a physically valid-looking but extreme value (e.g., 180 °C due to a bit error).

A single extreme outlier would compress all the interesting data into a thin band at the bottom of the chart, making it unreadable.

**Fix:** All readings are clamped to physically reasonable ranges before charting:

| Metric | Clamped range |
|--------|--------------|
| Temperature | −50 °C to 100 °C |
| Humidity | 0% to 100% |

Outliers are removed from the visual; they remain in the database unchanged.

---

# Bug Fix: Landscape Overflow

Two screens produced overflow errors in landscape orientation.

**Dashboard (53px overflow):** The inner column — header, reading card, chart — had too much fixed content for the reduced landscape height. The column became scrollable via `SingleChildScrollView`, and the chart was given a fixed height of 280px instead of an `Expanded` that required unbounded space.

**Onboarding (205px overflow):** Three feature cards plus intro text exceeded landscape screen height. The column became scrollable, and the `Spacer()` before the Get Started button was replaced with a fixed `SizedBox` — `Spacer` has no effect inside a scroll view.

---

# Bug Fix: deviceId Scoping

The existing 24h min/max queries in the dashboard controller did not filter by `deviceId` — they returned the minimum and maximum temperature across **all devices in the database**.

This is harmless for single-device users, but would produce incorrect results the moment a second device is ever paired.

The fix was applied in two places:
- `ReadingsRepository.getMinTemperatureSince()` and `getMaxTemperatureSince()` now accept and filter by `deviceId`
- The `DashboardController` passes `deviceId` into both calls

---

# Polish: Y-Axis Label Algorithm

**Problem:** fl_chart draws axis labels at every `n × interval` position *and* at the `minY`/`maxY` boundaries. When the boundaries don't fall on the interval grid — which percentage-padded bounds almost never do — two labels end up within a fraction of an interval of each other, causing visual crowding.

**Fix — two-step approach:**

1. **Nice interval:** divide the data range by 4, then round up to the nearest value in the 1/2/5/10 scale (e.g., a 0.7°F range → raw interval 0.175 → rounds to 0.2)

2. **Snap bounds to the grid:** `yBottom = floor(yMin / interval) × interval`, `yTop = ceil(yMax / interval) × interval`. Now `minY` and `maxY` are always exact multiples of the interval — the boundary label and the nearest grid label are always the same point.

---

# Database: Schema History

| Version | What changed |
|---------|-------------|
| v1 | Original schema |
| v2 | Corrected readings and alert history tables |
| v3 | Added auto-connect preference to settings |
| **v4** | **Composite index on `readings(deviceId, timestamp)`** |

The v4 migration uses a `CREATE INDEX IF NOT EXISTS` statement — non-destructive, no data loss, no table rebuild. All existing rows are immediately covered by the new index.

---

# SRS Requirement Coverage After Week 14

| Requirement | Status |
|-------------|--------|
| Device discovery and connection | Complete |
| Auto-connect to last device | Complete |
| Signal strength display | Complete |
| Device labels | Complete |
| Live readings (temperature + humidity) | Complete |
| 24h min/max temperature range | Complete |
| Settings (units, polling, thresholds, quiet hours) | Complete |
| Threshold alerts with notifications | Complete |
| Alert history with timestamps | Complete |
| Stale-data detection | Complete |
| First-run onboarding gate | Complete |
| **Trend chart (1h / 24h / 7d)** | **Complete — this week** |

---

# Week 14 Summary

| Area | Status |
|------|--------|
| Trend chart — 1h / 24h / 7d ranges | Done |
| Temperature / Humidity toggle | Done |
| Reactive data pipeline (Drift stream) | Done |
| Downsampling (bucket averages per range) | Done |
| Gap visualization (nan breaks) | Done |
| Outlier clamping | Done |
| 30-day retention policy | Done |
| Composite DB index (schema v4) | Done |
| deviceId scoping fix on min/max queries | Done |
| Landscape overflow fixed (dashboard + onboarding) | Done |
| Y-axis nice-number interval algorithm | Done |
| All Must + Should + Stretch SRS requirements | **Complete** |

---

# Looking Ahead

All requirements from the spec — Must, Should, and the one Stretch item — are now implemented.

Remaining considerations for the project's final stretch:

- **Enclosure / packaging** — moving the hardware off the breadboard into something more durable and presentable
- **Data export** — not in the spec, but a natural extension for users who want to pull readings into a spreadsheet
- **Final documentation pass** — ensuring architecture docs, SRS traceability, and README reflect the current state of the system

*The StillCold system is now complete end-to-end: hardware, firmware, and a fully-featured companion app.*

---

# Thank you

**StillCold** — *Environmental monitoring without opening the door*

Questions?
