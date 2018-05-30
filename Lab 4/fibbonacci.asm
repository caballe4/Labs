.data

a:	.word	0
b:	.word	0
c:	.word 	0

.text
main:

addi	a2, x0, 3 	# perform fibonacci(3)
jal	fibonacci 	# 
sw	a0, a, t6	# store fib(3) into a

addi	a2, x0, 10 	# peform fibonacci(10)
jal	fibonacci 		# 
sw	a0, b, t6	# store fib(10) into b

addi	a2, x0, 20 	# perform fibonacci(20)
jal	fibonacci 	#
sw	a0, c, t6	# store fib(20) into c

li 	a7, 10
ecall

fibonacci:

addi 	sp, sp, -12	# grow down stack
sw 	ra, 0(sp)	# store return address
sw 	s0, 4(sp)	
sw 	s1, 8(sp)

add 	s0, a2, x0	# store parameter into new register
addi	t1, x0, 1	# store 1 into register
beq 	s0, x0, if0	# if parameter is equal to 0 jump
beq 	s0, t1, if1	# if parameter is equal to 1 jump

addi 	a2, s0, -1	
jal 	fibonacci
add 	s1, x0, a0	# store fib(n - 1)
addi 	a2, s0, -2
jal 	fibonacci		
add 	a0, a0, s1      # store fib(n - 2)

exit:
lw 	ra, 0(sp)       # restore registers from stack
lw 	s0, 4(sp)
lw 	s1, 8(sp)
addi 	sp, sp, 12	# pop off stack pointer
jr 	ra, 0

if1:
li	a0, 1		# return 1
j	exit

if0 :     
li 	a0, 0		# return 0
j	exit

