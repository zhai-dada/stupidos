#include <driver/cmos.h>
#include <stdint.h>
#include <lib/asm.h>

void get_cmos_time(time_t* time)
{
    cli();
    do
    {
        time->century = CMOS_READ(CMOS_CENTURY);
        time->year = CMOS_READ(CMOS_YEAR) + time->century * 0x100;
        time->month = CMOS_READ(CMOS_MONTH);
        time->week = CMOS_READ(CMOS_WEEK);
        time->day = CMOS_READ(CMOS_DAY);
        time->hour = CMOS_READ(CMOS_HOUR);
        time->minute = CMOS_READ(CMOS_MINUTE);
        time->second = CMOS_READ(CMOS_SECOND);
    }while(time->second != CMOS_READ(CMOS_SECOND)); // 防止RTC发生跳变，循环读取
    port_out8(0x70, 0x00); // nmi 开启
    return;
}