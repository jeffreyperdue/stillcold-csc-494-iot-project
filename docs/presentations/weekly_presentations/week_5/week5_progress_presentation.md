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
    max-height: 82vh;
    max-width: 100%;
    width: auto;
    height: auto;
    object-fit: contain;
  }
---

# **StillCold** — Week 5 Progress
## Reliable temperature data inside the system

*A brief update on where the project stands*

---

# What Week 5 Was About

**Goal:** Make sure temperature and humidity data move reliably inside the device, from the sensor to the part that will later talk wirelessly.

- Have one small computer focus on **reading the sensor**.
- Have a second small computer focus on **holding and sharing the latest readings**.
- Build a simple, structured way for them to **talk to each other** and keep the data trustworthy.

*This week was about the “plumbing” inside the box, not the app or Bluetooth yet.*

---

# The Two Main Pieces

Inside the StillCold system, there are now two clearly defined roles:

- **Sensing component (Arduino Nano)**  
  - Reads temperature and humidity from the sensor.  
  - Sends those readings out as simple text messages.

- **Communication component (ESP32-C6)**  
  - Listens for those messages.  
  - Stores the most recent temperature and humidity.  
  - Shows the results on a computer screen for easy checking.

*Think of it as one device doing the measuring, and another device preparing the data to be shared.*

---

# What Was Achieved

By the end of Week 5:

- **Internal data flow is reliable** — Readings consistently travel from the sensor board to the communication board without corruption.
- **Data has a clear, simple format** — Each reading is sent as a short text line like “temperature = X, humidity = Y”.
- **Values are stored for later use** — The communication board keeps the latest numbers ready for when Bluetooth and apps are added.
- **The system is observable** — We can watch the data update on a computer screen every few seconds to confirm everything is working.

---

# How the Data Moves (Plain Language)

Every few seconds:

1. The sensing board reads the **temperature and humidity**.
2. It creates a simple message:  
   - “T = 20.6, H = 28.7” (for example).
3. It sends that message over a short wired link to the communication board.
4. The communication board:
   - **Listens for a full line** of text.  
   - **Pulls out the numbers** for temperature and humidity.  
   - **Stores** them and shows them on the screen.

*This simple text format makes it easy to test, debug, and trust the readings.*

---

# Assumptions We Validated

- **Two-board design works well** — Splitting “sense the environment” and “share the data” across two devices is practical and reliable.
- **Simple text messages are enough** — Using clear text for readings makes it easy to confirm that the system is behaving correctly.
- **Regular updates are stable** — The system can send and receive new readings every few seconds without crashing or drifting.

---

# What We Corrected or Clarified

- **Pin choices matter** — The communication board needed its data pins explicitly assigned so that it listened on the correct wires.
- **Power and ground must be shared** — Both boards must share a common reference (ground) so that the data link works consistently.
- **Upload vs. operation** — We confirmed that certain connections can interfere with reprogramming one of the boards, and adjusted our workflow to avoid that.

*These details help prevent confusing behavior later, when more features are added.*

---

# Ready for the Next Step

**Current state:**  
The StillCold prototype now has a **trustworthy internal data pipeline**:

Sensor → Sensing board → Safe voltage conversion → Communication board → Stored values → Screen output

- Data flows steadily and accurately.  
- The relationship between the two boards is well understood and documented.  
- We have confidence in the numbers we see.

**Next:**  
Use this stable internal data stream to **expose readings over Bluetooth** and support user-facing applications.

---

# Summary

| Area                     | Status                                      |
|--------------------------|---------------------------------------------|
| Internal data pipeline   | Working; sensor-to-board link is reliable   |
| Data format & storage    | Defined, simple, and tested                 |
| Hardware interactions    | Verified pins, shared ground, safe levels  |
| Foundation for wireless  | In place and ready to build on             |

*StillCold is on track, with a solid internal data flow ready for wireless and app integration.*

---

# Thank you

**StillCold** — *Environmental monitoring without opening the door*

There are also images of my code and output in my weekly_presentations folder