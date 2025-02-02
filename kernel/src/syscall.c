#include <stdint.h>

#define SYS_CALL(nr, sym) extern u64 sym(void);
SYS_CALL(0, no_system_call)
#include "syscall.h"
#undef SYS_CALL

#define SYS_CALL(nr, sym) [nr] = sym,
#define SYS_CALL_NUM 128
typedef u64 (*system_call_t)(void);

system_call_t system_call_table[SYS_CALL_NUM] =
    {
        [0 ... SYS_CALL_NUM - 1] = no_system_call,
        [1] = sys_printf,
        [2] = sys_open,
        [3] = sys_close,
        [4] = sys_read,
        [5] = sys_write,
        [6] = sys_lseek,
        [7] = sys_fork,
        [8] = sys_vfork,
        [9] = sys_brk,
        [10] = sys_device_openkeyboard,
        [11] = sys_execve,
        [12] = sys_exit,
        [13] = sys_wait4,
        [14] = sys_reboot,
    };