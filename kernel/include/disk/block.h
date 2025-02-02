#ifndef __BLOCK_H__
#define __BLOCK_H__

#include <stdint.h>
#include <waitque.h>

struct block_buffer_node
{
    u32 count;
    u8 cmd;
    u64 lba;
    u8* buffer;
    void (*end_handler)(u64 nr, u64 parameter);
    waitque_t wait_queue;
};
struct request_queue
{
    waitque_t wait_queue_list;
    struct block_buffer_node* in_using;
    u64 block_request_count;
};
struct block_device_operation
{
    u64 (*open)();
    u64 (*close)();
    u64 (*ioctl)(u64 cmd, u64 arg);
    u64 (*transfer)(u64 cmd, u64 blocks, u64 count, u8* buffer);
};

#endif