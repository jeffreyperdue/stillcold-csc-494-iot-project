---
marp: true
theme: default
paginate: true
backgroundColor: #ffffff
---

# StillCold  
## Learning with AI — Post Week 6 Update

*An update on what I've learned so far*


---

# Early Reality: Hardware Is Not Polite

On paper, sensors return numbers.

In reality, readings drift. Pins have to match exactly. Grounds need to be shared. Small mistakes lead to behavior that makes no sense at first, and you're left wondering what you did wrong.

---

AI didn't "solve" any of that for me.

It did help me ask better questions, though. Why would two boards need a shared ground? What actually happens when voltage levels don't match? What does a sensor reading really represent?

That shift, from copying solutions to understanding how systems actually work, was one of the first big learning moments. I suppose you could say I started paying attention in the right places.

---

# Understanding Data as Interpretation

Temperature and humidity sound simple.

They're not. Sensors don't measure perfectly. Values get sampled, converted, formatted. Every number carries assumptions, and AI helped me unpack datasheets and get clear on terminology and see the tradeoffs.

Then I had to go test those ideas in the real world.

When the BLE value finally matched what I saw on the serial monitor, that wasn't just code working. It was me actually understanding what was going on. I couldn't help but feel like that distinction mattered.

---

# Architecture: Thinking in Responsibilities

StillCold uses two microcontrollers. One reads the environment. One prepares and exposes the data.

That separation turned out to be a turning point. AI helped me think through why splitting responsibilities makes things clearer, how communication between parts should be structured, and what actually makes a system easier to debug later.

I stopped building "whatever works" and started building something I could explain. In a way, that difference is the whole point.

---

# BLE Was a Systems Lesson

At first, making data available over Bluetooth felt like just another feature.

It wasn't. BLE brought in advertising lifecycle, connection and disconnection states, real-time sync. AI helped me reason through when advertising should restart, how values should update, what state I needed to track.

But I still had to test. Multiple connect and disconnect cycles. Idle behavior. Environmental changes. The learning came from pairing AI's reasoning with my own observation. I keep coming back to that.

---

# What AI Did *Not* Do

AI did not wire the breadboard. It didn't fix wrong pin assignments. It didn't diagnose bad physical connections. It didn't replace testing.

When things acted weird, I still had to trace wires, check power, and question my assumptions. That boundary was important to me. AI supported how I think. It didn't take over the responsibility.

---

# What Changed in My Thinking

Before this project, I mostly thought of embedded systems as code running on small hardware.

Now I see hardware and software as inseparable. Data pipelines matter more than features. Observability is as important as functionality. Simplicity is what makes systems trustworthy. AI got me to those ideas faster, but the understanding came from building. I wonder whether that's always how it goes.

---

# The Most Important Shift

The biggest change wasn't technical. It was cognitive.

I got more comfortable asking "why" before "how." Breaking problems into layers. Checking my assumptions by testing. Treating AI as a collaborator instead of an oracle. That mindset will outlast this prototype, and I'm curious what I'll take from it going forward.

---

# Where This Leaves StillCold

Today the system does this:

Sensor → Arduino → ESP32 → BLE → External Device

Data flows end-to-end. No Wi-Fi. No opening the environment. No manual intervention. Being able to explain why it works feels like the part that will stick.

---

# Closing Reflection

Learning with AI hasn't made this project easier. It's made it clearer.

The combination of AI-assisted reasoning, physical prototyping, structured testing, and actually writing things down has deepened my sense of how real systems behave. StillCold is a working prototype. More importantly, it's evidence of learning: learning how to build, and learning how to think. I wonder what I'll be reflecting on in a few months, or in a couple of years.
