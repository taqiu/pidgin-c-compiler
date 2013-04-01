; ModuleID = 'example3.c'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@x = common global i32 0, align 4
@xa = common global [4 x [5 x i32]] zeroinitializer, align 16
@ga = common global [2 x [4 x [4 x i32*]]] zeroinitializer, align 16
@y = common global i32 0, align 4
@d = common global double 0.000000e+00, align 8

define i32 @foo(i32 %i, [3 x i32*]* %da, [6 x [7 x i32]]* %da2) nounwind uwtable {
entry:
  %i.addr = alloca i32, align 4
  %da.addr = alloca [3 x i32*]*, align 8
  %da2.addr = alloca [6 x [7 x i32]]*, align 8
  %a = alloca i32, align 4
  %b = alloca i32, align 4
  %c = alloca [5 x i32], align 16
  %pr = alloca i32*, align 8
  %ar = alloca [2 x [2 x [3 x i32]]], align 16
  %d = alloca double, align 8
  store i32 %i, i32* %i.addr, align 4
  store [3 x i32*]* %da, [3 x i32*]** %da.addr, align 8
  store [6 x [7 x i32]]* %da2, [6 x [7 x i32]]** %da2.addr, align 8
  store i32 0, i32* %a, align 4
  %0 = load i32* @x, align 4
  store i32 %0, i32* %a, align 4
  %1 = load i32* %i.addr, align 4
  store i32 %1, i32* %a, align 4
  %2 = load i32* %b, align 4
  store i32 %2, i32* %a, align 4
  %3 = load i32* getelementptr inbounds ([4 x [5 x i32]]* @xa, i32 0, i64 1, i64 2), align 4
  store i32 %3, i32* %a, align 4
  %4 = load [6 x [7 x i32]]** %da2.addr, align 8
  %arrayidx = getelementptr inbounds [6 x [7 x i32]]* %4, i64 2
  %arrayidx1 = getelementptr inbounds [6 x [7 x i32]]* %arrayidx, i32 0, i64 3
  %arrayidx2 = getelementptr inbounds [7 x i32]* %arrayidx1, i32 0, i64 4
  %5 = load i32* %arrayidx2, align 4
  store i32 %5, i32* %a, align 4
  %6 = load i32** getelementptr inbounds ([2 x [4 x [4 x i32*]]]* @ga, i32 0, i64 1, i64 2, i64 2), align 8
  %7 = load i32* %6, align 4
  store i32 %7, i32* %a, align 4
  %arrayidx3 = getelementptr inbounds [5 x i32]* %c, i32 0, i64 2
  %8 = load i32* %arrayidx3, align 4
  store i32 %8, i32* %a, align 4
  %9 = load [3 x i32*]** %da.addr, align 8
  %arrayidx4 = getelementptr inbounds [3 x i32*]* %9, i64 1
  %arrayidx5 = getelementptr inbounds [3 x i32*]* %arrayidx4, i32 0, i64 2
  %10 = load i32** %arrayidx5, align 8
  %11 = load i32* %10, align 4
  %conv = sitofp i32 %11 to double
  store double %conv, double* %d, align 8
  %arrayidx6 = getelementptr inbounds [2 x [2 x [3 x i32]]]* %ar, i32 0, i64 1
  %arrayidx7 = getelementptr inbounds [2 x [3 x i32]]* %arrayidx6, i32 0, i64 1
  %arrayidx8 = getelementptr inbounds [3 x i32]* %arrayidx7, i32 0, i64 2
  %12 = load i32* %arrayidx8, align 4
  store i32 %12, i32* %a, align 4
  %13 = load i32** %pr, align 8
  %14 = load i32* %13, align 4
  store i32 %14, i32* %a, align 4
  %15 = load i32** %pr, align 8
  %16 = load i32* %15, align 4
  %add = add nsw i32 %16, 1
  store i32 %add, i32* %b, align 4
  %17 = load i32* @x, align 4
  %18 = load i32** %pr, align 8
  store i32 %17, i32* %18, align 4
  %19 = load i32* %a, align 4
  %20 = load i32* %b, align 4
  %add9 = add nsw i32 %19, %20
  %add10 = add nsw i32 %add9, 3
  %21 = load i32* %a, align 4
  %div = sdiv i32 %21, 4
  %add11 = add nsw i32 %add10, %div
  %22 = load i32* %b, align 4
  %mul = mul nsw i32 8, %22
  %sub = sub nsw i32 %add11, %mul
  store i32 %sub, i32* @x, align 4
  %23 = load i32* %a, align 4
  %add12 = add nsw i32 %23, 8
  %add13 = add nsw i32 %add12, 1
  %conv14 = sitofp i32 %add13 to double
  store double %conv14, double* %d, align 8
  %24 = load i32* %a, align 4
  ret i32 %24
}
