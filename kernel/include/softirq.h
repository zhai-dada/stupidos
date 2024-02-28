#ifndef __SOFTIRQ_H__
#define __SOFTIRQ_H__

#include <stdint.h>


#define TIMER_S_IRQ     (1 << 0)

uint64_t volatile softirq_status = 0;
uint64_t volatile jiffies = 0;

struct softirq
{
    void (*action)(void* data);
    void* data;
};

struct softirq softirq_vector[64] = {0};

void set_softirq_status(uint64_t status);
uint64_t get_softirq_status(void);
void register_softirq(int32_t nr, void (*action)(void* data), void* data);
void unregister_softirq(int32_t nr);
void softirq_init(void);
void do_softirq(void);

#endif