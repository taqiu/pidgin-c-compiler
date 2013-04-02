@i = common global i32 0
@j = common global i32 0
@f = common global double 0.000000e+00

define i32 @foo(i32 %r, double %t, i8* %xd, i8* %xx, [8 x double]* %o, [3 x [5 x i8*]]* %sp, i8* %sp1, i32* %xp) {
   %sp.addr = alloca [3 x [5 x i8*]]*
   store [3 x [5 x i8*]]* %sp, [3 x [5 x i8*]]** %sp.addr
   %xp.addr = alloca i32*
   store i32* %xp, i32** %xp.addr
   %o.addr = alloca [8 x double]*
   store [8 x double]* %o, [8 x double]** %o.addr
   %xx.addr = alloca i8*
   store i8* %xx, i8** %xx.addr
   %xd.addr = alloca i8*
   store i8* %xd, i8** %xd.addr
   %t.addr = alloca double
   store double %t, double* %t.addr
   %r.addr = alloca i32
   store i32 %r, i32* %r.addr
   %sp1.addr = alloca i8*
   store i8* %sp1, i8** %sp1.addr
   %i = alloca i32
   %pr = alloca i32*
   %a = alloca [7 x [3 x i32]]
   %c = alloca [3 x [4 x i32*]]
   %d = alloca double
   %a1 = alloca [10 x double]
   %pd = alloca double*
   %ppd = alloca [4 x double*]
   %ad = alloca [3 x [3 x [6 x [6 x double]]]]
   %str = alloca i8*
   %str1 = alloca [40 x i8]
   %s = alloca i8
   %temp0 = load i32* %i
   ret i32 %temp0
}

define void @bar(double %x) {
   %x.addr = alloca double
   store double %x, double* %x.addr
   %i = alloca double
   %temp0 = load double* %x.addr
   %temp2 = sitofp i32 9 to double
   %temp1 = fadd double %temp0, %temp2
   store double %temp1, double* %i
   ret void
}
