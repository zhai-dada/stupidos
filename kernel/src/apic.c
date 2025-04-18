#include <apic.h>

ioapic_mm_map_t ioapic_mm_map = {0};

static void local_apic_init()
{
    u64 x = 0;
    u64 y = 0;

    // 置位IA32_APIC_BASE bit 10 11开启local apic工作模式
    asm volatile
    (
        "movq $0x1b, %%rcx\n"
        "rdmsr\n"
        "bts $10, %%rax\n"
        "bts $11, %%rax\n"
        "wrmsr\n"
        :"=a"(x), "=d"(y)
        :
        :"memory"
    );
    // 置位SVR bit 8 开启local apic
    // 置位SVR bit 12 禁止广播EOI消息功能
    asm volatile
    (
        "movq $0x80f, %%rcx\n"
        "rdmsr\n"
        "bts $8, %%rax\n"
        "bts $12, %%rax\n"
        "wrmsr\n"
        :"=a"(x), "=d"(y)
        :
        :"memory"
    );
    // apic id
    asm volatile
    (
        "movq $0x802, %%rcx\n"
        "rdmsr\n"
        :"=a"(x), "=d"(y)
        :
        :"memory"
    );
    // apic version
    asm volatile
    (
        "movq $0x803, %%rcx\n"
        "rdmsr\n"
        :"=a"(x), "=d"(y)
        :
        :"memory"
    );

    #ifndef QEMU
    // 禁用LVT中断投递
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
    // 清除ESR 错误状态寄存器
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

void ioapic_rte_write(u8 index, u64 value)
{
    *ioapic_mm_map.virtual_index_address = index;
    io_mfence();
    *ioapic_mm_map.virtual_data_address = value & 0xffffffff;
    value = value >> 32;
    io_mfence();
    *ioapic_mm_map.virtual_index_address = index + 1;
    io_mfence();
    *ioapic_mm_map.virtual_data_address = value & 0xffffffff;
    io_mfence();
    return;
}

u64 ioapic_rte_read(u8 index)
{
    u64 ret = 0;
    *ioapic_mm_map.virtual_index_address = index + 1;
    io_mfence();
    ret = *ioapic_mm_map.virtual_data_address;
    ret = ret << 32;
    io_mfence();
    *ioapic_mm_map.virtual_index_address = index;
    io_mfence();
    ret = ret | *ioapic_mm_map.virtual_data_address;
    io_mfence();
    return ret;
}

static void ioapic_init()
{
    u64 test = 0;
    u32 i = 0;
    *ioapic_mm_map.virtual_index_address = 0x00;
    io_mfence();
    *ioapic_mm_map.virtual_data_address = 0x0f000000;// 在使用IOAPIC之前，处理器必须给IOAPICID寄存器写入正确的ID，并且保证该ID在APIC总线上唯一
    io_mfence();
    u16 ioapic_id = ((*ioapic_mm_map.virtual_data_address) >> 24) & 0xff;
	io_mfence();
	*ioapic_mm_map.virtual_index_address = 0x01;
	io_mfence();
    u32 ioapic_rtenum = (((*ioapic_mm_map.virtual_data_address) >> 16) & 0xff) + 1;
    u8 apic_version = ((*ioapic_mm_map.virtual_data_address) >> 0) & 0xf;

    serial_printf(SFCYAN, SBBLACK, "ioapic id : %#x rte num : %d apic version : %#x\n", ioapic_id, ioapic_rtenum, apic_version);

    for(i = 0x10; i < 0x10 + ioapic_rtenum; i = i + 2) // 我qemu模拟的RTE的数量
	{
        ioapic_rte_write(i, 0x10020 + ((i - 0x10) >> 1)); // 屏蔽中断
    }
    return;
}

void apic_ioapic_init(void)
{
    u32 x = 0;
    u16* p = NULL;

    // init 8259a master
    port_out8(0x20, 0x11);
    port_out8(0x21, 0x20);
    port_out8(0x21, 0x04);
    port_out8(0x21, 0x01);
    // 8259a slave
    port_out8(0xa0, 0x11);
    port_out8(0xa1, 0x28);
    port_out8(0xa1, 0x02);
    port_out8(0xa1, 0x01);
    // 屏蔽8259a 中断
    port_out8(0x21, 0xff);
    port_out8(0xa1, 0xff);

    // remap
    ioapic_mm_map.physical_address = 0x0fec00000;
    ioapic_mm_map.virtual_index_address = (u8*)P_TO_V(ioapic_mm_map.physical_address);
    ioapic_mm_map.virtual_data_address = (u32*)((u64)ioapic_mm_map.virtual_index_address + 0x10);
    ioapic_mm_map.virtual_eoi_address = (u32*)((u64)ioapic_mm_map.virtual_index_address + 0x40);
    buffer_remap(ioapic_mm_map.physical_address, PAGE_2M_SIZE);

    // 填充中断idt  外设统一使用ist2作为栈
    for(u32 i = 0x20; i < 0x38; ++i)
    {
        set_intr_gate(i, 2, interrupt[i - 0x20]);
    }

    // 初始化
    local_apic_init();
    ioapic_init();
    io_mfence();

    // 清零
    memset(interrupt_desc, 0, sizeof(irq_desc_t) * IRQ_NR);

    io_mfence();
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
	ioapic_rte_write((irq - 0x20) * 2 + 0x10, 0x10000UL);
    return;
}

u64 ioapic_install(u64 irq, void * arg)
{
    ioapic_ret_entry_t *entry = (ioapic_ret_entry_t *)arg;
	ioapic_rte_write((irq - 0x20) * 2 + 0x10, *(u64 *)entry);
	return SOK;
}

void ioapic_level_ack(u64 irq)
{
    apic_eoi();				
	*ioapic_mm_map.virtual_eoi_address = irq;
    return;
}

void ioapic_edge_ack(u64 irq)
{
    apic_eoi();
    return;
}

void do_irq(stackregs_t* regs, u64 nr)
{
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
        default:
        {
            serial_printf(SFRED, SBBLACK, "irq:%d\n", nr);
            break;
        }
    }
    return;
}