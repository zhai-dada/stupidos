#ifndef __LIB_STRING_H__
#define __LIB_STRING_H__

#include <stdint.h>

#define is_digit(c) ((c) >= '0' && (c) <= '9')

s32 strlen(u8 *str);


void* memcpy(void* dest, void* srcs, s64 num);
void* memset(void *address, u8 c, s64 count);

#endif