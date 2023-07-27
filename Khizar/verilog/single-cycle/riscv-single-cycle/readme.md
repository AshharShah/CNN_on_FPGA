# RISC-V Single Cycle Core

**make all** command inside the **risc-single-cycle** folder does the following:

1. Takes the instructions in hexadecimal and converts it into 8-bit binary per line in a new file **ins.txt**.

2. iverilog compiles the **RISCV-Testbench**(riscv_tb.v) which creates **vvp file** in **../vvp/** directory.

3. Runs the iverilog compiled vvp file on the terminal, which generates value change dump **riscv.vcd** in the **../vcd/** directory.

We can open the **riscv.vcd** file on **gtkwave** to view values. (My own created graph of values is stored in **riscv.gtkwv** file in **../vcd/**.)