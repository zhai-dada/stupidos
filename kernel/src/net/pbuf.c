#include <lib.h>
#include <net/pbuf.h>
#include <debug.h>
#include <memory.h>

static list_t free_pbuf_list;
static u64 pbuf_count = 0;
static u64 free_count = 0;

// 分配pbuf空间
void pbuf_alloc(u64 count)
{
    pbuf_t *pbuf = NULL;
    for(u64 i = 0; i < count; i++)
    {
        pbuf = (pbuf_t*)kmalloc(2048, 0);
        list_add_behind(&free_pbuf_list, &pbuf->node);
    }
    free_count += count;
    pbuf_count += count;
}

// 获取空闲缓冲
pbuf_t *pbuf_get()
{
    pbuf_t *pbuf = NULL;
    if (free_count == 0)
    {
        pbuf_alloc(32);
    }
    pbuf = container_of((list_t *)list_prev(&free_pbuf_list), pbuf_t, node);
    pbuf_delete_list(pbuf);
    free_count--;
    return pbuf;
}

// 加入空闲
void pbuf_release(pbuf_t *pbuf)
{
    pbuf_delete_list(pbuf);
    list_add_behind(&free_pbuf_list, &pbuf->node);
    free_count++;
}

// 释放缓冲
void pbuf_free(pbuf_t *pbuf)
{
    list_delete(&pbuf->node);
    kfree(pbuf);
    pbuf_count--;
    free_count--;
}

void pbuf_delete_list(pbuf_t* pbuf)
{
    list_delete(&pbuf->node);
    return;
}

// 初始化数据包缓冲
void pbuf_init()
{
    list_init(&free_pbuf_list);
    pbuf_alloc(64);
}