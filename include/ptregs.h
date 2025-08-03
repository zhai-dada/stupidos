#ifndef __PTREGS_H
#define __PTREGS_H

#include <type/stdint.h>

typedef struct pt_regs
{
	u64 regs[31];
	u64 sp;
	u64 pc;
	u64 pstate;
} pt_regs_t;

#endif
