/*
shared under GPLv3
Author SIBU SAMAN
code for controlling the speed and the direction of a stepepr motor using a
rotary encoder
*/
#define F_CPU 8000000UL
#include <avr/interrupt.h>
#include <avr/io.h>
/*
  PA0		dir
  PA1		step
  PA2		sleep
  PA3		reset
  PA4		enable
  PA5		orange LED
  PA6		Blue LED

  Rotate the knob to adjust the speed of rotation and use the built-in
  push-button to toggle the direction.
 */

int temp = 20000;
int step = 1000;

void update(void);

int main(void) {
  DDRA |= (1 << PA6) | (1 << PA5) | (1 << PA4) | (1 << PA3) | (1 << PA2) |
          (1 << PA1) | (1 << PA0);
  PORTA |= (0 << PA5); // orange led
  // initialize Timer1 the 16bit timer
  cli(); // disable global interrupts
  TCCR1A = 0;
  TCCR1B = 0;

  // set compare match register to desired timer count:
  OCR1A = temp;

  TCCR1B |= (1 << WGM12); // turn on CTC mode:
  TCCR1B |= (1 << CS11);  // Use CS10, CS11 and CS12 bits for 1/8 prescaler:

  // enable timer compare interrupt:
  TIMSK1 |= (1 << OCIE1A);

  // enble pin change interrupts on porta and portb
  GIMSK |= (1 << PCIE0) | (1 << PCIE1); // PCICR is GIMSK in attiny

  // enable external interrupts for rotary switch
  PCMSK0 |= (1 << PCINT7); // CLK of Rotary
  PCMSK1 |= (1 << PCINT8); // push button of Rotary

  sei(); // enable global interrupts:

  PORTA |= (1 << PA3) | (1 << PA2); // sleep and reset
  PORTA |= (0 << PA4);              // enable
  while (1) {
    OCR1A = temp;
  }
}

ISR(TIM1_COMPA_vect) {
  PORTA ^= (1 << PA1);
  PORTA ^= (1 << PA5);
}
ISR(PCINT1_vect) {
  if ((PINB & 0b00000001)) {
    PORTA ^= (1 << PA6);
    PORTA ^= (1 << PA0); // change direction on push button
  }
}

ISR(PCINT0_vect) {
  if ((PINB & 0b00000001))
    update();
}
void update(void) {
  if (PINA & 0b10000000)
    if (PINB & 0b00000010)
      temp -= step;
    else
      temp += step;
  step = temp / 30;
  if (temp > 25000)
    temp = 25000;
  if (temp < 600)
    temp = 600;
  if (step < 10)
    step = 10;
}
