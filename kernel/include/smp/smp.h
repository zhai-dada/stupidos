#ifndef __SMP_H__
#define __SMP_H__

#include <lib.h>
#include <stdint.h>
#include <spinlock.h>
#include <stackregs.h>

extern spinlock_t smp_lock;

extern u32 apu_boot_start[];
extern u32 apu_boot_end[];


#define smp_cpu_id() (current->cpu_id)

void smp_init(void);
void start_smp(void);

#endif