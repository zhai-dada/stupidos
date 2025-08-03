#ifndef __SYSREG_H
#define __SYSREG_H

#define CurrentEL_EL0 (0 << 2)
#define CurrentEL_EL1 (1 << 2)
#define CurrentEL_EL2 (2 << 2)
#define CurrentEL_EL3 (3 << 2)

#define HCR_EL2_RW_MASK         (1 << 31)   // offset
#define HCR_EL2_RW_AARCH32      (0 << 31)
#define HCR_EL2_RW_AARCH64      (1 << 31)

#define SCTLR_EL1_EE_MASK       (1 << 25)   // offset
#define SCTLR_EL1_EE_LENDIAN    (0 << 25)
#define SCTLR_EL1_EE_BENDIAN    (1 << 25)

#define SCTLR_EL1_EOE_MASK      (1 << 24)   // offset
#define SCTLR_EL1_EOE_LENDIAN   (0 << 24)
#define SCTLR_EL1_EOE_BENDIAN   (1 << 24)

#define SCTLR_EL1_MMU_MASK      (1 << 0)    // offset
#define SCTLR_EL1_MMU_DISABLE   (0 << 0)
#define SCTLR_EL1_MMU_ENABLE    (1 << 0)

#define SCTLR_LL_MMU_DISABLE    (SCTLR_EL1_MMU_DISABLE | SCTLR_EL1_EOE_LENDIAN | SCTLR_EL1_EE_LENDIAN)

#define SPSR_INT_D              (1 << 9)    // offset
#define SPSR_INT_A              (1 << 8)
#define SPSR_INT_I              (1 << 7)
#define SPSR_INT_F              (1 << 6)
#define SPSR_INT_MASK           (SPSR_INT_D | SPSR_INT_A | SPSR_INT_I | SPSR_INT_F)
#define SPSR_INT_ALL            (SPSR_INT_D | SPSR_INT_A | SPSR_INT_I | SPSR_INT_F)

#define SPSR_EL_MASK            (0x0F << 0)
#define SPSR_EL3h               (0x0D << 0)
#define SPSR_EL3t               (0x0C << 0)
#define SPSR_EL2h               (0x09 << 0)
#define SPSR_EL2t               (0x08 << 0)
#define SPSR_EL1h               (0x05 << 0)
#define SPSR_EL1t               (0x04 << 0)
#define SPSR_EL0t               (0x00 << 0)

#endif
