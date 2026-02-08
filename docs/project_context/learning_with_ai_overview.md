# StillCold — Learning with AI

## 1. Purpose of Learning with AI

In CSC 494, AI is introduced not as a replacement for thinking, but as a *second brain*. A place to offload context, ask better questions, and work through uncertainty. The Learning with AI component of StillCold is grounded in that idea. AI is used as a cognitive support, something to think with, not something that thinks for the project.

Much of what this project explores sits in unfamiliar territory. Sensors do not behave perfectly. Documentation is dense. System behavior is often shaped by factors that are not obvious at first glance. In these moments, AI functions as an external aid. It helps surface relevant concepts, clarify technical language, and expose tradeoffs that might otherwise take much longer to uncover through trial and error alone.

Within StillCold, Learning with AI focuses on two areas: how physical measurements are converted into digital data, and how software applications act as interfaces to external hardware systems. Both require building mental models that connect theory, documentation, and observed behavior. AI is used to help assemble those models and to pressure-test assumptions as the system evolves.

The intent is not to outsource understanding. It is to build it. Learning with AI is documented through reasoning, design decisions, and reflection, showing how AI-assisted exploration informed the direction of the project rather than dictating it.

---

## 2. Hardware Learning Topic  
### Sensors and Data Acquisition  
*How physical measurements are converted into digital data*

A central hardware learning focus of StillCold is understanding how physical conditions in the real world are transformed into digital values that software can interpret and act upon. While temperature and humidity readings often appear as simple numbers, the process that produces those values is layered, imperfect, and shaped by both the sensor and its environment.

This learning topic centers on how sensors observe physical phenomena, how those observations are sampled and represented digitally, and what assumptions are embedded in that process. Rather than treating sensor output as inherently correct, this project approaches sensor data as an interpretation of the physical world, influenced by resolution, timing, environmental factors, and the limitations of the sensing hardware itself.

AI is used as a “second brain” to help unpack this process. It supports interpreting sensor datasheets, clarifying how measurements are derived, and identifying factors that affect accuracy and reliability. These insights are then compared against observed system behavior to refine understanding and guide design decisions.

This learning is expected to evolve as the prototype is exercised and tested. As new behaviors are observed, assumptions about sensor data are revisited and refined, reinforcing the idea that data acquisition is an ongoing process of interpretation rather than a one-time configuration step.

Through this lens, Sensors and Data Acquisition becomes less about obtaining a value and more about understanding what that value represents, how it might be misleading, and how much confidence the system can reasonably place in it. This perspective informs both the design of the StillCold prototype and the way its output is interpreted by downstream software.

---

## 3. Software Learning Topic  
### Applications as System Interfaces  
*How software applications interact with external hardware*

The software learning focus of StillCold centers on understanding how applications function as interfaces between users and physical systems. Rather than treating the application as a standalone product, this project approaches the application as one component within a broader system, responsible for observing, interpreting, and presenting data produced by external hardware.

Within this system, Bluetooth Low Energy (BLE) serves as the primary mechanism through which the application communicates with the embedded prototype. This introduces constraints around data availability, update frequency, and connectivity that shape how the application must be designed and how it behaves at runtime.

In this context, the application’s role is not to control hardware directly, but to serve as a bridge between embedded system behavior and human understanding. Data must be requested, received, and displayed in a way that is meaningful while remaining resilient to the limitations of short-range wireless communication. This requires thinking beyond surface-level interface design and toward system interaction as a whole.

AI is used as a “second brain” to help reason about how applications communicate with external hardware systems over BLE. It supports exploring common interaction patterns, clarifying the responsibilities of the application layer, and evaluating how design decisions influence reliability, usability, and system clarity.

As the StillCold prototype evolves, this learning area informs how the application retrieves sensor data, how frequently it updates, and how it behaves when data is unavailable or stale. The emphasis remains on understanding the application as an interface to a physical system rather than an isolated piece of software, reinforcing system-level thinking over tool-specific implementation.

---

## 4. Documenting and Evaluating Learning with AI

Learning with AI in StillCold is treated as an explicit and documented part of the development process rather than an implicit background activity. AI-assisted learning is recorded through written explanations, design rationale, and reflections that connect newly acquired understanding to concrete system behavior and decisions.

For both hardware and software learning topics, AI interactions are used to support comprehension, clarify unfamiliar concepts, and explore tradeoffs. Insights gained through this process are reflected in project documentation and design choices, demonstrating how AI-assisted reasoning influenced the direction of the system without replacing independent problem-solving or hands-on experimentation.

Evaluation of Learning with AI focuses on evidence of understanding rather than volume of AI usage. Progress is demonstrated by the ability to explain system behavior, justify design decisions, and revise assumptions as new information or observations emerge. Learning is treated as iterative, with understanding expected to deepen as the prototype evolves across sprints.

By framing AI as a “second brain” and documenting its role transparently, this project emphasizes responsible and intentional use of AI as a learning tool. The outcome is not just a functional prototype, but a clearer, more structured understanding of how embedded systems and software interfaces interact in practice.
