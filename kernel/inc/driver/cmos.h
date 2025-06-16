#ifndef __CMOS_H__
#define __CMOS_H__

#include <lib/libio.h>

// CMOS 保存的数值使用8421编码
#define CMOS_INDEX_PORT 0x70
#define CMOS_DATA_PORT  0x71

enum
{
    CMOS_SECOND = 0x00,
    CMOS_MINUTE = 0x02,
    CMOS_HOUR   = 0x04,
    CMOS_WEEK   = 0x06,
    CMOS_DAY    = 0x07,
    CMOS_MONTH  = 0x08,
    CMOS_YEAR   = 0x09,
    CMOS_CENTURY= 0x32,
};

// 0x70 bit 7 控制NMI中断使能，读取的时候先关闭，防止NMI中断干扰结果
#define CMOS_READ(index)            \
({                                  \
    port_out8(0x70, 0x80 | index);  \
    port_in8(0x71);                 \
})

void get_cmos_time(time_t* time);

#endif
