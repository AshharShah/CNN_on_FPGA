# RISC-V Single Cycle Core

## How can you use this?

    Write an assembly code and put it in ./set-instructions folder
    with any name like 'instruction_assembly6.asm' (you can write any number here).
    Then generate its .hex code using the venus simulator and place it in the
    same directory with the same name but .hex extension.

    Finally, go to the parent directory 'pipeline' and run this:
    'make all'

    It will open the wave and you will be able to see the running/simulation
    of the provided assembly code.

    Make sure you have iverilog, g++, and gtkwave installed.

## Some technical details

**make all** command inside the **risc-single-cycle** folder does the following:

1. Takes the instructions in hexadecimal and converts it into 8-bit binary per line in a new file **ins.txt**.

2. iverilog compiles the **RISCV-Testbench**(riscv_tb.v) which creates **vvp file** in **../vvp/** directory.

3. Runs the iverilog compiled vvp file on the terminal, which generates value change dump **riscv.vcd** in the **../vcd/** directory.

We can open the **riscv.vcd** file on **gtkwave** to view values. (My own created graph of values is stored in **riscv.gtkwv** file in **../vcd/**.)
