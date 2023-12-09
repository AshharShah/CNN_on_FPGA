all:
	gcc pngtohex.c
	./a.out

ver:
	iverilog -o ./vvp/image_tb.vvp ./image_tb.v
	vvp ./vvp/image_tb.vvp

conv:
	iverilog -o ./vvp/conv_tb.vvp ./conv_tb.v
	vvp ./vvp/conv_tb.vvp

ck:
	iverilog -o ./vvp/a.vvp ./a.v
	vvp ./vvp/a.vvp