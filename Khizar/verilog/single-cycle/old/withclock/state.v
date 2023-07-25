module state(clk, state);

    input clk;
    output reg [1:0] state;

    initial 
        begin
            state <= 3;        
        end

    always @(posedge clk) 
        begin
            if (state == 3)
                state <= 0;
            else
                state <= state + 1;  // 0 1 2 3       
        end

endmodule