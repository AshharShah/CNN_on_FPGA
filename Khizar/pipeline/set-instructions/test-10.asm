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
sw x24, 8(x16)     # address 4+8=12  ---> 6
sw x25, 12(x17)    # address 4+12=16 ---> 2
sw x19, 19(x10)    # address 1+19=20 ---> 3
sw x30, 21(x18)    # address 21+3=24 ---> 2
lw x5, 10(x11)     # address 10+2=12 ---> 6 ---> x5
lw x6, 13(x12)     # address 13+3=16 ---> 2 ---> x6
lw x7, 14(x15)     # address 14+6=20 ---> 3 ---> x7
lw x8, 22(x25)     # address 22+2=24 ---> 2 ---> x8
addi x4, x5, 0
addi x4, x6, 0
addi x4, x7, 0
addi x4, x8, 0     # 2
label2:
addi x1,  x1,  0   # XX
addi x2,  x2,  0   # XX
addi x3,  x3,  0   # XX
addi x4,  x4,  0   # 2
addi x5,  x5,  0   # 6
addi x6,  x6,  0   # 2
addi x7,  x7,  0   # 3
addi x8,  x8,  0   # 2
addi x9,  x9,  0   # XX
addi x10, x10, 0   # 1
addi x11, x11, 0   # 2
sll  x11, x11, x10   # 2 << 1  = 4
sll  x11, x11, x10   # 4 << 1  = 8
sll  x11, x11, x10   # 8 << 1  = 16
sll  x11, x11, x10   # 16 << 1 = 32
sll  x11, x11, x10   # 32 << 1 = 64
addi x12, x12, 0   # 3
addi x13, x13, 0   # 4
addi x14, x14, 0   # 6
srl  x11, x11, x10   # 64 >> 1 = 32
srl  x11, x11, x10   # 32 >> 1 = 16
srl  x11, x11, x10   # 16 >> 1 = 8
srl  x11, x11, x10   # 8  >> 1 = 4
addi x15, x15, 0   # 6
srl  x15, x15, x22 #   6 >> 2  = 3 >> 1 = '1'  
addi x16, x16, 0   # 4
addi x17, x17, 0   # 4
addi x18, x18, 0   # 3
srl  x18, x18, x10
addi x19, x19, 0   # 3
addi x20, x20, 0   # 1
addi x21, x21, 0   # 6
sll  x21, x20, x10   # 6 << 1 = 12
addi x22, x22, 0   # 2
addi x23, x23, 0   # 1
addi x24, x24, 0   # 6
addi x25, x25, 0   # 2
addi x26, x26, 0   # 3
addi x27, x27, 0   # 3
addi x28, x28, 0   # XX
addi x29, x29, 0   # XX
addi x30, x30, 0   # 2
addi x31, x31, 0   # 2