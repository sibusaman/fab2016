/* timer CTC interrupt test
Author SIBU SAMAN
licensed under GPLv3
code for networking with identity, accepts ascii chars, # as end of packet and
alphabet as address, soft serial code from Neil is used for data transfer, the
value is then indiacted in the led ring
*/
#define F_CPU 8000000UL
#include <avr/interrupt.h>
#include <avr/io.h>
#include <avr/pgmspace.h>
#include <string.h>
#include <util/delay.h>

#define output(directions, pin)                                                \
  (directions |= pin) // set port direction for output
#define input(directions, pin)                                                 \
  (directions &= (~pin))                        // set port direction for input
#define set(port, pin) (port |= pin)            // set port pin
#define clear(port, pin) (port &= (~pin))       // clear port pin
#define pin_test(pins, pin) (pins & pin)        // test for port pin
#define bit_test(byte, bit) (byte & (1 << bit)) // test for bit set
#define bit_delay_time 98 // bit delay for 9600 with overhead
#define bit_delay() _delay_us(bit_delay_time)          // RS232 bit delay
#define half_bit_delay() _delay_us(bit_delay_time / 2) // RS232 half bit delay

#define serial_port PORTB
#define serial_direction DDRB
#define serial_pins PINB
#define serial_pin_in (1 << PB2)
//#define serial_pin_out (1 << PB4)

/////////////////////////////////////////
#define identity = 'A'

// int temp=0;
int val = 1;
int prev_val = 100;
int last_led_val;
int temp_val = 0;
unsigned int last_led = 0;
unsigned int shift;

unsigned int forme = 0;

void get_char(volatile unsigned char *pins, unsigned char pin, char *rxbyte) {
  // This function is written by Neil Gershenfeld
  // read character into rxbyte on pins pin
  //  assumes line driver (inverts bits)
  //
  *rxbyte = 0;
  while (pin_test(*pins, pin))
    // wait for start bit
    // delay to middle of first data bit
    half_bit_delay();
  bit_delay();
  //
  // unrolled loop to read data bits
  //
  if
    pin_test(*pins, pin) *rxbyte |= (1 << 0);
  else
    *rxbyte |= (0 << 0);
  bit_delay();
  if
    pin_test(*pins, pin) *rxbyte |= (1 << 1);
  else
    *rxbyte |= (0 << 1);
  bit_delay();
  if
    pin_test(*pins, pin) *rxbyte |= (1 << 2);
  else
    *rxbyte |= (0 << 2);
  bit_delay();
  if
    pin_test(*pins, pin) *rxbyte |= (1 << 3);
  else
    *rxbyte |= (0 << 3);
  bit_delay();
  if
    pin_test(*pins, pin) *rxbyte |= (1 << 4);
  else
    *rxbyte |= (0 << 4);
  bit_delay();
  if
    pin_test(*pins, pin) *rxbyte |= (1 << 5);
  else
    *rxbyte |= (0 << 5);
  bit_delay();
  if
    pin_test(*pins, pin) *rxbyte |= (1 << 6);
  else
    *rxbyte |= (0 << 6);
  bit_delay();
  if
    pin_test(*pins, pin) *rxbyte |= (1 << 7);
  else
    *rxbyte |= (0 << 7);
  //
  // wait for stop bit
  //
  bit_delay();
  half_bit_delay();
}

int main(void) {
  static char chr;
  DDRB = 0b00000011;
  DDRA = 0xff;

  cli(); // disable global interrupts

  // set clock divider to /1
  CLKPR = (1 << CLKPCE);
  CLKPR = (0 << CLKPS3) | (0 << CLKPS2) | (0 << CLKPS1) | (0 << CLKPS0);

  // enble pin change interrupts on int0
  //	GIMSK |= (1<<INT0);
  //	MCUCR= (1<<ISC00) | (1<<ISC00);

  //	TCCR1A = 0;
  //	TCCR1B = 0;
  TCCR0A = 0;

  TCCR0B = 0;

  // set compare match register to desired timer count:
  OCR0B = 200;
  TCCR0B |= (1 << CS01);
  //	TCCR1B |= (1 << CS11);

  // enable timer compare interrupt:
  TIMSK0 |= (1 << OCIE0A);
  TIMSK0 |= (1 << OCIE0B);

  sei(); // enable global interrupts:

  while (1) {
    get_char(&serial_pins, serial_pin_in, &chr);

    if (chr == 'A') // set forme flag =1 if found my address
    {
      forme = 1;
      if (~temp_val)
        val = temp_val;
      temp_val = 0;
    } else {
      if (chr == '#' || (chr > 64 && chr < 91)) // not my address but either a
                                                // stop char or the address of
                                                // another slave 65 & 90 are
                                                // ascii codes for A and Z
      {
        forme = 0;
        if (temp_val != 0 && chr == '#')
          val = temp_val;
        if (val > 100)
          val = 90;
        temp_val = 0;
      }
    }

    if (forme == 1 && (chr > 47 && chr < 58)) {
      temp_val = temp_val * 10 + (chr - 48);
    }

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
