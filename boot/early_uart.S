#include "asm/gpio.h"
#include "asm/uart.h"

/*
    void early_uart_init(void)
*/
.global early_uart_init
.type early_uart_init, @function
early_uart_init:
    // gpio init
    // set alt0 for gpio 14 15
    ldr x1, =GPFSEL1
    ldr w0, [x1]
    mov x2, #0x0024
    bfi x0, x2, #12, #6
    str w0, [x1]

    // gpio pull down
    ldr x1, =GPUPDNCTRL0
    ldr w0, [x1]
    mov x2, #0x000a
    bfi x0, x2, #28, #4
    str w0, [x1]

    // disable uart
    ldr x1, =UART_CR(UART0_BASE)
    str wzr, [x1]

    // 48000000 / 16 / 115200 = 26.04166
    // IBAUD = 26
    //FBAUD = (0.04166 * 64 + 0.5) = 3.166 = 3
    // set baud rate
    ldr x1, =UART_IBRD(UART0_BASE)
    mov w2, #26
    str w2, [x1]
    ldr x1, =UART_FBRD(UART0_BASE)
    mov w2, #3
    str w2, [x1]

    // enable fifo 8 bits
    ldr x1, =UART_LCRH(UART0_BASE)
    mov x2, #7
    bfi x1, x2, #4, #3

    // disable intr
    ldr x1, =UART_IMSC(UART0_BASE)
    str wzr, [x1]

    // enable uart and tx rx
    ldr x1, =UART_CR(UART0_BASE)
    mov w2, #1
    mov x3, 3
    bfi x2, x3, #8, #2
    str w2, [x1]

    // test data
    ldr x1, =UART_DATA(UART0_BASE)
    mov x2, #0x60

    isb
    ret

/*
    void early_uart_put_char(char w0)
*/
.type early_uart_put_char, @function
early_uart_put_char:
	ldr x1, =UART_FR(UART0_BASE)
1:
	ldr w2, [x1]
    // tx fifo is full?
	and w2, w2, #0x20
	cmp w2, #0x0
	b.ne 1b

	ldr x1, =UART_DATA(UART0_BASE)
	str w0, [x1]
    isb
	ret

/*
    void early_uart_put_string(char* x0)
*/
.globl early_uart_put_string
.type early_uart_put_string, @function
early_uart_put_string:
    // string -> x4
	mov x4, x0
	// save ret addr
	mov x6, x30
1:
    // ldr ont byte to w0
	ldrb w0, [x4]
	bl early_uart_put_char
    
    // next char
	add x4, x4, 1

    // char == '\0' ?
	cmp w0, #0
	b.ne 1b

	// restore ret addr
	mov x30, x6
	ret