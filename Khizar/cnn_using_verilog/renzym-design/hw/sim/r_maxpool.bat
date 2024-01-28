 iverilog -o tb_maxpool.vvp .\tb_maxpool.v ..\rtl\max_pool.v
 vvp .\tb_maxpool.vvp
 gtkwave .\wave_mp.vcd .\sigs_mp.gtkw