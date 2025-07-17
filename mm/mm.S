.globl memzero
.type memzero, @function
memzero:
	str xzr, [x0], #8	// 后变基
	subs x1, x1, #8
	b.gt memzero
	ret
