	.file	"example5-me.s"
	.text
	.globl	foo
	.align	16, 0x90
	.type	foo,@function
foo:                                    # @foo
	.cfi_startproc
# BB#0:
	pushq	%rax
.Ltmp1:
	.cfi_def_cfa_offset 16
	movq	%rdx, (%rsp)
	movq	%rsi, -8(%rsp)
	movl	%edi, -12(%rsp)
	negl	-16(%rsp)
	xorl	%eax, %eax
	subl	-12(%rsp), %eax
	movl	%eax, -16(%rsp)
	leaq	-12(%rsp), %rcx
	leaq	-16(%rsp), %rax
	xorl	%edx, %edx
	subl	gx(%rip), %edx
	movl	%edx, -16(%rsp)
	movq	%rax, -24(%rsp)
	movq	$gx, -24(%rsp)
	movq	%rcx, -24(%rsp)
	movl	-16(%rsp), %ecx
	movl	%ecx, gx(%rip)
	movl	-16(%rsp), %ecx
	movl	%ecx, -12(%rsp)
	movq	-24(%rsp), %rcx
	movl	-16(%rsp), %edx
	movl	%edx, (%rcx)
	movq	-24(%rsp), %rcx
	movl	-16(%rsp), %edx
	movl	%edx, (%rcx)
	movq	-8(%rsp), %rcx
	movl	-16(%rsp), %edx
	movl	%edx, (%rcx)
	movq	%rax, -24(%rsp)
	movq	%rax, gp(%rip)
	movq	%rax, -8(%rsp)
	movl	-16(%rsp), %eax
	movl	%eax, ga+28(%rip)
	movq	(%rsp), %rax
	movl	-16(%rsp), %ecx
	movl	%ecx, 20(%rax)
	movl	-16(%rsp), %eax
	movl	%eax, -96(%rsp)
	xorl	%eax, %eax
	popq	%rdx
	ret
.Ltmp2:
	.size	foo, .Ltmp2-foo
	.cfi_endproc

	.type	gx,@object              # @gx
	.comm	gx,4,4
	.type	gp,@object              # @gp
	.comm	gp,8,8
	.type	ga,@object              # @ga
	.comm	ga,80,16

	.section	".note.GNU-stack","",@progbits
