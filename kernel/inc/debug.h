#ifndef __DEBUG_H__
#define __DEBUG_H__

#include <driver/serial.h>
#include <stdarg.h>

#ifdef __SERIAL_H__
#define printk(...) serial_printf(SFWHITE, SBBLACK, __VA_ARGS__)
#else
#define printk(...)
#endif

#endif
