#ifndef __MEMORY_H__
#define __MEMORY_H__

#include <stdint.h>
#include <lib/asm.h>
#include <lib/libio.h>
#include <lib/list.h>
#include <lib/string.h>

extern u64* cr3;

#define BUFFER_1M_SIZE  0x100000
#define COUNT_PER_PAGE  512

#define PAGE_OFFSET         ((u64)0xffff800000000000)

#define PAGE_GDT_SHIFT  39
#define PAGE_1G_SHIFT   30
#define PAGE_2M_SHIFT	21
#define PAGE_4K_SHIFT	12

#define PAGE_1G_SIZE        (1UL << PAGE_1G_SHIFT)
#define PAGE_2M_SIZE        (1UL << PAGE_2M_SHIFT)
#define PAGE_4K_SIZE        (1UL << PAGE_4K_SHIFT)

#define PAGE_1G_MASK        (~(PAGE_1G_SIZE - 1))
#define PAGE_2M_MASK        (~(PAGE_2M_SIZE - 1))
#define PAGE_4K_MASK        (~(PAGE_4K_SIZE - 1))

#define PAGE_1G_ALIGN(addr) (((u64)(addr) + PAGE_1G_SIZE - 1) & PAGE_1G_MASK)
#define PAGE_2M_ALIGN(addr) (((u64)(addr) + PAGE_2M_SIZE - 1) & PAGE_2M_MASK)
#define PAGE_4K_ALIGN(addr) (((u64)(addr) + PAGE_4K_SIZE - 1) & PAGE_4K_MASK)

#define V_TO_P(addr)        ((u64)(addr) - PAGE_OFFSET)
#define P_TO_V(addr)        ((u64)(addr) + PAGE_OFFSET)

// 内存分布区域结构体
typedef struct mm_e820
{
    u64 address;       // 区域起始地址
    u64 length;        // 区域长度
    u32 type;          // 区域类型
}__attribute__((packed)) mm_e820_t;

typedef struct
{
    u64 pml4t;
} pml4t_t;
#define make_pml4t(addr, attr) ((u64)(addr) | (u64)(attr))
#define set_pml4t(pml4t_ptr, pml4t_val) (*(pml4t_ptr) = (pml4t_val))

typedef struct
{
    u64 pdpt;
} pdpt_t;
#define make_pdpt(addr, attr) ((u64)(addr) | (u64)(attr))
#define set_pdpt(pdpt_ptr, pdpt_val) (*(pdpt_ptr) = (pdpt_val))

typedef struct
{
    u64 pdt;
} pdt_t;
#define make_pdt(addr, attr) ((u64)(addr) | (u64)(attr))
#define set_pdt(pdt_ptr, pdt_val) (*(pdt_ptr) = (pdt_val))

typedef struct
{
    u64 pt;
} pt_t;
#define make_pt(addr, attr) ((u64)(addr) | (u64)(attr))
#define set_pt(pdpt_ptr, pdpt_val) (*(pt_ptr) = (pt_val))

// 定义页表项的相关属性
#define PAGE_ATTR_XD         (1UL << 63) // 执行禁止位
#define PAGE_ATTR_PAT        (1UL << 12) // 页属性表位
#define PAGE_ATTR_GLOBAL     (1UL << 8)  // 全局位
#define PAGE_ATTR_PS         (1UL << 7)  // 页面大小位
#define PAGE_ATTR_DIRTY      (1UL << 6)  // 脏位
#define PAGE_ATTR_ACCESSED   (1UL << 5)  // 访问位
#define PAGE_ATTR_PCD        (1UL << 4)  // 缓存禁止位
#define PAGE_ATTR_PWT        (1UL << 3)  // 写入穿透位
#define PAGE_ATTR_U_S        (1UL << 2)  // 用户/超级用户位
#define PAGE_ATTR_R_W        (1UL << 1)  // 读/写位
#define PAGE_ATTR_PRESENT    (1UL << 0)  // 存在位

// 内核和用户页表项的属性
#define PAGE_ATTR_KERNEL_GDT     (PAGE_ATTR_R_W | PAGE_ATTR_PRESENT)                  // 内核 GDT
#define PAGE_ATTR_KERNEL_DIR     (PAGE_ATTR_R_W | PAGE_ATTR_PRESENT)                  // 内核目录
#define PAGE_ATTR_KERNEL_PAGE    (PAGE_ATTR_PS  | PAGE_ATTR_R_W | PAGE_ATTR_PRESENT)       // 内核页面
#define PAGE_ATTR_USER_GDT       (PAGE_ATTR_U_S | PAGE_ATTR_R_W | PAGE_ATTR_PRESENT)       // 用户 GDT
#define PAGE_ATTR_USER_DIR       (PAGE_ATTR_U_S | PAGE_ATTR_R_W | PAGE_ATTR_PRESENT)       // 用户目录
#define PAGE_ATTR_USER_PAGE      (PAGE_ATTR_PS  | PAGE_ATTR_U_S | PAGE_ATTR_R_W | PAGE_ATTR_PRESENT) // 用户页面

// 页属性
#define PAGE_PT_MAPED       (1 << 0)   // 页表映射
#define PAGE_KERNEL_INIT    (1 << 1)   // 内核初始化页
#define PAGE_DEVICE         (1 << 2)   // 设备页
#define PAGE_KERNEL         (1 << 3)   // 内核页
#define PAGE_SHARED         (1 << 4)   // 共享页

struct mm_descriptor;
struct page;
struct zone;

// 内存管理描述符结构体
typedef struct mm_descriptor
{
    mm_e820_t e820[32];         // E820 内存信息
    u64 e820_length;            // E820 结构体长度
    u64* bits_map;              // 位图指针
    u64 bits_size;              // 位图大小
    u64 bits_length;            // 位图长度
    struct page* pages_struct;  // 页面结构体指针
    u64 pages_size;             // 页面结构体大小
    u64 pages_length;           // 页面结构体长度
    struct zone* zones_struct;  // 区域结构体指针
    u64 zones_size;             // 区域结构体大小
    u64 zones_length;           // 区域结构体长度
    u64 start_code, end_code;   // 内核代码段地址范围
    u64 start_data, end_data;   // 内核数据段地址范围
    u64 end_rodata;             // 只读数据段结束地址
    u64 start_brk;              // 内核堆开始地址
    u64 end_of_struct;          // 描述符结构体结束地址
} mm_des_t;
extern mm_des_t mem_structure;

// 页面结构体
typedef struct page
{
    struct zone* zone_struct;   // 所属区域结构体指针
    u64 p_address;         // 页面物理地址
    u64 attribute;         // 页面属性
    u64 reference_count;   // 页面引用计数
    u64 age;               // 页面年龄
} page_t;

// 区域结构体
typedef struct zone
{
    struct page* pages_group;   // 页面组指针
    u64 pages_length;      // 页面组长度
    u64 zone_start_address;// 区域起始地址
    u64 zone_end_address;  // 区域结束地址
    u64 zone_length;       // 区域长度
    u64 attritube;         // 区域属性
    struct mm_descriptor* gmd_struct; // 内存描述符结构体指针
    u64 page_using_count;  // 使用中的页面数量
    u64 page_free_count;   // 空闲的页面数量
    u64 total_pages_link;  // 总页面链接数量
} zone_t;




void mm_init(void);

page_t * alloc_pages(s32 zone_select, s32 number, u64 page_flags);
void free_pages(struct page* page, s32 number);

u64 page_init(page_t *page, u64 flags);
u64 set_page_attribute(page_t* page, u64 flags);
u64 get_page_attribute(page_t* page);
u64 page_clean(page_t* page);

#endif
