#include <mm/mm.h>
#include <drivers/uart.h>

s32 kernel_main(void)
{
    uart_init(UART0_BASE);
    uart_send_string((u8*)"hello stupidos\n");
    
    while(1)
    {
        uart_send(uart_recv());
    }
    return 0;
}