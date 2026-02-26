# StillCold Power Options

This document assesses power supply options for the StillCold prototype, with a focus on reducing form factor while maintaining reliability in cold environments.

## Current Context

- **Current setup**: 5 V from USB (wall adapter or power bank). README lists "USB cables, 5 V USB wall adapter."
- **Load**: ESP32-C6 + (currently) Arduino Nano + HTU21D + level shifter — roughly **100–200 mA** when both MCUs are active; BLE dominates. HTU21D is negligible.
- **Use case**: SRS states StillCold uses its own power source (e.g., portable USB power bank) so it can remain operational when the refrigeration unit loses power.

---

## Option-by-Option Assessment

### 1. 1S Li-ion / LiPo (3.7 V nominal)

- **Viability**: Good. Single cell is simple; 3.7 V nominal (4.2 V max, ~3.0–3.3 V cutoff).
- **Fit**: ESP32-C6 is 3.0–3.6 V; Nano wants 5 V. So you need either a boost to 5 V for Nano (and optionally 3.3 V from that or from cell), or, if ESP32-only, you can run ESP32-C6 from a 3.3 V LDO from the cell — smallest form factor, fewest parts.
- **Pros**: Small, flat packs (e.g. 500–1000 mAh), low profile, rechargeable, good for reduced form factor.
- **Cons**: Needs protection (overcharge/over-discharge), and either a boost (Nano) or a clean 3.3 V LDO (ESP32-only). Cold: Li-ion capacity drops and internal resistance rises; still workable in a fridge, but runtime will be shorter.

**Summary**: Best fit if the design moves to **ESP32-only**; with two-MCU design it is still viable but adds a boost stage.

---

### 2. 18650 Li-ion Cell

- **Viability**: Very good. Single 18650 is 3.7 V nominal, 2000–3500 mAh, robust and well understood.
- **Fit**: Same voltage story as 1S LiPo: boost to 5 V if Nano stays; or 3.3 V LDO for ESP32-only.
- **Pros**: High capacity, cheap, easy to source, good cycle life. A small 1S module (protection + USB charging) keeps integration simple.
- **Cons**: Cylindrical shape increases form factor in one dimension; heavier than a small LiPo pouch. Cold behavior similar to 1S LiPo.

**Summary**: Strong for runtime and reliability; form factor is "different" (taller/round) rather than "minimal." Good if reducing form factor means "smaller than power bank" but not "flattest possible."

---

### 3. Two AA Lithium Batteries + Boost Converter

- **Viability**: Good. 2× 1.5 V lithium primary (e.g. Energizer L91) ≈ 3.0 V nominal (fresh ~3.2 V); boost to 5 V or 3.3 V is standard.
- **Fit**: Boost can feed 5 V to Nano or 3.3 V to ESP32-only; efficiency ~85–90% with a small DC-DC.
- **Pros**: No charging circuitry; good for cold (lithium primary handles cold better than Li-ion); simple integration; long shelf life.
- **Cons**: Non-rechargeable (ongoing cost, less "product-like"). Two AAs add volume; "AA" is not the smallest form factor.

**Summary**: Strong for **cold-environment validation** and simplicity; weaker for "smallest possible" and for a rechargeable prototype.

---

### 4. Direct 5 V USB Wall Adapter

- **Viability**: Trivial electrically — that is effectively what you have now (power bank is 5 V USB).
- **Fit**: Perfect for current two-MCU design; no change except cable and adapter.
- **Pros**: No battery design, no charge/discharge or cold-battery issues; smallest **device** form factor (no battery inside); reliable for demos and testing.
- **Cons**: No backup when fridge (or outlet) loses power; device must be near an outlet; not "portable" in the power-bank sense.

**Summary**: Best for **reducing device form factor** (no battery inside) and for focusing on cold testing and packaging — at the cost of giving up "works when power is out."

---

## Other Alternatives

- **Small USB power bank (slim / low profile)**  
  Keep 5 V USB but choose a much smaller bank (e.g. 2000–3000 mAh slim). No electrical redesign; form factor improves without new power architecture. Fits "reduce form factor" with minimal risk.

- **3.7 V → 5 V boost module (e.g. MT3608) + 1S LiPo**  
  If you want integrated rechargeable and smaller than 18650: small boost + small LiPo + simple USB charging module (e.g. TP4056). One extra PCB/module, but well within a later sprint if scope is kept tight.

- **ESP32-only + single-cell LDO**  
  If the design moves to ESP32-only: 1S LiPo/Li-ion → 3.3 V LDO only (no boost). Smallest and simplest integrated battery option; aligns with hardware consolidation and reduced form factor.

---

## Recommendation for Sprint 2

- **In Sprint 2**: Reduce form factor with a **smaller 5 V source** (small USB power bank or wall adapter) and/or neater cable placement when moving off breadboard. Document "power: 5 V USB, optional power bank for backup" and note that integrated battery is a future improvement.
- **Defer to a later sprint**: Full integrated battery (1S LiPo, 18650, or 2× AA + boost) once ESP32-only vs two-MCU is decided and cold testing is done. Then pick one option and implement it without overloading Sprint 2.

This keeps Sprint 2 focused on cold-environment validation, packaging, and Flutter–SRS alignment while still improving prototype form factor and leaving a clear path for integrated battery later.
