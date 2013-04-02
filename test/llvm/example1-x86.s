	.file	"example1-me.s"
	.type	i,@object               # @i
	.comm	i,4,4
	.type	j,@object               # @j
	.comm	j,4,4
	.type	k,@object               # @k
	.comm	k,4,4
	.type	pr,@object              # @pr
	.comm	pr,8,8
	.type	a,@object               # @a
	.comm	a,84,16
	.type	c,@object               # @c
	.comm	c,96,16
	.type	d,@object               # @d
	.comm	d,8,8
	.type	pd,@object              # @pd
	.comm	pd,8,8
	.type	ppd,@object             # @ppd
	.comm	ppd,32,16
	.type	ad,@object              # @ad
	.comm	ad,2592,16
	.type	str,@object             # @str
	.comm	str,8,8
	.type	str1,@object            # @str1
	.comm	str1,40,16
	.type	s,@object               # @s
	.comm	s,1,1

	.section	".note.GNU-stack","",@progbits
