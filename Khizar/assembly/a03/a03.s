.data
p: .word 3
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

recursive:
    addi x10, x10, -1
    jal x1, func
    add x7, x10, x7
    
    lw x10, 4(sp)
    addi x10, x10, -2
    addi x11, x0, 2
    jal x1, func
    jal x1, umul
    add x7, x10, x7
    
    lw x10, 4(sp)
    addi x10, x10, -3
    addi x11, x0, 3
    jal x1, func
    jal x1, umul
    add x7, x10, x7
    add x10, x7, x0
    
	ret
    
recur:
	addi sp, sp, -12
    sw x1, 0(sp)
    sw x10, 4(sp)
    sw x7, 8(sp)
    add x7, x0, x0
    jal x0, recursive
    lw x28, 8(sp)
    lw x10, 4(sp)
    lw x1, 0(sp)
    addi sp, sp, 12
    add x7, x7, x28
    add x10, x7, x0
	ret

func:
	addi x8, x10, -3
	bge x8, x0, recur
    ret
    
main:
	lw x10, p
    lw x11, q
    lw x12, r
    lw x13, s
    jal x1, func