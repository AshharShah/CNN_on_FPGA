 iverilog -o tb_proc.vvp .\tb_agu.v ..\rtl\agu.v
 vvp .\tb_proc.vvp
 gtkwave .\wave.vcd .\sigs_agu.gtkw