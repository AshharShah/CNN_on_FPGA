Q5:
# Let Arr be an array of 10 integers located at address 0x100 in RAM.
# It contains the marks of AI31 students.
# Write code that sorts those marks in descending order using bubble sort.

# pseudo code
# for(int i=0; i<9; i++)
#   for(int j=i+1; j<10; j++)
#     if(Arr[i]<Arr[j]){
#       int temp = Arr[i];
#		Arr[i] = Arr[j];
#		Arr[j] = temp;
#	  }

# Use any registers

addi x5 x0 0x100
addi x6 x0 32
sw x6 0(x5)
addi x6 x0 99
sw x6 4(x5)
addi x6 x0 102
sw x6 8(x5)
addi x6 x0 5
sw x6 12(x5)
addi x6 x0 77
sw x6 16(x5)
addi x6 x0 2
sw x6 20(x5)
addi x6 x0 11
sw x6 24(x5)
addi x6 x0 67
sw x6 28(x5)
addi x6 x0 33
sw x6 32(x5)




addi x5 x0 0 # i=0
addi x6 x0 9 		# x6 = 9
addi x7 x0 0x100 # x7=Arr
addi x29 x0 10		# x29 = 10

OUTERLOOP5:
beq x5 x6 OUTEREXIT5	# if i==9 exit

addi x28 x5 1	# j=i+1
INNERLOOP5:
beq x28 x29 INNEREXIT5	# if j==10 exit

slli x30 x5 2	# i*4
add x30 x30 x7  # Arr+i*4 = &Arr[i]
lw  x10 0(x30) 	# Arr[i]

slli x31 x28 2	# j*4
add x31 x31 x7  # Arr+j*4 = &Arr[j]
lw  x11 0(x31) 	# Arr[j]

bge x10 x11 SKIPIF5	# if a[i]>=a[j] skip
sw x11 0(x30)	# swap
sw x10 0(x31)

SKIPIF5:
addi x28 x28 1	# j++
beq x0 x0 INNERLOOP5

INNEREXIT5:
addi x5 x5 1	# i++
beq x0 x0 OUTERLOOP5

OUTEREXIT5:
add x0 x0 x0