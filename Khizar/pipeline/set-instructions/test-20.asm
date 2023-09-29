addi x3, x0, 0x100 		# x3 = 0x100 = 16^2 = 256 decimal
addi x4, x0, 50			# x4 = 10			  
addi x1, x0, 0

loop: beq x1 x4 next
slli x2 x1 2			# x2 = 0 << 2 becomes 0 (4)
add x2 x2 x3			# x2 = base + 0			(b+4)
sw x1 0(x2)				# x1 = 0 ---> stack		(4)
addi x1 x1 1			# x1 = 1				
jal x0 loop				# x0 stores line 14

next: addi x6 x0 0 			# Stores Sum
addi x1 x0 0			# x1 = 0

loop1: beq x1 x4 store
slli x2 x1 2
add x2 x2 x3
lw x7 0(x2)
add x6 x6 x7
addi x1 x1 1
jal x0 loop1

store: slli x2 x1 2			# 1 << 2 becomes 4
add x2 x2 x3			# x2 = base + 4
sw x6 0(x2)				# x6 Stores Sum --> Sum is stored in stack

# 	Data Memory
# 	0x100 + 0				0
#	0x100 + 4				1
#	0x100 + 8				2
#	0x100 + 12				3
#	...
#	0x100 + 36				9
#	0x100 + 40 				Stores Sum (Must be 0+1+2+...+9=45)