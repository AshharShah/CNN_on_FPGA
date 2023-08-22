number = 1

all: ins cpp tb vv gt

cpp:
	./set-instructions/a.out ./set-instructions/unit-test-arithmetic.hex ./set-instructions/unit-test-arithmetic-binary.txt
	./set-instructions/a.out ./set-instructions/unit-test-arithmetic.hex ./set-instructions/unit-test-arithmetic-binary.txt
	cp ./set-instructions/unit-test-arithmetic-binary.txt ./set-instructions/binary-instructions.txt

ins:
	g++ -o ./set-instructions/a.out ./set-instructions/instruction_worker.cpp

tb:
	iverilog -o ../vvp/tb_riscv_pipe.vvp riscv_tb.v

vv:
	vvp ../vvp/tb_riscv_pipe.vvp
	cp ../vcd/riscv_pipeline.vcd ../vcd/unit-test-arithmetic.txt

gt:
	gtkwave ../vcd/riscv_pipeline.gtkw
