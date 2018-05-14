.data

f: 		.float	#fahrenheit	
con1:	.float	32.00
con2:	.float	5.0
con3:	.float	9.0
con4: 	.float 	273.15

str1:	.asciz	"Enter Fahrenheit: "
str2:	.asciz	"\nCelsius: "
str3:	.asciz	"Kelvin: "	


.text

main:

li	a7, 4			# load imm. 4
la	a0, str1		# load initating string
ecall

li	a7, 6			# fa0 = float
fadd.s	fa0, f, f0		# load fahrenheit into f0
ecall
jal	formula

fadd.s	f0, f8, fa0
fadd.s	f1, f8, fa1

li	a7, 4
la	a0, str3
ecall

li	a7, 2
fadd.s	fa1, f0, f8
ecall

li	a7, 4
la	a0, str2
ecall

li	a7, 2
fadd.s	fa0, f1, f8
ecall

li	a7,10
ecall

formula:		
flw		f0, con1, t0  	# load 32 from constants
flw		f2, con2, t0	# load 5 from constants
flw		f4, con3, t0	# load 9 from constants
flw		f6, con4, t0	# load 273.15 from constants

fsub.s		f1,  fa0, f0	# farenheight - 32
fmul.s		f3, f1, f2	# (far -32)*5
fdiv.s		f5, f3, f4	# (far -32)*5/9
fadd.s		fa1, f8, f5	# get ready to return celcius

fadd.s		f7, f5, f6	# (far -32)*5/9 +273.15
fadd.s		fa0, f8, f7	# get ready to return kelvin

jr		ra, 0 		# return
