#ifndef __SOFTIRQ_H__
#define __SOFTIRQ_H__

#include <stdint.h>
#include <smp/cpu.h>

#define TIMER_S_IRQ     (1 << 0)

u64 volatile jiffies = 0;

struct softirq
{
    void (*action)(void* data);
    void* data;
};

void set_softirq_status(u64 status);
u64 get_softirq_status(void);
void register_softirq(s32 nr, void (*action)(void* data), void* data);
void unregister_softirq(s32 nr);
void softirq_init(void);
void do_softirq(void);

#endif