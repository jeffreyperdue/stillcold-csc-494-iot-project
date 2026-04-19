---
marp: true
size: 4:3
paginate: true
title: Final Project Rubric
---

# Final Project Rubric

- This is a **self-evaluation** rubric. Evaluate yourself as a professional problem solver.
- **Note:** This rubric covers the 500-point self-evaluation portion (project + learning with AI) and the 100-point evaluation of peers. HW (150 points) and midterm (250 points) are graded separately.
- All-or-nothing grading for each item (No partial points)
- Make sure to change the rubric file name correctly before submission
- Make sure you fill in all the (?) or ? marks with correct information
  - Use (V) for OK and (X) for not OK

---

## Information

- Name: Jeffrey Perdue
- Email: perduej7@nku.edu

---

## Summary

- One-line description of your project (focus on the problem you solved): An IoT device that monitors temperature and humidity inside a refrigerator and delivers live readings wirelessly over BLE — no door opening required.
- Why solving this problem is important: Opening an enclosure to check conditions disrupts the temperature and hides what is actually happening over time. BLE provides low-cost, short-range access without Wi-Fi, cellular, or network infrastructure.

---

- Your approach/solution: An HTU21D sensor wired to an ESP32-C6, which exposes readings as a BLE GATT server. A Flutter companion app connects, polls, stores readings locally, and provides live data, alerts, and trend charts.
- Technology stack used: HTU21D sensor, Seeed XIAO ESP32-C6, Arduino IDE/core, Flutter, Drift (SQLite), fl_chart, BLE GATT.

---
- Your two Learning with AI topics:
  - Topic 1: Hardware - Sensors and Data Acquisition
  - Topic 2: Software - Applications as System Interfaces

---
- Link to your Canvas page: https://nku.instructure.com/courses/88152/pages/individual-project-jeffrey-perdue
- Link to your GitHub repository: https://github.com/jeffreyperdue/stillcold-csc-494-iot-project

For Grading 1 & 2, you self-evaluate your problem definitions & solutions uploaded to GitHub & Canvas pages.

---

## Grading 1 - Project (300 points total)

Use the answers for your Marp slides.

### 1.1 Solving Problems (50 points)

#### Problem Domain (25 points)

* Use the answer for your resume
* Use this question/answer format for your future problem-solving

- (V) I clearly defined the problem I am solving.
- (V) I explained why this problem is important to solve.
- (V) My problem definition is accessible to my managers via Canvas or GitHub.

Describe your problem domain in your own words:
Monitoring temperature inside a refrigerated enclosure without opening it, while avoiding dependence on Wi-Fi or cellular. Every time you open the door to check, you change what you are measuring. The domain adds secondary concerns: sensor behavior in the cold, BLE penetration through a closed door, and distinguishing current readings from stale ones.

**Grading Scale:**
- 90-100%: I am confident that I clearly defined a meaningful problem and convincingly explained its importance; my managers can easily find and understand it.
- 70-89%: I defined the problem and explained its importance, but some parts could be clearer or more accessible to my managers.
- 50-69%: I attempted to define the problem, but the definition is vague or the importance is not well explained.
- 30-49%: My problem definition is incomplete or unclear, and my managers would struggle to understand it.
- 0-29%: I did not define the problem, or the definition is missing entirely.

**Points in Percentage**: (100)/100%
**Points:** (25)/25

---

#### Solution Domain (25 points)

* Also, use the answer for your resume
* Use this question/answer format for your future problem-solving

- (V) I clearly described my proposed solution.
- (V) I explained how my solution addresses the problem.
- (V) My solution design is documented and accessible to my managers.

Describe your solution domain in your own words:
An ESP32-C6 reads an HTU21D sensor over I²C and exposes temperature and humidity as BLE characteristics. A Flutter app polls those characteristics and persists readings locally, driving a dashboard with live data, 24h min/max, threshold alerts, stale-data detection, and trend charts. Hardware was simplified mid-project from a two-MCU design to a single ESP32-C6, with no app changes required.

**Grading Scale:**
- 90-100%: I am confident that I proposed a well-designed solution that clearly addresses the problem; it is fully documented and accessible.
- 70-89%: I described a reasonable solution and how it addresses the problem, but documentation or accessibility could be improved.
- 50-69%: I described a solution, but the connection to the problem is weak, or the documentation is incomplete.
- 30-49%: My solution description is vague, and it is unclear how it solves the problem.
- 0-29%: I did not describe a solution, or the description is missing entirely.

**Points in Percentage**: (100)/100%
**Points:** (25)/25

---

### 1.2 Implementation (150 points)

#### Technology (Tools) Stack (50 points)

- (V) I clearly described the technology stack (tools) I used.
- (V) I explained why I chose this technology stack for this problem.
- How you solved the problems with the technology stack (tools) with AI: AI helped me with initial understanding of the hardware itself, how to physically wire it to the breadboard, introduce me to Arduino IDE and enough C++ concepts to get me started, I used it to brainstorm, bounce ideas off of, and also to understand tradeoffs and pros/cons of different solutions. AI scaffolded the initial Sketches, helped me generate and refine the SRS document for the Flutter app, helped me implement features in the Flutter app.
- The technology stack I used: HTU21D sensor, Seeed XIAO ESP32-C6, Arduino IDE/core, Flutter, Drift (SQLite),
fl_chart, BLE GATT.

**Grading Scale:**
- 90-100%: I am confident that I clearly described the technology stack and provided a strong justification for why it was the right choice for my problem.
- 70-89%: I described the technology stack and gave a reasonable justification, but the reasoning could be more specific or thorough.
- 50-69%: I listed the technology stack, but the justification for choosing it is weak or missing.
- 30-49%: My technology stack description is incomplete or the choice seems unrelated to the problem.
- 0-29%: I did not describe the technology stack or it is missing entirely.

**Points in Percentage**: (100)/100%
**Points:** (50)/50

---

#### Demonstration Video (50 points)

- (V) I created a demonstration video clip showing my project results.
- (V) The video is accessible to my managers and the class.
- The link to my demonstration video: https://www.youtube.com/shorts/DTpED5YB1A8

**Grading Scale:**
- 90-100%: I am confident that my demonstration video clearly shows working project results and is easily accessible to anyone.
- 70-89%: I created a demonstration video showing results, but it could be clearer or more complete in what it demonstrates.
- 50-69%: I created a video, but it is difficult to follow, incomplete, or hard to access.
- 30-49%: My video is very rough, does not clearly demonstrate results, or has accessibility issues.
- 0-29%: I did not create a demonstration video or the link is missing/broken.

**Points in Percentage**: (100)/100%
**Points:** (50)/50

---

#### Marp Presentation (50 points)

- (v) I created a high-quality Marp presentation PDF with video clips for my final presentation.
- (v) The presentation PDF is uploaded to GitHub and accessible to anyone.
- The link to my Marp presentation PDF: ?

**Grading Scale:**
- 90-100%: I am confident that my Marp presentation is professional, clearly communicates my project with video clips, and is publicly accessible on GitHub.
- 70-89%: I created a Marp presentation that covers the key points, but it could be more polished, better organized, or video clips are missing.
- 50-69%: I created a presentation, but it is missing important content or does not fully represent my project results.
- 30-49%: My presentation is incomplete, hard to follow, or not properly uploaded and accessible.
- 0-29%: I did not create a Marp presentation or the link is missing/broken.

**Points in Percentage**: (100)/100%
**Points:** (50)/50

---

### 1.3 Progress According to the Plan (100 points)

#### Weekly Updates (100 points)

- (V) I have regularly updated my individual progress on Canvas.
- (V) I have regularly updated my project artifacts (code, documents) on GitHub.
- (V) My weekly updates are clearly accessible by my managers.

Provide a brief summary of your weekly progress:

- Week 1 (Week 10 of course): Planning and documentation only — no new code. Produced the hardware architecture doc, SRS gap analysis, and Sprint 2 backlog.
- Week 2 (Week 11 of course): Cold-environment testing (3 scenarios in a household refrigerator). Validated steady-state accuracy, door-event response, and power-cycle recovery. All scenarios passed; BLE stable throughout.
- Week 3 (Week 12 of course): Built 7 Flutter features (auto-connect, onboarding gate, RSSI display, device labels, 24h min/max, stale-data indicator, threshold unit fix) plus database migration and query bug fixes. All Must + Should SRS requirements complete.
- Week 4 (Week 13 of course): Single-MCU migration — removed the Arduino Nano, level shifter, and UART wire. Wired HTU21D directly to ESP32-C6, flashed new unified firmware, validated end-to-end. No app changes needed.
- Week 5 (Week 14 of course): Implemented trend charts (1h/24h/7d) with downsampling, gap visualization, and 30-day retention. Fixed landscape overflow and deviceId scoping bugs. All Must + Should + Stretch SRS requirements complete.

**Grading Scale:**
- 90-100%: I am confident that I updated my progress and artifacts consistently every week; my managers could always track my work without asking.
- 70-89%: I updated my progress most weeks, but there were a few gaps or updates were not always detailed enough.
- 50-69%: I updated my progress, but updates were irregular, incomplete, or hard for managers to find.
- 30-49%: My updates were very infrequent and managers would have had difficulty tracking my progress.
- 0-29%: I did not provide regular updates or there are no visible updates on Canvas or GitHub.

**Points in Percentage**: (100)/100%
**Points:** (100)/100

---

## Grading 2 - Learning with AI (200 points)

### Topic 1 (100 points)

- Topic name: Hardware - Sensors and Data Acquisition
- (V) I clearly explained what I learned from AI about this topic.
- (V) I interpreted the topic in my own words (not just copy-pasting from AI).
- (V) I created a high-quality Marp PDF slide for this topic.
- (V) The slide is publicly accessible (anyone can download it).
- The link to my Topic 1 Marp PDF slide: ?

What I learned and my interpretation:
The main thing I learned is that outputs from a sensor are interpretations, not just measurements. This showed up multiple times throughout the semester when working on this project. A sensor reading in isolation isn't an inherent truth, but rather a sample that's shaped by a number of variables.

Another thing I learned is the chain involved with each reading. The HTU21D samples the physical environment, converts an analog signal into a digital value using internal ADC circuitry, applies compensation algorithms documented in its datasheet, and hands a formatted number to the I²C bus. Obviously learning about some of these topics in class helped deepen my understanding. And alongside AI made troubleshooting and execution much easier.

**Grading Scale:**
- 90-100%: I am confident that I deeply understood the topic, expressed it in my own words, and created a clear, publicly accessible Marp slide that others can learn from.
- 70-89%: I explained the topic and created a slide, but the interpretation could be more original or the slide could be more polished and accessible.
- 50-69%: I covered the topic, but my explanation heavily relies on AI-generated text rather than my own interpretation.
- 30-49%: My explanation is superficial or mostly copied from AI with little evidence of personal understanding.
- 0-29%: I did not submit a slide or the explanation is missing entirely.

**Points:** (100)/100

---

### Topic 2 (100 points)

- Topic name: Software - Applications as System Interfaces
- (V) I clearly explained what I learned from AI about this topic.
- (V) I interpreted the topic in my own words (not just copy-pasting from AI).
- (V) I created a high-quality Marp PDF slide for this topic.
- (V) The slide is publicly accessible (anyone can download it).
- The link to my Topic 2 Marp PDF slide: ?

What I learned and my interpretation:
Coming from a more pure Software Engineering background, I had to shift the way I thought about applications. In this case, the Flutter application isn't standalone, but rather it is a layer in a physical system. As a product of that, understanding that and keeping that front of mind was essential in designing the holistic StillCold project. 

A big lesson as well was understanding the contraints of BLE, and having that drive the design of the application. I used AI to learn about key concepts like polling vs pushing and the GATT read model to better design the application. One way this made my life easier was in the transition to a single MCU. Since the application never knew the Nano existed and all the BLE information (service UUID, value format, etc.) was consistent, there was no coupling and I didn't have to worry about restructuring anything on the application side and could focus on the hardware alone. 

**Grading Scale:**
- 90-100%: I am confident that I deeply understood the topic, expressed it in my own words, and created a clear, publicly accessible Marp slide that others can learn from.
- 70-89%: I explained the topic and created a slide, but the interpretation could be more original or the slide could be more polished and accessible.
- 50-69%: I covered the topic, but my explanation heavily relies on AI-generated text rather than my own interpretation.
- 30-49%: My explanation is superficial or mostly copied from AI with little evidence of personal understanding.
- 0-29%: I did not submit a slide or the explanation is missing entirely.

**Points:** (100)/100

---

## Grading 3 - Evaluating Peers (100 points)

### Self-Evaluation as a Manager

- I am managing these three peers:
  - Student 1: Ryan Arnzen
  - Student 2: Jacob Canada
  - Student 3: Hunter Dreves

- (V) I have kept track of my three peers' progress regularly throughout the project.
- (V) I monitored both their project results and progress reports on Canvas.
- (V) I will submit my peer evaluation using the peer evaluation rubric.
- (V) I will submit my peer evaluation before the deadline.
- (V) I understand that failure to submit peer evaluations may result in failure of this course.
- (V) I will evaluate my peers professionally, fairly, and honestly.

**Grading Scale:**
- 90-100%: I am confident that I actively tracked all three peers throughout the project and will submit a thorough, fair, and professional evaluation.
- 70-89%: I tracked my peers' progress for most of the project, but my monitoring was not fully consistent.
- 50-69%: I checked on my peers occasionally but did not maintain regular tracking throughout the project.
- 30-49%: I did minimal peer monitoring and my evaluation will be based on limited observation.
- 0-29%: I did not track my peers or I do not plan to submit the peer evaluation.

**Points:** (100)/100

---

## Total Self-Grading Summary

| Category                          | Points           | Comment |
| --------------------------------- | ---------------- | ------- |
| 1.1 Solving Problems              | ( (50) / 50)      |         |
| 1.2 Implementation                | ( (150) / 150)     |         |
| 1.3 Progress According to Plan    | ( (100) / 100)     |         |
| 2. Learning with AI               | ( (200) / 200)     |         |
| **Total Points**                  | **( (500) / 500)** |         |

| Category                          | Points           | Comment |
| --------------------------------- | ---------------- | ------- |
| 3. Evaluating Peers               | ( (100) / 100)     |         |
| **Total Points**                  | **( (100) / 100)** |         |

---

## Checklist Before Submission

- (V) I checked that all rubric items are graded; no ? marks remain.
- (V) I filled in all the requested links (Canvas, GitHub, video, slides).
- (V) I understand the grading rules and have followed the rubric guidelines.
- (V) I uploaded this rubric file with the correct name: `Doe_John_project_rubric.md`
- (V) I will upload my peer evaluation using the peer evaluation rubric file.
- (V) I understand this assignment will be regraded and points can be deducted (up to 100%) if:
  - Any violation of academic integrity is detected
  - The rubric guidelines are not followed
  - The content is of low quality
