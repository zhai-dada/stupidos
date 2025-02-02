#include <apic.h>
#include <stdint.h>
#include <printk.h>
#include <interrupt.h>
#include <memory.h>
#include <gate.h>
#include <lib.h>
#include <debug.h>

void local_apic_init()
{
    u64 x = 0;
    u64 y = 0;
    u32 a = 0;
    u32 b = 0;
    u32 c = 0;
    u32 d = 0;
    cpuid(1, 0, &a, &b, &c, &d);
    asm volatile
    (
        "movq $0x1b, %%rcx\n"
        "rdmsr\n"
        "bts $10, %%rax\n"
        "bts $11, %%rax\n"
        "wrmsr\n"
        "movq $0x1b, %%rcx\n"
        "rdmsr\n"
        :"=a"(x), "=d"(y)
        :
        :"memory"
    );
    asm volatile
    (
        "movq $0x80f, %%rcx\n"
        "rdmsr\n"
        "bts $8, %%rax\n"
        "bts $12, %%rax\n"
        "wrmsr\n"
        "movq $0x80f, %%rcx\n"
        "rdmsr\n"
        :"=a"(x), "=d"(y)
        :
        :"memory"
    );
    asm volatile
    (
        "movq $0x802, %%rcx\n"
        "rdmsr\n"
        :"=a"(x), "=d"(y)
        :
        :"memory"
    );
    asm volatile
    (
        "movq $0x803, %%rcx\n"
        "rdmsr\n"
        :"=a"(x), "=d"(y)
        :
        :"memory"
    );
    #ifndef QEMU
    asm volatile
    (
        "movq $0x82f, %%rcx\n"
        "wrmsr\n"
        "movq $0x832, %%rcx\n"
        "wrmsr\n"
        "movq $0x833, %%rcx\n"
        "wrmsr\n"
        "movq $0x834, %%rcx\n"
        "wrmsr\n"
        "movq $0x835, %%rcx\n"
        "wrmsr\n"
        "movq $0x836, %%rcx\n"
        "wrmsr\n"
        "movq $0x837, %%rcx\n"
        "wrmsr\n"
        :
        :"a"(0x10000), "d"(0x00)
        :"memory"
    );
    #endif
    asm volatile
    (
        "movq $0x808, %%rcx\n"
        "rdmsr\n"
        :"=a"(x), "=d"(y)
        :
        :"memory"
    );
    asm volatile
    (
        "movq $0x80a, %%rcx\n"
        "rdmsr\n"
        :"=a"(x), "=d"(y)
        :
        :"memory"
    );
    asm volatile
    (
        "movq $0x828, %%rcx\n"
        "wrmsr\n"
        :
        :"a"(0), "d"(0)
        :"memory"
    );
    return;
}
void apic_ioapic_init()
{
    u32 x = 0;
    u16* p = NULL;
    io_out8(0x21, 0xff);
    io_out8(0xa1, 0xff);
    ioapic_page_table_remap();
    for(u32 i = 0x20; i <= 0x38; ++i)
    {
        set_intr_gate(i, 0, interrupt[i - 0x20]);
    }
    io_out8(0x22, 0x70);
    io_out8(0x23, 0x01);
    local_apic_init();
    ioapic_init();
    io_mfence();
    memset(interrupt_desc, 0, sizeof(irq_desc_t) * IRQ_NR);
    io_mfence();
    return;
}

void ioapic_page_table_remap()
{
    u64* tmp = NULL;
    u64* virtual = NULL;
    u8* IOAPIC_addr = (u8*)P_TO_V(0x0fec00000);
    ioapic_map.physical_address = 0xfec00000;
    ioapic_map.virtual_index_address = IOAPIC_addr;
    ioapic_map.virtual_data_address = (u32*)(IOAPIC_addr + 0x10);
    ioapic_map.virtual_eoi_address = (u32*)(IOAPIC_addr + 0x40);
    cr3 = get_gdt();
	tmp = (u64*)(((u64)P_TO_V((u64)cr3 & (~0xfffUL))) + ((u64)((u64)IOAPIC_addr >> PAGE_GDT_SHIFT) & (0x1ff)) * 8);
    if(*tmp == 0)
    {
        virtual = (u64*)kmalloc(PAGE_4K_SIZE, 0);
        memset(virtual, 0, PAGE_4K_SIZE);
        set_pml4t(tmp, make_pml4t(V_TO_P(virtual), PAGE_KERNEL_GDT));
    }
	tmp = (u64*)(((u64)P_TO_V((u64)(*tmp & (~0xfffUL)) & (~0xfffUL))) + (((u64)(IOAPIC_addr) >> PAGE_1G_SHIFT) & 0x1ff) * 8);
    if(*tmp == 0)
    {
        virtual = (u64*)kmalloc(PAGE_4K_SIZE, 0);
        memset(virtual, 0, PAGE_4K_SIZE);
        set_pdpt(tmp, make_pdpt(V_TO_P(virtual), PAGE_KERNEL_DIR));
    }
	tmp = (u64*)(((u64)P_TO_V((u64)(*tmp & (~0xfffUL)) & (~0xfffUL))) + (((u64)(IOAPIC_addr) >> PAGE_2M_SHIFT) & 0x1ff) * 8);
    set_pdt(tmp, make_pdt(ioapic_map.physical_address, PAGE_KERNEL_PAGE | PAGE_PWT | PAGE_PCD));
    flush_tlb();
    return;
}
u64 ioapic_rte_read(u8 index)
{
    u64 ret = 0;
    *ioapic_map.virtual_index_address = index + 1;
    io_mfence();
    ret = *ioapic_map.virtual_data_address;
    ret = ret << 32;
    io_mfence();
    *ioapic_map.virtual_index_address = index;
    io_mfence();
    ret = ret | *ioapic_map.virtual_data_address;
    io_mfence();
    return ret;
}
void ioapic_rte_write(u8 index, u64 value)
{
    *ioapic_map.virtual_index_address = index;
    io_mfence();
    *ioapic_map.virtual_data_address = value & 0xffffffff;
    value = value >> 32;
    io_mfence();
    *ioapic_map.virtual_index_address = index + 1;
    io_mfence();
    *ioapic_map.virtual_data_address = value & 0xffffffff;
    io_mfence();
    return;
}
void ioapic_init()
{
    u64 test = 0;
    u32 i = 0;
    *ioapic_map.virtual_index_address = 0x00;
    io_mfence();
    *ioapic_map.virtual_data_address = 0x0f000000;// 在使用IOAPIC之前，处理器必须给IOAPICID寄存器写入正确的ID，并且保证该ID在APIC总线上唯一
    io_mfence();
    u16 ioapic_id = ((*ioapic_map.virtual_data_address) >> 24) & 0xff;
	io_mfence();
	*ioapic_map.virtual_index_address = 0x01;
	io_mfence();
    u16 ioapic_rtenum = ((*ioapic_map.virtual_data_address) >> 16) & 0xff;
    u8 apic_version = ((*ioapic_map.virtual_data_address) >> 0) & 0xf;

    DBG_SERIAL(SERIAL_ATTR_FRONT_CYAN, SERIAL_ATTR_BACK_BLACK, "ioapic id : %x rte num : %x apic version : %x\n", ioapic_id, ioapic_rtenum, apic_version);

    for(i = 0x10; i < 0x10 + ioapic_rtenum; i = i + 2)
	{
        ioapic_rte_write(i, 0x10020 + ((i - 0x10) >> 1)); // 屏蔽中断
    }
    return;
}
void ioapic_enable(u64 irq)
{
	u64 value = 0;
	value = ioapic_rte_read((irq - 0x20) * 2 + 0x10);
	value = value & (~0x10000UL); 
	ioapic_rte_write((irq - 0x20) * 2 + 0x10, value);
    return;
}
void ioapic_disable(u64 irq)
{
	u64 value = 0;
	value = ioapic_rte_read((irq - 0x20) * 2 + 0x10);
	value = value | (0x10000UL); 
	ioapic_rte_write((irq - 0x20) * 2 + 0x10, value);
    return;
}
void ioapic_uninstall(u64 irq)
{
	ioapic_rte_write((irq - 32) * 2 + 0x10, 0x10000UL);
    return;
}
u64 ioapic_install(u64 irq,void * arg)
{
	struct IOAPIC_RET_ENTRY *entry = (struct IOAPIC_RET_ENTRY *)arg;
	ioapic_rte_write((irq - 32) * 2 + 0x10, *(u64 *)entry);
	return 1;
}
void ioapic_level_ack(u64 irq)
{
    EOI();				
	*ioapic_map.virtual_eoi_address = irq;
    return;
}
void ioapic_edge_ack(u64 irq)
{
    EOI();
    return;
}
void do_irq(struct stackregs* regs, u64 nr)
{
    // color_printk(RED, GREEN, "IRQ %d\t", nr);
    switch(nr & 0x80)
    {
        case 0x00:
        {
            irq_desc_t* irq = &interrupt_desc[nr - 0x20];
            if(irq->handler != NULL)
            {
                irq->handler(nr, irq->parameter, regs);
            }
            if(irq->controler != NULL && irq->controler->ack != NULL)
            {
                irq->controler->ack(nr);
            }
            break;
        }
        case 0x80:
        {
            ioapic_edge_ack(nr);
            irq_desc_t* irq = &smp_ipi_desc[nr - 200];
            if(irq->handler != NULL)
            {
                irq->handler(nr, irq->parameter, regs);
            }
            break;
        }
        default:
        {
            color_printk(RED, BLACK, "u32:%d\n", nr);
            break;
        }
    }
    return;
}