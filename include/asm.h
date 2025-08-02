#ifndef __ASM_H
#define __ASM_H

#include <type/stdint.h>

#define read_sysreg(reg)		\
({ 								\
	u64 _val; 					\
	asm volatile				\
	(							\
		"mrs %0," #reg 			\
		: "=r"(_val)			\
		:						\
		: "memory"				\
	); 							\
	_val; 						\
})

#define write_sysreg(val, reg)	\
({ 								\
	u64 _val = (u64)val; 		\
	asm volatile				\
	(							\
		"msr " #reg ", %x0" 	\
		:						\
		: "r"(_val)				\
		: "memory"				\
	); 							\
})

#endif
