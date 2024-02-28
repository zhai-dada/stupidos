#ifndef __BLOCK_H__
#define __BLOCK_H__

#include <stdint.h>
#include <waitque.h>

struct block_buffer_node
{
    uint32_t count;
    uint8_t cmd;
    uint64_t lba;
    uint8_t* buffer;
    void (*end_handler)(uint64_t nr, uint64_t parameter);
    waitque_t wait_queue;
};
struct request_queue
{
    waitque_t wait_queue_list;
    struct block_buffer_node* in_using;
    uint64_t block_request_count;
};
struct block_device_operation
{
    uint64_t (*open)();
    uint64_t (*close)();
    uint64_t (*ioctl)(uint64_t cmd, uint64_t arg);
    uint64_t (*transfer)(uint64_t cmd, uint64_t blocks, uint64_t count, uint8_t* buffer);
};

#endif