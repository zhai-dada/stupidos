#ifndef __ATOMIC_H__
#define __ATOMIC_H__

#include <stdint.h>

typedef struct 
{
    volatile s64 value;
}atomic_t;

void atomic_add(atomic_t* atomic, s64 value);
void atomic_sub(atomic_t* atomic, s64 value);
void atomic_inc(atomic_t* atomic);
void atomic_dec(atomic_t* atomic);
void atomic_set_mask(atomic_t *atomic, s64 mask);
void atomic_clear_mask(atomic_t *atomic, s64 mask);

#define atomic_read(atomic)	((atomic)->value)
#define atomic_set(atomic, val)	(((atomic)->value) = (val))

#endif