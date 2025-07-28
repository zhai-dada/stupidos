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

    // u32 fbd = ((48000000.0 / 16 / baud) - ibd) * 64 + 0.5;
    // 换一种方式，不使用浮点计算
    u32 fbd = ((UART_CLK % (16 * baud)) * 64 + (16 * baud / 2)) / (16 * baud);
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

static void uart_send(u8 c)
{
	/* wait for transmit FIFO to have an available slot*/
	while (readl(UART_FR(UART0_BASE)) & (1 << 5))
    {
        ;
    }
	writel(c, UART_DATA(UART0_BASE));
}

static u8 uart_recv(void)
{
	/* wait for receive FIFO to have data to read */
	while (readl(UART_FR(UART0_BASE)) & (1 << 4))
	{
        ;
    }
	return(readl(UART_DATA(UART0_BASE)) & 0xFF);
}

void uart_putchar(u8 c)
{
    if(c == '\n')
    {
        uart_send('\r');
    }
    uart_send(c);
    return;
}

u8 uart_getchar(void)
{
    s8 c = uart_recv();
    if(c == '\r')
    {
        uart_putchar('\n');
    }
    return c;
}

void uart_send_string(u8 *str)
{
	for (u64 i = 0; str[i] != '\0'; i++)
	{
        uart_putchar(str[i]);
    }
    return;
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