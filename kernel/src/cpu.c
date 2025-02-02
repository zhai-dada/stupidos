#include <smp/cpu.h>
#include <printk.h>
#include <debug.h>

void get_cpuinfo(void)
{
    u32 CPU_ID[4] = {0, 0, 0, 0};
    s8 CPUNAME[18] = {0};
    cpuid(0, 0, &CPU_ID[0], &CPU_ID[1], &CPU_ID[2], &CPU_ID[3]);
    *(u32*)&CPUNAME[0] = CPU_ID[1];
    *(u32*)&CPUNAME[4] = CPU_ID[3];
    *(u32*)&CPUNAME[8] = CPU_ID[2];
    CPUNAME[12] = '\0';
    DBG_SERIAL(SERIAL_ATTR_FRONT_YELLOW, SERIAL_ATTR_BACK_BLACK, "%s\n", CPUNAME);
    u64 i, j;
    for(i = 0x80000002; i < 0x80000005; i++)
    {
        cpuid(i, 0, &CPU_ID[0], &CPU_ID[1], &CPU_ID[2], &CPU_ID[3]);
        *(u32*)&CPUNAME[0] = CPU_ID[0];
        *(u32*)&CPUNAME[4] = CPU_ID[1];
        *(u32*)&CPUNAME[8] = CPU_ID[2];
        *(u32*)&CPUNAME[12] = CPU_ID[3];
        CPUNAME[16] = '\0';
        DBG_SERIAL(SERIAL_ATTR_FRONT_YELLOW, SERIAL_ATTR_BACK_BLACK, "%s", CPUNAME);
    }
    DBG_SERIAL(SERIAL_ATTR_FRONT_YELLOW, SERIAL_ATTR_BACK_BLACK, "\n");
    cpuid(1, 0, &CPU_ID[0], &CPU_ID[1], &CPU_ID[2], &CPU_ID[3]);
    DBG_SERIAL(SERIAL_ATTR_FRONT_YELLOW, SERIAL_ATTR_BACK_BLACK, "Family:%x Extended Family:%x Mode:%x Extended Mode:%x CPUtype:%x StepID:%x\n", ((CPU_ID[0] >> 8) & 0xf), ((CPU_ID[0] >> 20) & 0xff), ((CPU_ID[0] >> 4) & 0xf), ((CPU_ID[0] >> 16) & 0xf), ((CPU_ID[0] >> 12) & 0x3), ((CPU_ID[0] >> 0) & 0xf));
    cpuid(0x80000008, 0, &CPU_ID[0], &CPU_ID[1], &CPU_ID[2], &CPU_ID[3]);
    DBG_SERIAL(SERIAL_ATTR_FRONT_YELLOW, SERIAL_ATTR_BACK_BLACK, "Physical Address Width:%d Linear Address Width:%d\n", ((CPU_ID[0] >> 0) & 0xff), ((CPU_ID[0] >> 8) & 0xff));
    cpuid(0, 0, &CPU_ID[0], &CPU_ID[1], &CPU_ID[2], &CPU_ID[3]);
    DBG_SERIAL(SERIAL_ATTR_FRONT_YELLOW, SERIAL_ATTR_BACK_BLACK, "MAX Operator Code:%x\t", CPU_ID[0]);
    cpuid(0x80000000, 0, &CPU_ID[0], &CPU_ID[1], &CPU_ID[2], &CPU_ID[3]);
    DBG_SERIAL(SERIAL_ATTR_FRONT_YELLOW, SERIAL_ATTR_BACK_BLACK, "MAX EXT Operator Code:%x\n", CPU_ID[0]);
    return;
}