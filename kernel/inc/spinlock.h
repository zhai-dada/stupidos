#ifndef __SPINLOCK_H__
#define __SPINLOCK_H__

#include <stdint.h>

typedef struct
{
    volatile u64 lock; // 1 unlock 0 lock
} spinlock_t;

void spinlock_init(spinlock_t *lock);
void spinlock_lock(spinlock_t *lock);
void spinlock_unlock(spinlock_t *lock);

#endif