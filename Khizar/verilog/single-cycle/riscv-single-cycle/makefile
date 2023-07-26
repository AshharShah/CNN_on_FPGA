all: ins tb cpp
	vvp ../vvp/tb_riscv.vvp

cpp:
	./a.out instructions_hex.hex ins.txt

ins:
	g++ instruction_worker.cpp

tb:
	iverilog -o ../vvp/tb_riscv.vvp riscv_tb.v