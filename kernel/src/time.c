#include <smp/smp.h>
#include <time.h>
#include <printk.h>
#include <task.h>
#include <softirq.h>
#include <debug.h>

struct time time;
struct timer_list timer_list_head;

#define CMOS_READ(addr)         \
({                               \
    io_out8(0x70, 0x80 | addr); \
    io_in8(0x71);               \
})

void get_cmos_time(struct time* time)
{
    cli();
    do
    {
        time->year = CMOS_READ(0x09) + CMOS_READ(0x32) * 0x100;
        time->century = CMOS_READ(0x32);
        time->week = CMOS_READ(0x06);
        time->month = CMOS_READ(0x08);
        time->day = CMOS_READ(0x07);
        time->hour = CMOS_READ(0x04);
        time->minute = CMOS_READ(0x02);
        time->second = CMOS_READ(0x00);
    }while(time->second != CMOS_READ(0x00));
    io_out8(0x70, 0x00);
    return;
}
void do_timer(void* data)
{
    struct timer_list* tmp = container_of(list_next(&timer_list_head.list), struct timer_list, list);
    while((!(list_is_empty(&timer_list_head.list))) && (tmp->jiffies <= jiffies))
    {
        del_timer(tmp);
        tmp->func(tmp->data);
        tmp = container_of(list_next(&timer_list_head.list), struct timer_list, list);
    }   
    DBG_SERIAL(SERIAL_ATTR_FRONT_YELLOW, SERIAL_ATTR_BACK_BLACK, "(HPET:%ld) CPU:%d PREE:%ld\n", jiffies, smp_cpu_id(), current->preempt_count);
    return;
}
void init_timer(struct timer_list* timer, void (*func)(void* data), void* data, u64 jiffies)
{
    list_init(&timer->list);
    timer->func = func;
    timer->data = data;
    timer->jiffies = jiffies + timer->jiffies;
    return;
}
void add_timer(struct timer_list* timer)
{
    struct timer_list* tmp = container_of(list_next(&timer_list_head.list), struct timer_list, list);
    if(list_is_empty(&timer_list_head.list))
    {
        ;
    }
    else
    {
        while(tmp->jiffies < timer->jiffies)
        {
            tmp = container_of(list_next(&tmp->list), struct timer_list, list);
        }
    }
    list_add_before(&tmp->list, &timer->list);
    return;
}
void del_timer(struct timer_list* timer)
{
    list_delete(&timer->list);
    return;
}


void timer_init()
{
    struct timer_list* tmp = NULL;
    jiffies = 0;
    init_timer(&timer_list_head, NULL, NULL, -1UL);
    register_softirq(0, &do_timer, NULL);
    tmp = (struct timer_list*)kmalloc(sizeof(struct timer_list), 0);
    init_timer(tmp, &test_timer, NULL, 5);
    add_timer(tmp);
    return;
}
void test_timer(void* data)
{
    DBG_SERIAL(SERIAL_ATTR_FRONT_GREEN, SERIAL_ATTR_BACK_BLACK, "test_timer\n");
    return;
}