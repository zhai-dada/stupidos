#ifndef __SERIAL_H__
#define __SERIAL_H__

#include <stdint.h>

#define COM1_BASE 0x3f8 // COM1基地址
#define COM2_BASE 0x2f8
#define COM3_BASE 0x3e8
#define COM4_BASE 0x2e8

#define IER 1 // 中断使能寄存器
#define FCR 2 // FIFO控制寄存器
#define LCR 3 // 线路控制寄存器
#define MCR 4 // 调制解调器控制寄存器
#define LSR 5 // 线路状态寄存器
#define RBR 0 // 接收缓冲寄存器
#define THR 0 // 发送保持寄存器
#define DLR 0 // DLAB L
#define DHR 1 // DLAB H
#define IIR 2 // Line Status Register
#define MSR 6 // Modem Status Register
#define SR  7  // Scratch Register

#define SERIAL_ATTR_RESET           "\x1b[0m"
#define SERIAL_ATTR_FRONT_BLACK     "\x1b[30m"
#define SERIAL_ATTR_FRONT_RED       "\x1b[31m"
#define SERIAL_ATTR_FRONT_GREEN     "\x1b[32m"
#define SERIAL_ATTR_FRONT_YELLOW    "\x1b[33m"
#define SERIAL_ATTR_FRONT_BLUE      "\x1b[34m"
#define SERIAL_ATTR_FRONT_MAGENTA   "\x1b[35m"
#define SERIAL_ATTR_FRONT_CYAN      "\x1b[36m"
#define SERIAL_ATTR_FRONT_WHITE     "\x1b[37m"

#define SERIAL_ATTR_BACK_BLACK      "\x1b[40m"
#define SERIAL_ATTR_BACK_RED        "\x1b[41m"
#define SERIAL_ATTR_BACK_GREEN      "\x1b[42m"
#define SERIAL_ATTR_BACK_YELLOW     "\x1b[43m"
#define SERIAL_ATTR_BACK_BLUE       "\x1b[44m"
#define SERIAL_ATTR_BACK_MAGENTA    "\x1b[45m"
#define SERIAL_ATTR_BACK_CYAN       "\x1b[46m"
#define SERIAL_ATTR_BACK_WHITE      "\x1b[47m"

void serial_init(void);
void serial_irq_en(void);

s32 serial_printf(s8 *front, s8 *back, const s8 *fmt, ...);

#endif
