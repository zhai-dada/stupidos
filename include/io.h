#ifndef __IO_H
#define __IO_H

#include <type/stdint.h>

#define dmb()   __asm__ __volatile__ (" " : : : "memory")

#define __arch_readl(addr)			    (*(volatile u32 *)(addr))
#define __arch_writel(value, addr)		(*(volatile u32 *)(addr) = (value))

#define readl(addr)	        ({ u32 __value = __arch_readl(addr); dmb(); __value;})
#define writel(value, addr)	({ u32 __value = value; dmb(); __arch_writel(__value, addr); dmb();})


#endif
