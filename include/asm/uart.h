#ifndef __ASM_UART_H
#define __ASM_UART_H

#include <asm/base.h>

#define UART_DATA(UART_BASE)        (UART_BASE + 0x0000)
#define UART_RSRECR(UART_BASE)      (UART_BASE + 0x0004)
#define UART_FR(UART_BASE)          (UART_BASE + 0x0018)
#define UART_ILPR(UART_BASE)        (UART_BASE + 0x0020)
#define UART_IBRD(UART_BASE)        (UART_BASE + 0x0024)
#define UART_FBRD(UART_BASE)        (UART_BASE + 0x0028)
#define UART_LCRH(UART_BASE)        (UART_BASE + 0x002C)
#define UART_CR(UART_BASE)          (UART_BASE + 0x0030)
#define UART_IFLS(UART_BASE)        (UART_BASE + 0x0034)
#define UART_IMSC(UART_BASE)        (UART_BASE + 0x0038)
#define UART_RIS(UART_BASE)         (UART_BASE + 0x003C)
#define UART_MIS(UART_BASE)         (UART_BASE + 0x0040)
#define UART_ICR(UART_BASE)         (UART_BASE + 0x0044)
#define UART_DMACR(UART_BASE)       (UART_BASE + 0x0048)
#define UART_ITCR(UART_BASE)        (UART_BASE + 0x0080)
#define UART_ITIP(UART_BASE)        (UART_BASE + 0x0084)
#define UART_ITOP(UART_BASE)        (UART_BASE + 0x0088)
#define UART_TDR(UART_BASE)         (UART_BASE + 0x008C)

#endif
