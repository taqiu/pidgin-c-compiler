define double @dotproduct(double* %A, double* %B, i32 %n) {
entry:
	%i = alloca i32 
	%s = alloca double
	store i32 0, i32* %i
	store double 0.0, double* %s
	br label %test
test:
	%i_val = load i32* %i
	%cond = icmp slt i32 %i_val, %n
	br i1 %cond, label %loop, label %exit
loop:
	%A_idx = getelementptr double* %A, i32 %i_val
	%A_val = load double* %A_idx
	%idx_temp = mul i32 %n, %i_val
	%B_idx = getelementptr double* %B, i32 %idx_temp
	%B_val = load double* %B_idx
	%product = fmul double %A_val, %B_val
	%s_prev = load double* %s
	%s_new = fadd double %s_prev, %product
	store double %s_new, double* %s

	%i_current = load i32* %i	
	%i_next = add i32 1, %i_current
	store i32 %i_next, i32* %i
	br label %test
exit:
	%final_s = load double* %s
	ret double %final_s
}

define void @matmul(double* %A, double* %B, double* %C, i32 %n) {
entry:
	%i = alloca i32
	%j = alloca i32
	store i32 0, i32* %i
	br label %outer_test
outer_test:
	%i_val = load i32* %i
	%outer_cond = icmp slt i32 %i_val, %n
	store i32 0, i32* %j
	br i1 %outer_cond, label %test, label %exit
test:
	%j_val = load i32* %j
	%cond = icmp slt i32 %j_val, %n
	br i1 %cond, label %loop, label %outer_inc
loop:
	%A_idx_temp = mul i32 %n, %i_val
	%A_idx = getelementptr double* %A, i32 %A_idx_temp	
	%B_idx = getelementptr double* %B, i32 %j_val	
	%retval = call double @dotproduct(double* %A_idx, double* %B_idx, i32 %n)
	%C_idx_temp = add i32 %A_idx_temp, %j_val
	%C_idx = getelementptr double* %C, i32 %C_idx_temp
	store double %retval, double* %C_idx

	%j_current = load i32* %j	
	%j_next = add i32 1, %j_current
	store i32 %j_next, i32* %j
	br label %test
outer_inc:
	%i_current = load i32* %i	
	%i_next = add i32 1, %i_current
	store i32 %i_next, i32* %i
	br label %outer_test
exit:
	ret void
}
