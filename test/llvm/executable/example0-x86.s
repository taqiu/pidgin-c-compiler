	.file	"example0.s"
	.section	.rodata.cst8,"aM",@progbits,8
	.align	8
.LCPI0_0:
	.quad	4635189178982727680     # double 7.800000e+01
                                        #  (0x4053800000000000)
.LCPI0_1:
	.quad	4635822497680326656     # double 8.700000e+01
                                        #  (0x4055c00000000000)
	.text
	.globl	bar
	.align	16, 0x90
	.type	bar,@function
bar:                                    # @bar
	.cfi_startproc
# BB#0:
	pushq	%rbp
.Ltmp4:
	.cfi_def_cfa_offset 16
	pushq	%r14
.Ltmp5:
	.cfi_def_cfa_offset 24
	pushq	%rbx
.Ltmp6:
	.cfi_def_cfa_offset 32
	subq	$480, %rsp              # imm = 0x1E0
.Ltmp7:
	.cfi_def_cfa_offset 512
.Ltmp8:
	.cfi_offset %rbx, -32
.Ltmp9:
	.cfi_offset %r14, -24
.Ltmp10:
	.cfi_offset %rbp, -16
	movsd	%xmm0, 472(%rsp)
	movl	$90, 468(%rsp)
	leaq	468(%rsp), %rax
	movq	%rax, 456(%rsp)
	movq	%rax, 208(%rsp)
	leaq	464(%rsp), %rax
	movq	%rax, 256(%rsp)
	movq	456(%rsp), %rax
	movl	(%rax), %eax
	leal	87(%rax,%rax), %eax
	movl	%eax, 464(%rsp)
	movl	468(%rsp), %eax
	cvtsi2sd	%eax, %xmm0
	callq	buz
	movl	%eax, %ebx
	movsd	.LCPI0_0(%rip), %xmm0
	movq	208(%rsp), %rcx
	movq	256(%rsp), %rax
	addl	(%rcx), %ebx
	movq	456(%rsp), %rcx
	movl	(%rcx), %r14d
	movl	(%rax), %ebp
	callq	buz
	movl	468(%rsp), %ecx
	imull	$-3, %ecx, %edx
	cvtsi2sd	%edx, %xmm1
	divsd	.LCPI0_1(%rip), %xmm1
	xorps	%xmm0, %xmm0
	cvtsi2sd	%eax, %xmm0
	addsd	472(%rsp), %xmm0
	negl	%ecx
	cvtsi2sd	%ecx, %xmm2
	mulsd	%xmm0, %xmm2
	addl	%ebx, %ebp
	addl	%r14d, %ebp
	xorps	%xmm0, %xmm0
	cvtsi2sd	%ebp, %xmm0
	addsd	%xmm2, %xmm0
	addsd	%xmm1, %xmm0
	movsd	%xmm0, (%rsp)
	addq	$480, %rsp              # imm = 0x1E0
	popq	%rbx
	popq	%r14
	popq	%rbp
	ret
.Ltmp11:
	.size	bar, .Ltmp11-bar
	.cfi_endproc

	.section	.rodata.cst8,"aM",@progbits,8
	.align	8
.LCPI1_0:
	.quad	4636737291354636288     # double 1.000000e+02
                                        #  (0x4059000000000000)
	.text
	.globl	buz
	.align	16, 0x90
	.type	buz,@function
buz:                                    # @buz
	.cfi_startproc
# BB#0:
	movsd	%xmm0, -8(%rsp)
	addsd	-16(%rsp), %xmm0
	addsd	.LCPI1_0(%rip), %xmm0
	movsd	%xmm0, -16(%rsp)
	movl	$20, %eax
	ret
.Ltmp12:
	.size	buz, .Ltmp12-buz
	.cfi_endproc


	.section	".note.GNU-stack","",@progbits
