nop
nop
nop
nop
addi x10, x0, 10        # 0 + 10 = 10
nop
nop
nop
nop
addi x15, x0, 14        # 0 + 14 = 14
nop
nop
nop
nop
sub x11, x15, x10       # 14 - 10 = 4
nop
nop
nop
nop
xor x12, x10, x11       # 1010 xor 0100 = 1110 = 14
nop
nop
nop
nop
sub x13, x11, x10       # 4 - 10 = -6
nop
nop
nop
nop
or x14, x11, x13        # 4 or -6 = 0100 or 1010 = 1110 => 0010 => -2
nop
nop
nop
nop
and x15, x10, x13       # 10 and -6 = 01010 and 1010 = 01010 = 10
nop
nop
nop
nop
sub x16, x14, x13       # -2 - (-6) = 4
nop
nop
nop
nop