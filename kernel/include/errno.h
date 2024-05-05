#ifndef __ERRNO_H__
#define __ERRNO_H__

#define	E2BIG			1		/* 参数列表过长或输出缓冲区空间不足或参数超过系统规定的最大值 */
#define	EACCES			2		/* 拒绝访问 */
#define	EADDRINUSE		3		/* 地址正在使用中 */
#define	EADDRNOTAVAIL	4		/* 地址不可用 */
#define	EAFNOSUPPORT	5		/* 不支持的地址类型 */
#define	EAGAIN			6		/* 资源暂时不可用 */
#define	EALREADY		7		/* 连接已经在进行中 */
#define	EBADF			8		/* 错误的文件描述符 */
#define	EBADMSG			9		/* 错误的消息 */

#define	EBUSY			10		/* 资源忙 */
#define	ECANCELED		11		/* 操作被取消 */
#define	ECHILD			12		/* 没有子进程 */
#define	ECONNABORTED	13		/* 连接中止 */
#define	ECONNREFUSED	14		/* 连接被拒绝 */
#define	ECONNRESET		15		/* 连接重置 */
#define	EDEADLK			16		/* 资源死锁将会发生 */
#define	EDESTADDRREQ	17		/* 需要目标地址 */
#define	EDOM			18		/* 域错误 */
#define	EDQUOT			19		/* 保留 */

#define	EEXIST			20		/* 文件已存在 */
#define	EFAULT			21		/* 错误的地址 */
#define	EFBIG			22		/* 文件太大 */
#define	EHOSTUNREACH	23		/* 主机不可达 */
#define	EIDRM			24		/* 标识符已移除 */
#define	EILSEQ			25		/* 非法字节序列 */
#define	EINPROGRESS		26		/* 操作正在进行中或套接字文件描述符已设置了 O_NONBLOCK 并且连接无法 */

#define	EINTR			27		/* 中断的函数调用 */
#define	EINVAL			28		/* 无效参数 */
#define	EIO				29		/* 输入/输出错误 */

#define	EISCONN			30		/* 套接字已连接 */
#define	EISDIR			31		/* 是一个目录 */
#define	ELOOP			32		/* 符号链接循环 */
#define	EMFILE			33		/* 文件描述符值过大或打开的流太多 */
#define	EMLINK			34		/* 太多的链接 */
#define	EMSGSIZE		35		/* 消息太大或不适当的消息缓冲区长度 */
#define	EMULTIHOP		36		/* 保留 */
#define	ENAMETOOLONG	37		/* 文件名太长 */
#define	ENETDOWN		38		/* 网络已关闭 */

#define	ENETRESET		39		/* 网络中断连接 */
#define	ENETUNREACH		40		/* 网络不可达 */
#define	ENFILE			41		/* 系统中打开的文件太多 */
#define	ENOBUFS			42		/* 没有可用的缓冲区空间 */
#define	ENODATA			43		/* 没有可用的消息 */
#define	ENODEV			44		/* 没有这样的设备 */
#define	ENOENT			45		/* 没有这样的文件或目录 */
#define	ENOEXEC			46		/* 可执行文件格式错误 */
#define	ENOLCK			47		/* 没有可用的锁 */
#define	ENOLINK			48		/* 保留 */
#define	ENOMEM			49		/* 空间不足 */

#define	ENOMSG			50		/* 没有所需类型的消息 */
#define	ENOPROTOOPT		51		/* 不支持的协议 */
#define	ENOSPC			52		/* 设备上没有空间 */
#define	ENOSR			53		/* 没有 STREAM 资源 */
#define	ENOSTR			54		/* 不是 STREAM */
#define	ENOSYS			55		/* 功能未实现 */
#define	ENOTCONN		56		/* 套接字未连接 */
#define	ENOTDIR			57		/* 不是目录 */
#define	ENOTEMPTY		58		/* 目录不为空 */
#define	ENOTRECOVERABLE	59		/* 状态无法恢复 */

#define	ENOTSOCK		60		/* 不是套接字 */
#define	ENOTSUP			61		/* 不支持 */
#define	ENOTTY			62		/* 不适当的 I/O 控制操作 */
#define	ENXIO			63		/* 没有这样的设备或地址 */
#define	EOPNOTSUPP		64		/* 套接字上不支持的操作 */
#define	EOVERFLOW		65		/* 值太大，无法存储在数据类型中 */
#define	EOWNERDEAD		66		/* 先前的所有者已经死亡 */
#define	EPERM			67		/* 操作不允许 */
#define	EPIPE			68		/* 管道破裂 */
#define	EPROTO			69		/* 协议错误 */

#define	EPROTONOSUPPORT	70		/* 不支持的协议 */
#define	EPROTOTYPE		71		/* 套接字类型错误的协议 */
#define	ERANGE			72		/* 结果太大或太小 */
#define	EROFS			73		/* 只读文件系统 */
#define	ESPIPE			74		/* 无效的 seek */
#define	ESRCH			75		/* 没有这样的进程 */
#define	ESTALE			76		/* 保留 */
#define	ETIME			77		/* STREAM ioctl( ) 超时 */
#define	ETIMEDOUT		78		/* 连接超时或操作超时 */
#define	ETXTBSY			79		/* 文本文件繁忙 */

#define	EWOULDBLOCK		80		/* 操作将会阻塞 */
#define	EXDEV			81		/* 不合适的链接 */

#endif