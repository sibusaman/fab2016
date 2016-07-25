/* timer CTC interrupt test
Author SIBU SAMAN
licensed under GPLv3
code to  test all the LEDs connected to the different ports by blinking them
*/
#define F_CPU 8000000UL
#include <avr/interrupt.h>
#include <avr/io.h>

int temp = 0;
int main(void) {
  DDRB = 0b00000011;
  DDRA = 0xff;
  // initialize Timer1 the 16bit timer
  cli(); // disable global interrupts
  TCCR1A = 0;
  TCCR1B = 0; // same for TCCR1*

  // set compare match register to desired timer count:
  OCR1A = 10000;

  // turn on CTC mode:
  TCCR1B |= (1 << WGM12);

  TCCR1B |= (1 << CS11);

  // enable timer compare interrupt:
  TIMSK1 |= (1 << OCIE1A);

  sei(); // enable global interrupts:
}

ISR(TIM1_COMPA_vect) {
  if (temp == 1) {
    PORTB = (0b00000011);
    PORTA = 0xff;
    temp = 0;
  } else {
    PORTB = (0b00000000);
    PORTA = 0x00;
    temp = 1;
  }
}
