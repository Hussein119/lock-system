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
