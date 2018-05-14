.data

far: 		.float	#fahrenheit	
con1:	.float	32.00
con2:	.float	5.0
con3:	.float	9.0
con4: 	.float 	273.15

str1:	.asciz	"Enter Fahrenheit: "
str2:	.asciz	"Celsius: "
str3:	.asciz	"\nKelvin: "	


.text

main:

li	a7, 4
la	a0, str1
ecall

li	a7, 6			#read a flow from input console, fa0 = float
fadd.s	fa0, f, f0		#load fahrenheit into f0
ecall
jal	formula

fadd.s	f0, f8, fa0
fadd.s	f1, f8, fa1

li	a7, 4
la	a0, str2
ecall

li	a7, 2
fadd.s	fa0, f0, f8
ecall

li	a7, 4
la	a0, str3
ecall

li	a7, 2
fadd.s	fa0, f1, f8
ecall

li	a7,10
ecall

formula:		
flw		f0, con1, t0  		#store 32 
fsub.s		f1,  fa0, f0		#fahrenheit - 32
flw		f2, con2, t0		#store 5
fmul.s		f3, f1, f2		#(fahrenheit -32)*5
flw		f4, con3, t0		#store 9
fdiv.s		f5, f3, f4		#(fahrenheit -32)*5/9 , f5=celsius
flw		f6, con4, t0		#store 273.15
fadd.s		f7, f5, f6		#celsius + 273.15, 
fadd.s		fa0, f8, f7		#return kelvin
fadd.s		fa1, f8, f5		#return celsius
jr		ra, 0 
