all: ins cpp tb vv
	gtkwave ../vcd/riscv.gtkw	

cpp:
	./set-instructions/a.out ./set-instructions/instructions_hex.hex ./set-instructions/ins.txt

ins:
	g++ -o ./set-instructions/a.out ./set-instructions/instruction_worker.cpp

tb:
	iverilog -o ../vvp/tb_riscv.vvp riscv_tb.v

vv:
	vvp ../vvp/tb_riscv.vvp
