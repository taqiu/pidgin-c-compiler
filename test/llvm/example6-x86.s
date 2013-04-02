	.file	"example6-me.s"
	.text
	.globl	foo
	.align	16, 0x90
	.type	foo,@function
foo:                                    # @foo
	.cfi_startproc
# BB#0:
	subq	$24, %rsp
.Ltmp1:
	.cfi_def_cfa_offset 32
	cvtsi2sd	20(%rsp), %xmm0
	movsd	%xmm0, 8(%rsp)
	movl	20(%rsp), %eax
	xorps	%xmm0, %xmm0
	cvtsi2sd	%eax, %xmm0
	callq	bar
	xorps	%xmm0, %xmm0
	cvtsi2sd	%eax, %xmm0
	movsd	%xmm0, 8(%rsp)
	movl	20(%rsp), %eax
	addq	$24, %rsp
	ret
.Ltmp2:
	.size	foo, .Ltmp2-foo
	.cfi_endproc

	.globl	bar
	.align	16, 0x90
	.type	bar,@function
bar:                                    # @bar
	.cfi_startproc
# BB#0:
	movsd	%xmm0, -8(%rsp)
	xorl	%eax, %eax
	ret
.Ltmp3:
	.size	bar, .Ltmp3-bar
	.cfi_endproc


	.section	".note.GNU-stack","",@progbits
