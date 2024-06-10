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

extern int8_t _text, _etext;
extern int8_t _data, _edata;
extern int8_t _end, _bss;
extern int8_t _erodata;

extern int64_t global_pid;
extern spinlock_t smp_lock;

struct mm_descriptor mem_structure = {{0}, 0};
void *tmp = NULL;
struct slab *slab = NULL;
int32_t global_i = 0;

struct KERNEL_BOOT_INFORMATION *boot_info = (struct KERNEL_BOOT_INFORMATION *)0xffff800000060000;

