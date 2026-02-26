# StillCold

## Current status (end of Sprint 1)

Sprint 1 is complete. The project currently has:

- **Full end-to-end embedded pipeline:** HTU21D sensor → Arduino Nano → ESP32-C6 → BLE → external device.
- **BLE service** on ESP32-C6 exposing temperature and humidity as readable characteristics.
- **Flutter companion app MVP:** Discovers StillCold over BLE; connects and reads live temperature and humidity; displays readings in a dashboard; supports thresholds, quiet hours, and alert history.

For Sprint 2 scope, week-by-week plan, and priorities, see **[Sprint 2 Plan](docs/project_context/sprint_2_plan.md)**.

---

## 1. Hardware Components

StillCold is built using the following hardware components. This list reflects the complete and current parts list for the project.

| Category | Components |
|----------|------------|
| MCUs | ESP32-C6, Arduino Nano |
| Sensor | HTU21D I²C temperature and humidity sensor |
| Safety | Bidirectional logic level shifter |
| Wiring | Breadboard, jumper wires |
| Assembly | Pin headers |
| Power | USB cables, 5 V USB wall adapter |
| Packaging | Silica gel, bag or basic enclosure |

## 2. Project Title and Description

StillCold is an educational IoT prototype focused on collecting environmental sensor data and exposing it wirelessly using Bluetooth Low Energy (BLE). The project explores how real-world measurements can move through an embedded system, from sensing to wireless access, in a way that is easy to observe and reason about.

The system combines a temperature and humidity sensor with two microcontrollers, separating data collection from wireless communication to keep responsibilities clear and the design modular. This structure allows the project to focus on core system behavior without unnecessary complexity.

While developed primarily as a learning-focused prototype, StillCold is grounded in scenarios that resemble real-world environmental monitoring. The project prioritizes clarity, correctness, and end-to-end functionality over optimization or polish.

## 3. Problem Domain and Motivation

Monitoring the temperature inside a refrigerated or enclosed environment often requires opening that environment to check conditions. Doing so disrupts the internal temperature and makes it harder to understand what is actually happening over time.

Many existing monitoring solutions rely on Wi-Fi or cellular connectivity. Wi-Fi-based systems may depend on the same power source as the refrigerated environment, making them unreliable during power interruptions. Cellular solutions avoid this dependency but introduce ongoing costs and added complexity.

StillCold is motivated by a simple problem: measuring the temperature inside a refrigerated environment without having to access the inside of that environment directly, while avoiding reliance on Wi-Fi or cellular infrastructure. By using Bluetooth Low Energy (BLE), the system allows nearby devices to retrieve sensor data without disturbing the environment and without requiring continuous network connectivity.

This problem provides a practical context for exploring sensor behavior in cold, enclosed spaces and for understanding how short-range wireless communication can support reliable, low-overhead monitoring.

## 4. Features and Requirements

StillCold is designed around a small set of clearly defined features and requirements, framed through a software-oriented lens while remaining appropriate for an embedded system. The focus is on observable behavior and system responsibilities rather than implementation details.

### Sprint 1 Goal (achieved)

Establish a reliable end-to-end data pipeline that measures internal temperature and exposes it via BLE, demonstrating a functional embedded prototype.

### Sprint 1 Features (Prototype / MVP) — delivered

- **Internal temperature measurement**  
  The system measures temperature inside the monitored environment using an internal sensor. Humidity measurements are collected as supporting context but are not the primary focus.

- **Wireless temperature access via BLE**  
  The system exposes the most recent temperature reading through a readable Bluetooth Low Energy (BLE) characteristic that can be accessed by a nearby device.

- **End-to-end data flow**  
  Temperature data flows from the sensor, through the system, and to the BLE interface without manual intervention.

- **Initial mobile application groundwork**  
  A Flutter companion app acts as a BLE client: it discovers StillCold devices, connects, and displays live temperature and humidity in a dashboard. Sprint 1 delivery includes thresholds, quiet hours, alert history, and local storage; further alignment with the SRS continues in Sprint 2.

- **No external infrastructure dependency**  
  The system operates without reliance on Wi-Fi or cellular connectivity.

### Sprint 1 Functional Requirements

- The system shall periodically collect temperature readings from the internal sensor.
- The system shall transmit the most recent temperature reading to a BLE-capable device upon request.
- The system shall allow temperature data to be accessed without opening the monitored environment.
- The system shall operate independently of internet connectivity.

### Sprint 1 Non-Functional Requirements

- The system should expose temperature data in a simple, readable format.
- The system should prioritize correctness and reliability over optimization.
- The system should be understandable and observable during development and testing.

### Sprint 1 Weekly Milestones — completed

- **Week 4**  
  Hardware setup and verification, including sensor communication and microcontroller integration.

- **Week 5**  
  Reliable temperature data acquisition and transfer between system components.

- **Week 6**  
  BLE service and characteristic implementation with readable temperature data.

- **Week 7**  
  End-to-end system validation and Flutter companion app MVP (discovery, dashboard, thresholds, quiet hours, alert history).

### Sprint 2 Goal

Refine StillCold into a reliable, tested system that behaves well in realistic cold environments and has a companion app aligned with the SRS, while cautiously exploring hardware consolidation. See **[Sprint 2 Plan](docs/project_context/sprint_2_plan.md)** for objectives, scope (Must/Should/Stretch), and week-by-week schedule.

### Sprint 2 Features (Refinement and Extension)

- **Improved reliability and stability**  
  The system improves consistency in sensor readings and BLE data exposure.

- **Expanded environmental context**  
  Humidity data may be incorporated more explicitly to provide additional context for temperature readings.

- **Mobile application integration**  
  The Flutter application communicates with the StillCold prototype via BLE and displays live temperature data to the end user.

- **Refined system behavior**  
  The system may improve update strategies, data representation, or internal structure based on Sprint 1 outcomes.

### Sprint 2 Functional Requirements

- The system shall improve robustness of temperature data collection and transmission.
- The system shall support refinements to BLE data representation without breaking existing behavior.
- The system shall enable BLE communication with a mobile device running the Flutter application.
- The system shall incorporate lessons learned from Sprint 1 into updated system behavior.

### Sprint 2 Non-Functional Requirements

- The system should maintain a clear separation of responsibilities between sensing and communication.
- The system should support incremental improvement without requiring architectural redesign.
- The system should remain aligned with its original problem scope.

## 5. Data Model and Architecture

StillCold uses a simple data model and a modular system architecture designed to support clarity, reliability, and incremental development.

### Data Model

At a high level, the system works with a small set of environmental data values:

- **Temperature**  
  The primary measurement produced by the system and exposed to external devices.

- **Humidity**  
  A secondary measurement used to provide additional environmental context and support future refinement.

Each data value is represented in a simple, human-readable form suitable for inspection during development and testing. The system maintains only the most recent sensor readings and does not persist historical data.

This minimal data model is intentional, allowing the project to focus on correctness and end-to-end data flow rather than storage or analysis.

### System Architecture

The system is organized around two logical components with clearly defined responsibilities:

- **Sensing Component**  
  Responsible for interfacing with the environmental sensor and collecting temperature (and humidity) readings at a regular interval.

- **Communication Component**  
  Responsible for exposing the most recent sensor readings through a Bluetooth Low Energy (BLE) interface.

Sensor data flows from the sensing component to the communication component, where it is made available via a BLE service and characteristic. A nearby device can read this data without requiring direct access to the monitored environment.

This separation of responsibilities keeps the system modular and easier to reason about, while allowing individual components to be refined independently as the project evolves.

## 6. Links to Code, Documentation, and Presentations

All artifacts related to StillCold are organized across dedicated repositories and course resources.

### Source Code

**Project Repository:**  
[[StillCold](https://github.com/jeffreyperdue/stillcold-csc-494-iot-project)]  
The primary repository containing source code, configuration files, and project-specific documentation for StillCold.

### Learning with AI

**Learning with AI Repository:**  
[[Learning With AI](https://github.com/jeffreyperdue/csc-494-learning-with-ai)]  
A separate repository containing documentation, notes, and reflections related to AI-assisted learning activities, including exploration of sensor behavior and BLE data design.

### Documentation

Project documentation, including the project outline and README files, is maintained within the project repository. Key documents include:

- **[Sprint 2 Plan](docs/project_context/sprint_2_plan.md)** — Current state, Sprint 2 goal, scope, and week-by-week plan.
- **[Flutter app SRS](docs/project_context/flutter_app_srs.md)** — Software requirements for the companion app.
- **[SRS status (Week 7)](docs/project_context/SRS_status_week7.md)** — Implementation status of the Flutter app relative to the SRS.

Additional documentation may be introduced as the project evolves.

### Presentations

- **Project Preparation Presentation (PPP)** — Course platforms as finalized.
- **Sprint 1 Presentation (s1p)** — [docs/presentations/s1p/s1p.md](docs/presentations/s1p/s1p.md) — Summary of Sprint 1 progress (weeks 4–7).
