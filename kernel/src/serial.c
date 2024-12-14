#include "serial.h"
#include "lib.h"
#include <printk.h>
#include <apic.h>
#include <interrupt.h>

#define COM1_BASE 0x3F8 // COM1基地址
#define IER 1           // 中断使能寄存器
#define FCR 2           // FIFO控制寄存器
#define LCR 3           // 线路控制寄存器
#define MCR 4           // 调制解调器控制寄存器
#define LSR 5           // 线路状态寄存器
#define RBR 0           // 接收缓冲寄存器
#define THR 0           // 发送保持寄存器

void serial_send(unsigned char font)
{
    int timeout = 100000;
    while ((io_in8(COM1 + LINE_STATUS_REG) & 0x20) != 0x20)
        if (!timeout--)
            return;

    io_out8(COM1 + TRANSMITTER_HOLDING_REG, font);
}
int serial_recv(unsigned char *font)
{
    int timeout = 100000;

    while ((io_in8(COM1 + LINE_STATUS_REG) & 0x01) != 0x01)
        if (!timeout--)
            return -1;

    *font = io_in8(COM1 + RECEIVE_BUFFER_REG);
    return 0;
}
void serial_putchar(unsigned char font)
{
    if (font == '\n')
        serial_send('\r');
    serial_send(font);
}
void serial_string(char *str)
{
    int i = 0;
    if (str != NULL)
    {
        while (str[i] != '\0')
        {
            if (str[i] == '\n')
                serial_send('\r');
            serial_send(str[i]);
            i++;
        }
    }
}

void serial_set_color(int foreground, int background, int bold)
{
    char color[11] = {0};
    color[0] = '\x1b';
    color[1] = '[';
    color[2] = bold + 48;
    color[3] = ';';
    color[4] = foreground / 10 + 48;
    color[5] = foreground % 10 + 48;
    color[6] = ';';
    color[7] = (background + 10) / 10 + 48;
    color[8] = (background + 10) % 10 + 48;
    color[9] = 'm';
    color[10] = '\0';
    serial_string(color);
}
// 重置颜色
void serial_reset_color()
{
    serial_string("\x1b[0m");
}

// 示例：打印带颜色的文本
void serial_test()
{
    serial_set_color(31, 40, 0); // 红色前景，黑色背景
    serial_string("Hello, Red Text\n");
    serial_reset_color();

    serial_set_color(32, 40, 0); // 绿色前景，黑色背景
    serial_string("Hello, Green Text\n");
    serial_reset_color();

    serial_set_color(33, 40, 0); // 黄色前景，黑色背景
    serial_string("Hello, Yellow Text\n");
    serial_reset_color();
}
void serial_clear_line()
{
    serial_string("\x1b[1A");  // 清除当前行内容
    serial_string("\r");      // 回到行首
}
void serial_interrupt_handler()
{
    // 检查是否有数据可读
    while (io_in8(COM1_BASE + LSR) & 0x01)
    {
        char c = io_in8(COM1_BASE + RBR); // 读取接收缓冲区
        // 简单回显，或者存储到缓冲区
        color_printk(YELLOW, BLACK, "int serial recv char %x\n", c);
        if (c == 0x7f)
        {
            serial_string("\b \b");
        }
        else if (c == '\r')
        {
            serial_string("\n");
        }
        else if(c == 0x7e)
        {
            serial_clear_line();
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
void serial_init()
{
    // 禁用中断
    io_out8(COM1_BASE + IER, 0x00);

    // 配置波特率为115200 (DIV = 1)
    io_out8(COM1_BASE + LCR, 0x80); // 使能DLAB
    io_out8(COM1_BASE + 0, 0x01);   // 除数低字节
    io_out8(COM1_BASE + 1, 0x00);   // 除数高字节

    // 配置8N1: 8位数据，无校验，1停止位
    io_out8(COM1_BASE + LCR, 0x03);

    // 启用FIFO，清空接收和发送队列
    io_out8(COM1_BASE + FCR, 0x07);

    // 启用中断：接收缓冲区中断
    io_out8(COM1_BASE + IER, 0x01);

    // 设置DTR、RTS和OUT2
    io_out8(COM1_BASE + MCR, 0x0B);

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
    
    serial_test();
    serial_set_color(92, 40, 1);
    // serial_string("serial init ok!!!\n");
}

// void serial_init()
// {
//     unsigned char value = 0;

//     // io_out8(COM1 + INTERRUPT_ENABLE_REG,0x02);
//     // value = io_in8(COM1 + INTERRUPT_ENABLE_REG);
//     // color_printk(WHITE,BLACK,"Serial 1 send:%x\n",value);

//     // io_out8(COM2 + INTERRUPT_ENABLE_REG,0x02);
//     // value = io_in8(COM2 + INTERRUPT_ENABLE_REG);
//     // color_printk(WHITE,BLACK,"Serial 2 send:%x\n",value);

//     // io_out8(COM3 + INTERRUPT_ENABLE_REG,0x02);
//     // value = io_in8(COM3 + INTERRUPT_ENABLE_REG);
//     // color_printk(WHITE,BLACK,"Serial 3 send:%x\n",value);

//     // io_out8(COM4 + INTERRUPT_ENABLE_REG,0x02);
//     // value = io_in8(COM4 + INTERRUPT_ENABLE_REG);
//     // color_printk(WHITE,BLACK,"Serial 4 send:%x\n",value);

//     /// 8bit,1stop,No Parity,Break signal Disabled
//     /// DLAB=1
//     io_out8(COM1 + LINE_CONTROL_REG, 0x83);

//     /// set Baud rate 115200
//     io_out8(COM1 + DIVISOR_LATCH_HIGH_REG, 0x00);
//     io_out8(COM1 + DIVISOR_LATCH_LOW_REG, 0x01);

//     /// 8bit,1stop,No Parity,Break signal Disabled
//     /// DLAB=0
//     io_out8(COM1 + LINE_CONTROL_REG, 0x03);

//     /// disable ALL interrupt
//     io_out8(COM1 + INTERRUPT_ENABLE_REG, 0x00);

//     /// enable FIFO,clear receive FIFO,Clear transmit FIFO
//     /// enable 64Byte FIFO,receive FIFO interrupt trigger level
//     io_out8(COM1 + FIFO_CONTROL_REG, 0xe7);

//     io_out8(COM1 + MODEM_CONTROL_REG, 0x00);
//     io_out8(COM1 + SCRATCH_REG, 0x00);
//     char test;
//     serial_recv(&test);
//     serial_send(test);
//     serial_string("Hello World!\n");
//     serial_string("Hello World!");
// }
