module FilterCoefficients();

    reg signed [63:0] filter [0:2][0:2];

    integer i, j;

    initial begin
        // Read filter coefficients from file
        $readmemh("filter.txt", filter);

        // Display the read coefficients
        $display("Filter Coefficients:");
        for (i = 0; i < 3; i = i + 1) begin
            for (j = 0; j < 3; j = j + 1) begin
                $display("%d %d: %f", i, j, $bitstoreal(filter[i][j]));
            end
        end
    end

endmodule
