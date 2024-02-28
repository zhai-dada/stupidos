#include <smp/cpu.h>
#include <printk.h>

void init_cpu(void)
{
    uint32_t CPU_ID[4] = {0, 0, 0, 0};
    int8_t CPUNAME[18] = {0};
    cpuid(0, 0, &CPU_ID[0], &CPU_ID[1], &CPU_ID[2], &CPU_ID[3]);
    *(uint32_t*)&CPUNAME[0] = CPU_ID[1];
    *(uint32_t*)&CPUNAME[4] = CPU_ID[3];
    *(uint32_t*)&CPUNAME[8] = CPU_ID[2];
    CPUNAME[12] = '\0';
    color_printk(YELLOW, BLACK, "%s\n", CPUNAME);
    uint64_t i, j;
    for(i = 0x80000002; i < 0x80000005; i++)
    {
        cpuid(i, 0, &CPU_ID[0], &CPU_ID[1], &CPU_ID[2], &CPU_ID[3]);
        *(uint32_t*)&CPUNAME[0] = CPU_ID[0];
        *(uint32_t*)&CPUNAME[4] = CPU_ID[1];
        *(uint32_t*)&CPUNAME[8] = CPU_ID[2];
        *(uint32_t*)&CPUNAME[12] = CPU_ID[3];
        CPUNAME[16] = '\0';
        color_printk(YELLOW, BLACK, "%s", CPUNAME);
    }
    color_printk(YELLOW, BLACK, "\n");
    cpuid(1, 0, &CPU_ID[0], &CPU_ID[1], &CPU_ID[2], &CPU_ID[3]);
    color_printk(YELLOW, BLACK, "Family:%x Extended Family:%x Mode:%x Extended Mode:%x CPUtype:%x StepID:%x\n", ((CPU_ID[0] >> 8) & 0xf), ((CPU_ID[0] >> 20) & 0xff), ((CPU_ID[0] >> 4) & 0xf), ((CPU_ID[0] >> 16) & 0xf), ((CPU_ID[0] >> 12) & 0x3), ((CPU_ID[0] >> 0) & 0xf));
    cpuid(0x80000008, 0, &CPU_ID[0], &CPU_ID[1], &CPU_ID[2], &CPU_ID[3]);
    color_printk(YELLOW, BLACK, "Physical Address Width:%d Linear Address Width:%d\n", ((CPU_ID[0] >> 0) & 0xff), ((CPU_ID[0] >> 8) & 0xff));
    cpuid(0, 0, &CPU_ID[0], &CPU_ID[1], &CPU_ID[2], &CPU_ID[3]);
    color_printk(YELLOW, BLACK, "MAX Operator Code:%x\t", CPU_ID[0]);
    cpuid(0x80000000, 0, &CPU_ID[0], &CPU_ID[1], &CPU_ID[2], &CPU_ID[3]);
    color_printk(YELLOW, BLACK, "MAX EXT Operator Code:%x\n", CPU_ID[0]);
    return;
}