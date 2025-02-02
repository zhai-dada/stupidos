#ifndef __BACKTRACE_H__
#define __BACKTRACE_H__

#include <stackregs.h>

s32 lookup_kallsyms(u64 address);

void backtrace(struct stackregs *regs);

#endif