	.file	"matmul.s"
	.text
	.globl	dotproduct
	.align	16, 0x90
	.type	dotproduct,@function
dotproduct:                             # @dotproduct
	.cfi_startproc
# BB#0:                                 # %entry
	xorps	%xmm0, %xmm0
	xorl	%r8d, %r8d
	xorl	%ecx, %ecx
	jmp	.LBB0_1
	.align	16, 0x90
.LBB0_2:                                # %loop
                                        #   in Loop: Header=BB0_1 Depth=1
	movsd	(%rdi,%rcx,8), %xmm1
	movslq	%r8d, %rax
	addl	%edx, %r8d
	mulsd	(%rsi,%rax,8), %xmm1
	addsd	%xmm1, %xmm0
	incq	%rcx
.LBB0_1:                                # %test
                                        # =>This Inner Loop Header: Depth=1
	cmpl	%edx, %ecx
	jl	.LBB0_2
# BB#3:                                 # %done
	ret
.Ltmp0:
	.size	dotproduct, .Ltmp0-dotproduct
	.cfi_endproc

	.globl	matmul
	.align	16, 0x90
	.type	matmul,@function
matmul:                                 # @matmul
	.cfi_startproc
# BB#0:                                 # %entry
	pushq	%rbp
.Ltmp8:
	.cfi_def_cfa_offset 16
	pushq	%r15
.Ltmp9:
	.cfi_def_cfa_offset 24
	pushq	%r14
.Ltmp10:
	.cfi_def_cfa_offset 32
	pushq	%r13
.Ltmp11:
	.cfi_def_cfa_offset 40
	pushq	%r12
.Ltmp12:
	.cfi_def_cfa_offset 48
	pushq	%rbx
.Ltmp13:
	.cfi_def_cfa_offset 56
	subq	$24, %rsp
.Ltmp14:
	.cfi_def_cfa_offset 80
.Ltmp15:
	.cfi_offset %rbx, -56
.Ltmp16:
	.cfi_offset %r12, -48
.Ltmp17:
	.cfi_offset %r13, -40
.Ltmp18:
	.cfi_offset %r14, -32
.Ltmp19:
	.cfi_offset %r15, -24
.Ltmp20:
	.cfi_offset %rbp, -16
	movl	%ecx, %ebp
	movq	%rdx, 16(%rsp)          # 8-byte Spill
	movq	%rsi, (%rsp)            # 8-byte Spill
	movq	%rdi, %r12
	xorl	%eax, %eax
	xorl	%r15d, %r15d
	jmp	.LBB1_1
	.align	16, 0x90
.LBB1_4:                                # %outer_inc
                                        #   in Loop: Header=BB1_1 Depth=1
	movl	12(%rsp), %eax          # 4-byte Reload
	addl	%ebp, %eax
	incl	%r15d
.LBB1_1:                                # %outer_test
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB1_2 Depth 2
	movl	%eax, 12(%rsp)          # 4-byte Spill
	cmpl	%ebp, %r15d
	movl	$0, %r13d
	movq	(%rsp), %rbx            # 8-byte Reload
	movl	%eax, %r14d
	jge	.LBB1_5
	jmp	.LBB1_2
	.align	16, 0x90
.LBB1_3:                                # %loop
                                        #   in Loop: Header=BB1_2 Depth=2
	movl	%ebp, %eax
	imull	%r15d, %eax
	movslq	%eax, %rax
	leaq	(%r12,%rax,8), %rdi
	movq	%rbx, %rsi
	movl	%ebp, %edx
	callq	dotproduct
	movslq	%r14d, %r14
	movq	16(%rsp), %rax          # 8-byte Reload
	movsd	%xmm0, (%rax,%r14,8)
	incl	%r13d
	addq	$8, %rbx
	incl	%r14d
.LBB1_2:                                # %test
                                        #   Parent Loop BB1_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	cmpl	%ebp, %r13d
	jge	.LBB1_4
	jmp	.LBB1_3
.LBB1_5:                                # %done
	addq	$24, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	ret
.Ltmp21:
	.size	matmul, .Ltmp21-matmul
	.cfi_endproc


	.section	".note.GNU-stack","",@progbits
