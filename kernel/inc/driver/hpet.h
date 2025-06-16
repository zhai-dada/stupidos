#ifndef __HPET_H__
#define __HPET_H__

#include <stdint.h>
#include <mm/memory.h>

#define HPET_BASEADDR   P_TO_V(0xfed00000)

void hpet_init(void);

#endif