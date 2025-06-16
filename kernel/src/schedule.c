#include <schedule.h>
#include <task.h>
#include <debug.h>
#include <cpu.h>

schedule_t task_schedule[MAX_CPUNUM];

/**
 * 
 */
void schedule(void)
{
    task_t* task = NULL;
    current->flags &= ~NEED_SCHEDULE;
    u8 cpuid = current->cpuid;
    cli();
    task = get_next_task();
    if(current->vruntime >= task->vruntime || current->state != TASK_RUNNING)
    {
        if(current->state == TASK_RUNNING)
        {
            insert_task_queue(current);
        }
        if(!task_schedule[cpuid].exectask_jiffies)
        {
            switch(task->priority)
            {
                case 0:
                case 1:
                {
                    task_schedule[cpuid].exectask_jiffies = 4 / task_schedule[cpuid].running_task_count;
                    break;
                }
                case 2:
                default:
                {
                    task_schedule[cpuid].exectask_jiffies = 4 / task_schedule[cpuid].running_task_count * 3;
                    break;
                }

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
        if(!task_schedule[cpuid].exectask_jiffies)
        {
            switch(task->priority)
            {
                case 0:
                case 1:
                    task_schedule[cpuid].exectask_jiffies = 4 / task_schedule[cpuid].running_task_count;
                    break;
                case 2:
                default:
                    task_schedule[cpuid].exectask_jiffies = 4 / task_schedule[cpuid].running_task_count * 3;
                    break;
            }
        }
    }
    barrier();
    sti();
    return;
}

/**
 * schedule_init
 * 初始化可用cpu数量的task_schedule结构
 * 填充成员变量
 */
void schedule_init(void)
{
    u64 i = 0;
    memset(task_schedule, 0, sizeof(schedule_t) * MAX_CPUNUM);
    for(i = 0; i < cpunum; ++i)
    {
        list_init(&task_schedule[i].task_queue.list);
        task_schedule[i].task_queue.vruntime = 0x7fffffffffffffff;
        task_schedule[i].running_task_count = 1;
        task_schedule[i].exectask_jiffies = 4;
    }
    return;
}

task_t* get_next_task(void)
{
    task_t* task = NULL;
    if(list_is_empty(&task_schedule[current->cpuid].task_queue.list))
    {
        return current;
    }
    task = container_of(list_next(&task_schedule[current->cpuid].task_queue.list), list, task_t);
    list_delete(&task->list);
    task_schedule[current->cpuid].running_task_count -= 1;
    return task;
}

void insert_task_queue(task_t* task)
{
    task_t* tmp = container_of(list_next(&task_schedule[current->cpuid].task_queue.list), list, task_t);
    if(task == current)
    {
        return;
    }
    if(list_is_empty(&task_schedule[current->cpuid].task_queue.list))
    {
        return;
    }
    else
    {
        while(tmp->vruntime < task->vruntime)
        {
            tmp = container_of(list_next(&tmp->list), list, task_t);
        }
    }
    list_add_before(&tmp->list, &task->list);
    task_schedule[current->cpuid].running_task_count += 1;
    return;
}
