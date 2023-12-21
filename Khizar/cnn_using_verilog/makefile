all:
	gcc pngtohex.c
	./a.out

ver:
	iverilog -o ./vvp/image_tb.vvp ./image_tb.v
	vvp ./vvp/image_tb.vvp

cc:
	iverilog -o ./vvp/conv.vvp ./conv.v
	vvp ./vvp/conv.vvp

conv:
	iverilog -o ./vvp/conv_tb.vvp ./conv_tb.v
	vvp ./vvp/conv_tb.vvp

cv:
	iverilog -o ./vvp/conv_tb.vvp ./conv_tb.v
	vvp ./vvp/conv_tb.vvp

ck:
	iverilog -o ./vvp/aa.vvp ./aa.v
	vvp ./vvp/aa.vvp