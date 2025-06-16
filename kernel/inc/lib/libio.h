#ifndef __LIB_IO_H__
#define __LIB_IO_H__

#include <stdint.h>

/**
 * 内存IO
 */

// in 读取
u8 min8(u64 addr);
u16 min16(u64 addr);
u32 min32(u64 addr);
u64 min64(u64 addr);

// out 写入
void mout8(u64 addr, u8 value);
void mout16(u64 addr, u16 value);
void mout32(u64 addr, u32 value);
void mout64(u64 addr, u64 value);

/**
 * 端口IO
 */

// in 读取
u8 port_in8(u16 port);
u32 port_in32(u16 port);

// out 写入
void port_out8(u16 port, u8 value);
void port_out32(u16 port, u32 value);

#endif