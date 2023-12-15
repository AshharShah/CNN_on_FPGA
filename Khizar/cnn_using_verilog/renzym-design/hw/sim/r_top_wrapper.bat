iverilog -o tb_ren_conv_top_wrapper.vvp ..\rtl\*.v tb_ren_conv_top_wrapper.v
vvp .\tb_ren_conv_top_wrapper.vvp
::gtkwave .\wave.vcd .\sigs_wrapper.gtkw