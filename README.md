<h1 align="center">MoneroSigner OS</h1>
<strong><a href="">This is a fork of SeedSigner OS, with changes necessary for MoneroSigner</a>.</strong> <a href="A huge thank you to https://x.com/SeedSigner">@SeedSigner</a> without this project would not exist!

**This readme is still work in progress, like the whole repo. [With time I will change all the documentation where changes to SeedSigner OS where made](Todo.md)**

* [Overview](#overview)
* [Building](docs/building.md)
* [Building (without Docker)](docs/without_docker.md)
* [SeedSigner OS structure](docs/structure.md)
* [Dev workflow](docs/dev_workflow.md)
* [Customizing Buildroot](docs/customize_buildroot.md)
* [Todo](Todo.md)

<br/>

JUMP STRAIGHT TO: [🔥🔥🔥🛠 Quickstart: SeedSigner Reproducible Build! 🛠🔥🔥🔥](docs/building.md)

<br/>

---

# Overview

A custom linux based operating system built to manage software running on airgapped Bitcoin signing device. MoneroSigner is both the project name and [application](https://github.com/DiosDelRayo/MoneroSigner) running on airgapped hardware. This custom operating system, like all operating systems, manages the hardware resources and provides them to the application code. It's currently designed to run on common Raspberry Pi hardware with [accessories](https://github.com/SeedSigner/seedsigner/#shopping-list). The goal of SeedSigner OS is to provide an easy, fast, and secure way to build microSD card image to securely run [SeedSigner](https://seedsigner.com) code.


## ⚙️ Under the Hood

SeedSigner OS is built using [Buildroot](https://www.buildroot.org). Buildroot is a simple, efficient and easy-to-use tool to generate embedded Linux systems through cross-compilation. SeedSigner OS does not fork Buildroot, but uses Buildroot with custom configurations to build microSD card images tailor made for running SeedSigner.


## 🛂 Security

SeedSigner OS is built to reduce the attack surface area and enable additional application functionality. The OS is an order of magnitude smaller in size than Raspberry Pi OS (which is what typically is used to run software on a Pi device). Here are a list of some security and functional advantages of using SeedSigner OS.

- Boots 100% from RAM. This means, once you see the SeedSigner splash screen, you can remove the microSD card because no disk I/O is needed after boot!
- One FAT32 partition on the microSD card
- Removes these standard Raspberry Pi OS Kernel modules:
   - Networking and Bluetooth
   - SWAP
   - I2C
   - Serial
   - USB
   - Pulse-Width Modulation (PWM)
- NO HDMI support
- NO Serial connection TTL support
- NO Software supporting any wireless or networking chips
- A single read only zImage file on the boot partition containing the entire Linux kernel and filesystem


