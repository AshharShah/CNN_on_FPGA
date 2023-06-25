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

umul:
	addi x11, x11, -1
    add x12, x0, x0
	add x5, x11, x0
    bge x5, x0, loop
    ret

main:
	lw x10, p
    lw x11, q
    lw x12, r
    lw x13, s
    jal x1, umul
    