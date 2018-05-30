# Jack Gularte and Anthony Caballero 
# ECEGR 2200 - Microprocessor Design 
# May 14th, 2018


.data

.text

main:
	li t0, 0x0123abc0	# set t0 to 0x0123abc0
	li t1, 0x011df001	# set t1 to 0x011df001
	
	
	add s0, t0, t1		# test the adder
				# result: s0 = 0x2419bc1
	
	addi s1, t0, 0x00000011	# testing addi function by adding 3
				# result: 0x0123abd1

	li t1, 0x11223344	# load negative number
	sub s2, t0, t1		# testing sub function
				# result: 
				
	li t1, 0x00000001	# load 1 into register
	sll s3, t0, t1		# testing shift left function
				# result: 0x02475780
	
	li t1, 0x00000001	# load 1 into register
	srl s4, t0, t1		# testing shift right function
				# result: 0x0091d5e0
	
	li t1, 0xa0253b40	# load 0xa0253b40 into register
	and s5, t0, t1		# testing and function
				# result: 0x00212b40
	
	andi s6, t0, 0x00000010	# testing andi function
				# result: 0x00000000
	
	li t1, 0x11223344	# load 0x038cd840
	or s7, t0, t1		# testing or function
				# result: 0x1123bbc4

	ori s8, t0, 0x00000010	# testing ori function
				# result: 0x0123abd0
				
	li a7, 10
	ecall
	
	li a7, 10
	ecall