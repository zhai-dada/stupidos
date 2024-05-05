#include <softirq.h>
#include <lib.h>
#include <smp/smp.h>
#include <task.h>

uint64_t volatile softirq_status[CPUNUM] = {0};
struct softirq softirq_vector[64] = {0};

void set_softirq_status(uint64_t status)
{
    softirq_status[smp_cpu_id()] |= status;
    return;
}
uint64_t get_softirq_status()
{
    return softirq_status[smp_cpu_id()];
}
void register_softirq(int32_t nr, void (*action)(void* data), void* data)
{
    softirq_vector[nr].action = action;
    softirq_vector[nr].data = data;
    return;
}
void unregister_softirq(int32_t nr)
{
    softirq_vector[nr].action = NULL;
    softirq_vector[nr].data = NULL;
    return;
}
void softirq_init()
{
    memset((void *)softirq_status, 0, sizeof(softirq_status));
    memset((void *)softirq_vector, 0, sizeof(struct softirq) * 64);
    return;
}
void do_softirq()
{
    sti();
    int32_t i = 0;
    for(i = 0; i < 64 && softirq_status; i++)
    {
        if(softirq_status[smp_cpu_id()] & (1 << i))
        {
            softirq_vector[i].action(softirq_vector[i].data);
            softirq_status[smp_cpu_id()] &= ~(1 << i);
        }
    }
    cli();
    return;
}