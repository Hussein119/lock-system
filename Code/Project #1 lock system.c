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
void EE_ReadString(unsigned int address, char *buffer, unsigned int length);
void initializeUsers();
void displayMessage(char *message, int delay_ms_value);
int enterValueWithKeypad(char *buffer);
void generateTone();

// User structure to store user data
typedef struct
{
	const char *name;
	char id[4];  // Change data type to string
	char pc[4];  // Change data type to string
} User;
User users[] =
{
	// name  ID   PC
	{"Prof", "111", "203"},
	{"Ahmed", "126", "129"},
	{"Amr", "128", "325"},
	{"Adel", "130", "426"},
	{"Omer", "132", "079"},
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
    
    // Set the speaker as a output 
    DDRD.7 = 1;
    PORTD.7 = 1; // Set it to 1 initially

	// Initialize user data in EEPROM
	initializeUsers();

	while (1)
		{
		char enteredID[4];  // Change data type to string
		User currentUser;
		unsigned int address = 0;
		int userFound = 0;
		int i;

		displayMessage("Enter your ID: ", 1000);

		if (enterValueWithKeypad(enteredID))
			{
			char enteredPC[4];
			for (i = 0; i < sizeof(users) / sizeof(users[0]); ++i)
				{
				address += sizeof(users[i].name);
				EE_ReadString(address, currentUser.id, sizeof(currentUser.id));  // Read ID as a string

				if (strcmp(currentUser.id, enteredID) == 0)
					{

					address += sizeof(users[i].id);
					EE_ReadString(address, currentUser.pc, sizeof(currentUser.pc));  // Read PC as a string

					displayMessage("Enter your PC: ", 1000);

					if (enterValueWithKeypad(enteredPC))
						{
						if (strcmp(currentUser.pc, enteredPC) == 0)
							{
							displayMessage("Welcome", 1000);
							// Open the door 
                            DDRB .0 = 1;
							}
						else
							displayMessage("Sorry wrong PC", 1000);
                            // one peep alarm
                            generateTone();
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

void displayMessage(char *message, int delay_ms_value)
{
	lcd_clear();
	lcd_puts(message);
	delay_ms(delay_ms_value);
}

int enterValueWithKeypad(char *buffer)
{
    buffer[0] = keypad() + '0';
    lcd_putchar(buffer[0]);
    buffer[1] = keypad() + '0';
    lcd_putchar(buffer[1]);
    buffer[2] = keypad() + '0';
    lcd_putchar(buffer[2]);
    buffer[3] = '\0';  // Null-terminate the string

    delay_ms(1000);

    return 1;  // Return a non-zero value to indicate success
}
void generateTone()
{
    PORTD.7 = 1;  // Set PD7 HIGH
    delay_ms(500);  // Adjust duration as needed
    PORTD.7 = 0;  // Set PD7 LOW
    delay_ms(500);  // Pause between tones
    PORTD.7 = 1;  // Set PD7 HIGH (optional: restore to high for a brief moment)
}
