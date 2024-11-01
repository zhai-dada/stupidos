#ifndef __SERIAL_H__
#define __SERIAL_H__


#define COM1           0x3f8
#define COM2           0x2f8
#define COM3           0x3e8
#define COM4           0x2e8

// Serial port offsets
#define RECEIVE_BUFFER_REG		0
#define TRANSMITTER_HOLDING_REG		0
#define DIVISOR_LATCH_LOW_REG		0

#define INTERRUPT_ENABLE_REG		1
#define DIVISOR_LATCH_HIGH_REG		1

#define INTERRUPT_IDENTIFICATION_REG	2
#define FIFO_CONTROL_REG		2

#define LINE_CONTROL_REG		3

#define MODEM_CONTROL_REG		4

#define LINE_STATUS_REG			5

#define MODEM_STATUS_REG		6

#define SCRATCH_REG			7

void serial_init();

void serial_putchar(unsigned char font);

#endif
