#ifndef __WAITQUE_H__
#define __WAITQUE_H__

#include <task.h>
#include <lib/list.h>

typedef struct
{
    list_t wait_list;
    task_t *task;
} waitque_t;

void wait_queue_init(waitque_t *wait_queue, task_t *task);
void sleep_on(waitque_t *wait_queue_head);
void interruptible_sleep_on(waitque_t *wait_queue_head);
void wakeup(waitque_t *wait_queue_head, s64 state);

#endif