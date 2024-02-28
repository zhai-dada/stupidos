#ifndef __ATOMIC_H__
#define __ATOMIC_H__

#include <stdint.h>

typedef struct 
{
    volatile int64_t value;
}atomic_t;

void atomic_add(atomic_t* atomic, int64_t value);
void atomic_sub(atomic_t* atomic, int64_t value);
void atomic_inc(atomic_t* atomic);
void atomic_dec(atomic_t* atomic);
void atomic_set_mask(atomic_t *atomic, int64_t mask);
void atomic_clear_mask(atomic_t *atomic, int64_t mask);

#define atomic_read(atomic)	((atomic)->value)
#define atomic_set(atomic, val)	(((atomic)->value) = (val))

#endif