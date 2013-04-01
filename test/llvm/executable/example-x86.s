	.file	"example.s"
	.section	.rodata.cst8,"aM",@progbits,8
	.align	8
.LCPI0_0:
	.quad	4611686018427387904     # double 2.000000e+00
                                        #  (0x4000000000000000)
	.text
	.globl	foo
	.align	16, 0x90
	.type	foo,@function
foo:                                    # @foo
	.cfi_startproc
# BB#0:
	subq	$168, %rsp
.Ltmp1:
	.cfi_def_cfa_offset 176
	movl	$1, 164(%rsp)
	movl	$2, 160(%rsp)
	movl	$3, gx(%rip)
	movl	$4, gy(%rip)
	movl	$5, ga+112(%rip)
	movl	$6, 100(%rsp)
	movl	164(%rsp), %edi
	leaq	16(%rsp), %rdx
	movl	$6, %esi
	callq	add
	movl	ga+112(%rip), %esi
	movl	gx(%rip), %edi
	movl	$ga, %edx
	callq	add
	movl	160(%rsp), %esi
	movl	$ga, %edi
	callq	mult
	movsd	%xmm0, 8(%rsp)
	movl	ga(%rip), %eax
	addl	$4, %eax
	cvtsi2sd	%eax, %xmm2
	divsd	.LCPI0_0(%rip), %xmm2
	movl	16(%rsp), %eax
	addl	%eax, %eax
	cvtsi2sd	%eax, %xmm1
	addsd	%xmm0, %xmm1
	cvtsi2sd	gy(%rip), %xmm0
	addsd	%xmm2, %xmm1
	subsd	%xmm0, %xmm1
	movsd	%xmm1, gd(%rip)
	movaps	%xmm1, %xmm0
	addq	$168, %rsp
	ret
.Ltmp2:
	.size	foo, .Ltmp2-foo
	.cfi_endproc

	.globl	add
	.align	16, 0x90
	.type	add,@function
add:                                    # @add
	.cfi_startproc
# BB#0:
	movq	%rdx, -8(%rsp)
	movl	%esi, -12(%rsp)
	movl	%edi, -16(%rsp)
	addl	-12(%rsp), %edi
	movq	-8(%rsp), %rax
	movl	%edi, (%rax)
	ret
.Ltmp3:
	.size	add, .Ltmp3-add
	.cfi_endproc

	.section	.rodata.cst8,"aM",@progbits,8
	.align	8
.LCPI2_0:
	.quad	4604480259023595110     # double 7.000000e-01
                                        #  (0x3fe6666666666666)
	.text
	.globl	mult
	.align	16, 0x90
	.type	mult,@function
mult:                                   # @mult
	.cfi_startproc
# BB#0:
	movl	%esi, -4(%rsp)
	movq	%rdi, -16(%rsp)
	cvtsi2sd	-4(%rsp), %xmm1
	addsd	.LCPI2_0(%rip), %xmm1
	movsd	%xmm1, gd(%rip)
	movq	-16(%rsp), %rax
	cvtsi2sd	112(%rax), %xmm0
	mulsd	%xmm1, %xmm0
	movsd	%xmm0, -24(%rsp)
	ret
.Ltmp4:
	.size	mult, .Ltmp4-mult
	.cfi_endproc

	.type	gx,@object              # @gx
	.comm	gx,4,4
	.type	gy,@object              # @gy
	.comm	gy,4,4
	.type	ga,@object              # @ga
	.comm	ga,144,16
	.type	gd,@object              # @gd
	.comm	gd,8,8

	.section	".note.GNU-stack","",@progbits
