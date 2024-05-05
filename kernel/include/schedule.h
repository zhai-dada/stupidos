#ifndef __SCHEDULE_H__
#define __SCHEDULE_H__

#include <smp/cpu.h>
#include <stdint.h>
#include <task.h>
#include <stackregs.h>

struct schedule
{
    int64_t running_task_count;
    int64_t exectask_jiffies;
    struct task_struct task_queue;
};
extern struct schedule task_schedule[CPUNUM];

void schedule(void);
void schedule_init(void);
struct task_struct* get_next_task(void);
void insert_task_queue(struct task_struct* task);

#endif

