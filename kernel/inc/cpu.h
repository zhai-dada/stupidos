#ifndef __CPU_H__
#define __CPU_H__

#include <stdint.h>

#define MAX_CPUNUM  16

extern u32 cpunum;
extern u32 initial_apicid;

void get_cpuinfo(void);

#endif