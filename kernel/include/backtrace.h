#ifndef __BACKTRACE_H__
#define __BACKTRACE_H__
#include <stackregs.h>

int lookup_kallsyms(unsigned long address);

void backtrace(struct stackregs *regs);

#endif