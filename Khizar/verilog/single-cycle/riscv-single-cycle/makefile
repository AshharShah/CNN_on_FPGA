all: ins tb
	vvp ../vvp/tb_riscv.vvp
ins:
	g++ instruction_worker.cpp
	./a.out instructions_hex.hex ins
tb:
	iverilog -o ../vvp/tb_riscv.vvp riscv_tb.v