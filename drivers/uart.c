#include <drivers/uart.h>
#include <io.h>

static void uart_disable(u64 uart_base)
{
    u32 uart_cr = readl(UART_CR(uart_base));
    writel((uart_cr) & (~1), UART_CR(uart_base));
    return;
}

static void uart_enable(u64 uart_base)
{
    u32 uart_cr = readl(UART_CR(uart_base));
    writel((uart_cr) | 1, UART_CR(uart_base));
    return;
}

static void uart_set_baudrate(u64 uart_base, u32 baud)
{
    u32 ibd = UART_CLK / 16 / UART_BAUD;
    writel(ibd, UART_IBRD(uart_base));

    u32 fbd = ((48000000.0 / 16 / baud) - ibd) * 64 + 0.5;
    writel(fbd, UART_FBRD(uart_base));
    
    return;
}

static void uart_tx_enable(u64 uart_base)
{
    u32 uart_cr = readl(UART_CR(uart_base));
    writel((uart_cr) | (1 << 8), UART_CR(uart_base));
    return;
}

static void uart_tx_disable(u64 uart_base)
{
    u32 uart_cr = readl(UART_CR(uart_base));
    writel((uart_cr) & ~(1 << 8), UART_CR(uart_base));
    return;
}

static void uart_rx_enable(u64 uart_base)
{
    u32 uart_cr = readl(UART_CR(uart_base));
    writel((uart_cr) | (1 << 9), UART_CR(uart_base));
    return;
}

static void uart_rx_disable(u64 uart_base)
{
    u32 uart_cr = readl(UART_CR(uart_base));
    writel((uart_cr) & ~(1 << 9), UART_CR(uart_base));
    return;
}

static void uart_fifo_enable(u64 uart_base, u32 length_mode)
{
    u32 uart_lcrh = readl(UART_LCRH(uart_base));
    // clear length mode
    writel((uart_lcrh) & ~(3 << 5), UART_LCRH(uart_base));
    // set length mode
    writel((uart_lcrh) | (length_mode << 5), UART_LCRH(uart_base));
    // enable fifo
    writel((uart_lcrh) | (1 << 4), UART_LCRH(uart_base));
    return;
}

static void uart_fifo_disable(u64 uart_base)
{
    u32 uart_lcrh = readl(UART_LCRH(uart_base));
    // disable fifo
    writel((uart_lcrh) & (~(1 << 4)), UART_LCRH(uart_base));
    return;
}

static void uart_irq_disable(u64 uart_base)
{
    u32 uart_imsc = readl(UART_IMSC(uart_base));
    writel(0, UART_IMSC(uart_base));
    return;
}

static void uart_irq_enable(u64 uart_base, u32 type)
{
    // null
    return;
}

void uart_send(u8 c)
{
	/* wait for transmit FIFO to have an available slot*/
	while (readl(UART_FR(UART0_BASE)) & (1 << 5))
    {
        ;
    }
	writel(c, UART_DATA(UART0_BASE));
}

u8 uart_recv(void)
{
	/* wait for receive FIFO to have data to read */
	while (readl(UART_FR(UART0_BASE)) & (1 << 4))
	{
        ;
    }
	return(readl(UART_DATA(UART0_BASE)) & 0xFF);
}

void uart_send_string(u8 *str)
{
	for (int i = 0; str[i] != '\0'; i++)
	{
        if(str[i] == '\n')
        {
            uart_send((u8)'\r');
        }
        uart_send((u8)str[i]);
    }
}

void uart_init(u64 uart_base)
{
    uart_disable(uart_base);
    uart_set_baudrate(uart_base, 115200);

    uart_irq_disable(uart_base);

    // 8 bits fifo
    uart_fifo_enable(uart_base, 0x3);
    uart_tx_enable(uart_base);
    uart_rx_enable(uart_base);
    uart_enable(uart_base);
    return;
}