#ifndef __BITS_TIME_H__
#define __BITS_TIME_H__

#include <bit/types.h>

struct time
{
    uint32_t second;    //00
    uint32_t minute;    //02
    uint32_t hour;      //04
    uint32_t week;      //06
    uint32_t day;       //07
    uint32_t month;     //08
    uint32_t year;      //09
    uint32_t century;   //32
};

#endif