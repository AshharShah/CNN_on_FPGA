all:
	gcc pngtohex.c
	./a.out

ver:
	iverilog -o ./vvp/image_tb.vvp ./image_tb.v
	vvp ./vvp/image_tb.vvp