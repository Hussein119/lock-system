/*
 * Project #1 lock system.c
 *
 * Created: 12/16/2023 1:47:34 AM
 * Author: Hos10
 */

#include <mega16.h>
#include <alcd.h>
#include <delay.h>
#include <string.h>

#define bit_set(r, b) r |= 1 << b
#define bit_clr(r, b) r &= ~(1 << b)

char keypad();

unsigned char EE_Read(unsigned int address);
void EE_Write(unsigned int address, unsigned char data);
void EE_WriteString(unsigned int address, const char *str);
void initializeUsers();
void displayMessage(char *message, int delay_ms_value);
int enterValueWithKeypad();

// User structure to store user data
typedef struct
{
	const char *name;
	unsigned int id;
	unsigned int pc;
} User;
User users[] =
{
	// name  ID   PC
	{"Prof", 111, 203},
	{"Ahmed", 126, 129},
	{"Amr", 128, 325},
	{"Adel", 130, 426},
	{"Omer", 132, 077},
};

void main(void)
{
	// Set keypad ports
	DDRC = 0b00000111;
	PORTC = 0b11111000;

	// Initialize the LCD
	lcd_init(16);

	// Set the door as input (now by default the door is closed)
	DDRB .0 = 0;
	PORTB .0 = 1; // turn on pull up resistance

	// Initialize user data in EEPROM
	initializeUsers();

	while (1)
		{
		int enteredID;
		User currentUser;
		// Search for the entered ID in EEPROM
		unsigned int address = 0;
		int userFound = 0;
		int i;

		displayMessage("Enter your ID: ", 1000);

		enteredID = enterValueWithKeypad();

		for (i = 0; i < sizeof(users); ++i)
			{
			address += sizeof(users[i].name);  // Increment for name
			currentUser.id = EE_Read(address);
			if (currentUser.id == enteredID)
				{
				displayMessage("User Found", 5000);  // NOT PRINTED !!!!!!!!!! why ????
				address += sizeof(users[i].id);    // Increment for ID
				lcd_printf("%d", users[i].pc);
				delay_ms(5000);
				currentUser.pc = EE_Read(address); // store current user pc \

				userFound = 1; // set the flag = 1 if we found it
				break;
				}
			address += sizeof(users[i].id);    // Increment for ID
			address += sizeof(users[i].pc);    // Increment for PC
			}

		if (userFound)
			{
			int enteredPC;

			displayMessage("Enter your PC: ", 1000);

			enteredPC = enterValueWithKeypad();

			if (currentUser.pc == enteredPC)
				{
				displayMessage("Welcome", 1000);
				// Open the door
				}
			else
				displayMessage("Sorry wrong PC", 1000);
			}
		else
			{
			displayMessage("Wrong ID", 1000);
			// Two peeps alarm
			}

		delay_ms(2000);
		}
}

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
				while (PINC .3 == 0);
				return 1;
			case 0b11101110:
				while (PINC .4 == 0);
				return 4;
			case 0b11011110:
				while (PINC .5 == 0);
				return 7;
			case 0b10111110:
				while (PINC .6 == 0);
				return 10;
			}

		PORTC .0 = 1;
		PORTC .1 = 0;
		PORTC .2 = 1;

		switch (PINC)
			{
			case 0b11110101:
				while (PINC .3 == 0);
				return 2;
			case 0b11101101:
				while (PINC .4 == 0);
				return 5;
			case 0b11011101:
				while (PINC .5 == 0);
				return 8;
			case 0b10111101:
				while (PINC .6 == 0);
				return 0;
			}

		PORTC .0 = 1;
		PORTC .1 = 1;
		PORTC .2 = 0;

		switch (PINC)
			{
			case 0b11110011:
				while (PINC .3 == 0);
				return 3;
			case 0b11101011:
				while (PINC .4 == 0);
				return 6;
			case 0b11011011:
				while (PINC .5 == 0);
				return 9;
			case 0b10111011:
				while (PINC .6 == 0);
				return 11;
			}
		}
}

unsigned char EE_Read(unsigned int address)
{
	while (EECR .1 == 1); // Wait till EEPROM is ready
	EEAR = address;       // Prepare the address you want to read from
	EECR .0 = 1;          // Execute read command
	return EEDR;
}

void EE_Write(unsigned int address, unsigned char data)
{
	while (EECR .1 == 1); // Wait till EEPROM is ready
	EEAR = address;       // Prepare the address you want to read from
	EEDR = data;          // Prepare the data you want to write in the address above
	EECR .2 = 1;          // Master write enable
	EECR .1 = 1;          // Write Enable
}

void EE_WriteString(unsigned int address, const char *str)
{
	// Write each character of the string to EEPROM
	while (*str)
		EE_Write(address++, *str++);
	// Terminate the string with a null character
	EE_Write(address, '\0');
}

// Function to initialize user data in EEPROM
void initializeUsers()
{
	unsigned int address = 0;
	int i;
	for (i = 0; i < sizeof(users); ++i)
		{
		EE_WriteString(address, users[i].name);
		address += sizeof(users[i].name);  // Increment for name

		EE_Write(address, users[i].id);
		address += sizeof(users[i].id);    // Increment for ID

		EE_Write(address, users[i].pc);
		address += sizeof(users[i].pc);    // Increment for PC
		}
}


void displayMessage(char *message, int delay_ms_value)
{
	lcd_clear();
	lcd_puts(message);
	delay_ms(delay_ms_value);
}

int enterValueWithKeypad()
{
	char digit1;
	char digit2;
	char digit3;
	digit1 = keypad();
	lcd_putchar(digit1 + '0');
	digit2 = keypad();
	lcd_putchar(digit2 + '0');
	digit3 = keypad();
	lcd_putchar(digit3 + '0');

	delay_ms(1000);

	return (digit1 * 100) + (digit2 * 10) + digit3;
}

/*
interrupt [1] void Reset (void) {
    // action on interrupt
}
interrupt [2] void ext0 (void) {
    // action on interrupt
}
interrupt [3] void ext1 (void) {
    // action on interrupt
}
*/