	.file	"example3-me.s"
	.text
	.globl	foo
	.align	16, 0x90
	.type	foo,@function
foo:                                    # @foo
	.cfi_startproc
# BB#0:
	movq	%rdx, -8(%rsp)
	movq	%rsi, -16(%rsp)
	movl	%edi, -20(%rsp)
	movl	$0, -24(%rsp)
	movl	x(%rip), %eax
	movl	%eax, -24(%rsp)
	movl	-20(%rsp), %eax
	movl	%eax, -24(%rsp)
	movl	-28(%rsp), %eax
	movl	%eax, -24(%rsp)
	movl	xa+28(%rip), %eax
	movl	%eax, -24(%rsp)
	movq	-8(%rsp), %rax
	movl	436(%rax), %eax
	movl	%eax, -24(%rsp)
	movq	ga+208(%rip), %rax
	movl	(%rax), %eax
	movl	%eax, -24(%rsp)
	movl	-40(%rsp), %eax
	movl	%eax, -24(%rsp)
	movq	-16(%rsp), %rax
	movq	40(%rax), %rax
	cvtsi2sd	(%rax), %xmm0
	movsd	%xmm0, -112(%rsp)
	movl	-60(%rsp), %eax
	movl	%eax, -24(%rsp)
	movq	-56(%rsp), %rax
	movl	(%rax), %eax
	movl	%eax, -24(%rsp)
	movq	-56(%rsp), %rax
	movl	(%rax), %eax
	incl	%eax
	movl	%eax, -28(%rsp)
	movq	-56(%rsp), %rax
	movl	x(%rip), %ecx
	movl	%ecx, (%rax)
	movl	-28(%rsp), %eax
	movl	-24(%rsp), %edx
	movl	%edx, %ecx
	sarl	$31, %ecx
	shrl	$30, %ecx
	addl	%edx, %ecx
	leal	(%rdx,%rax), %edx
	sarl	$2, %ecx
	leal	3(%rcx,%rdx), %ecx
	shll	$3, %eax
	subl	%eax, %ecx
	movl	%ecx, x(%rip)
	movl	-24(%rsp), %eax
	addl	$9, %eax
	cvtsi2sd	%eax, %xmm0
	movsd	%xmm0, -112(%rsp)
	movl	-24(%rsp), %eax
	ret
.Ltmp0:
	.size	foo, .Ltmp0-foo
	.cfi_endproc

	.type	x,@object               # @x
	.comm	x,4,4
	.type	y,@object               # @y
	.comm	y,4,4
	.type	xa,@object              # @xa
	.comm	xa,80,16
	.type	ga,@object              # @ga
	.comm	ga,256,16
	.type	d,@object               # @d
	.comm	d,8,8

	.section	".note.GNU-stack","",@progbits
