# Embedded Lock System Documentation

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Usage](#usage)
  - [Proteus Simulation](#proteus-simulation)
- [Main Program Flowchart](#main-program-flowchart)
- [Developers](#developers)
- [Main file](#main-file)
  - [LockSystem.c](#locksystem.c)
- [Header files](#header-files)
  - [lockSysInit.h](#locksysinit.h)
  - [lockSysReadWrite.h](#locksysreadwrite.h)
  - [lockSysMode.h](#locksysmode.h)
  - [lockSysHelp.h](#locksyshelp.h)

## Overview

The Embedded Lock System is a collaborative project designed to implement a secure lock system. The system utilizes Proteus 8 Professional for simulation and CodeVisionAVR Evaluation for programming the ATmega16 microcontroller. Written in the C programming language, the system encompasses three main functionalities: opening the door, setting a new passcode (PC), and accessing administrative features. The project is organized into three distinct parts, with each part expertly handled by different contributors.

## Features

- Password-based Access Control
- LCD Display for User Interaction
- Audible Alarms for Incorrect Entries

### Define interrupts priorities:

(Recommended):

- Press the Open button to open the door, triggering button '\*'.
- Prioritize the Admin button by associating it with interrupt INT0.
- Set the PC configuration with the Set PC button, utilizing interrupt INT1.

> The project favors this Option because it assigns higher priority to the Admin button, followed logically by the Set PC button, and then the Open button.

## Getting Started

### Prerequisites

Ensure you have the following tools and components:

- Proteus 8 Professional
- CodeVisionAVR Evaluation
- ATmega16 Microcontroller
- Other necessary components (LCD, DC Motor, Buzzer, Keypad)

### Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/Hussein119/lock-system.git
   cd lock-system
   ```

2. Open the project in CodeVisionAVR.

   - Launch CodeVisionAVR and open the project file (`\Code\Project #1 lock system.prj`).
   - Customize project settings if necessary.

3. Simulate in Proteus.

   - Open Proteus 8 Professional.
   - Load the simulation file (`\Simulation\Project #1 lock system.pdsprj`) and run the simulation.

4. Hardware Implementation.

   - Connect the ATmega16 to the necessary components.
   - Program the microcontroller using CodeVisionAVR.

### Usage

Test the lock system with the predefined password, verify LED indicators, and explore other functionalities.

### Proteus Simulation

#### Hardware Components

1. ATmega16 Microcontroller
2. LCD Display
3. Keypad 4x3
4. Red light (for door simulation)
5. Motor (for door simulation)
6. Speaker (Peeps alarm)
7. Keypad 4x3
8. Two Buttons for interrupts

![Hardware](image.png)

## Main Program Flowchart

### Open Door Flowchart

![Open Door](Open.png)

### Set New PC Flowchart

![Set New PC](SetPC.jpg)

### Admin Sittings Flowchart

![Admin Sittings](Admin.jpg)

### Default Users in System

| Name  | ID  | PC  |
| ----- | --- | --- |
| Prof  | 111 | 203 |
| Ahmed | 126 | 129 |
| Amr   | 128 | 325 |
| Adel  | 130 | 426 |
| Omer  | 132 | 079 |

## Developers

- Islam AbdElhady Hassanein
- Ahmed Hesham Fathall Farag
- Elsherif Shapan Abdelmageed
- Hussein AbdElkader Hussein
- Enas Ragab AbdEllatif
- Mariam Tarek Saad

## Main File

### LockSystem.c

- LockSystem.c - Main file for the embedded lock system project.
- This file serves as the main entry point for the lock system project. It includes necessary header files
- and contains the main function that initializes hardware, user data, and interrupts. The main loop continuously checks for a specific input ('\*') on the keypad to trigger the door open/close mode.

```c
/*
 * Project #1 lock system.c
 *
 * Created: 12/16/2023 1:47:34 AM
 * Author: Hos10
 */

#include "lockSysInit.h"
#include "lockSysMode.h"

void main(void)
{
	char input;

	// Initialize Hardware
	initializeHardware();

	// Initialize user data in EEPROM
	initializeUsers();

	// Initialize interrupts for various modes
	initializeIntrrupts();

	// If user need to open the door must press '*' on the keypad
	while (1)
	{
		input = keypad();
		if (input == 10) // 10 is '*' in keypad
			openCloseDoorMode();
	}
}

interrupt[3] void setPC(void) //  vector no 3 -> INT1
{
	setPCMode();
}

interrupt[2] void admin(void) // vector no 2 -> INT0
{
	adminMode();
}
```

## Header Files

### lockSysInit.h

- lockSysInit.h - Header file containing initialization functions for the embedded lock system.
- This file includes functions for initializing various hardware components such as the keypad, LCD, door motor, speaker, and interrupts. Additionally, it defines macros for setting and clearing bits in a register.
- The file also includes the definition of the User structure and initializes user data in EEPROM.

```c
#include <mega16.h>
#include <alcd.h>
#include "lockSysReadWrite.h"

// Macros for setting and clearing bits in a register
#define bit_set(r, b) r |= 1 << b
#define bit_clr(r, b) r &= ~(1 << b)

// Function prototypes
void initializeHardware();
void initializeKeypad();
char keypad();
void initializeDoor();
void initializeSpeaker();
void initializeIntrrupts();
void initializeUsers();

// User structure to store user data
typedef struct
{
    char name[6];
    char id[4];
    char pc[4];
} User;
// Array of user data
User users[] =
    {
        // name  ID   PC
        {"Prof", "111", "203"},
        {"Ahmed", "126", "129"},
        {"Amr", "128", "325"},
        {"Adel", "130", "426"},
        {"Omer", "132", "079"},
};

// Function to initialize hardware components
void initializeHardware()
{
    initializeKeypad();
    lcd_init(16); // Initialize the LCD
    initializeDoor();
    initializeSpeaker();
}

// Function to initialize keypad
void initializeKeypad()
{
    // Set keypad ports
    DDRC = 0b00000111;  // 1 unused pin, 4 rows (input), 3 columns (output)
    PORTC = 0b11111000; // pull-up resistance
}

// Function: keypad
// Description: Reads the input from a 4x3 matrix keypad and returns the corresponding key value.
//              The keypad is connected to port C, and the function scans each row and column
//              combination to determine the pressed key.
// Returns: Character representing the pressed key.
char keypad()
{
    while (1)
    {
        PORTC .0 = 0;
        PORTC .1 = 1;
        PORTC .2 = 1;

        switch (PINC)
        {
        case 0b11110110:
            while (PINC .3 == 0)
                ;
            return 1;
        case 0b11101110:
            while (PINC .4 == 0)
                ;
            return 4;
        case 0b11011110:
            while (PINC .5 == 0)
                ;
            return 7;
        case 0b10111110:
            while (PINC .6 == 0)
                ;
            return 10;
        }

        PORTC .0 = 1;
        PORTC .1 = 0;
        PORTC .2 = 1;

        switch (PINC)
        {
        case 0b11110101:
            while (PINC .3 == 0)
                ;
            return 2;
        case 0b11101101:
            while (PINC .4 == 0)
                ;
            return 5;
        case 0b11011101:
            while (PINC .5 == 0)
                ;
            return 8;
        case 0b10111101:
            while (PINC .6 == 0)
                ;
            return 0;
        }

        PORTC .0 = 1;
        PORTC .1 = 1;
        PORTC .2 = 0;

        switch (PINC)
        {
        case 0b11110011:
            while (PINC .3 == 0)
                ;
            return 3;
        case 0b11101011:
            while (PINC .4 == 0)
                ;
            return 6;
        case 0b11011011:
            while (PINC .5 == 0)
                ;
            return 9;
        case 0b10111011:
            while (PINC .6 == 0)
                ;
            return 11;
        }
    }
}

// Function to initialize door
void initializeDoor()
{
    // Set the motor pins as output
    DDRB |= (1 << DDB3) | (1 << DDB4);
    // Set the red LED pin as output
    DDRB |= (1 << DDB0);
}

// Function to initialize speaker
void initializeSpeaker()
{
    // Set the speaker as an output
    DDRD .7 = 1;
    PORTD .7 = 1; // Set it to 1 initially
}

// Function to initialize interrupts
void initializeIntrrupts()
{
    DDRB .2 = 0;  // make button as input
    PORTB .2 = 1; // turn on pull up resistance for INT2 intrrupt

    // actual casue INT2
    bit_set(MCUCSR, 6);

    DDRD .2 = 0;  // make button as input
    PORTD .2 = 1; // turn on pull up resistance for INT0 intrrupt

    // actual casue (The falling edge of INT0)
    bit_set(MCUCR, 1);
    bit_clr(MCUCR, 0);

    // actual casue (The falling edge of INT1)
    bit_set(MCUCR, 3);
    bit_clr(MCUCR, 2);

    DDRD .3 = 0;  // make button SetPC as input
    PORTD .3 = 1; // turn on pull up resistance

    // Enable global interrupts
#asm("sei")

    // GICR INT1 (bit no 7) , SetPC spacific enable
    bit_set(GICR, 7);

    // GICR INT2 (bit no 5) , open spacific enable
    bit_set(GICR, 5);

    // GICR INT0 (bit no 6) , admin spacific enable
    bit_set(GICR, 6);
}

// Function to initialize user data in EEPROM
void initializeUsers()
{
    unsigned int address = 0;
    int i;
    for (i = 0; i < sizeof(users) / sizeof(users[0]); ++i)
    {
        EE_WriteString(address, users[i].name);
        address += sizeof(users[i].name);

        EE_WriteString(address, users[i].id);
        address += sizeof(users[i].id);

        EE_WriteString(address, users[i].pc);
        address += sizeof(users[i].pc);
    }
}
```

### lockSysReadWrite.h

- lockSysReadWrite.h - Header file containing functions for reading and writing data to EEPROM.
- This file includes functions for reading and writing individual bytes as well as strings to EEPROM.
- The EEPROM operations are crucial for storing and retrieving persistent data such as user information, PC details, and other configuration settings.

```c
#include <mega16.h>

unsigned char EE_Read(unsigned int address);
void EE_Write(unsigned int address, unsigned char data);
void EE_WriteString(unsigned int address, const char *str);
void EE_ReadString(unsigned int address, char *buffer, unsigned int length);

// Function to read from EEPROM
unsigned char EE_Read(unsigned int address)
{
    while (EECR .1 == 1)
        ;           // Wait till EEPROM is ready
    EEAR = address; // Prepare the address you want to read from
    EECR .0 = 1;    // Execute read command
    return EEDR;
}

// Function to write to EEPROM
void EE_Write(unsigned int address, unsigned char data)
{
    while (EECR .1 == 1)
        ;           // Wait till EEPROM is ready
    EEAR = address; // Prepare the address you want to read from
    EEDR = data;    // Prepare the data you want to write in the address above
    EECR .2 = 1;    // Master write enable
    EECR .1 = 1;    // Write Enable
}

// Function to write a string to EEPROM
void EE_WriteString(unsigned int address, const char *str)
{
    // Write each character of the string to EEPROM
    while (*str)
        EE_Write(address++, *str++);
    // Terminate the string with a null character
    EE_Write(address, '\0');
}

// Function to read a string from EEPROM
void EE_ReadString(unsigned int address, char *buffer, unsigned int length)
{
    unsigned int i;
    for (i = 0; i < length; ++i)
    {
        buffer[i] = EE_Read(address + i);
        if (buffer[i] == '\0')
            break;
    }
}
```

### lockSysMode.h

- lockSysMode.h - Header file containing functions for different modes of the Embedded Lock System.
- This file includes functions for admin mode, setting PC mode, and open/close door mode.
- Each mode serves a specific purpose in the functionality of the lock system, such as managing user data, updating user PC information, and controlling the door's open and close operations.

```c
#include <string.h>
#include "lockSysHelp.h"

void adminMode();
void setPCMode();
void openCloseDoorMode();

// Interrupt functions

// Function for admin mode
void adminMode()
{
    char enteredPC[4];
    char enteredStudentID[4];
    char enteredNewPC[4];
    User student;
    User admin;
    unsigned int adminPCAddress = 0;
    unsigned int address = 0;
    int userFound = 0;
    int i;

    for (i = 0; i < sizeof(users) / sizeof(users[0]); ++i)
    {
        EE_ReadString(address, admin.name, sizeof(users[i].name));
        if (strcmp(admin.name, "Prof") == 0)
        {
            address += sizeof(users[i].name);
            EE_ReadString(address, admin.id, sizeof(admin.id));
            address += sizeof(users[i].id);
            EE_ReadString(address, admin.pc, sizeof(admin.pc));
            adminPCAddress = address;
            break;
        }
        address += sizeof(users[i].pc);
    }

    address = 0; // reset the address

    displayMessage("Enter Admin PC: ", 0);
    lcd_gotoxy(0, 1);

    if (enterValueWithKeypad(enteredPC))
    {

        if (strcmp(admin.pc, enteredPC) == 0)
        {
            displayMessage("Enter Student ID: ", 0);

            if (enterValueWithKeypad(enteredStudentID))
            {
                int j;
                for (j = 0; j < sizeof(users) / sizeof(users[0]); ++j)
                {
                    address += sizeof(users[j].name);
                    EE_ReadString(address, student.id, sizeof(student.id));
                    address += sizeof(users[j].id);
                    if (strcmp(student.id, enteredStudentID) == 0)
                    {
                        displayMessage("Enter student's new PC: ", 0);
                        if (enterValueWithKeypad(enteredNewPC))
                        {
                            // Set the new pc for this student, address is for student PC
                            EE_WriteString(address, enteredNewPC);
                            displayMessage("Student PC is stored", 1000);
                            userFound = 1;
                            break;
                        }
                    }
                    else if (strcmp(admin.id, enteredStudentID) == 0)
                    {
                        displayMessage("Enter your new PC: ", 0);
                        lcd_gotoxy(0, 1);
                        if (enterValueWithKeypad(enteredNewPC))
                        {
                            // Set the new pc for this user (Admin),  address is for admin PC
                            EE_WriteString(adminPCAddress, enteredNewPC);
                            displayMessage("Your PC is stored", 1000);
                            userFound = 1;
                            break;
                        }
                    }
                    address += sizeof(users[i].pc);
                }
            }
        }
    }

    if (!userFound)
    {
        displayMessage("Contact Admin", 0);
        // Two peeps alarm
        generateTone();
        generateTone();
    }
    delay_ms(5000);
    lcd_clear();
}

// Function for set PC mode
void setPCMode()
{
    char enteredID[5]; // Change data type to string
    User currentUser;
    unsigned int address = 0;
    int userFound = 0;
    int i;
    char enteredNewPC[5];   // define enteredNewPC array to hold the new PC
    char reenteredNewPC[5]; // define reenteredNewPC array to hold the Re-entered new PC

    lcd_clear();
    displayMessage("Enter your ID:", 0);
    lcd_gotoxy(0, 1);
    if (enterValueWithKeypad(enteredID))
    {
        char enteredOldPC[5];
        // search for the entered ID in the user data
        for (i = 0; i < sizeof(users) / sizeof(users[0]); ++i)
        {
            address += sizeof(users[i].name);
            EE_ReadString(address, currentUser.id, sizeof(currentUser.id)); // Read ID as a string

            if (strcmp(currentUser.id, enteredID) == 0)
            {
                // ID found, verify the old PC
                address += sizeof(currentUser.id);
                EE_ReadString(address, currentUser.pc, sizeof(currentUser.pc)); // Read PC as a string
                displayMessage("Enter old PC:", 0);
                lcd_gotoxy(0, 1);

                if (enterValueWithKeypad(enteredOldPC))
                {
                    if (strcmp(currentUser.pc, enteredOldPC) == 0)
                    {
                        // Old PC verified
                        displayMessage("Enter new PC:", 0);
                        lcd_gotoxy(0, 1);
                        enterValueWithKeypad(enteredNewPC);

                        lcd_clear();
                        displayMessage("Re-enter new PC:", 0);
                        lcd_gotoxy(0, 1);
                        enterValueWithKeypad(reenteredNewPC);

                        if (strcmp(enteredNewPC, reenteredNewPC) == 0)
                        {
                            // If new PC entered correctly, store it
                            EE_WriteString(address, enteredNewPC);
                            displayMessage("New PC stored", 1000);
                        }
                        else
                        {
                            displayMessage("New PC mismatch, Contact admin", 1000);
                            generateTone();
                            generateTone();
                        }
                    }
                    else
                    {
                        displayMessage("Wrong old PC,   Contact admin", 1000);

                        generateTone();
                        generateTone();
                    }
                }

                userFound = 1;
                break;
            }

            address += sizeof(users[i].id);
            address += sizeof(users[i].pc);
        }

        if (!userFound)
        {
            displayMessage("Wrong ID", 0);
            generateTone();
            generateTone();
        }
        delay_ms(5000);
        lcd_clear();
    }
}

// Function for open/close door mode
void openCloseDoorMode()
{
    char enteredID[4]; // Change data type to string
    User currentUser;
    unsigned int address = 0;
    int userFound = 0;
    int i;

    displayMessage("Enter your ID: ", 0);
    lcd_gotoxy(0, 1);

    if (enterValueWithKeypad(enteredID))
    {
        char enteredPC[4];
        for (i = 0; i < sizeof(users) / sizeof(users[0]); ++i)
        {
            EE_ReadString(address, currentUser.name, sizeof(users[i].name));
            address += sizeof(users[i].name);
            EE_ReadString(address, currentUser.id, sizeof(currentUser.id)); // Read ID as a string

            if (strcmp(currentUser.id, enteredID) == 0)
            {

                address += sizeof(users[i].id);
                EE_ReadString(address, currentUser.pc, sizeof(currentUser.pc)); // Read PC as a string

                displayMessage("Enter your PC: ", 0);
                lcd_gotoxy(0, 1);

                if (enterValueWithKeypad(enteredPC))
                {
                    if (strcmp(currentUser.pc, enteredPC) == 0)
                    {
                        lcd_clear();
                        lcd_puts("Welcome, ");
                        lcd_puts(currentUser.name);
                        openDoor();
                        delay_ms(2000); // Wait for 2 seconds with the door open

                        closeDoor();
                        delay_ms(2000); // Wait for 2 seconds with the door closed
                    }
                    else
                    {
                        displayMessage("Sorry wrong PC", 1000);
                        // one peep alarm
                        generateTone();
                    }
                }
                userFound = 1;
                break;
            }

            address += sizeof(users[i].id);
            address += sizeof(users[i].pc);
        }
    }

    if (!userFound)
    {
        displayMessage("Wrong ID", 1000);
        // Two peeps alarm
        generateTone();
        generateTone();
    }
    lcd_clear();
}
```

### lockSysHelp.h

- lockSysHelp.h - Header file containing helper functions for the Embedded Lock System.
- This file includes functions for displaying messages on the LCD, entering values with the keypad,
- generating tones with the speaker, and controlling the motor to open and close the door.

```c
#include <mega16.h>
#include <alcd.h>
#include <delay.h>

void displayMessage(char *message, int delay_ms_value);
int enterValueWithKeypad(char *buffer);
void generateTone();
void openDoor();
void closeDoor();

// Function to display a message on the LCD
void displayMessage(char *message, int delay_ms_value)
{
    lcd_clear();
    lcd_puts(message);
    delay_ms(delay_ms_value);
}

// Function to enter a value with the keypad

int enterValueWithKeypad(char *buffer)
{
    int buffer2[3];

    buffer2[0] = keypad();
    if (buffer2[0] == 10)
        lcd_putchar('*');
    else if (buffer2[0] == 11)
        lcd_putchar('#');
    else
        lcd_putchar(buffer2[0] + '0');

    buffer2[1] = keypad();
    if (buffer2[1] == 10)
        lcd_putchar('*');
    else if (buffer2[1] == 11)
        lcd_putchar('#');
    else
        lcd_putchar(buffer2[1] + '0');

    buffer2[2] = keypad();
    if (buffer2[2] == 10)
        lcd_putchar('*');
    else if (buffer2[2] == 11)
        lcd_putchar('#');
    else
        lcd_putchar(buffer2[2] + '0');

    buffer[0] = buffer2[0] + '0';
    buffer[1] = buffer2[1] + '0';
    buffer[2] = buffer2[2] + '0';
    buffer[3] = '\0';

    delay_ms(1000);

    return 1;
}

// Function to generate a tone with speaker
void generateTone()
{
    PORTD .7 = 1;
    delay_ms(500);
    PORTD .7 = 0;
    delay_ms(500);
    PORTD .7 = 1;
}

// Function to open the door (motor and redled)
void openDoor()
{
    // Turn on the red LED light
    PORTB |= (1 << PORTB0);

    // Motor movement for smooth opening
    PORTB &= ~(1 << PORTB3);
    delay_ms(500);
    PORTB |= (1 << PORTB4);
    delay_ms(1000);
    PORTB &= ~(1 << PORTB4);
}
// Function to open the door (motor and redled)
void closeDoor()
{
    // Turn off the red LED light
    PORTB &= ~(1 << PORTB0);

    // Motor movement for smooth closing
    PORTB |= (1 << PORTB3);
    delay_ms(500);
    PORTB |= (1 << PORTB4);
    delay_ms(1000);
    PORTB &= ~(1 << PORTB4);
    PORTB &= ~(1 << PORTB3);

    // Return to initial position
    PORTB |= (1 << PORTB3);
    delay_ms(500);
    PORTB &= ~(1 << PORTB3);
}
```
