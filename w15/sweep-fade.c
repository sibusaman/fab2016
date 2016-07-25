/* timer CTC interrupt test
Author SIBU SAMAN
licensed under GPLv3
code to  test all the LEDs by sweeping them from left to right, one at a time
*/
#define F_CPU 8000000UL
#include <avr/interrupt.h>
#include <avr/io.h>

int temp = 0;
int val = 0;
int prev_val = 0;
int last_led_val;
unsigned int last_led = 0;
unsigned int shift;

int main(void) {
  DDRB = 0b00000011;
  DDRA = 0xff;
  // initialize Timer1 the 16bit timer
  cli(); // disable global interrupts
  TCCR1A = 0;
  TCCR1B = 0;
  TCCR0A = 0;
  TCCR0B = 0;

  // set compare match register to desired timer count:
  OCR0B = 200;

  TCCR0B |= (1 << CS11);
  ;

  // enable timer compare interrupt:
  TIMSK0 |= (1 << OCIE0A);
  TIMSK0 |= (1 << OCIE0B);

  sei(); // enable global interrupts:

  while (1) {
    while (prev_val != val) {
      last_led = val / 10;
      last_led_val = (val - 10 * last_led);
      last_led_val = last_led_val * last_led_val * 2;
      PORTB = 0x00;
      PORTA = 0x00;
      if (last_led < 2) {
        shift = 8 - last_led;
        PORTB = 0b11000000 << shift;
      } else {
        PORTB = 0b00000011;
        shift = 10 - last_led;
        PORTA = 0xff << shift;
      }
      OCR0A = last_led_val + 1;
      prev_val = val;
    }

    if (temp > 500) {
      temp = 0;
      val++;
      if (val > 98) {
        val = 0;
      }
    }
    temp++;
  }
  while (0) {
    OCR0A = 20;
  }
}

ISR(TIM0_COMPA_vect) {
  if (last_led < 2) {
    PORTB &= 0xff ^ (1 << last_led);
  } else {
    PORTA &= 0xff ^ (1 << (last_led - 2));
  }
}

ISR(TIM0_COMPB_vect) {
  if (last_led < 2) {
    PORTB |= (1 << last_led);
  } else {
    PORTA |= (1 << (last_led - 2));
  }
  TCNT0 = 0;
}
