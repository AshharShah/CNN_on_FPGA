label1:
addi x1, x0, 1
addi x2, x1, 1
addi x3, x2, 1
beq  x2, x3, label1
sw   x3, 0(x0)
sw   x2, 4(x0)
sw   x1, 8(x0)
lw   x4, 8(x0)
lw   x5, 4(x0)
lw   x6, 0(x0)
addi x4, x4, 0
addi x5, x5, 0
addi x5, x5, 0