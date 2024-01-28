iverilog -o tb_ren_conv_top.vvp ..\rtl\*.v tb_ren_conv_top.v
vvp .\tb_ren_conv_top.vvp
::gtkwave .\wave.vcd .\sigs.gtkw