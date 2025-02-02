#ifndef __DEBUG_H__
#define __DEBUG_H__

#include <serial.h>

void dbg_null(s8* front, s8* back, const s8* fmt, ...)
{
    ;
}
#define DBG_ON

#ifdef DBG_ON
#define DBG_SERIAL(a, b, fmt, arg...) serial_printf(a, b, fmt, ##arg)
#else
#define DBG_SERIAL(a, b, fmt, arg...) dbg_null(a, b, fmt, ##arg)
#endif

#endif
