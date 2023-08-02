`include "immediategen.v"

module immediategen_tb;

reg [6:0] opcode;

reg  [31:0] instruction;
reg  [12:0] immediate; // 13-bit only for branch (12 for others)
wire [31:0] result;

immediategen uut(instruction, result);

initial 
    begin
        $dumpfile("../vcd/immediategen_tb.vcd");
        $dumpvars(1, immediategen_tb);

        #2
        opcode = 7'b0000011; // LOAD
        immediate = 12'b0000_1111_0000;
        instruction = {immediate, {13{1'b0}}, opcode};

        #2
        $display("result: 1 %d", result);

        #2
        opcode = 7'b0000011; // LOAD
        immediate = 12'b0100_0010_1000;
        instruction = {immediate, {13{1'b0}}, opcode};

        #2
        $display("result: %d", result);

        #2
        opcode = 7'b0100011; // STORE
        immediate = 12'b0000_0000_0000;
        instruction = {immediate[11:5], {8{1'b0}}, immediate[4:0], opcode};

        #2
        $display("result st: %d", result);

        #2
        opcode = 7'b0000011; // LOAD
        immediate = 12'b1111_0000_0000;
        instruction = {immediate, {13{1'b0}}, opcode};

        #2
        $display("result: %d", result);

        #2
        opcode = 7'b0100011; // STORE
        immediate = 12'b1000_1100_0000;
        instruction = {immediate[11:5], {13{1'b0}}, immediate[4:0], opcode};

        #2
        $display("result store 2: %d", result);

        #2
        opcode = 7'b0000011; // LOAD
        immediate = 12'b1111_0000_1111;
        instruction = {immediate, {13{1'b0}}, opcode};

        #2
        $display("result: %d", result);

        #2
        opcode = 7'b0100011; // STORE
        immediate = 12'b0110_0000_0100;
        instruction = {immediate[11:5], {13{1'b0}}, immediate[4:0], opcode};

        #2
        $display("result store 3: %d", result);

        #2
        opcode = 7'b0100011; // STORE
        immediate = 12'b0000_0000_0111;
        instruction = {immediate[11:5], {13{1'b0}}, immediate[4:0], opcode};

        #2
        $display("result store 4: %d", result);

        #2
        opcode = 7'b1100011; // BRANCH
        immediate = 13'b0_0110_0001_0100;
        instruction = {immediate[12], immediate[10:5], {13{1'b0}}, immediate[4:1], immediate[11], opcode};

        #2
        $display("result branch 1: %d", result);

        #2
        opcode = 7'b1100011; // BRANCH
        immediate = 13'b0_0110_0101_0010;
        instruction = {immediate[12], immediate[10:5], {13{1'b0}}, immediate[4:1], immediate[11], opcode};

        #2
        $display("result branch 2: %d", result);

        #2
        opcode = 7'b1100011; // BRANCH
        immediate = 13'b0_0111_1111_0000;
        instruction = {immediate[12], immediate[10:5], {13{1'b0}}, immediate[4:1], immediate[11], opcode};

        #2
        $display("result branch 3: %d", result);

        #2
        $display("result: ....");
    end

endmodule