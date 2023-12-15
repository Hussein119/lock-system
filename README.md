# Lock System using Proteus 8 Professional and CodeVisionAVR

This project implements a secure lock system using Proteus 8 Professional for simulation and CodeVisionAVR Evaluation for programming the ATmega16 microcontroller. The system, written in the C programming language, includes three main functionalities: opening the door, setting a new passcode (PC), and accessing administrative features. The project is divided into three parts, each handled by different contributors.

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Usage](#usage)
- [Documentation](#documentation)
- [Contributing](#contributing)
- [Acknowledgments](#acknowledgments)

## Overview

The lock system provides password-based access control, an LCD display for user interaction, and audible alarms for incorrect entries. Option 2 for interrupts prioritization is chosen to avoid nested interrupts.

## Features

- Password-based Access Control
- LCD Display for User Interaction
- Audible Alarms for Incorrect Entries
- Option 2 for Interrupts Prioritization to Avoid Nested Interrupts

## Getting Started

### Prerequisites

- Proteus 8 Professional
- CodeVisionAVR Evaluation
- ATmega16 Microcontroller
- Other necessary components (LCD, DC Motor, Buzzer, Keypad)

### Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/your-username/lock-system.git
   cd lock-system
   ```

2. Open the project in CodeVisionAVR.

   - Launch CodeVisionAVR and open the project file (`lock_system.cvp`).
   - Customize project settings if necessary.

3. Simulate in Proteus.

   - Open Proteus 8 Professional.
   - Load the simulation file (`lock_system.pdsprj`) and run the simulation.

4. Hardware Implementation.
   - Connect the ATmega16 to the necessary components.
   - Program the microcontroller using CodeVisionAVR.

### Usage

Test the lock system with the predefined password, verify LED indicators, and explore other functionalities.

## Documentation

The documentation includes detailed information about the project, divided into three parts:

### Part 1 - Door Opening

- `door_opening.c`: Main C code for opening the door.

### Part 2 - Set New PC

- `set_new_pc.c`: Main C code for setting a new PC.

### Part 3 - Admin Access

- `admin_access.c`: Main C code for administrative access.

### Proteus Simulation

#### Hardware Components

1. ATmega16 Microcontroller
2. LCD Display
3. DC Motor (for door simulation)
4. Buzzer or Speaker (Peeps alarm)
5. Keypad 4x3

## Contributing

Contributions are welcome! Feel free to submit bug reports, feature requests, or pull requests.

## Acknowledgments

- Proteus 8 Professional
- CodeVisionAVR Evaluation
- ATmega16 Microcontroller
