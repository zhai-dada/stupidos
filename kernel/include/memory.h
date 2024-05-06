#ifndef __MEMORY_H__
#define __MEMORY_H__

#include <stdint.h>
#include <lib.h>


extern uint64_t* cr3;

#define COUNT_PER_PAGE  512

#define PAGE_OFFSET         ((uint64_t)0xffff800000000000)
#define PAGE_GDT_SHIFT  39
#define PAGE_1G_SHIFT   30
#define PAGE_2M_SHIFT	21
#define PAGE_4K_SHIFT	12

#define PAGE_2M_SIZE        (1UL << PAGE_2M_SHIFT)
#define PAGE_4K_SIZE        (1UL << PAGE_4K_SHIFT)

#define PAGE_2M_MASK        (~(PAGE_2M_SIZE - 1))
#define PAGE_4K_MASK        (~(PAGE_4K_SIZE - 1))

#define PAGE_2M_ALIGN(addr) (((uint64_t)(addr) + PAGE_2M_SIZE - 1) & PAGE_2M_MASK)
#define PAGE_4K_ALIGN(addr) (((uint64_t)(addr) + PAGE_4K_SIZE - 1) & PAGE_4K_MASK)

#define V_TO_P(addr)        ((uint64_t)(addr) - PAGE_OFFSET)
#define P_TO_V(addr)        ((uint64_t)(addr) + PAGE_OFFSET)



typedef struct
{
    uint64_t pml4t;
} pml4t_t;
#define make_pml4t(addr, attr) ((uint64_t)(addr) | (uint64_t)(attr))
#define set_pml4t(pml4t_ptr, pml4t_val) (*(pml4t_ptr) = (pml4t_val))

typedef struct
{
    uint64_t pdpt;
} pdpt_t;
#define make_pdpt(addr, attr) ((uint64_t)(addr) | (uint64_t)(attr))
#define set_pdpt(pdpt_ptr, pdpt_val) (*(pdpt_ptr) = (pdpt_val))

typedef struct
{
    uint64_t pdt;
} pdt_t;
#define make_pdt(addr, attr) ((uint64_t)(addr) | (uint64_t)(attr))
#define set_pdt(pdt_ptr, pdt_val) (*(pdt_ptr) = (pdt_val))

typedef struct
{
    uint64_t pt;
} pt_t;
#define make_pt(addr, attr) ((uint64_t)(addr) | (uint64_t)(attr))
#define set_pt(pdpt_ptr, pdpt_val) (*(pt_ptr) = (pt_val))

// 定义页表项的相关属性
#define PAGE_XD         (1UL << 63) // 执行禁止位
#define PAGE_PAT        (1UL << 12) // 页属性表位
#define PAGE_GLOBAL     (1UL << 8)  // 全局位
#define PAGE_PS         (1UL << 7)  // 页面大小位
#define PAGE_DIRTY      (1UL << 6)  // 脏位
#define PAGE_ACCESSED   (1UL << 5)  // 访问位
#define PAGE_PCD        (1UL << 4)  // 缓存禁止位
#define PAGE_PWT        (1UL << 3)  // 写入穿透位
#define PAGE_U_S        (1UL << 2)  // 用户/超级用户位
#define PAGE_R_W        (1UL << 1)  // 读/写位
#define PAGE_PRESENT    (1UL << 0)  // 存在位

// 内核和用户页表项的属性
#define PAGE_KERNEL_GDT     (PAGE_R_W | PAGE_PRESENT)                  // 内核 GDT
#define PAGE_KERNEL_DIR     (PAGE_R_W | PAGE_PRESENT)                  // 内核目录
#define PAGE_KERNEL_PAGE    (PAGE_PS  | PAGE_R_W | PAGE_PRESENT)       // 内核页面
#define PAGE_USER_GDT       (PAGE_U_S | PAGE_R_W | PAGE_PRESENT)       // 用户 GDT
#define PAGE_USER_DIR       (PAGE_U_S | PAGE_R_W | PAGE_PRESENT)       // 用户目录
#define PAGE_USER_PAGE      (PAGE_PS  | PAGE_U_S | PAGE_R_W | PAGE_PRESENT) // 用户页面

// 内存分布区域结构体
struct e820_format
{
    uint64_t address;       // 区域起始地址
    uint64_t length;        // 区域长度
    uint32_t type;          // 区域类型
}__attribute__((packed));

// 内存管理描述符结构体
struct mm_descriptor
{
    struct e820_format e820[32];   // E820 内存信息
    uint64_t e820_length;           // E820 结构体长度
    uint64_t* bits_map;             // 位图指针
    uint64_t bits_size;             // 位图大小
    uint64_t bits_length;           // 位图长度
    struct page* pages_struct;      // 页面结构体指针
    uint64_t pages_size;            // 页面结构体大小
    uint64_t pages_length;          // 页面结构体长度
    struct zone* zones_struct;      // 区域结构体指针
    uint64_t zones_size;            // 区域结构体大小
    uint64_t zones_length;          // 区域结构体长度
    uint64_t start_code, end_code;  // 内核代码段地址范围
    uint64_t start_data, end_data;  // 内核数据段地址范围
    uint64_t end_rodata;            // 只读数据段结束地址
    uint64_t start_brk;             // 内核堆开始地址
    uint64_t end_of_struct;         // 描述符结构体结束地址
};

// 页面结构体
struct page
{
    struct zone* zone_struct;   // 所属区域结构体指针
    uint64_t p_address;         // 页面物理地址
    uint64_t attribute;         // 页面属性
    uint64_t reference_count;   // 页面引用计数
    uint64_t age;               // 页面年龄
};

// 区域结构体
struct zone
{
    struct page* pages_group;   // 页面组指针
    uint64_t pages_length;      // 页面组长度
    uint64_t zone_start_address;// 区域起始地址
    uint64_t zone_end_address;  // 区域结束地址
    uint64_t zone_length;       // 区域长度
    uint64_t attritube;         // 区域属性
    struct mm_descriptor* gmd_struct; // 内存描述符结构体指针
    uint64_t page_using_count;  // 使用中的页面数量
    uint64_t page_free_count;   // 空闲的页面数量
    uint64_t total_pages_link;  // 总页面链接数量
};

extern int32_t ZONE_DMA_INDEX;
extern int32_t ZONE_NORMAL_INDEX;
extern int32_t ZONE_UNMAPED_INDEX;

#define MAX_ZONES 10

extern struct mm_descriptor mem_structure;
// 区域选择
#define ZONE_DMA            (1 << 0)   // DMA区域
#define ZONE_NORMAL         (1 << 1)   // 普通区域
#define ZONE_UNMAPED        (1 << 2)   // 未映射区域

// 页属性
#define PAGE_PT_MAPED       (1 << 0)   // 页表映射
#define PAGE_KERNEL_INIT    (1 << 1)   // 内核初始化页
#define PAGE_DEVICE         (1 << 2)   // 设备页
#define PAGE_KERNEL         (1 << 3)   // 内核页
#define PAGE_SHARED         (1 << 4)   // 共享页

#define flush_tlb()                     \
    {uint64_t a;                       \
    asm volatile                        \
    (                                   \
        "movq %%cr3, %0          \n"    \
        "movq %0, %%cr3          \n"    \
        : "=r"(a)                     \
        :                               \
        : "memory"                      \
    );}

#define SIZEOF_LONG_ALIGN(size) ((size + sizeof(int64_t) - 1) & ~(sizeof(int64_t) - 1))
#define SIZEOF_INT_ALIGN(size) ((size + sizeof(int32_t) - 1) & ~(sizeof(int32_t) - 1))

#define V_TO_2M(kaddr) (mem_structure.pages_struct + (V_TO_P(kaddr) >> PAGE_2M_SHIFT))
#define P_TO_2M(kaddr) (mem_structure.pages_struct + ((uint64_t)(kaddr) >> PAGE_2M_SHIFT))

// 用于内存分配的缓存结构
struct kmem_cache
{
    uint64_t size;              // 单个对象的大小
    uint64_t total_using;       // 正在使用的对象总数
    uint64_t total_free;        // 空闲对象总数
    struct kmem* cache_pool;    // 缓存池指针
    void* (*construct)(void* vaddress, uint64_t arg); // 构造函数指针
    void* (*destruct)(void* vaddress, uint64_t arg);  // 析构函数指针
};
// kmem分配器中的kmem结构
struct kmem
{
    struct list list;           // 用于连接到kmem链表中的节点
    struct page* page;          // 所属页结构指针
    uint64_t using_count;       // 正在使用的对象计数
    uint64_t free_count;        // 空闲对象计数
    void* vaddress;             // kmem起始虚拟地址
    uint64_t color_length;      // 颜色数组长度
    uint64_t color_count;       // 颜色数量
    uint64_t* color_map;        // 颜色映射表
};


extern struct kmem_cache kmalloc_cache_size[16];

void init_memory(void);
uint64_t page_init(struct page* page, uint64_t flags);
uint64_t* get_gdt(void);
struct page* alloc_pages(int32_t zones_select, int32_t number, uint64_t flags);

uint64_t kmem_init(void);
struct kmem_cache* kmem_create(uint64_t size, void* (*construct)(void* vaddress, uint64_t arg), void* (*destruct)(void* vaddress, uint64_t arg), uint64_t arg);
void* kmalloc(uint64_t size, uint64_t flags);
uint64_t kfree(void* address);
void free_pages(struct page* page, int32_t number);
void* kmem_malloc(struct kmem_cache* kmem_cache, uint64_t arg);
uint64_t kmem_destroy(struct kmem_cache* kmem_cache);
uint64_t page_clean(struct page * page);
uint64_t kmem_free(struct kmem_cache* kmem_cache, void* address, uint64_t arg);
uint64_t get_page_attribute(struct page* page);
uint64_t set_page_attribute(struct page* page, uint64_t flags);
void pagetable_init();
uint64_t do_brk(uint64_t addr, uint64_t len);

#endif