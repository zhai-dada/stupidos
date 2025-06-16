#ifndef __LIB_VSPRINTF_H__
#define __LIB_VSPRINTF_H__

#include <stdint.h>
#include <stdarg.h>
#include <lib/string.h>

s32 sprintf(s8 *buffer, const s8 *fmt, ...);
s32 vsprintf(s8 *buf, const s8 *fmt, va_list args);

#endif