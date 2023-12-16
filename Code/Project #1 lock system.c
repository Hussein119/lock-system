/*
 * Project #1 lock system.c
 *
 * Created: 12/16/2023 1:47:34 AM
 * Author: Hos10
*/

#include <mega16.h>
#include <alcd.h>
#include <delay.h>

char keypad();

void main(void)
{
    int x1 = 0;
    //int x2 = 0;
    DDRC = 0b00000111;
    PORTC = 0b11111000;
    lcd_init(16);
    
    while (1)
        {
            
            x1 = keypad();
            //x1 = x1*10 + keypad();
            lcd_clear();
            lcd_printf("U pressed: %d",x1);
            
        }
}

char keypad()
{
    while(1)
        {
            PORTC.0 = 0; PORTC.1 = 1; PORTC.2 = 1;
            //Only C1 is activated
            switch(PINC)
            {
                case 0b11110110:
                while (PINC.3 == 0);
                return 1;
                break;
                
                case 0b11101110:
                while (PINC.4 == 0);
                return 4;
                break;
                
                case 0b11011110:
                while (PINC.5 == 0);
                return 7;
                break;
                
                case 0b10111110:
                while (PINC.6 == 0);
                return 10;
                break;
                
            }
            PORTC.0 = 1; PORTC.1 = 0; PORTC.2 = 1;
            //Only C2 is activated
            switch(PINC)
            {
                case 0b11110101:
                while (PINC.3 == 0);
                return 2;
                break;
                
                case 0b11101101:
                while (PINC.4 == 0);
                return 5;
                break;
                
                case 0b11011101:
                while (PINC.5 == 0);
                return 8;
                break;
                
                case 0b10111101:
                while (PINC.6 == 0);
                return 0;
                break;
                
            }
            PORTC.0 = 1; PORTC.1 = 1; PORTC.2 = 0;
            //Only C3 is activated
            switch(PINC)
            {
                case 0b11110011:
                while (PINC.3 == 0);
                return 3;
                break;
                
                case 0b11101011:
                while (PINC.4 == 0);
                return 6;
                break;
                
                case 0b11011011:
                while (PINC.5 == 0);
                return 9;
                break;
                
                case 0b10111011:
                while (PINC.6 == 0);
                return 11;
                break;
                
            }  
        
		}
}
