addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x10, x0, 10        # 0 + 10 = 10
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x15, x0, 14        # 0 + 14 = 14
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
sub x11, x15, x10       # 14 - 10 = 4
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
xor x12, x10, x11       # 1010 xor 0100 = 1110 = 14
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
sub x13, x11, x10       # 4 - 10 = -6
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
or x14, x11, x13        # 4 or -6 = 0100 or 1010 = 1110 => 0010 => -2
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
and x15, x10, x13       # 10 and -6 = 01010 and 1010 = 01010 = 10
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
sub x16, x14, x13       # -2 - (-6) = 4
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0