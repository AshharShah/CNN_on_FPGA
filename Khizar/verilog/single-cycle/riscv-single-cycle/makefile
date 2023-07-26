all: ins tb cpp
	vvp ../vvp/tb_riscv.vvp

cpp:
	./set-instructions/a.out ./set-instructions/instructions_hex.hex ./set-instructions/ins.txt

ins:
	g++ -o ./set-instructions/a.out ./set-instructions/instruction_worker.cpp

tb:
	iverilog -o ../vvp/tb_riscv.vvp riscv_tb.v