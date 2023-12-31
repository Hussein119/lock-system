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
