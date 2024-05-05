#ifndef __APIC_H__
#define __APIC_H__

#define QEMU

#include <stdint.h>
#include <stackregs.h>

// 交付模式
#define IOAPIC_FIXED                0 // 固定
#define IOAPIC_LOWESTPRIORITY       1 // 最低优先级
#define IOAPIC_SMI                  2 // SMI
#define IOAPIC_NMI                  4 // NMI
#define IOAPIC_INIT                 5 // INIT
#define IOAPIC_EXTINT               7 // 外部中断
#define IOAPIC_ICR_START_UP         6 // 启动

// 目的地模式
#define IOAPIC_DEST_MODE_PHYSICAL   0 // 物理
#define IOAPIC_DEST_MODE_LOGICAL    1 // 逻辑

// 交付状态
#define IOAPIC_DELI_STATUS_IDLE     0 // 空闲
#define IOAPIC_DELI_STATUS_SEND     1 // 发送
// 极性
#define IOAPIC_POLARITY_HIGH        0 // 高
#define IOAPIC_POLARITY_LOW         1 // 低
// 中断请求寄存器（IRR）
#define IOAPIC_IRR_RESET            0 // 重置
#define IOAPIC_IRR_ACCEPT           1 // 接受
// 触发
#define IOAPIC_TRIGGER_EDGE         0 // 边沿触发
#define IOAPIC_TRIGGER_LEVEL        1 // 电平触发

// 屏蔽
#define IOAPIC_MASK_MASKED          1 // 屏蔽
#define IOAPIC_MASK_UNMASK          0 // 解除屏蔽

// 缩写
#define ICR_NO_SHORTHAND		    0 // 无缩写
#define ICR_SELF		        	1 // 自身
#define ICR_ALL_INCLUDE_SELF		2 // 包括所有，包括自身
#define ICR_ALL_EXCLUDE_SELF		3 // 包括所有，不包括自身

// 电平
#define ICR_LEVEL_DE_ASSERT		    0 // 取消断言
#define ICR_LEVLE_ASSERT		    1 // 断言


#define EOI()                   \
    asm volatile                \
    (                           \
        "movq $0x00, %%rax  \n" \
        "movq $0x00, %%rdx  \n" \
        "movq $0x80b, %%rcx \n" \
        "wrmsr              \n" \
        :                       \
        :                       \
        : "memory"              \
    );
struct IOAPIC_map
{
    uint32_t physical_address;
    uint8_t* virtual_index_address;
    uint32_t* virtual_data_address;
    uint32_t* virtual_eoi_address;
}ioapic_map;

struct IOAPIC_RET_ENTRY
{
    uint32_t 
    vector_num	    :8,	    // 0~7 中断向量号
    deliver_mode	:3,	    // 8~10 交付模式
    dest_mode	    :1,	    // 11 目的地模式
    deliver_status	:1,	    // 12 交付状态
    polarity        :1,	    // 13 极性
    irr	            :1,	    // 14 IRR
    trigger	        :1,	    // 15 触发
    mask	        :1,	    // 16 屏蔽
    reserved        :15;	// 17~31 保留位
    union
    {
        struct 
        {
            uint32_t
            reserved1	:24,	// 32~55 保留位
            phy_dest	:4,	    // 56~59 物理目的地
            reserved2	:4;	    // 60~63 保留位	
        } physical;
        struct 
        {
            uint32_t
            reserved1	    :24,	// 32~55 保留位
            logical_dest	:8;	    // 56~63 逻辑目的地
        } logical;
    } destination;
} __attribute__((packed));

struct IRQ_CMD_REG
{
    uint32_t
    vector_num  	:8,	// 0~7 中断向量号
    deliver_mode	:3,	// 8~10 交付模式
    dest_mode	    :1,	// 11 目的地模式
    deliver_status	:1,	// 12 交付状态
    res_1	        :1,	// 13 保留位
    level	        :1,	// 14 电平
    trigger	        :1,	// 15 触发
    res_2	        :2,	// 16~17 保留位
    dest_shorthand	:2,	// 18~19 目的地缩写
    res_3       	:12;	// 20~31 保留位
    union 
    {
        struct
        {
            uint32_t
            res_4	    :24,	// 32~55 保留位
            dest_field	:8;	    // 56~63 目的地字段		
        } apic_destination;
        uint32_t
        x2apic_destination;	    // 32~63
    } destination;
} __attribute__((packed));


void local_apic_init(void);
void apic_ioapic_init(void);
void do_irq(struct stackregs* regs, uint64_t nr);
void ioapic_page_table_remap(void);
uint64_t ioapic_rte_read(uint8_t index);
void ioapic_rte_write(uint8_t index, uint64_t value);
void ioapic_init(void);
void ioapic_enable(uint64_t irq);
void ioapic_disable(uint64_t irq);
void ioapic_uninstall(uint64_t irq);
void ioapic_level_ack(uint64_t irq);
void ioapic_edge_ack(uint64_t irq);
uint64_t ioapic_install(uint64_t irq,void * arg);

#endif
