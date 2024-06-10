#ifndef __LIB_H__
#define __LIB_H__
/**
 * 一些常用的宏定义
*/
#include <stdint.h>

#define NULL        0

#define nop()       asm volatile ("nop":::"memory")
#define hlt()       asm volatile ("hlt":::"memory")
#define sti()       asm volatile ("sti":::"memory")
#define cli()       asm volatile ("cli":::"memory")
#define io_mfence() asm volatile ("mfence":::"memory")
#define barrier()   asm volatile ("":::"memory")

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
    (type *)((uint64_t)p - (uint64_t)&(((type *)0)->type_member));    \
})
/**
 * 这个宏函数的作用是----->    n / base
 * 
*/
#define do_div(n, base)                 \
({                                      \
    int32_t res;                            \
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
struct list
{
    struct list* prev;
    struct list* next;
};
__attribute__((always_inline)) inline void list_init(struct list* list)
{
    list->prev = list;
    list->next = list;
    return;
}
__attribute__((always_inline)) inline void list_add_behind(struct list* list, struct list* newn)
{
    newn->next = list->next;
    newn->prev = list;
    newn->next->prev = newn;
    list->next = newn;
    return;
}
__attribute__((always_inline)) inline void list_add_before(struct list* list, struct list* newn)
{
    list->prev->next = newn;
    newn->prev = list->prev;
    list->prev = newn;
    newn->next = list;
    return;
}
__attribute__((always_inline)) inline void list_delete(struct list* list)
{
    list->next->prev = list->prev;
    list->prev->next = list->next;
    return;
}
__attribute__((always_inline)) inline int64_t list_is_empty(struct list* list)
{
    if(list->next == list && list->prev == list)
    {
        return 1;
    }
    return 0;
}
__attribute__((always_inline)) inline struct list* list_prev(struct list* list)
{
    if(list->prev != NULL)
    {
        return list->prev;
    }
    return NULL;
}
__attribute__((always_inline)) inline struct list* list_next(struct list* list)
{
    if(list->next != NULL)
    {
        return list->next;
    }
    return NULL;
}
/**
 * 内存操作，全是汇编代码写的程序
 * b表示操作最低字节，h表示操作次低字节
*/
__attribute__((always_inline)) inline void* memcpy(void* From, void* To, int64_t num)
{
    int32_t d0, d1, d2;
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
__attribute__((always_inline)) inline void* memset(void *address, uint8_t c, int64_t count)
{
    uint8_t* tmp = (uint8_t*)address;
    for(uint32_t i = 0; i < count; ++i, ++tmp)
    {
        *tmp = c;
    }
    return address;
}

/**
 * 字符串常用函数
*/
int8_t *strncpy(int8_t *d, int8_t *s, int64_t count)
{
    asm volatile
    (
        "cld                \n"
        "1:                 \n"
        "decq %2            \n"
        "js 2f              \n"
        "lodsb              \n"
        "stosb              \n"
        "testb %%al, %%al   \n"
        "jne 1b             \n"
        "rep                \n"
        "stosb              \n"
        "2:                 \n"
        :
        : "S"(s), "D"(d), "c"(count)
        : "memory"
    );
    return d;
}
int32_t strlen(uint8_t *S)
{
    int res = 0;
    for(res = 0; S[res] != '\0'; res++);
    return res;
}
int32_t strcmp(int8_t* FirstPart, int8_t* SecondPart)
{
	register int32_t res;
	asm	volatile
    (	
        "cld	                \n"
		"1:	                    \n"
		"lodsb	                \n"
		"scasb	                \n"
		"jne	2f	            \n"
		"testb	%%al,	%%al	\n"
		"jne	1b	            \n"
		"xorl	%%eax,	%%eax	\n"
		"jmp	3f	            \n"
		"2:	                    \n"
        "movl	$1,	%%eax	    \n"
		"jl	3f	                \n"
		"negl	%%eax	        \n"
		"3:	                    \n"
		: "=a"(res)
		: "D"(FirstPart),"S"(SecondPart)
		: "memory"					
	);
	return res;
}
/**
 * 端口读写函数
*/
__attribute__((always_inline)) inline uint8_t io_in8(uint16_t port)
{
    uint8_t ret = 0;
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
__attribute__((always_inline)) inline uint32_t io_in32(uint16_t port)
{
    uint32_t ret = 0;
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
__attribute__((always_inline)) inline void io_out8(uint16_t port, uint8_t value)
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
__attribute__((always_inline)) inline void io_out32(uint16_t port, uint32_t value)
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
__attribute__((always_inline)) inline uint64_t get_rsp(void)
{
    uint64_t rsp;
    asm volatile
    (
        "movq %%rsp, %0 \n"
        :"=r"(rsp)
        :
        :"memory"
    );
    return rsp;
}
__attribute__((always_inline)) inline uint64_t rdmsr(uint64_t address)
{
    uint64_t r1, r2;
    asm volatile
    (
        "rdmsr          \n"
        :"=d"(r1), "=a"(r2)
        :"c"(address)
        :"memory"
    );
    return (uint64_t)((r1 << 32) | r2);
}
__attribute__((always_inline)) inline void wrmsr(uint64_t address, uint64_t value)
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
void cpuid(uint32_t mainleaf, uint32_t subleaf, uint32_t* a, uint32_t* b, uint32_t* c, uint32_t* d)
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
uint64_t get_rflags()
{
	uint64_t tmp = 0;
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
int64_t verify_area(uint8_t* addr, uint64_t size)
{
	if(((uint64_t)addr + size) <= (uint64_t)0x00007fffffffffff)
	{
        return 1;
    }
	return 0;
}
int64_t copy_from_user(void* from, void* to, uint64_t size)
{
	uint64_t d0,d1;
	if(!verify_area((uint8_t*)from, size))
	{
        return 0;
    }
	asm volatile
    (
        "rep	        \n"
		"movsq	        \n"
		"movq	%3,	%0	\n"
		"rep	        \n"
		"movsb	        \n"
		: "=&c"(size),"=&D"(d0),"=&S"(d1)
		: "r"(size & 7),"0"(size / 8),"1"(to),"2"(from)
		: "memory"
	);
	return size;
}
int64_t copy_to_user(void* from, void* to, uint64_t size)
{
	uint64_t d0,d1;
	if(!verify_area((uint8_t*)to, size))
	{
        return 0;
    }
	asm volatile
    (
        "rep	        \n"
		"movsq	        \n"
		"movq	%3,	%0	\n"
		"rep	        \n"
		"movsb	        \n"
		: "=&c"(size),"=&D"(d0),"=&S"(d1)
		: "r"(size & 7),"0"(size / 8),"1"(to),"2"(from)
		: "memory"
	);
	return size;
}

int64_t strncpy_from_user(void* from, void* to, uint64_t size)
{
	if(!verify_area((uint8_t*)from,size))
	{
        return 0;
    }
	strncpy((int8_t*)to, (int8_t*)from, size);
	return	size;
}
int64_t strnlen_user(void* src, uint64_t maxlen)
{
	uint64_t size = strlen(src);
	if(!verify_area(src, size))
	{
        return 0;
    }
	return size <= maxlen ? size : maxlen;
}
uint8_t * strcpy(char * Dest,char * Src)
{
	asm	volatile
    (	"cld	                \n\t"
		"1:	                    \n\t"
		"lodsb	                \n\t"
		"stosb	                \n\t"
		"testb %%al, %%al	    \n\t"
		"jne 1b	                \n\t"
		:
		:"S"(Src),"D"(Dest)
		:"ax","memory"
	);
	return 	Dest;
}
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
__attribute__((always_inline)) inline uint8_t min8(uint64_t addr)
{
    return *((volatile uint8_t *)addr);
}

__attribute__((always_inline)) inline uint16_t min16(uint64_t addr)
{
    return *((volatile uint16_t *)addr);
}

__attribute__((always_inline)) inline uint32_t min32(uint64_t addr)
{
    return *((volatile uint32_t *)addr);
}

__attribute__((always_inline)) inline uint64_t min64(uint64_t addr)
{
    return *((volatile uint64_t *)addr);
}

__attribute__((always_inline)) inline void mout8(uint64_t addr, uint8_t value)
{
    *((volatile uint8_t *)addr) = value;
}

__attribute__((always_inline)) inline void mout16(uint64_t addr, uint16_t value)
{
    *((volatile uint16_t *)addr) = value;
}

__attribute__((always_inline)) inline void mout32(uint64_t addr, uint32_t value)
{
    *((volatile uint32_t *)addr) = value;
}

__attribute__((always_inline)) inline void mout64(uint64_t addr, uint64_t value)
{
    *((volatile uint64_t *)addr) = value;
}

#endif