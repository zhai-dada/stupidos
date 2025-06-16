#include <lib/libio.h>

u8 min8(u64 addr)
{
    return *((volatile u8 *)addr);
}

u16 min16(u64 addr)
{
    return *((volatile u16 *)addr);
}

u32 min32(u64 addr)
{
    return *((volatile u32 *)addr);
}

u64 min64(u64 addr)
{
    return *((volatile u64 *)addr);
}

void mout8(u64 addr, u8 value)
{
    *((volatile u8 *)addr) = value;
}

void mout16(u64 addr, u16 value)
{
    *((volatile u16 *)addr) = value;
}

void mout32(u64 addr, u32 value)
{
    *((volatile u32 *)addr) = value;
}

void mout64(u64 addr, u64 value)
{
    *((volatile u64 *)addr) = value;
}

// 端口读写使用的是dx寄存器
u8 port_in8(u16 port)
{
    u8 ret = 0;
    asm volatile
    (
        "inb %%dx, %0       \n"
        "mfence             \n"
        : "=a"(ret)
        : "d"(port)
        : "memory"
    );
    return ret;
}
u32 port_in32(u16 port)
{
    u32 ret = 0;
    asm volatile
    (
        "inl %%dx, %0       \n"
        "mfence             \n"
        : "=a"(ret)
        : "d"(port)
        : "memory"
    );
    return ret;
}
void port_out8(u16 port, u8 value)
{
    asm volatile
    (
        "outb %0, %%dx      \n"
        "mfence             \n"
        :
        : "a"(value), "d"(port)
        : "memory"
    );
    return;
}
void port_out32(u16 port, u32 value)
{
    asm volatile
    (
        "outl %0, %%dx      \n"
        "mfence             \n"
        :
        : "a"(value), "d"(port)
        : "memory"
    );
    return;
}
