#ifndef __LIB_H__
#define __LIB_H__

/**
 * 一些常用的宏定义
*/
#include <stdint.h>
#include <stdarg.h>

#define NULL        0

#define nop()       asm volatile ("nop":::"memory")
#define hlt()       asm volatile ("hlt":::"memory")
#define sti()       asm volatile ("sti":::"memory")
#define cli()       asm volatile ("cli":::"memory")
#define io_mfence() asm volatile ("mfence":::"memory")
#define barrier()   asm volatile ("":::"memory")

#define is_digit(c) ((c) >= '0' && (c) <= '9')

/**
 * 这个宏函数的功能是：
 * 根据结构体变量内的某个成员变量基地址推导出父结构的地址
 * ptr是结构体内某个变量的地址
 * type是这个ptr所在结构体的类型
 * type_number是成员的变量名
*/
#define container_of(ptr, type, type_member)                                    \
({                                                                              \
    typeof(((type *)0)->type_member) *p = (ptr);                                \
    (type *)((u64)p - (u64)&(((type *)0)->type_member));                        \
})

/**
 * 这个宏函数的作用是----->    n / base
 * 
*/
#define do_div(n, base)                 \
({                                      \
    s32 res;                            \
    asm                                 \
    (                                   \
        "divq %%rcx"                    \
        : "=a"(n), "=d"(res)            \
        : "0"(n), "1"(0), "c"(base)     \
    );                                  \
    res;                                \
})

/**
 * 链表数据结构
*/
typedef struct list
{
    struct list* prev;
    struct list* next;
}list_t;
__attribute__((always_inline)) inline void list_init(list_t* list)
{
    list->prev = list;
    list->next = list;
    return;
}
__attribute__((always_inline)) inline void list_add_behind(list_t* list, list_t* newn)
{
    newn->next = list->next;
    newn->prev = list;
    newn->next->prev = newn;
    list->next = newn;
    return;
}
__attribute__((always_inline)) inline void list_add_before(list_t* list, list_t* newn)
{
    list->prev->next = newn;
    newn->prev = list->prev;
    list->prev = newn;
    newn->next = list;
    return;
}
__attribute__((always_inline)) inline void list_delete(list_t* list)
{
    list->next->prev = list->prev;
    list->prev->next = list->next;
    return;
}
__attribute__((always_inline)) inline s64 list_is_empty(list_t* list)
{
    if(list->next == list && list->prev == list)
    {
        return 1;
    }
    return 0;
}
__attribute__((always_inline)) inline list_t* list_prev(list_t* list)
{
    if(list->prev != NULL)
    {
        return list->prev;
    }
    return NULL;
}
__attribute__((always_inline)) inline list_t* list_next(list_t* list)
{
    if(list->next != NULL)
    {
        return list->next;
    }
    return NULL;
}
__attribute__((always_inline)) inline u64 list_size(list_t* list)
{
    u64 i = 0;
    list_t* node = list;
    for(node = list->next; node != list; node = node->next)
    {
        i++;
    }
    return i;
}

/**
 * 内存操作，全是汇编代码写的程序
 * b表示操作最低字节，h表示操作次低字节
*/
__attribute__((always_inline)) inline void* memcpy(void* From, void* To, s64 num)
{
    s32 d0, d1, d2;
    asm volatile
    (
        "cld            \n"
        "rep movsq      \n"
        "testb $4, %b4  \n"
        "jz 1f          \n"
        "movsl          \n"
        "1:             \n"
        "testb $2, %b4  \n"
        "jz 2f          \n"
        "movsw          \n"
        "2:             \n"  
        "testb $1, %b4  \n"
        "jz 3f          \n"
        "movsb          \n"
        "3:             \n"
        : "=&c"(d0), "=&D"(d1), "=&S"(d2)
        : "0"(num / 8), "q"(num), "1"(To), "2"(From)
        : "memory"
    );
    return To;
}
__attribute__((always_inline)) inline void* memset(void *address, u8 c, s64 count)
{
    u8* tmp = (u8*)address;
    for(u32 i = 0; i < count; ++i, ++tmp)
    {
        *tmp = c;
    }
    return address;
}

/**
 * 字符串常用函数
*/
s8 *strncpy(s8 *d, s8 *s, s64 count);
s32 strlen(u8 *str);
s32 strcmp(s8* FirstPart, s8* SecondPart);
s8* strcpy(s8 * Dest, s8 * Src);
/**
 * 端口读写函数
*/
__attribute__((always_inline)) inline u8 io_in8(u16 port)
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
__attribute__((always_inline)) inline u32 io_in32(u16 port)
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
__attribute__((always_inline)) inline void io_out8(u16 port, u8 value)
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
__attribute__((always_inline)) inline void io_out32(u16 port, u32 value)
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
/**
 * 获取rsp寄存器的数据
*/
__attribute__((always_inline)) inline u64 get_rsp(void)
{
    u64 rsp;
    asm volatile
    (
        "movq %%rsp, %0 \n"
        :"=r"(rsp)
        :
        :"memory"
    );
    return rsp;
}

/**
 * wrmsr
 * rdmsr
 */
__attribute__((always_inline)) inline u64 rdmsr(u64 address)
{
    u64 r1, r2;
    asm volatile
    (
        "rdmsr          \n"
        :"=d"(r1), "=a"(r2)
        :"c"(address)
        :"memory"
    );
    return (u64)((r1 << 32) | r2);
}
__attribute__((always_inline)) inline void wrmsr(u64 address, u64 value)
{
    asm volatile
    (
        "wrmsr\n"
        :
        :"d"(value >> 32), "a"(value & 0xffffffff), "c"(address)
        :"memory"
    );
    return;
}

/**
 * cpuid
 */
void cpuid(u32 mainleaf, u32 subleaf, u32* a, u32* b, u32* c, u32* d)
{
    asm volatile
    (
        "cpuid      \n"
        : "=a"(*a), "=b"(*b), "=c"(*c), "=d"(*d)
        : "0"(mainleaf), "2"(subleaf)
        : "memory"
    );
    return;
}

/**
 * 获取flags寄存器状态
*/
__attribute__((always_inline)) inline u64 get_rflags()
{
	u64 tmp = 0;
    asm volatile
    (
        "pushfq                 \n"
        "movq 0(%%rsp), %0      \n"
        "popfq                  \n"
        : "=r"(tmp)
        :
        : "memory"
    );
	return tmp;
}

/**
 * 关于用户内存以及内核内存的函数
*/
s64 verify_area(u8* addr, u64 size);
s64 copy_from_user(void* from, void* to, u64 size);
s64 copy_to_user(void* from, void* to, u64 size);

s64 strncpy_from_user(void* from, void* to, u64 size);
s64 strnlen_user(void* src, u64 maxlen);

/**
 * snprintf 函数族
 */
s32 vsprintf(s8 *buf, const s8 *fmt, va_list args);
s32 sprintf(s8* buffer, const s8* fmt, ...);

/**
 * 端口读写
 */
#define port_insw(port, buffer, nr)	    \
    asm volatile                        \
    (                                   \
        "cld        \n"                 \
        "rep insw   \n"                 \
        "mfence     \n"                 \
        :                               \
        : "d"(port),"D"(buffer),"c"(nr) \
        : "memory"                      \
    )

#define port_outsw(port, buffer, nr)	\
    asm volatile                        \
    (                                   \
        "cld        \n"                 \
        "rep outsw  \n"                 \
        "mfence     \n"                 \
        :                               \
        : "d"(port),"S"(buffer),"c"(nr) \
        : "memory"                      \
    )

/** 
 * 内存读写
*/
__attribute__((always_inline)) inline u8 min8(u64 addr)
{
    return *((volatile u8 *)addr);
}

__attribute__((always_inline)) inline u16 min16(u64 addr)
{
    return *((volatile u16 *)addr);
}

__attribute__((always_inline)) inline u32 min32(u64 addr)
{
    return *((volatile u32 *)addr);
}

__attribute__((always_inline)) inline u64 min64(u64 addr)
{
    return *((volatile u64 *)addr);
}

__attribute__((always_inline)) inline void mout8(u64 addr, u8 value)
{
    *((volatile u8 *)addr) = value;
}

__attribute__((always_inline)) inline void mout16(u64 addr, u16 value)
{
    *((volatile u16 *)addr) = value;
}

__attribute__((always_inline)) inline void mout32(u64 addr, u32 value)
{
    *((volatile u32 *)addr) = value;
}

__attribute__((always_inline)) inline void mout64(u64 addr, u64 value)
{
    *((volatile u64 *)addr) = value;
}

#endif