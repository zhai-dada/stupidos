#ifndef __TIME_H__
#define __TIME_H__

#include <stdint.h>
#include <lib.h>

#define BCD2BIN(value)  (((value) & 0xf) + ((value) >> 4) * 10)

struct timer_list
{
    list_t list;
    u64 jiffies;
    void (*func)(void* data);
    void* data;
};

void get_cmos_time(struct time* time);
void do_timer(void* data);
void timer_init(void);
void test_timer(void* data);
void timer_init(void);
void del_timer(struct timer_list* timer);
void add_timer(struct timer_list* timer);
void init_timer(struct timer_list* timer, void (*func)(void* data), void* data, u64 jiffies);

#endif