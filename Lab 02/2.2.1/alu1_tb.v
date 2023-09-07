module alu1_test;
    // exhaustively test your 1-bit ALU implementation by 
    // adapting mux4_tb.v from Lab 2 part 1
    //   these are inputs to "logicunit under test"
    reg A = 0;
    reg B = 0;
    reg carryin = 0;
    reg expect_out = 0;
    reg expect_cout = 0;

    reg [2:0] control;
    
    // wires for the outputs of "logicunit under test"
    wire out, carryout;
    
    // the circuit under test
    alu1 a1(out, carryout, A, B, carryin, control);
    
    initial begin               // initial = run at beginning of simulation
                                // begin/end = associate block with initial

        $dumpfile("alu1.vcd");
        $dumpvars(0, alu1_test);

        $display(" -------- logic unit -------- ");
        A = 0; B = 0; control = 3'b100; expect_out = 0; #4 // 0
        A = 0; B = 1; control = 3'b100; expect_out = 0; #4 // 0
        A = 1; B = 0; control = 3'b100; expect_out = 0; #4 // 0
        A = 1; B = 1; control = 3'b100; expect_out = 1; #4 // 1
        
        A = 0; B = 0; control = 3'b101; expect_out = 0; #4 // 0
        A = 0; B = 1; control = 3'b101; expect_out = 1; #4 // 1
        A = 1; B = 0; control = 3'b101; expect_out = 1; #4 // 1
        A = 1; B = 1; control = 3'b101; expect_out = 1; #4 // 1
        
        A = 0; B = 0; control = 3'b110; expect_out = 1; #4 // 1
        A = 0; B = 1; control = 3'b110; expect_out = 0; #4 // 0
        A = 1; B = 0; control = 3'b110; expect_out = 0; #4 // 0
        A = 1; B = 1; control = 3'b110; expect_out = 0; #4 // 0
    
        A = 0; B = 0; control = 3'b111; expect_out = 0; #4 // 0
        A = 0; B = 1; control = 3'b111; expect_out = 1; #4 // 1
        A = 1; B = 0; control = 3'b111; expect_out = 1; #4 // 1
        A = 1; B = 1; control = 3'b111; expect_out = 0; #4 // 0

        $display();
        $display(" -------- full adder -------- ");
        $display("A   B   Cin   Control     Out   Cout   | expect_out   expect_cout");

        A = 0; B = 0; carryin = 0; control = 3'b010; expect_out = 0; expect_cout = 0; #4 // 0 0 
        A = 0; B = 0; carryin = 1; control = 3'b010; expect_out = 1; expect_cout = 0; #4 // 1 0

        A = 0; B = 1; carryin = 0; control = 3'b010; expect_out = 1; expect_cout = 0; #4 // 1 0
        A = 0; B = 1; carryin = 1; control = 3'b010; expect_out = 0; expect_cout = 1; #4 // 0 1
        
        A = 1; B = 0; carryin = 0; control = 3'b010; expect_out = 1; expect_cout = 0; #4 // 1 0
        A = 1; B = 0; carryin = 1; control = 3'b010; expect_out = 0; expect_cout = 1; #4 // 0 1

        A = 1; B = 1; carryin = 0; control = 3'b010; expect_out = 0; expect_cout = 1; #4 // 0 1
        A = 1; B = 1; carryin = 1; control = 3'b010; expect_out = 1; expect_cout = 1; #4 // 1 1

        $display(" -------- complement full adder -------- ");
        $display("A   B   Cin   Control     Out   Cout   | expect_out   expect_cout");

        A = 0; B = 0; carryin = 0; control = 3'b011; expect_out = 0; expect_cout = 0; #4 // 0 0 
        A = 0; B = 0; carryin = 1; control = 3'b011; expect_out = 1; expect_cout = 0; #4 // 1 0

        A = 0; B = 1; carryin = 0; control = 3'b011; expect_out = 1; expect_cout = 0; #4 // 1 0
        A = 0; B = 1; carryin = 1; control = 3'b011; expect_out = 0; expect_cout = 1; #4 // 0 1
        
        A = 1; B = 0; carryin = 0; control = 3'b011; expect_out = 1; expect_cout = 0; #4 // 1 0
        A = 1; B = 0; carryin = 1; control = 3'b011; expect_out = 0; expect_cout = 1; #4 // 0 1

        A = 1; B = 1; carryin = 0; control = 3'b011; expect_out = 0; expect_cout = 1; #4 // 0 1
        A = 1; B = 1; carryin = 1; control = 3'b011; expect_out = 1; expect_cout = 1; #4 // 1 1

        $finish; // end the simulation
    end  
   
    initial begin
        $display("A   B   Cin   Control     Out   Cout   |  expect_out   expect_cout");
        $monitor("A=%b B=%b Cin=%b Control=%b Out=%b Cout=%b | %b %b", A, B, carryin, control, out, carryout, expect_out, expect_cout);
    end

endmodule
