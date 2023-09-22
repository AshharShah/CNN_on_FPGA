addi x10, x0, 5
addi sp, x0, 200
addi x1, x0, 120
addi sp, sp, -16
sw x1, (12)sp
sw x10, (8)sp
addi x11, x0, 1
sw x11, (4)sp             
addi x11, x11, 1          
sw x11, (0)sp
lw x12, (8)sp
add x11, x12, x12
add x11, x11, x12
lw x12, (4)sp
lw x12, (0)sp
add x11, x11, x12
lw x14, (12)sp

#sp=184
#200
#196            120
#192            5
#188            1
#184 -->        2
#180
#176