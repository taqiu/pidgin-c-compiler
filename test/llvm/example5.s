; ModuleID = 'example5.c'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@gx = common global i32 0, align 4
@gp = common global i32* null, align 8
@ga = common global [4 x [5 x i32]] zeroinitializer, align 16

define i32 @foo(i32 %px, i32* %pp, [3 x i32]* %pa) nounwind uwtable {
entry:
  %px.addr = alloca i32, align 4
  %pp.addr = alloca i32*, align 8
  %pa.addr = alloca [3 x i32]*, align 8
  %lx = alloca i32, align 4
  %lp = alloca i32*, align 8
  %la = alloca [5 x [5 x i32]], align 16
  store i32 %px, i32* %px.addr, align 4
  store i32* %pp, i32** %pp.addr, align 8
  store [3 x i32]* %pa, [3 x i32]** %pa.addr, align 8
  %0 = load i32* %lx, align 4
  %sub = sub nsw i32 0, %0
  store i32 %sub, i32* %lx, align 4
  %1 = load i32* %px.addr, align 4
  %sub1 = sub nsw i32 0, %1
  store i32 %sub1, i32* %lx, align 4
  %2 = load i32* @gx, align 4
  %sub2 = sub nsw i32 0, %2
  store i32 %sub2, i32* %lx, align 4
  store i32* %lx, i32** %lp, align 8
  store i32* @gx, i32** %lp, align 8
  store i32* %px.addr, i32** %lp, align 8
  %3 = load i32* %lx, align 4
  store i32 %3, i32* @gx, align 4
  %4 = load i32* %lx, align 4
  store i32 %4, i32* %px.addr, align 4
  %5 = load i32* %lx, align 4
  %6 = load i32** %lp, align 8
  store i32 %5, i32* %6, align 4
  %7 = load i32* %lx, align 4
  %8 = load i32** %lp, align 8
  store i32 %7, i32* %8, align 4
  %9 = load i32* %lx, align 4
  %10 = load i32** %pp.addr, align 8
  store i32 %9, i32* %10, align 4
  store i32* %lx, i32** %lp, align 8
  store i32* %lx, i32** @gp, align 8
  store i32* %lx, i32** %pp.addr, align 8
  %11 = load i32* %lx, align 4
  store i32 %11, i32* getelementptr inbounds ([4 x [5 x i32]]* @ga, i32 0, i64 1, i64 2), align 4
  %12 = load i32* %lx, align 4
  %13 = load [3 x i32]** %pa.addr, align 8
  %arrayidx = getelementptr inbounds [3 x i32]* %13, i64 1
  %arrayidx3 = getelementptr inbounds [3 x i32]* %arrayidx, i32 0, i64 2
  store i32 %12, i32* %arrayidx3, align 4
  %14 = load i32* %lx, align 4
  %arrayidx4 = getelementptr inbounds [5 x [5 x i32]]* %la, i32 0, i64 1
  %arrayidx5 = getelementptr inbounds [5 x i32]* %arrayidx4, i32 0, i64 2
  store i32 %14, i32* %arrayidx5, align 4
  ret i32 0
}
