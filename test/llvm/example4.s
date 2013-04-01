; ModuleID = 'example4.c'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

define i32 @foo() nounwind uwtable {
entry:
  %b = alloca double, align 8
  %c = alloca double, align 8
  %a = alloca [9 x [7 x i32]], align 16
  %x = alloca [2 x i32], align 4
  call void @bar(i32 9)
  %0 = load double* %b, align 8
  %1 = load double* %c, align 8
  %add = fadd double %0, %1
  %arraydecay = getelementptr inbounds [9 x [7 x i32]]* %a, i32 0, i32 0
  %arraydecay1 = getelementptr inbounds [2 x i32]* %x, i32 0, i32 0
  %call = call double @buz(double %add, i32 4, [7 x i32]* %arraydecay, i32* %arraydecay1)
  store double %call, double* %b, align 8
  ret i32 0
}

define void @bar(i32 %i) nounwind uwtable {
entry:
  %i.addr = alloca i32, align 4
  store i32 %i, i32* %i.addr, align 4
  ret void
}

define double @buz(double %x, i32 %y, [7 x i32]* %a, i32* %b) nounwind uwtable {
entry:
  %x.addr = alloca double, align 8
  %y.addr = alloca i32, align 4
  %a.addr = alloca [7 x i32]*, align 8
  %b.addr = alloca i32*, align 8
  store double %x, double* %x.addr, align 8
  store i32 %y, i32* %y.addr, align 4
  store [7 x i32]* %a, [7 x i32]** %a.addr, align 8
  store i32* %b, i32** %b.addr, align 8
  ret double 0.000000e+00
}
