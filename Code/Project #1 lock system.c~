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

// interrupts MCUCR & GICR
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
	char name[6];
	char id[4];
	char pc[4];
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
	DDRC = 0b00000111; // 1 unused pin , 4 rows (input) , 3 cloumns (output)
	PORTC = 0b11111000; // pull up resistance

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

	PORTB.2 = 1; // turn on pull up resistance for INT2 intrrupt

	// actual casue INT2
	bit_set(MCUCSR, 6);

	PORTD.2 = 1; // turn on pull up resistance for INT0 intrrupt

	// actual casue (The falling edge of INT0)
	bit_set(MCUCR, 1);
	bit_clr(MCUCR, 0);

	// Enable global interrupts
#asm("sei")

	// GICR INT2 (bit no 5) , EXT2 spacific enable
	bit_set(GICR, 5);

	// GICR INT0 (bit no 6) , EXT0 spacific enable
	bit_set(GICR, 6);

}

/*
interrupt [3] void ext1 (void) // vector no 3 -> INT1
{
    // action on interrupt
}
*/

interrupt [19] void Reset (void) // vector no 19 -> INT2 
{
	// action on click on a button

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
			EE_ReadString(address, currentUser.name, sizeof(users[i].name));
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
						lcd_clear();
						lcd_puts("Welcome, ");
						lcd_puts(currentUser.name);
						// Open the door
						DDRB .0 = 1;
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
	delay_ms(5000);
	// close the door and clear lcd
	DDRB .0 = 0;
	lcd_clear();
}

interrupt [2] void ext1 (void) // vector no 2 -> INT0
{
	// action on interrupt
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

	displayMessage("Enter Admin PC: ", 1000);

	if (enterValueWithKeypad(enteredPC))
		{

		if (strcmp(admin.pc, enteredPC) == 0)
			{
			displayMessage("Enter Student ID: ", 1000);

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
						displayMessage("Enter student's new PC: ", 1000);
						if (enterValueWithKeypad(enteredNewPC))
							{
							// Set the new pc for this student, address is for student PC  
							EE_WriteString(address, enteredNewPC);
							displayMessage("Student PC is stored", 3000);
							userFound = 1;
							break;
							}
						}
					else if (strcmp(admin.id, enteredStudentID) == 0)
						{
						displayMessage("Enter your new PC: ", 1000);
						if (enterValueWithKeypad(enteredNewPC))
							{
							// Set the new pc for this user (Admin),  address is for admin PC
							EE_WriteString(adminPCAddress, enteredNewPC);
							displayMessage("Your PC is stored", 3000);
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
		displayMessage("Contact Admin", 3000);
		// Two peeps alarm
		generateTone();
		generateTone();
		}
	delay_ms(5000);
	lcd_clear();
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
				return '*';
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
