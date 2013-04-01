; ModuleID = 'example2.c'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@i = common global i32 0, align 4
@j = common global i32 0, align 4
@f = common global double 0.000000e+00, align 8

define i32 @foo(i32 %r, double %t, i8* %xd, i8* %xx, [8 x double]* %o, [3 x [5 x i8*]]* %sp, i8* %sp1, i32* %xp) nounwind uwtable {
entry:
  %r.addr = alloca i32, align 4
  %t.addr = alloca double, align 8
  %xd.addr = alloca i8*, align 8
  %xx.addr = alloca i8*, align 8
  %o.addr = alloca [8 x double]*, align 8
  %sp.addr = alloca [3 x [5 x i8*]]*, align 8
  %sp1.addr = alloca i8*, align 8
  %xp.addr = alloca i32*, align 8
  %i = alloca i32, align 4
  %pr = alloca i32*, align 8
  %a = alloca [7 x [3 x i32]], align 16
  %c = alloca [3 x [4 x i32*]], align 16
  %d = alloca double, align 8
  %a1 = alloca [10 x double], align 16
  %pd = alloca double*, align 8
  %ppd = alloca [4 x double*], align 16
  %ad = alloca [3 x [3 x [6 x [6 x double]]]], align 16
  %str = alloca i8*, align 8
  %str1 = alloca [40 x i8], align 16
  %s = alloca i8, align 1
  store i32 %r, i32* %r.addr, align 4
  store double %t, double* %t.addr, align 8
  store i8* %xd, i8** %xd.addr, align 8
  store i8* %xx, i8** %xx.addr, align 8
  store [8 x double]* %o, [8 x double]** %o.addr, align 8
  store [3 x [5 x i8*]]* %sp, [3 x [5 x i8*]]** %sp.addr, align 8
  store i8* %sp1, i8** %sp1.addr, align 8
  store i32* %xp, i32** %xp.addr, align 8
  %0 = load i32* %i, align 4
  ret i32 %0
}

define void @bar(double %x) nounwind uwtable {
entry:
  %x.addr = alloca double, align 8
  %i = alloca double, align 8
  store double %x, double* %x.addr, align 8
  %0 = load double* %x.addr, align 8
  %add = fadd double %0, 9.000000e+00
  store double %add, double* %i, align 8
  ret void
}
