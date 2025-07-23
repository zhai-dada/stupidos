/*
	x0 基地址
	x1 长度
	void memzero(void* x0, u64 x1)
*/
.globl memzero
.type memzero, @function	// x0 基地址  x1 长度
memzero:
	cmp x1, #0
	b.le 2f					// 有符号数 小于等于
1:
	strb wzr, [x0], #1		// 后变基
	subs x1, x1, #1
	b.gt 1b
2:
	ret
