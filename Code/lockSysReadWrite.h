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
