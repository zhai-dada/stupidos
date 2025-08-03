#include <mm/mm.h>
#include <drivers/uart.h>
#include <printk.h>
#include <asm.h>

typedef u8 eth_addr_t[6]; // MAC
typedef u8 ip_addr_t[4];

s8 buffer[512];
eth_addr_t mac;
ip_addr_t ip;

s32 kernel_main(void)
{
    uart_init(UART0_BASE);
    uart_send_string((u8 *)"[test uart_pl01\t] : hello stupidos\n");

    sprintf(buffer, "[test sprintf\t] : Hello %s %#018lx\n", "str", 0x55aa55aa);
    mac[0] = 0x55;
    mac[1] = 0xaa;
    ip[0] = 192;
    ip[1] = 168;
    ip[2] = 1;
    ip[3] = 0;
    printk("[test printk\t] : hello %#p %d %x %#018lx %m %b %r\n", buffer, 10, 0xff, 0x55aa55aa, mac, 0x5a, ip);

    u64 cval = read_sysreg(CurrentEL);
    printk("[current EL\t] : current el is %d\n", cval >> 2);

    while (1)
    {
        uart_putchar(uart_getchar());
    }
    return 0;
}