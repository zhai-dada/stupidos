#include <uefi.h>

// UEFI保存所需数据的存放地址，具体参考UEFI代码
boot_para_t* boot_info = (boot_para_t *)0xffff800000060000;

