#for(int i=0; i<n; i+=1) {
#	for(int j=i-1; j>=0 && v[j] > v[j+1]; j-=1) {
#    	swap(v,j);
#    }
#}

#int i=0
#for( i<n ) {
#		int j=i-1
#		for( j>=0 && v[j] > v[j+1] ) {
#    			swap(v,j)
#				j-=1
#    	}
#		i+=1
#}



# x11 = n
# x10 = base address of array v

.data
v: .word 1000
n: .word 2



.text

.globl main

#swap:
	#temp   = v[k];
    #v[k]   = v[k+1];
    #v[k+1] = temp;
    #sw x24, 0(x23)
    #sw x25, 0(x22)
    
	#jal x0, x1

sort:
	add x19, x0, x0		#	x19 = i

	addi sp, sp, -4
	sw x1, 0(sp)
	jal x1, outer_loop  # 	x1 ---> 0(sp)
    lw x1, 0(sp)
    addi sp, sp, 4
    jal x0, x1			# 	to main
    
ends:
	jal x0, x1
    
in1fail:
	addi x19, x19, 1
    jal x0, outer_loop

inner_loop:
	blt x20, x0, in1fail
    
	slli x21, x20, 2	#	j*4
    add x22, x21, x10	#	v[j] = v
    addi x21, x21, 4
    add x23, x21, x10	#	v[j+1] = v + (j*4 + 4)
    
    lw x24, 0(x22)
    lw x25, 0(x23)
    
    bge x25, x24, in1fail
    
    #addi sp, sp, -4
    #sw x1, 0(sp)
    #jal x1, swap
    #lw x1, 0(sp)
    #addi sp, sp, 4
    sw x24, 0(x23)
    sw x25, 0(x22)
    
    addi x20, x20, -1
    jal x0, inner_loop

outer_loop:
	bge x19, x11, ends
    addi x20, x19, -1	#	x20 = j
    jal x0, inner_loop
    
main:
	lw x10, v
    lw x11, n
	jal x1, sort
	
#for( i<n ) {
#		int j=i-1
#		for( j>=0 && v[j] > v[j+1] ) {
#    			swap(v,j)
#				j-=1
#    	}
#		i+=1
#} 


