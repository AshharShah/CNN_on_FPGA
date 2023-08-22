from riscv_assembler.convert import AssemblyConverter as AC
# instantiate object, by default outputs to a file in nibbles, not in hexademicals 
convert = AC(output_mode = 'f', nibble_mode = True, hex_mode = False)

# Convert a whole .s file to text file
convert("unit-test-arithmetic.S", "result.txt") 

# Convert a string of assembly to binary file 
cnv_str = "add x1 x0 x0\nadd x2 x0 x1" 
convert(cnv_str, "result.bin") 

# Convert a string and print output with no nibbles
convert.output_mode = 'p' 
convert.nibble_mode = False 
convert.convert(cnv_str) 

# Convert a string and save to array 
convert.output_mode = 'a' 
result = convert(cnv_str) 