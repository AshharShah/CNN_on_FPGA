.data
a: .word 23 # f(27) cannot be stored in a word

.globl main

.text

calc:
	#calc next number using previous three
  	#f(3) = f(2) + 2*f(1) + 3*f(0) = (8)sp + 2*[(4)sp] + 3*[(0)sp]
	lw x12, (8)sp
    add x11, x12, x12
    add x11, x11, x12
    lw x12, (4)sp
    add x11, x11, x12
    add x11, x11, x12
    lw x12, (0)sp
    add x11, x11, x12
    
    lw x14, (12)sp
    sw x14, (8)sp
    
    addi sp, sp, -4
    sw x11, (0)sp	# store f(x13) and move ahead
    
    
    addi x13, x13, 1 # increment counter (x13)
    bge x10, x13, calc
    
    lw x1, (12)sp
    add x10, x11, x0
	ret
    
f:
	# store 0, 1, 2 in stack
	addi sp, sp, -16
    sw x1, (12)sp # store x1 in sp
    sw x0, (8)sp
    addi x11, x0, 1
    sw x11, (4)sp
    addi x11, x11, 1
    sw x11, (0)sp

    addi x13, x0, 3 # x13 is counter. initially 3
    bge x10, x13, calc
    
main:
	lw x10, a
    jal x1, f
    
#----------------SOME BRAINSTORMING HERE------------------------------------
#stack
#.		return to main
#.	0	return to main
#.	1	return to main
#.  2           ......
#	4	
#	11	<----- sp
#
#