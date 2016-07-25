/* timer CTC interrupt test
Author SIBU SAMAN
licensed under GPLv3
code to  test all the LEDs by sweeping them from left to right, one at a time
*/
#define F_CPU 8000000UL
#include <avr/io.h>
#include <util/delay.h>
#define BLINK_DELAY_MS 75

int temp = 0;
int inc = 1;

int main(void) {
  /* set (PB5) of PORTB for output*/
  DDRA = 0xff; // does the same thing as above line
  DDRB = 0b00000011;

  while (1) {
    _delay_ms(BLINK_DELAY_MS);
    switch (temp) {
    case 1:
      PORTB = 0b00000001;
      PORTA = 0x00;
      break;
    case 2:
      PORTB = 0b00000010;
      PORTA = 0x00;
      break;
    case 3:
      PORTB = 0x00;
      PORTA = 0b00000001;
      break;
    case 4:
      PORTA = 0b00000010;
      break;
    case 5:
      PORTA = 0b00000100;
      break;
    case 6:
      PORTA = 0b00001000;
      break;
    case 7:
      PORTA = 000010000;
      break;
    case 8:
      PORTA = 0b00100000;
      break;
    case 9:
      PORTA = 0b01000000;
      break;
    case 10:
      PORTA = 0b10000000;
      inc *= -1;
      break;
    default:
      temp = 0;
      inc *= -1;
    }
    temp += inc;
  }
}
