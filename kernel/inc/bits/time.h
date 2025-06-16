#ifndef __BITS_TIME_H__
#define __BITS_TIME_H__

#include <bits/types.h>

typedef struct
{
    u32 second;    //00
    u32 minute;    //02
    u32 hour;      //04
    u32 week;      //06
    u32 day;       //07
    u32 month;     //08
    u32 year;      //09
    u32 century;   //32
} time_t;

#endif