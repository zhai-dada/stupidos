#include <serial.h>
#include <lib.h>
#include <printk.h>
#include <apic.h>
#include <interrupt.h>
#include <spinlock.h>

spinlock_t serial_lock;

void serial_send(u8 font)
{
    while ((io_in8(COM1_BASE + LSR) & 0x20) != 0x20);
    {
        io_out8(COM1_BASE + THR, font);
    }
    return;
}
s32 serial_recv(u8 *font)
{
    while ((io_in8(COM1_BASE + LSR) & 0x01) != 0x01);
    {
        *font = io_in8(COM1_BASE + RBR);
    }
    return 0;
}
void serial_putchar(u8 font)
{
    if (font == '\n')
    {
        serial_send('\r');
    }
    serial_send(font);
    return;
}
void serial_string(s8 *str)
{
    s32 i = 0;
    if (str != NULL)
    {
        while (str[i] != '\0')
        {
            serial_putchar(str[i]);
            i++;
        }
    }
    return;
}

s32 serial_printf(s8* front, s8* back, const s8* fmt, ...)
{
    s8 buffer[512] = {0};
    u64 flags = 0;
    s32 i = 0;

	va_list args;
	va_start(args, fmt);
	i = vsprintf(buffer, fmt, args);
	va_end(args);

    local_irq_save(flags);
    spinlock_lock(&serial_lock);

    serial_string(front);
    serial_string(back);
    serial_string(buffer);
    serial_string(SERIAL_ATTR_RESET);

    spinlock_unlock(&serial_lock);
    local_irq_restore(flags);

    return i;
}

// 只是简单显示，不做处理
void serial_interrupt_handler()
{
    // 检查是否有数据可读
    while (io_in8(COM1_BASE + LSR) & 0x01)
    {
        s8 c = io_in8(COM1_BASE + RBR); // 读取接收缓冲区
        // 简单回显，或者存储到缓冲区
        if (c == 0x7f)
        {
            serial_string("\b \b");
        }
        else if (c == '\r')
        {
            serial_string("\n");
        }
        else
        {
            serial_putchar(c);
        }
    }
    // 发送EOI到APIC
    EOI();
}

irq_controller serial_controller =
    {
        .enable = ioapic_enable,
        .disable = ioapic_disable,
        .install = ioapic_install,
        .uninstall = ioapic_uninstall,
        .ack = ioapic_edge_ack,
};

void serial_irq_en()
{
    // 启用中断：接收缓冲区中断
    io_out8(COM1_BASE + IER, 0x01);

    struct IOAPIC_RET_ENTRY entry;
    entry.vector_num = 0x24;
    entry.deliver_mode = IOAPIC_FIXED;
    entry.dest_mode = IOAPIC_DEST_MODE_PHYSICAL;
    entry.deliver_status = IOAPIC_DELI_STATUS_IDLE;
    entry.irr = IOAPIC_IRR_RESET;
    entry.trigger = IOAPIC_TRIGGER_EDGE;
    entry.polarity = IOAPIC_POLARITY_HIGH;
    entry.mask = IOAPIC_MASK_MASKED;
    entry.reserved = 0;
    entry.destination.physical.reserved1 = 0;
    entry.destination.physical.reserved2 = 0;
    entry.destination.physical.phy_dest = 0;
    register_irq(0x24, &entry, &serial_interrupt_handler, NULL, &serial_controller, "serial");
}

void serial_init()
{
    // 禁用中断
    io_out8(COM1_BASE + IER, 0x00);

    // 配置波特率为115200 (DIV = 1)
    io_out8(COM1_BASE + LCR, 0x80);     // 使能DLAB
    io_out8(COM1_BASE + DLR, 0x01);     // 除数低字节
    io_out8(COM1_BASE + DHR, 0x00);     // 除数高字节

    // 配置8N1: 8位数据，无校验，1停止位
    io_out8(COM1_BASE + LCR, 0x03);

    // 启用FIFO，清空接收和发送队列
    io_out8(COM1_BASE + FCR, 0x07);

    // 禁用中断
    io_out8(COM1_BASE + IER, 0x00);

    // 设置DTR、RTS和OUT2
    io_out8(COM1_BASE + MCR, 0x0B);

    spinlock_init(&serial_lock);
    return;
}