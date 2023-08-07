.data
v: .word 0x10007ff0
n: .word 10

.globl main

.text

sort:
	addi x19, x0, -1		#	x19 = i

outer_loop:
    addi x19, x19, 1
	bge x19, x11, ends
    addi x20, x19, -1	#	x20 = j ; j = i - 1

inner_loop:
	blt x20, x0, outer_loop #       j >= 0
    
	slli x21, x20, 2	#	j*4
    add x22, x21, x10	#	v[j] = v
    addi x21, x21, 4
    add x23, x21, x10	#	v[j+1] = v + (j*4 + 4)
    
    lw x24, 0(x22)
    lw x25, 0(x23)
    
    bge x25, x24, outer_loop  #   v[j+1] > v[j]
    
    sw x24, 0(x23)
    sw x25, 0(x22)
    
    addi x20, x20, -1
    beq x0, x0, inner_loop
    
ends:
	jalr x0, x1, 0
        
main:
	lw x10, v
    lw x11, n
    
    addi x5, x0, 7
    sw x5, 0(x10)
    addi x5, x0, 91
    sw x5, 4(x10)
    addi x5, x0, 5
    sw x5, 8(x10)
    addi x5, x0, 13
    sw x5, 12(x10)
    addi x5, x0, 2
    sw x5, 16(x10)
    addi x5, x0, 0
    sw x5, 20(x10)
    addi x5, x0, 81
    sw x5, 24(x10)
    addi x5, x0, 4
    sw x5, 28(x10)
    addi x5, x0, 5
    sw x5, 32(x10)
    addi x5, x0, 9
    sw x5, 36(x10)
    
	jal x1, sort
	
# for ( i < n ) {
#		int j = i - 1
#		for( j >= 0 && v[j] > v[j+1] ) {
#    			swap(v, j)
#				j -= 1
#    	}
#		i += 1
# }
