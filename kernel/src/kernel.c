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

extern u64 _text, _etext;
extern u64 _data, _edata;
extern u64 _rodata, _erodata;
extern u64 _bss, _ebss;
extern u64 _end;

int kernel(void)
{
    memset((void *)&_erodata, 0, (u64)&_end - (u64)&_erodata);

    serial_init();
    vbe_init();

    set_tss_descriptor(10, (void *)&tss[0]); // tss 0 
    load_tr(10);

    sys_vector_init();

    get_cpuinfo();

    mm_init();
    kmem_init();
    vbe_buffer_init();

    while (1)
    {
        ;
    }
    return SOK;
}