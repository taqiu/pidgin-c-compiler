; ModuleID = 'example.c'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@gx = common global i32 0, align 4
@gy = common global i32 0, align 4
@ga = common global [6 x [6 x i32]] zeroinitializer, align 16
@gd = common global double 0.000000e+00, align 8

define double @foo() nounwind uwtable {
entry:
  %lx = alloca i32, align 4
  %ly = alloca i32, align 4
  %la = alloca [6 x [6 x i32]], align 16
  %ld = alloca double, align 8
  store i32 1, i32* %lx, align 4
  store i32 2, i32* %ly, align 4
  store i32 3, i32* @gx, align 4
  store i32 4, i32* @gy, align 4
  store i32 5, i32* getelementptr inbounds ([6 x [6 x i32]]* @ga, i32 0, i64 4, i64 4), align 4
  %arrayidx = getelementptr inbounds [6 x [6 x i32]]* %la, i32 0, i64 3
  %arrayidx1 = getelementptr inbounds [6 x i32]* %arrayidx, i32 0, i64 3
  store i32 6, i32* %arrayidx1, align 4
  %0 = load i32* %lx, align 4
  %arrayidx2 = getelementptr inbounds [6 x [6 x i32]]* %la, i32 0, i64 3
  %arrayidx3 = getelementptr inbounds [6 x i32]* %arrayidx2, i32 0, i64 3
  %1 = load i32* %arrayidx3, align 4
  %arraydecay = getelementptr inbounds [6 x [6 x i32]]* %la, i32 0, i32 0
  call void @add(i32 %0, i32 %1, [6 x i32]* %arraydecay)
  %2 = load i32* @gx, align 4
  %3 = load i32* getelementptr inbounds ([6 x [6 x i32]]* @ga, i32 0, i64 4, i64 4), align 4
  call void @add(i32 %2, i32 %3, [6 x i32]* getelementptr inbounds ([6 x [6 x i32]]* @ga, i32 0, i32 0))
  %4 = load i32* %ly, align 4
  %call = call double @mult([6 x i32]* getelementptr inbounds ([6 x [6 x i32]]* @ga, i32 0, i32 0), i32 %4)
  store double %call, double* %ld, align 8
  %5 = load double* %ld, align 8
  %arrayidx4 = getelementptr inbounds [6 x [6 x i32]]* %la, i32 0, i64 0
  %arrayidx5 = getelementptr inbounds [6 x i32]* %arrayidx4, i32 0, i64 0
  %6 = load i32* %arrayidx5, align 4
  %mul = mul nsw i32 %6, 2
  %conv = sitofp i32 %mul to double
  %add = fadd double %5, %conv
  %7 = load i32* getelementptr inbounds ([6 x [6 x i32]]* @ga, i32 0, i64 0, i64 0), align 4
  %add6 = add nsw i32 %7, 4
  %conv7 = sitofp i32 %add6 to double
  %div = fdiv double %conv7, 2.000000e+00
  %add8 = fadd double %add, %div
  %8 = load i32* @gy, align 4
  %conv9 = sitofp i32 %8 to double
  %sub = fsub double %add8, %conv9
  store double %sub, double* @gd, align 8
  %9 = load double* @gd, align 8
  ret double %9
}

define void @add(i32 %x, i32 %y, [6 x i32]* %a) nounwind uwtable {
entry:
  %x.addr = alloca i32, align 4
  %y.addr = alloca i32, align 4
  %a.addr = alloca [6 x i32]*, align 8
  store i32 %x, i32* %x.addr, align 4
  store i32 %y, i32* %y.addr, align 4
  store [6 x i32]* %a, [6 x i32]** %a.addr, align 8
  %0 = load i32* %x.addr, align 4
  %1 = load i32* %y.addr, align 4
  %add = add nsw i32 %0, %1
  %2 = load [6 x i32]** %a.addr, align 8
  %arrayidx = getelementptr inbounds [6 x i32]* %2, i64 0
  %arrayidx1 = getelementptr inbounds [6 x i32]* %arrayidx, i32 0, i64 0
  store i32 %add, i32* %arrayidx1, align 4
  ret void
}

define double @mult([6 x i32]* %a, i32 %b) nounwind uwtable {
entry:
  %a.addr = alloca [6 x i32]*, align 8
  %b.addr = alloca i32, align 4
  %re = alloca double, align 8
  store [6 x i32]* %a, [6 x i32]** %a.addr, align 8
  store i32 %b, i32* %b.addr, align 4
  %0 = load i32* %b.addr, align 4
  %conv = sitofp i32 %0 to double
  %add = fadd double 7.000000e-01, %conv
  store double %add, double* @gd, align 8
  %1 = load [6 x i32]** %a.addr, align 8
  %arrayidx = getelementptr inbounds [6 x i32]* %1, i64 4
  %arrayidx1 = getelementptr inbounds [6 x i32]* %arrayidx, i32 0, i64 4
  %2 = load i32* %arrayidx1, align 4
  %conv2 = sitofp i32 %2 to double
  %3 = load double* @gd, align 8
  %mul = fmul double %conv2, %3
  store double %mul, double* %re, align 8
  %4 = load double* %re, align 8
  ret double %4
}
