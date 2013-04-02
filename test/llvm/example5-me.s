@gx = common global i32 0
@gp = common global i32* null
@ga = common global [4 x [5 x i32]] zeroinitializer

define i32 @foo(i32 %px, i32* %pp, [3 x i32]* %pa) {
   %pa.addr = alloca [3 x i32]*
   store [3 x i32]* %pa, [3 x i32]** %pa.addr
   %pp.addr = alloca i32*
   store i32* %pp, i32** %pp.addr
   %px.addr = alloca i32
   store i32 %px, i32* %px.addr
   %lx = alloca i32
   %lp = alloca i32*
   %la = alloca [5 x [5 x i32]]
   %temp0 = load i32* %lx
   %temp1 = sub i32 0, %temp0
   store i32 %temp1, i32* %lx
   %temp2 = load i32* %px.addr
   %temp3 = sub i32 0, %temp2
   store i32 %temp3, i32* %lx
   %temp4 = load i32* @gx
   %temp5 = sub i32 0, %temp4
   store i32 %temp5, i32* %lx
   store i32* %lx, i32** %lp
   store i32* @gx, i32** %lp
   store i32* %px.addr, i32** %lp
   %temp6 = load i32* %lx
   store i32 %temp6, i32* @gx
   %temp7 = load i32* %lx
   store i32 %temp7, i32* %px.addr
   %temp8 = load i32* %lx
   %temp9 = load i32** %lp
   store i32 %temp8, i32* %temp9
   %temp10 = load i32* %lx
   %temp11 = load i32** %lp
   store i32 %temp10, i32* %temp11
   %temp12 = load i32* %lx
   %temp13 = load i32** %pp.addr
   store i32 %temp12, i32* %temp13
   store i32* %lx, i32** %lp
   store i32* %lx, i32** @gp
   store i32* %lx, i32** %pp.addr
   %temp14 = load i32* %lx
   %temp15 = getelementptr inbounds [4 x [5 x i32]]* @ga, i32 0, i32 1, i32 2
   store i32 %temp14, i32* %temp15
   %temp16 = load i32* %lx
   %temp17 = load [3 x i32]** %pa.addr
   %temp18 = getelementptr inbounds [3 x i32]* %temp17, i32 1
   %temp19 = getelementptr inbounds [3 x i32]* %temp18, i32 0, i32 2
   store i32 %temp16, i32* %temp19
   %temp20 = load i32* %lx
   %temp21 = getelementptr inbounds [5 x [5 x i32]]* %la, i32 0, i32 1
   %temp22 = getelementptr inbounds [5 x i32]* %temp21, i32 0, i32 2
   store i32 %temp20, i32* %temp22
   ret i32 0
}
