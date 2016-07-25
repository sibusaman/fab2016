/* timer CTC interrupt test
Author SIBU SAMAN
licensed under GPLv3
code for networking, accepts the data in the form of pulse width, the value is then indiacted in the led ring
*/
#define F_CPU 8000000UL
#include <avr/interrupt.h>
#include <avr/io.h>

int temp = 0;
int val = 1;
int prev_val = 100;
int last_led_val;
unsigned int last_led = 0;
unsigned int shift;

int main(void) {
  DDRB = 0b00000011;
  DDRA = 0xff;
  // initialize Timer1 the 16bit timer which measures the pulse length
  cli(); // disable global interrupts

  // enble pin change interrupts on int0
  GIMSK |= (1 << INT0);
  MCUCR = (1 << ISC00) | (1 << ISC00);

  TCCR1A = 0;
  TCCR1B = 0;
  TCCR0A = 0;
  TCCR0B = 0;

  // set compare match register to desired timer count:
  OCR0B = 200;

  TCCR0B |= (1 << CS01);
  TCCR1B |= (1 << CS11);

  // enable timer compare interrupt:
  TIMSK0 |= (1 << OCIE0A);
  TIMSK0 |= (1 << OCIE0B);

  sei(); // enable global interrupts:

  while (1) {
    last_led = val / 10;
    last_led_val = (val - 10 * last_led);
    last_led_val = last_led_val * last_led_val * 2;
    PORTB = 0x00;
    PORTA = 0x00;
    if (last_led < 2) {
      shift = 8 - last_led;
      PORTB = 0b11000000 >> shift;
    } else {
      PORTB = 0b00000011;
      shift = 10 - last_led;
      PORTA = 0xff >> shift;
    }
    if (prev_val != val) {
      OCR0A = last_led_val + 1;
    }
    prev_val = val;
  }
}

ISR(INT0_vect) {
  if (PINB && 0b00000100) {
    TCNT1 = 0;
  } else {
    val = TCNT1 / 2;
    TCNT1 = 0;
  }
}

ISR(TIM0_COMPA_vect) {
  if (last_led < 2) {
    PORTB &= 0xff ^ (1 << last_led);
  } else {
    PORTA &= 0xff ^ (1 << (last_led - 2));
    ;
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
