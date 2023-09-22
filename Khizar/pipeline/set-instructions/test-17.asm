nop                     # 0
nop                     # 4
nop                     # 8
nop                     # 12
addi x13, x0, 30        # 16
addi x12, x0, 10        # 20
addi x11, x0, 1         # 24
jal  x1, label          # 28
label2:                 
addi x14, x0, 14        # 32
addi x15, x0, 15        # 36
addi x16, x0, 16        # 40
jalr x0, x1,  0         # 44
label:
addi x11, x11, 1        # 48
bne  x11, x12, label    # 52
jal  x1, label2         # 56
label3:
addi x12, x12, 10       # 60
beq x12, x13, label4    # 64
jal  x1, label          # 68
label4:                 
                        # 72