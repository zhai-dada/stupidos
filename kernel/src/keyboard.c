#include <apic.h>
#include <keyboard.h>
#include <printk.h>
#include <waitque.h>
#include <interrupt.h>
#include <softirq.h>
#include <task.h>

struct keyboard_input_buffer *p_kb = NULL;
waitque_t keyboard_wait_queue;

irq_controller keyboard_int_controller =
{
    .enable = ioapic_enable,
    .disable = ioapic_disable,
    .install = ioapic_install,
    .uninstall = ioapic_uninstall,
    .ack = ioapic_edge_ack,
};
void keyboard_exit()
{
    unregister_irq(0x21);
    kfree((uint64_t *)p_kb);
    return;
}
void keyboard_handler(uint64_t nr, uint64_t parameter, struct stackregs *reg)
{
    uint8_t x = 0;
    x = io_in8(PORT_KB_DATA);
    if (x == 0xfa)
    {
        return;
    }
    if (p_kb->p_head == p_kb->buf + KEYBOARD_BUF_SIZE)
    {
        p_kb->p_head = p_kb->buf;
    }
    *p_kb->p_head = x;
    p_kb->count++;
    p_kb->p_head++;
    wakeup(&keyboard_wait_queue, TASK_UNINTERRUPTIBLE);
    return;
}
void keyboard_init()
{
    struct IOAPIC_RET_ENTRY entry;
    uint64_t i = 0;
    uint64_t j = 0;
    wait_queue_init(&keyboard_wait_queue, NULL);
    p_kb = (struct keyboard_input_buffer *)kmalloc(sizeof(struct keyboard_input_buffer), 0);
    if (p_kb == NULL)
    {
        color_printk(RED, BLACK, "kmalloc()->p_kb failed\n");
    }
    p_kb->p_head = p_kb->buf;
    p_kb->p_tail = p_kb->buf;
    p_kb->count = 0;
    memset(p_kb->buf, 0, KEYBOARD_BUF_SIZE);
    entry.vector_num = 0x21;
    entry.deliver_mode = IOAPIC_FIXED;
    entry.deliver_status = IOAPIC_DELI_STATUS_IDLE;
    entry.dest_mode = IOAPIC_DEST_MODE_PHYSICAL;
    entry.polarity = IOAPIC_POLARITY_HIGH;
    entry.mask = IOAPIC_MASK_MASKED;
    entry.irr = IOAPIC_IRR_RESET;
    entry.trigger = IOAPIC_TRIGGER_EDGE;
    entry.reserved = 0;
    entry.destination.physical.reserved1 = 0;
    entry.destination.physical.reserved2 = 0;
    entry.destination.physical.phy_dest = 0;
    wait_KB_write();
    io_out8(PORT_KB_CMD, KB_WRITE_CMD);
    wait_KB_write();
    io_out8(PORT_KB_DATA, KB_INIT_MODE);
    wait_KB_write();
    for (j = 0; j < 1000; j++)
    {
        for (i = 0; i < 1000; i++)
        {
            nop();
        }
    }
    color_printk(GREEN, BLACK, "register_irq 0x21 keyboard\n");
    register_irq(0x21, &entry, &keyboard_handler, (uint64_t)p_kb, &keyboard_int_controller, "ps/2 keyboard");
    return;
}

int64_t keyboard_open(struct index_node *inode, struct file *filp)
{
    filp->private_data = p_kb;

    p_kb->p_head = p_kb->buf;
    p_kb->p_tail = p_kb->buf;
    p_kb->count = 0;
    memset(p_kb->buf, 0, KEYBOARD_BUF_SIZE);

    return 1;
}

int64_t keyboard_close(struct index_node *inode, struct file *filp)
{
    filp->private_data = NULL;

    p_kb->p_head = p_kb->buf;
    p_kb->p_tail = p_kb->buf;
    p_kb->count = 0;
    memset(p_kb->buf, 0, KEYBOARD_BUF_SIZE);

    return 1;
}

#define KEY_CMD_RESET_BUFFER 0

int64_t keyboard_ioctl(struct index_node *inode, struct file *filp, uint64_t cmd, uint64_t arg)
{
    switch (cmd)
    {

    case KEY_CMD_RESET_BUFFER:
        p_kb->p_head = p_kb->buf;
        p_kb->p_tail = p_kb->buf;
        p_kb->count = 0;
        memset(p_kb->buf, 0, KEYBOARD_BUF_SIZE);
        break;

    default:
        break;
    }

    return 0;
}

int64_t keyboard_read(struct file *filp, int8_t *buf, uint64_t count, int64_t *position)
{
    int64_t counter = 0;
    uint8_t *tail = NULL;

    if (p_kb->count == 0)
    {
        sleep_on(&keyboard_wait_queue);
    }
    counter = (p_kb->count >= count ? count : p_kb->count);
    tail = p_kb->p_tail;

    if (counter <= (p_kb->buf + KEYBOARD_BUF_SIZE - tail))
    {
        copy_to_user(tail, buf, counter);
        p_kb->p_tail += counter;
    }
    else
    {
		copy_to_user(tail, buf, (p_kb->buf + KEYBOARD_BUF_SIZE - tail));
		copy_to_user(p_kb->buf, buf + (p_kb->buf + KEYBOARD_BUF_SIZE - tail), counter - (p_kb->buf + KEYBOARD_BUF_SIZE - tail));
		p_kb->p_tail = p_kb->buf + (counter - (p_kb->buf + KEYBOARD_BUF_SIZE - tail));
    }
    p_kb->count -= counter;

    return counter;
}

int64_t keyboard_write(struct file *filp, int8_t *buf, uint64_t count, int64_t *position)
{
    return 0;
}

struct file_operations keyboard_fops =
{
    .open = keyboard_open,
    .close = keyboard_close,
    .ioctl = keyboard_ioctl,
    .read = keyboard_read,
    .write = keyboard_write,
};