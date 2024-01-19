# Plan
## Get the sims running on existing code
## Convert C code to fixed point
- Understand fixed point numbers (DSD fall 2018 videos 11,13,14 can help)  
- Decide Q formats and convert C code  
- Results comparison between fixed and floating point  
## Compare C code and HW results
- Update test bench to have C test equalent scenario in HW  
-- Can dump data in file from C and read in Verilog and vice versa for results  
- Results comparison (Results should be bit-accurate with fixed point C)
## Port the HW to FPGA
- Go through Zynq training but use Microblaze processor instead of Zynq  
-- It will include using various AXI IPs and profiling for timing etc.  
- Run fixed point code on Microblaze and profile results
- Make RenML HW writable/readable from Microblaze (Both data and configs)  
- Profile HW results and compare with C results from microblaze  
- Add DMA instead of memory controller  
## Architect how to scale the design
- Add Relu block  
- Stages could take input from other stages  
- Minimize data copying  
- Software pipelining  
-- While DMA copies data, keep processor busy in other stuff  
- Analyze other architectures like TPUs, Xilinx Versal etc.  
## Software Architecture
- Design a mechanism to take top level CNN strcuture as input and generate optimized C code for
  
# Meetings
## 2023-12-13: 
- Initial overview of RenML  
- Q-formats and pointers shared  
- Plan shared  
## 2024-01-19: 
- Not much progress. Plan discussed again  
- Next friday(2024-01-26) targets:  
-- Khizar: Get sims running, convert images so that they are readable in verilog  
-- Ashar: Convert C code to fixed point  
-- Khizar & Ashar: Try to match fixed point results with verilog  
-- Hasaan: Survey whether a standard format exist to specify CNN model. Read that format in a pythin script.  
# Misc
- Link to this dropbox: http://tinyurl.com/giki-cnn
## 
