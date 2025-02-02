#ifndef __SEMAPHORE_H__
#define __SEMAPHORE_H__

#include <stdint.h>
#include <atomic.h>
#include <waitque.h>

typedef struct
{
    atomic_t counter;
    waitque_t wait;
}semaphore_t;


void semaphore_init(semaphore_t* semaphore, u64 count);
void semaphore_down(semaphore_t* semaphore);
void semaphore_up(semaphore_t* semaphore);
#endif