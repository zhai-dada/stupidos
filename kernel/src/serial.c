#include "serial.h"
#include "lib.h"
#include <printk.h>

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
void serial_init()
{
    unsigned char value = 0;

    // io_out8(COM1 + INTERRUPT_ENABLE_REG,0x02);
    // value = io_in8(COM1 + INTERRUPT_ENABLE_REG);
    // color_printk(WHITE,BLACK,"Serial 1 send:%x\n",value);

    // io_out8(COM2 + INTERRUPT_ENABLE_REG,0x02);
    // value = io_in8(COM2 + INTERRUPT_ENABLE_REG);
    // color_printk(WHITE,BLACK,"Serial 2 send:%x\n",value);

    // io_out8(COM3 + INTERRUPT_ENABLE_REG,0x02);
    // value = io_in8(COM3 + INTERRUPT_ENABLE_REG);
    // color_printk(WHITE,BLACK,"Serial 3 send:%x\n",value);

    // io_out8(COM4 + INTERRUPT_ENABLE_REG,0x02);
    // value = io_in8(COM4 + INTERRUPT_ENABLE_REG);
    // color_printk(WHITE,BLACK,"Serial 4 send:%x\n",value);

    /// 8bit,1stop,No Parity,Break signal Disabled
    /// DLAB=1
    io_out8(COM1 + LINE_CONTROL_REG, 0x83);

    /// set Baud rate 115200
    io_out8(COM1 + DIVISOR_LATCH_HIGH_REG, 0x00);
    io_out8(COM1 + DIVISOR_LATCH_LOW_REG, 0x01);

    /// 8bit,1stop,No Parity,Break signal Disabled
    /// DLAB=0
    io_out8(COM1 + LINE_CONTROL_REG, 0x03);

    /// disable ALL interrupt
    io_out8(COM1 + INTERRUPT_ENABLE_REG, 0x00);

    /// enable FIFO,clear receive FIFO,Clear transmit FIFO
    /// enable 64Byte FIFO,receive FIFO interrupt trigger level
    io_out8(COM1 + FIFO_CONTROL_REG, 0xe7);

    io_out8(COM1 + MODEM_CONTROL_REG, 0x00);
    io_out8(COM1 + SCRATCH_REG, 0x00);
    char test;
    serial_recv(&test);
    serial_send(test);
    serial_string("Hello World!\n");
    serial_string("Hello World!");
}
