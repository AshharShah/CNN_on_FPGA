nop
nop
nop
nop
addi x10, x0, 1    # 1  
addi x11, x10, 1   # 2
beq x10, x11, label  
addi x12, x10, 2   # 3  
sw x10, 0(x0)      # address 0 ---> 1
addi x13, x10, 3   # 4    
add x14, x13, x11  # 6
addi x15, x14, 0   # 6
sub x16, x15, x11  # 4 
addi x17, x16, 0   # 4
sw x11, 0(x0)      # address 0 ---> 2       
sw x12, 4(x0)      # address 4 ---> 3
label:
lw x18, 4(x0)      # 3    
addi x19, x18, 0   # 3   
and x20, x10, x18  # 1   
addi x23, x20, 0   # 1  
or x21, x11, x16   # 6     
addi x24, x21, 0   # 6     
xor x22, x14, x17  # 2     
addi x25, x22, 0   # 2    
lw x26, 4(x0)      # 3        
addi x27, x26, 0   # 3
lw x30, 0(x0)      # 2
addi x31, x30, 0   # 2
sw x24, 8(x16)     # address 4+8=12 ---> 6
sw x25, 12(x17)    # address 4+12=16 ---> 2
sw x19, 19(x10)    # address 3+19=24 ---> 3
sw x30, 21(x18)    # address 21+3=24 ---> 2
lw x5, 10(x11)
lw x6, 13(x12)
lw x7, 14(x15)
lw x8, 22(x25)
addi x4, x5, 0
addi x4, x6, 0
addi x4, x7, 0
addi x4, x8, 0
label2:
addi x1,  x1,  0
addi x2,  x2,  0
addi x3,  x3,  0
addi x4,  x4,  0
addi x5,  x5,  0
addi x6,  x6,  0
addi x7,  x7,  0
addi x8,  x8,  0
addi x9,  x9,  0
addi x10, x10, 0
addi x11, x11, 0
addi x12, x12, 0
addi x13, x13, 0
addi x14, x14, 0
addi x15, x15, 0
addi x16, x16, 0
addi x17, x17, 0
addi x18, x18, 0
addi x19, x19, 0
addi x20, x20, 0
addi x21, x21, 0
addi x22, x22, 0
addi x23, x23, 0
addi x24, x24, 0
addi x25, x25, 0
addi x26, x26, 0
addi x27, x27, 0
addi x28, x28, 0
addi x29, x29, 0
addi x30, x30, 0
addi x31, x31, 0