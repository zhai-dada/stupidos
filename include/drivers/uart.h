#ifndef __UART_H
#define __UART_H

#include <asm/uart.h>
#include <type/stdint.h>

#define UART_BAUD   115200
#define UART_CLK    48000000

void uart_init(u64 uart_base);

void uart_putchar(u8 c);
u8 uart_getchar(void);

void uart_send_string(u8 *str);

#endif
