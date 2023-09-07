//implement a test bench for your 32-bit ALU
module alu32_test;
    reg [31:0] A = 0, B = 0;
    reg [2:0] control = 0;




    wire signed [31:0] out;
    wire overflow, zero, negative;
    alu32 a(out, overflow, zero, negative, A, B, control);  

    initial begin
        $dumpfile("alu32.vcd");
        $dumpvars(0, alu32_test);

        A = 8; B = 4; control = `ALU_ADD; // try adding 8 and 4
        # 10 A = 5; B = 3; control = `ALU_ADD;
        # 10 A = 2; B = 4; control = `ALU_ADD;
        # 10 A = 2; B = 5; control = `ALU_SUB;  // try subtracting 5 from 2
        # 10 A = 32'b10101111100100000011110100111010; B = 32'b10101111100100000011110100111010; control = 6;
        // add more test cases here!
        // big positive + big positive number
        # 10 A = 32'b01111111111111111111111111111100; B = 32'b00000000000000000000000000000101; control = `ALU_ADD;
        
        // big neg + big neg
        # 10 A = 32'b10000000000000000000000000000001; B = 32'b01000000000000000000000000000010; control = `ALU_ADD;
    
        // neg + neg
        # 10 A = 32'b00000000000000000000000000001010; B = 32'b01111111111111111111111111111111; control = `ALU_SUB;
        # 10 A = 32'b00000000000000000000000000001010; B = 32'b01111111111111111111111111111111; control = `ALU_ADD;

        #10 A = 32'b00000000000000000000000000001010; B = 32'b00000000000000000000000000001010; control = `ALU_SUB;
        #10 A = 32'b00000000000000000000000000001010; B = 32'b00000000000000000000000000001010; control = `ALU_ADD;

        
        # 10 $finish;
    end

    initial begin
        $monitor("A=%b B=%b control=%b out=%b (%d) overflow=%b  zero=%b negative=%b", A, B, control, out, out, overflow, zero, negative);
    end

endmodule // alu32_test
