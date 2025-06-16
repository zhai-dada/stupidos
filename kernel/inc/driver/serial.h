#ifndef __SERIAL_H__
#define __SERIAL_H__

#include <stdint.h>
#include <lib/libio.h>
#include <lib/vsprintf.h>

#define COM1_BASE 0x3f8 // COM1基地址
#define COM2_BASE 0x2f8 // COM2
#define COM3_BASE 0x3e8 // COM3
#define COM4_BASE 0x2e8 // COM4

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
#define SR  7 // Scratch Register

// attribute reset
#define SRESET      "\x1b[0m"

// front color
#define SFBLACK     "\x1b[30m"
#define SFRED       "\x1b[31m"
#define SFGREEN     "\x1b[32m"
#define SFYELLOW    "\x1b[33m"
#define SFBLUE      "\x1b[34m"
#define SFMAGENTA   "\x1b[35m"
#define SFCYAN      "\x1b[36m"
#define SFWHITE     "\x1b[37m"

// back color
#define SBBLACK      "\x1b[40m"
#define SBRED        "\x1b[41m"
#define SBGREEN      "\x1b[42m"
#define SBYELLOW     "\x1b[43m"
#define SBBLUE       "\x1b[44m"
#define SBMAGENTA    "\x1b[45m"
#define SBCYAN       "\x1b[46m"
#define SBWHITE      "\x1b[47m"

// 串口初始化
void serial_init(void);

// 串口打印
s32 serial_printf(s8 *front, s8 *back, const s8 *fmt, ...);

void serial_irq_en(void);

#endif
