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
   %temp1 = load i32* %lx
   %temp2 = sub i32 0, %temp1
   store i32 %temp2, i32* %lx
   %temp3 = load i32* %px.addr
   %temp4 = sub i32 0, %temp3
   store i32 %temp4, i32* %lx
   %temp5 = load i32* @gx
   %temp6 = sub i32 0, %temp5
   store i32 %temp6, i32* %lx
   store i32* %lx, i32** %lp
   store i32* @gx, i32** %lp
   store i32* %px.addr, i32** %lp
   %temp7 = load i32* %lx
   store i32 %temp7, i32* @gx
   %temp8 = load i32* %lx
   store i32 %temp8, i32* %px.addr
   %temp9 = load i32* %lx
   %temp10 = load i32** %lp
   store i32 %temp9, i32* %temp10
   %temp11 = load i32* %lx
   %temp12 = load i32** %lp
   store i32 %temp11, i32* %temp12
   %temp13 = load i32* %lx
   %temp14 = load i32** %pp.addr
   store i32 %temp13, i32* %temp14
   store i32* %lx, i32** %lp
   store i32* %lx, i32** @gp
   store i32* %lx, i32** %pp.addr
   %temp15 = load i32* %lx
   %temp16 = getelementptr inbounds [4 x [5 x i32]]* @ga, i32 0, i32 1, i32 2
   store i32 %temp15, i32* %temp16
   %temp17 = load i32* %lx
   %temp18 = load [3 x i32]** %pa.addr
   %temp19 = getelementptr inbounds [3 x i32]* %temp18, i32 1
   %temp20 = getelementptr inbounds [3 x i32]* %temp19, i32 0, i32 2
   store i32 %temp17, i32* %temp20
   %temp21 = load i32* %lx
   %temp22 = getelementptr inbounds [5 x [5 x i32]]* %la, i32 0, i32 1
   %temp23 = getelementptr inbounds [5 x i32]* %temp22, i32 0, i32 2
   store i32 %temp21, i32* %temp23
   ret i32 0
}
