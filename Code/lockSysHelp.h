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