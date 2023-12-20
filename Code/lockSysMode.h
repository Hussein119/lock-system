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