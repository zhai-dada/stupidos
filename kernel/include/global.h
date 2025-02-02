#include <memory.h>
#include <task.h>
#include <stdint.h>
#include <apic.h>
#include <printk.h>
#include <lib.h>
#include <stdio.h>
#include <assert.h>
#include <vfs/vfs.h>
#include <vfs/fat32.h>
#include <uefi.h>
#include <smp/cpu.h>
#include <smp/smp.h>
#include <hpet.h>
#include <time.h>
#include <softirq.h>
#include <semaphore.h>
#include <gate.h>
#include <schedule.h>
#include <disk/disk.h>
#include <trap.h>
#include <keyboard.h>
#include <interrupt.h>
#include <pci/pci.h>
#include <e1000.h>
#include <serial.h>
#include <debug.h>

extern s8 _text, _etext;
extern s8 _data, _edata;
extern s8 _end, _bss;
extern s8 _erodata;

extern s64 global_pid;
extern spinlock_t smp_lock;

struct mm_descriptor mem_structure = {{0}, 0};
void *tmp = NULL;
struct slab *slab = NULL;
s32 global_i = 0;

struct KERNEL_BOOT_INFORMATION *boot_info = (struct KERNEL_BOOT_INFORMATION *)0xffff800000060000;
