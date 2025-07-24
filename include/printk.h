#ifndef __PRINTK_H
#define __PRINTK_H

#include <type/stdint.h>
#include <stdarg.h>
#include <string.h>
#include <drivers/uart.h>

s32 sprintf(s8* buffer, const s8* fmt, ...);

s32 printk(const s8* fmt, ...);

#endif
