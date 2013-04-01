;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;   P523:  Assignment 4
;;   Author: Tanghong Qiu
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

define double @dotproduct(double* %A, double* %B, i32 %n) {
entry:
	br label %test
test:
	%i = phi i32 [0, %entry], [%i_next, %loop]
	%s = phi double [0.000000e+00, %entry], [%s_new, %loop]
	%cond = icmp slt i32 %i, %n
	br i1 %cond, label %loop, label %done
loop:
	%A_idx = getelementptr double* %A, i32 %i
	%A_val = load double* %A_idx
	%idx_temp = mul i32 %n, %i
	%B_idx = getelementptr double* %B, i32 %idx_temp
	%B_val = load double* %B_idx
	%product = fmul double %A_val, %B_val
	%s_new = fadd double %s, %product

	%i_next = add i32 %i, 1	
	br label %test
done:
	ret double %s
}

define void @matmul(double* %A, double* %B, double* %C, i32 %n) {
entry:
	br label %outer_test
outer_test:
	%i = phi i32 [0, %entry], [%i_next, %outer_inc]
	%outer_cond = icmp slt i32 %i, %n
	br i1 %outer_cond, label %test, label %done
test:
	%j = phi i32 [0, %outer_test], [%j_next, %loop]
	%cond = icmp slt i32 %j, %n
	br i1 %cond, label %loop, label %outer_inc
loop:
	%A_idx_temp = mul i32 %n, %i
	%A_idx = getelementptr double* %A, i32 %A_idx_temp	
	%B_idx = getelementptr double* %B, i32 %j	
	%retval = call double @dotproduct(double* %A_idx, double* %B_idx, i32 %n)
	%C_idx_temp = add i32 %A_idx_temp, %j
	%C_idx = getelementptr double* %C, i32 %C_idx_temp
	store double %retval, double* %C_idx

	%j_next = add i32 1, %j
	br label %test
outer_inc:
	%i_next = add i32 1, %i
	br label %outer_test
done:
	ret void
}
