#ifndef __PREEMPT_H__
#define __PREEMPT_H__

#define preempt_enable()    current->preempt_count--
#define preempt_disable()   current->preempt_count++

#endif