#ifndef __KMEM_H__
#define __KMEM_H__

#include <stdint.h>
#include <mm/memory.h>
#include <lib/list.h>

// kmem分配器中的kmem结构
typedef struct kmem
{
    list_t list;           // 用于连接到kmem链表中的节点
    page_t* page;          // 所属页结构指针
    u64 using_count;       // 正在使用的对象计数
    u64 free_count;        // 空闲对象计数
    void* vaddress;             // kmem起始虚拟地址
    u64 color_length;      // 颜色数组长度
    u64 color_count;       // 颜色数量
    u64* color_map;        // 颜色映射表
} kmem_t;


// 用于内存分配的缓存结构
typedef struct kmem_cache
{
    u64 size;              // 单个对象的大小
    u64 total_using;       // 正在使用的对象总数
    u64 total_free;        // 空闲对象总数
    kmem_t* cache_pool;    // 缓存池指针
    void* (*construct)(void* vaddress, u64 arg); // 构造函数指针
    void* (*destruct)(void* vaddress, u64 arg);  // 析构函数指针
} kmem_cache_t;

u64 kmem_init(void);

#endif
