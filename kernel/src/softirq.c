#include <softirq.h>
#include <lib/asm.h>
#include <driver/serial.h>

u64 volatile softirq_status = 0;
softirq_t softirq_vector[64] = {0};

void set_softirq_status(u64 status)
{
    softirq_status |= status;
    return;
}

u64 get_softirq_status(void)
{
    return softirq_status;
}

void register_softirq(s32 nr, void (*action)(void* data), void* data)
{
    softirq_vector[nr].action = action;
    softirq_vector[nr].data = data;
    return;
}

void unregister_softirq(s32 nr)
{
    softirq_vector[nr].action = NULL;
    softirq_vector[nr].data = NULL;
    return;
}

void softirq_init(void)
{
    jiffies = 0;
    memset((void *)softirq_status, 0, sizeof(softirq_status));
    memset((void *)softirq_vector, 0, sizeof(softirq_t) * 64);
    return;
}

void do_softirq(void)
{
    sti();
    s32 i = 0;
    for(i = 0; i < 64 && softirq_status; i++)
    {
        if(softirq_status & (1 << i))
        {
            softirq_vector[i].action(softirq_vector[i].data);
            softirq_status &= ~(1 << i);
        }
    }
    cli();
    return;
}