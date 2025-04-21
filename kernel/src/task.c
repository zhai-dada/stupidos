#include <task.h>

tss_t tss[MAX_CPUNUM] = 
{
    [0 ... MAX_CPUNUM - 1] = INIT_TSS,
};

task_stack inittask_stack __attribute__((__section__(".data.inittask_stack"))) =
{
    0
};