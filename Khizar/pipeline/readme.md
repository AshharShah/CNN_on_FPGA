# RISC-V Pipeline Version

## How can you use this?

    Write an assembly code and put it in ./set-instructions folder
    with the name 'test-12.asm' (you can write any number here). Then
    generate its .hex code using the venus simulator and place it in the
    same directory with the same name but .hex extension.

    Now, go to the makefile and change the variable value of 'test_cases'
    to the number that you wrote in your .asm file name (here 12).

    Finally, go to the parent directory 'pipeline' and run this:
    'make all'

    It will open the wave and you will be able to see the running/simulation
    of the provided assembly code.

    Make sure you have iverilog, g++, and gtkwave installed.

## Some technical details

    The top level module is 'riscv.v' which needs to be run by compiling
    (using iverilog) and then simulating (on gtkwave) its testbench
    module which is 'riscv_tb.v'

    'riscv_tb.v' takes as input the '.asm' file which contains the instructions.
    These instructions are loaded onto the instruction memory, after which the
    RISC-V starts running these.

    A complete compilation and running process is given in the makefile.

    Furthermore, currently the RISC-V only contains the instructions that are
    highlighted in the 'riscv-card.pdf.' I will be implementing more with time.
