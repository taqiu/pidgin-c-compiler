	.file	"example2-me.s"
	.text
	.globl	foo
	.align	16, 0x90
	.type	foo,@function
foo:                                    # @foo
	.cfi_startproc
# BB#0:
	subq	$2912, %rsp             # imm = 0xB60
.Ltmp1:
	.cfi_def_cfa_offset 2920
	movq	%r8, 2904(%rsp)
	movq	2920(%rsp), %rax
	movq	%rax, 2896(%rsp)
	movq	%rcx, 2888(%rsp)
	movq	%rdx, 2880(%rsp)
	movq	%rsi, 2872(%rsp)
	movsd	%xmm0, 2864(%rsp)
	movl	%edi, 2860(%rsp)
	movq	%r9, 2848(%rsp)
	movl	2844(%rsp), %eax
	addq	$2912, %rsp             # imm = 0xB60
	ret
.Ltmp2:
	.size	foo, .Ltmp2-foo
	.cfi_endproc

	.section	.rodata.cst8,"aM",@progbits,8
	.align	8
.LCPI1_0:
	.quad	4621256167635550208     # double 9.000000e+00
                                        #  (0x4022000000000000)
	.text
	.globl	bar
	.align	16, 0x90
	.type	bar,@function
bar:                                    # @bar
	.cfi_startproc
# BB#0:
	movsd	%xmm0, -8(%rsp)
	addsd	.LCPI1_0(%rip), %xmm0
	movsd	%xmm0, -16(%rsp)
	ret
.Ltmp3:
	.size	bar, .Ltmp3-bar
	.cfi_endproc

	.type	i,@object               # @i
	.comm	i,4,4
	.type	j,@object               # @j
	.comm	j,4,4
	.type	f,@object               # @f
	.comm	f,8,8

	.section	".note.GNU-stack","",@progbits
