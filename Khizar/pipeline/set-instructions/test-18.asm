addi sp, x0, 200
jal x0, main

calc:
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
    sw x11, (0)sp

    addi x13, x13, 1
    bge x10, x13, calc

    lw x1, (12)sp
    add x10, x11, x0
	ret

f:
	addi sp, sp, -16
    sw x1, (12)sp
    sw x0, (8)sp
    addi x11, x0, 1
    sw x11, (4)sp
    addi x11, x11, 1
    sw x11, (0)sp

    addi x13, x0, 3
    bge x10, x13, calc

main:
	addi x10, x0, 7
    jal x1, f

# sp = 184 se 200
# address     value
# 196       120 (x1 last line)
# 192       0    
# 188       1       
# 184       2
