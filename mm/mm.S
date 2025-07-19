/*
	x0 基地址
	x1 长度
	void memzero(void* x0, u64 x1)
*/
.globl memzero
.type memzero, @function	// x0 基地址  x1 长度
memzero:
	strb wzr, [x0], #1		// 后变基
	subs x1, x1, #1
	b.gt memzero
	ret
