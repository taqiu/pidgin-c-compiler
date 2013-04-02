; ModuleID = 'example6.c'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

define i32 @foo() nounwind uwtable {
entry:
  %i = alloca i32, align 4
  %d = alloca double, align 8
  %0 = load i32* %i, align 4
  %conv = sitofp i32 %0 to double
  store double %conv, double* %d, align 8
  %1 = load i32* %i, align 4
  %conv1 = sitofp i32 %1 to double
  %call = call i32 @bar(double %conv1)
  %conv2 = sitofp i32 %call to double
  store double %conv2, double* %d, align 8
  %2 = load i32* %i, align 4
  ret i32 %2
}

define i32 @bar(double %x) nounwind uwtable {
entry:
  %x.addr = alloca double, align 8
  store double %x, double* %x.addr, align 8
  ret i32 0
}
