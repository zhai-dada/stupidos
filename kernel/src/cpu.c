#include <debug.h>
#include <cpu.h>

u32 cpunum = 0;
u32 initial_apicid = 0;

static void cpuid(u32 mainleaf, u32 subleaf, u32* a, u32* b, u32* c, u32* d)
{
    asm volatile
    (
        "cpuid      \n"
        : "=a"(*a), "=b"(*b), "=c"(*c), "=d"(*d)
        : "0"(mainleaf), "2"(subleaf)
        : "memory"
    );
    return;
}

void get_cpuinfo(void)
{
    u32 CPU_ID[4] = {0};
    s8 CPUNAME[18] = {0};
    cpuid(0, 0, &CPU_ID[0], &CPU_ID[1], &CPU_ID[2], &CPU_ID[3]);
    *(u32*)&CPUNAME[0] = CPU_ID[1];
    *(u32*)&CPUNAME[4] = CPU_ID[3];
    *(u32*)&CPUNAME[8] = CPU_ID[2];
    CPUNAME[12] = '\0';
    printk("%s\n", CPUNAME);

    u64 i, j;
    // 0x80000002 - 0x80000004 获取处理器商标信息
    for(i = 0x80000002; i < 0x80000005; i++)
    {
        cpuid(i, 0, &CPU_ID[0], &CPU_ID[1], &CPU_ID[2], &CPU_ID[3]);
        *(u32*)&CPUNAME[0] = CPU_ID[0];
        *(u32*)&CPUNAME[4] = CPU_ID[1];
        *(u32*)&CPUNAME[8] = CPU_ID[2];
        *(u32*)&CPUNAME[12] = CPU_ID[3];
        CPUNAME[16] = '\0';
        printk("%s", CPUNAME);
    }

    printk("\n");
    cpuid(1, 0, &CPU_ID[0], &CPU_ID[1], &CPU_ID[2], &CPU_ID[3]);
    printk("Family:%x Extended Family:%x Mode:%x Extended Mode:%x CPUtype:%x StepID:%x\n", \
        ((CPU_ID[0] >> 8) & 0xf), ((CPU_ID[0] >> 20) & 0xff), ((CPU_ID[0] >> 4) & 0xf), \
        ((CPU_ID[0] >> 16) & 0xf), ((CPU_ID[0] >> 12) & 0x3), ((CPU_ID[0] >> 0) & 0xf));

    printk("cpu num : %lx init apic id : %lx\n", (CPU_ID[1] >> 16) & 0xff, (CPU_ID[1] >> 24) & 0xff);
    
    cpunum = (CPU_ID[1] >> 16) & 0xff;
    initial_apicid = (CPU_ID[1] >> 24) & 0xff;

    cpuid(0x80000008, 0, &CPU_ID[0], &CPU_ID[1], &CPU_ID[2], &CPU_ID[3]);
    printk("Physical Address Width:%d Linear Address Width:%d\n", \
        ((CPU_ID[0] >> 0) & 0xff), ((CPU_ID[0] >> 8) & 0xff));

    cpuid(0, 0, &CPU_ID[0], &CPU_ID[1], &CPU_ID[2], &CPU_ID[3]);
    printk("MAX Operator Code:%x\t", CPU_ID[0]);

    cpuid(0x80000000, 0, &CPU_ID[0], &CPU_ID[1], &CPU_ID[2], &CPU_ID[3]);
    printk("MAX EXT Operator Code:%x\n", CPU_ID[0]);

    return;
}