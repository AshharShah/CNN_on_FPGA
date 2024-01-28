module NegativeIntegersToHex;

reg signed [31:0] integer_value;
reg [31:0] hex_value;

integer integer_file;

initial begin
    // Open the file for reading
    integer_file = $fopen("filterhext.txt", "r");

    // Check if the file was opened successfully
    if (integer_file == 0) begin
        $display("Error opening file");
        $finish;
    end

    // Read integers from the file and convert to hexadecimal
    while (!$feof(integer_file)) begin
        // Read the integer value from the file
        $fscanf(integer_file, "%d", integer_value);

        // Convert the integer to hexadecimal
        hex_value = $sformat("%h", integer_value);

        // Display the result
        $display("Decimal: %d, Hexadecimal: %h", integer_value, hex_value);
    end

    // Close the file
    $fclose(integer_file);

    // Terminate the simulation
    $finish;
end

endmodule