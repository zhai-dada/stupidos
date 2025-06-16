#ifndef __SCHEDULE_H__
#define __SCHEDULE_H__

#include <cpu.h>
#include <stdint.h>
#include <task.h>
#include <stackregs.h>

typedef struct
{
    u64 running_task_count;
    u64 exectask_jiffies;
    task_t task_queue;
} schedule_t;

extern schedule_t task_schedule[MAX_CPUNUM];

void schedule(void);
void schedule_init(void);
task_t* get_next_task(void);
void insert_task_queue(task_t* task);

#endif

