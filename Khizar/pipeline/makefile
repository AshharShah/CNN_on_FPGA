test_cases = 18

all: compile ins tb vv gt

compile: ./set-instructions/assembler.cpp ./set-instructions/hex-corrector.cpp ./set-instructions/test-cases-check.cpp
	g++ -o ./set-instructions/hex-corrector.out ./set-instructions/hex-corrector.cpp

ins: ./set-instructions/hex-corrector.out
	./set-instructions/hex-corrector.out $(test_cases)

tb: riscv_tb.v
	iverilog -o ../vvp/tb_riscv_pipe.vvp riscv_tb.v

vv: ../vvp/tb_riscv_pipe.vvp
	vvp ../vvp/tb_riscv_pipe.vvp

gt:
	open -a gtkwave '../vcd/riscv-pipeline.gtkw'

newtest:
	touch ./set-instructions/test-$(test_cases)-new.asm
	touch ./set-instructions/test-$(test_cases)-new.hex
	