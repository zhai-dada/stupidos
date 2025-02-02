#ifndef __WAITQUE_H__
#define __WAITQUE_H__

#include <lib.h>
#include <stdint.h>

typedef struct
{
    list_t wait_list;
    struct task_struct *task;
} waitque_t;

void wait_queue_init(waitque_t *wait_queue, struct task_struct *task);
void sleep_on(waitque_t *wait_queue_head);
void interruptible_sleep_on(waitque_t *wait_queue_head);
void wakeup(waitque_t *wait_queue_head, s64 state);

#endif