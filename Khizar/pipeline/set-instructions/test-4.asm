nop
nop
nop
nop
addi x10, x0, 1
nop
nop
nop
nop
addi x11, x10, 1
nop
nop
nop
nop
beq x10, x11, label
nop
nop
nop
nop
addi x12, x10, 2
nop
nop
nop
nop
sw x10, 0(x0)
nop
nop
nop
nop
addi x13, x10, 3
nop
nop
nop
nop
add x14, x13, x11
nop
nop
nop
nop
addi x15, x14, 0
nop
nop
nop
nop
sub x16, x15, x11
nop
nop
nop
nop
addi x17, x16, 0
nop
nop
nop
nop
sw x11, 0(x0)
nop
nop
nop
nop
sw x12, 4(x0)
nop
nop
nop
nop
label:
lw x18, 4(x0)
nop
nop
nop
nop
addi x19, x18, 0
nop
nop
nop
nop
and x20, x10, x18
nop
nop
nop
nop
addi x23, x20, 0
nop
nop
nop
nop
or x21, x11, x16
nop
nop
nop
nop
addi x24, x21, 0
nop
nop
nop
nop
xor x22, x14, x17
nop
nop
nop
nop
addi x25, x22, 0
nop
nop
nop
nop
nop
lw x26, 4(x0)
nop
nop
nop
nop