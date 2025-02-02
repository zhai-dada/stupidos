#include <schedule.h>
#include <smp/cpu.h>
#include <lib.h>
#include <task.h>
#include <printk.h>

struct schedule task_schedule[CPUNUM];

void schedule()
{
    struct task_struct* task = NULL;
    current->flags &= ~NEED_SCHEDULE;
    u8 cpu_id = smp_cpu_id();
    cli();
    task = get_next_task();

    if(current->vruntime >= task->vruntime || current->state != TASK_RUNNING)
    {
        if(current->state == TASK_RUNNING)
        {
            insert_task_queue(current);
        }
        if(!task_schedule[cpu_id].exectask_jiffies)
        {
            switch(task->priority)
            {
                case 0:
                case 1:
                    task_schedule[cpu_id].exectask_jiffies = 4 / task_schedule[cpu_id].running_task_count;
                    break;
                case 2:
                default:
                    task_schedule[cpu_id].exectask_jiffies = 4 / task_schedule[cpu_id].running_task_count * 3;
                    break;

            }
        }
        barrier();
        switch_mm(current, task);
        barrier();
        switch_to(current, task);
    }
    else
    {
        insert_task_queue(task);
        if(!task_schedule[cpu_id].exectask_jiffies)
        {
            switch(task->priority)
            {
                case 0:
                case 1:
                    task_schedule[cpu_id].exectask_jiffies = 4 / task_schedule[cpu_id].running_task_count;
                    break;
                case 2:
                default:
                    task_schedule[cpu_id].exectask_jiffies = 4 / task_schedule[cpu_id].running_task_count * 3;
                    break;
            }
        }
    }
    barrier();
    sti();
}

void schedule_init()
{
    s32 i = 0;
    memset(task_schedule, 0, sizeof(struct schedule) * CPUNUM);
    for(i = 0; i < CPUNUM; ++i)
    {
        list_init(&task_schedule[i].task_queue.list);
        task_schedule[i].task_queue.vruntime = 0x7fffffffffffffff;
        task_schedule[i].running_task_count = 1;
        task_schedule[i].exectask_jiffies = 4;
    }
    return;
}

struct task_struct* get_next_task()
{
    struct task_struct* task = NULL;
    if(list_is_empty(&task_schedule[smp_cpu_id()].task_queue.list))
    {
        return init_task[smp_cpu_id()];
    }
    task = container_of(list_next(&task_schedule[smp_cpu_id()].task_queue.list), struct task_struct, list);
    list_delete(&task->list);
    task_schedule[smp_cpu_id()].running_task_count -= 1;
    return task;
}

void insert_task_queue(struct task_struct* task)
{
    struct task_struct* tmp = container_of(list_next(&task_schedule[smp_cpu_id()].task_queue.list), struct task_struct, list);
    if(task == init_task[smp_cpu_id()])
    {
        return;
    }
    if(list_is_empty(&task_schedule[smp_cpu_id()].task_queue.list))
    {
        ;
    }
    else
    {
        while(tmp->vruntime < task->vruntime)
        {
            tmp = container_of(list_next(&tmp->list), struct task_struct, list);
        }
    }
    list_add_before(&tmp->list, &task->list);
    task_schedule[smp_cpu_id()].running_task_count += 1;
    return;
}
