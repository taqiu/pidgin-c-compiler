; ModuleID = 'matmul.c'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

define double @dotproduct_c(double* %A, double* %B, i32 %n) nounwind uwtable {
entry:
  %A.addr = alloca double*, align 8
  %B.addr = alloca double*, align 8
  %n.addr = alloca i32, align 4
  %i = alloca i32, align 4
  %s = alloca double, align 8
  store double* %A, double** %A.addr, align 8
  store double* %B, double** %B.addr, align 8
  store i32 %n, i32* %n.addr, align 4
  store double 0.000000e+00, double* %s, align 8
  store i32 0, i32* %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i32* %i, align 4
  %1 = load i32* %n.addr, align 4
  %cmp = icmp slt i32 %0, %1
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %2 = load double* %s, align 8
  %3 = load i32* %i, align 4
  %idxprom = sext i32 %3 to i64
  %4 = load double** %A.addr, align 8
  %arrayidx = getelementptr inbounds double* %4, i64 %idxprom
  %5 = load double* %arrayidx, align 8
  %6 = load i32* %i, align 4
  %7 = load i32* %n.addr, align 4
  %mul = mul nsw i32 %6, %7
  %idxprom1 = sext i32 %mul to i64
  %8 = load double** %B.addr, align 8
  %arrayidx2 = getelementptr inbounds double* %8, i64 %idxprom1
  %9 = load double* %arrayidx2, align 8
  %mul3 = fmul double %5, %9
  %add = fadd double %2, %mul3
  store double %add, double* %s, align 8
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %10 = load i32* %i, align 4
  %inc = add nsw i32 %10, 1
  store i32 %inc, i32* %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %11 = load double* %s, align 8
  ret double %11
}

define void @matmul_c(double* %A, double* %B, double* %C, i32 %n) nounwind uwtable {
entry:
  %A.addr = alloca double*, align 8
  %B.addr = alloca double*, align 8
  %C.addr = alloca double*, align 8
  %n.addr = alloca i32, align 4
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  store double* %A, double** %A.addr, align 8
  store double* %B, double** %B.addr, align 8
  store double* %C, double** %C.addr, align 8
  store i32 %n, i32* %n.addr, align 4
  store i32 0, i32* %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc9, %entry
  %0 = load i32* %i, align 4
  %1 = load i32* %n.addr, align 4
  %cmp = icmp slt i32 %0, %1
  br i1 %cmp, label %for.body, label %for.end11

for.body:                                         ; preds = %for.cond
  store i32 0, i32* %j, align 4
  br label %for.cond1

for.cond1:                                        ; preds = %for.inc, %for.body
  %2 = load i32* %j, align 4
  %3 = load i32* %n.addr, align 4
  %cmp2 = icmp slt i32 %2, %3
  br i1 %cmp2, label %for.body3, label %for.end

for.body3:                                        ; preds = %for.cond1
  %4 = load i32* %i, align 4
  %5 = load i32* %n.addr, align 4
  %mul = mul nsw i32 %4, %5
  %idxprom = sext i32 %mul to i64
  %6 = load double** %A.addr, align 8
  %arrayidx = getelementptr inbounds double* %6, i64 %idxprom
  %7 = load i32* %j, align 4
  %idxprom4 = sext i32 %7 to i64
  %8 = load double** %B.addr, align 8
  %arrayidx5 = getelementptr inbounds double* %8, i64 %idxprom4
  %9 = load i32* %n.addr, align 4
  %call = call double @dotproduct_c(double* %arrayidx, double* %arrayidx5, i32 %9)
  %10 = load i32* %i, align 4
  %11 = load i32* %n.addr, align 4
  %mul6 = mul nsw i32 %10, %11
  %12 = load i32* %j, align 4
  %add = add nsw i32 %mul6, %12
  %idxprom7 = sext i32 %add to i64
  %13 = load double** %C.addr, align 8
  %arrayidx8 = getelementptr inbounds double* %13, i64 %idxprom7
  store double %call, double* %arrayidx8, align 8
  br label %for.inc

for.inc:                                          ; preds = %for.body3
  %14 = load i32* %j, align 4
  %inc = add nsw i32 %14, 1
  store i32 %inc, i32* %j, align 4
  br label %for.cond1

for.end:                                          ; preds = %for.cond1
  br label %for.inc9

for.inc9:                                         ; preds = %for.end
  %15 = load i32* %i, align 4
  %inc10 = add nsw i32 %15, 1
  store i32 %inc10, i32* %i, align 4
  br label %for.cond

for.end11:                                        ; preds = %for.cond
  ret void
}
