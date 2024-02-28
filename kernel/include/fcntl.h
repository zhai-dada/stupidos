#ifndef __FCNTL_H__
#define __FCNTL_H__

#define	O_RDONLY	00000000	/* 只读打开 */
#define	O_WRONLY	00000001	/* 只写打开 */
#define	O_RDWR		00000002	/* 读写打开 */
#define	O_ACCMODE	00000003	/* 文件访问模式的掩码 */

#define	O_CREAT		00000100	/* 如果文件不存在则创建 */
#define	O_EXCL		00000200	/* 如果文件已存在则失败 */
#define	O_NOCTTY	00000400	/* 不分配控制终端 */
#define	O_TRUNC		00001000	/* 如果文件存在且是常规文件，且成功以 O_RDWR 或 O_WRONLY 打开，则其长度将被截断为 0 */
#define	O_APPEND	00002000	/* 文件偏移量将设置为文件末尾 */
#define	O_NONBLOCK	00004000	/* 非阻塞 I/O 模式 */

#define	O_EXEC		00010000	/* 仅用于执行打开（非目录文件） */
#define	O_SEARCH	00020000	/* 仅用于搜索目录 */
#define	O_DIRECTORY	00040000	/* 必须是目录 */
#define	O_NOFOLLOW	00100000	/* 不跟随符号链接 */

#endif
