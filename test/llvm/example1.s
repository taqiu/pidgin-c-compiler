; ModuleID = 'example1.c'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@i = common global i32 0, align 4
@j = common global i32 0, align 4
@k = common global i32 0, align 4
@pr = common global i32* null, align 8
@a = common global [7 x [3 x i32]] zeroinitializer, align 16
@c = common global [3 x [4 x i32*]] zeroinitializer, align 16
@d = common global double 0.000000e+00, align 8
@pd = common global double* null, align 8
@ppd = common global [4 x double*] zeroinitializer, align 16
@ad = common global [3 x [3 x [6 x [6 x double]]]] zeroinitializer, align 16
@str = common global i8* null, align 8
@str1 = common global [40 x i8] zeroinitializer, align 16
@s = common global i8 0, align 1
