/*
shared under GPLv3
Author SIBU SAMAN
code for controlling the position of a servo or speed of an BLDC via ESC using a
rotary encoder.
The rotaion will control the angle
pressing the button toggles between fine and coarse control
the device powers on with high pulse corresponding t0 180deg or max throttle for
ESC, pressing the button sets it to low throttle/0deg, this enables esc
callibration for most esc's
*/
#define F_CPU 8000000UL
#include <avr/interrupt.h>
#include <avr/io.h>

void update(void); // function declaration
                   /*
                     PA5		orange LED
                     PA6		Blue LED
                     PB2		Servo Pin
                   */
int min = 520;     // 1554 for ESC and 520 for servo
int max = 2500;    // 1775 for ESC and2500 for servo
int servo_pos = 2500;
int step = 11;
int rot_dir = 0;
int calib = 1;
int sub_mod = 1; // sub_mod =1 for servo mode and 0 for ESC mod

int main(void) {
  DDRA |= (1 << PA6) | (1 << PA5); // blue led and Orange LED
  DDRB |= (1 << PB2);              // servo pin

  cli(); // disable global interrupts
  // initialize Timer1 the 16bit timer
  TCCR1A = 0;
  TCCR1B = 0;

  // set compare match register to desired timer count:
  // OCR1A = servo_pos*11+520; //min 520 0deg 2500 180deg
  OCR1B = 20000;

  // Use CS10, CS11 and CS12 bits for 1/8 prescaler:
  TCCR1B |= (1 << CS11);

  // enable timer compare interrupt:
  TIMSK1 |= (1 << OCIE1A);
  TIMSK1 |= (1 << OCIE1B);

  // enble pin change interrupts on porta and portb
  GIMSK |= (1 << PCIE0) | (1 << PCIE1); // PCICR is GIMSK in attiny

  // enable external interrupts for rotary switch
  PCMSK0 |= (1 << PCINT7); // CLK of Rotary
  PCMSK1 |= (1 << PCINT8); // push button of Rotary

  sei(); // enable global interrupts:

  while (1) {
    OCR1A = servo_pos;
  }
}

ISR(TIM1_COMPA_vect) { PORTB = 0x00; }

ISR(TIM1_COMPB_vect) {
  PORTB |= (1 << PB2);
  TCNT1 = 0;
}

ISR(PCINT1_vect) {
  if (PINB & 0b00000001) {
    if (sub_mod) {
      PORTA &= ~(1 << PA6); // clear LED
      step = 11;
      sub_mod = 0;
    } else {
      PORTA |= (1 << PA6);
      step = 1;
      sub_mod = 1;
    }
    if (calib) {
      servo_pos = min;
      calib = 0;
    }
  }
}

ISR(PCINT0_vect) {
  if (PINB & 0b00000001) // if push button is not pressed and held
    update();

  servo_pos += rot_dir;
  rot_dir = 0;
  if (servo_pos > max)
    servo_pos = max;
  else if (servo_pos < min)
    servo_pos = min;
}
void update(void) {
  if (PINA & 0b10000000)
    if (PINB & 0b00000010) {
      rot_dir = step; //+1 for CW
      PORTA &= ~(1 << PA5);
    } else {
      rot_dir = -1 * step; //-1 for CCW
      PORTA |= (1 << PA5);
    }
}
