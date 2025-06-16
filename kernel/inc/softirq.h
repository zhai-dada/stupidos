#ifndef __SOFTIRQ_H__
#define __SOFTIRQ_H__

#include <stdint.h>

extern u64 jiffies;

#define TIMER_IRQ       0
#define TIMER_S_IRQ     (1 << TIMER_IRQ)

typedef struct
{
    void (*action)(void* data);
    void* data;
} softirq_t;

void softirq_init(void);
void set_softirq_status(u64 status);
u64 get_softirq_status();
void register_softirq(s32 nr, void (*action)(void* data), void* data);
void unregister_softirq(s32 nr);

#endif
