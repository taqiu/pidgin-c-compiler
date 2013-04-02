	.file	"example4-me.s"
	.text
	.globl	foo
	.align	16, 0x90
	.type	foo,@function
foo:                                    # @foo
	.cfi_startproc
# BB#0:
	subq	$280, %rsp              # imm = 0x118
.Ltmp1:
	.cfi_def_cfa_offset 288
	movl	$9, %edi
	callq	bar
	movsd	272(%rsp), %xmm0
	addsd	264(%rsp), %xmm0
	leaq	12(%rsp), %rsi
	leaq	4(%rsp), %rdx
	movl	$4, %edi
	callq	buz
	movsd	%xmm0, 272(%rsp)
	xorl	%eax, %eax
	addq	$280, %rsp              # imm = 0x118
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
	movl	%edi, -4(%rsp)
	ret
.Ltmp3:
	.size	bar, .Ltmp3-bar
	.cfi_endproc

	.globl	buz
	.align	16, 0x90
	.type	buz,@function
buz:                                    # @buz
	.cfi_startproc
# BB#0:
	movq	%rdx, -8(%rsp)
	movq	%rsi, -16(%rsp)
	movl	%edi, -20(%rsp)
	movsd	%xmm0, -32(%rsp)
	xorps	%xmm0, %xmm0
	ret
.Ltmp4:
	.size	buz, .Ltmp4-buz
	.cfi_endproc


	.section	".note.GNU-stack","",@progbits
