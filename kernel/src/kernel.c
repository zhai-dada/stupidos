#include <lib/string.h>
#include <driver/serial.h>
#include <driver/vbe.h>
#include <uefi.h>
#include <gate.h>
#include <trap.h>
#include <task.h>
#include <cpu.h>
#include <assert.h>
#include <mm/memory.h>
#include <mm/kmem.h>

extern u64* _start;
int kernel(void)
{
    char a[512] = {0};
    memcpy(a, "Hello\n", 7);
    serial_init();
    vbe_init();
    serial_printf(SFGREEN, SBBLACK, "%s\n", a);
    color_printk(YELLOW, BLACK, "%s\n", a);

    set_tss_descriptor(10, (void *)&tss[0]); // tss 0 
    load_tr(10);

    sys_vector_init();
    
    get_cpuinfo();
    mm_init();
    kmem_init();
    void* tmp = kmalloc(32, 0);
    serial_printf(SFGREEN, SBBLACK, "%p\n", tmp);
    tmp = kmalloc(32, 0);
    serial_printf(SFGREEN, SBBLACK, "%p\n", tmp);
    tmp = kmalloc(32, 0);
    serial_printf(SFGREEN, SBBLACK, "%p\n", tmp);
    kfree(tmp);
    serial_printf(SFGREEN, SBBLACK, "%p\n", tmp);

    assert(1 > 0);
    assert(0 > 1);
    while (1)
    {
        ;
    }
    return SOK;
}