.data
p: .word 5
q: .word 4
r: .word 7
s: .word 8
z: .word 4

.globl main

.text

sum:
	add x10, x10, x11
    add x10, x10, x12
    add x10, x10, x13
    ret

abc:
	add x10, x11, x0

max:
	bge x11, x10, abc
    ret
    
loop:
	add x12, x10, x12
    addi x5, x5, -1
    bge x5, x0, loop
    add x10, x12, x0
	ret

umul:
	addi x11, x11, -1
    add x12, x0, x0
	add x5, x11, x0
    bge x5, x0, loop
    ret
    
# l = line number
# f(5)
## x1  (fuuny)         
## x10 (5)
## x7  (11+8+6)   ---sp
##.x1 beta
##.x10 3
##.x7 4          --sp
# -------------f4
## x1  (alpha)         
## x10 (4)
## x7  (11)   ---sp
## ------------f3
## x1  (alpha)         
## x10 (3)
## x7  (4)
#----x10 = 25
#----x1  = fuuny
recursive:
	# x10 = n
    # x7 = f(n-1) + 2*f(n-2) + 3*f(n-3)
    
    # store return value x1 = func last line
    addi sp, sp, -12
    sw x1, 8(sp)
    
    # f(n-1)
    # f(n-1) will have its own x10 (n-1) and x7 so store these first
    sw x10, 4(sp)
    add x7, x0, x0
    sw x7, 0(sp)
    
    addi x10, x10, -1
    add x7, x0, x0
    jal x1, func # return value is in x10
    lw x7, 0(sp) # alpha
    add x7, x10, x7
    sw x7, 0(sp)
    
    lw x10, 4(sp)
    addi x10, x10, -2
    jal x1, func
    addi x11, x0, 2 # beta
    jal x1, umul
    lw x7, 0(sp)
    add x7, x10, x7
    sw x7, 0(sp)
    
    lw x10, 4(sp)
    addi x10, x10, -3
    jal x1, func 
    addi x11, x0, 3 # gamma
    jal x1, umul
    lw x7, 0(sp)
    add x7, x10, x7
    
    add x10, x7, x0
    lw x1, 8(sp)
    addi sp, sp, 12
    
	ret

func:
	addi x8, x10, -3 # n-3
	bge x8, x0, recursive # if (n-3)>0 [or n>3] then resursive; else return base case 'n' (x10) which can be 0, 1, or 2 (so f(0)=0, f(1)=1, f(2)=2)
    ret # funny
    
main:
	lw x10, p
    lw x11, q
    lw x12, r
    lw x13, s
    jal x1, func
    
# f(5) = f(4) + 2*f(3) + 3*f(2) = (f3 + 2f2 + 3f1) + 2(f2 + 2f1 + 3f0) + 3(2)
#                               = [(f2+2f1+3f0) + 2(2)+3(1)] + 2[2+2(1)+3(0)]+6
#								= [2+2(1)+3(0)  + 4   + 3]   + 2[2+2+0] + 6
#								= [2+2+0+4+3] + 2(4) + 6
#								= 11 + 8 + 6
#								= 25


#main ret = e8
#f5
#    jal x1, f4  so x1 = 64
#     running 11
#     ...
#     ...
#     jal x1, f3 so x1 = 7c
#f4
#    jal x1, f3  so x1 = 64
#.   running...stopped



#stack
#f0
#ec      ec
#e8      05
#e4      00 0b                     13              <----- sp
#e0      60          x  7c
#dc      04          x  03
#d8      00 04 08 0b x  00 02 04              <---- sp
#d4      60
#d0      03
#cc      00 02 04 00 ==> 4
#c8