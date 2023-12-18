/*
 * Project #1 lock system.c
 *
 * Created: 12/16/2023 1:47:34 AM
 * Author: Hos10
 */

#include "lockSys.h"

void main(void)
{
    // Initialize Hardware
	initializeHardware();

	// Initialize user data in EEPROM
	initializeUsers();
    
    // Initialize interrupts for various modes
	initializeIntrrupts();
}

interrupt[3] void setPC(void) //  vector no 3 -> INT1
{
	setPCMode();
}

interrupt[19] void openCloseDoor(void) // vector no 19 -> INT2
{
	openCloseDoorMode();
}

interrupt[2] void admin(void) // vector no 2 -> INT0
{
	adminMode();
}
