module chopUpDigits_circuit_test;
    reg       clk = 0;
    always #1 clk = !clk;

    reg get_new, load_index, load_number, select_base, write;
    reg [31:0] number;
    reg [4:0] digits_ptr;
    reg reset;

    wire number_is_0;

    integer i;

    chopUpDigits_circuit circuit(number_is_0, get_new, load_index, load_number, select_base, write, number, digits_ptr, clk, reset);


    initial begin
        // $dumpfile("chopUpDigits_circuit.vcd");
        // $dumpvars(0, chopUpDigits_circuit_test);
        #2 reset = 0;

      	// Test 1: Chop Octal
        $display("\n\nTest 1: o1234, base 8");

        for ( i = 0; i < 32; i = i + 1)
          circuit.rf.r[i] <= 99;

        # 2  get_new = 1;
             load_index = 1;
             load_number = 1;
             select_base = 0; // octal
             write = 0;
             number = 32'o1234;
             digits_ptr = 15;

      	# 2  get_new = 0;
             write = 1;
        # 12
        for ( i = 15; i < 32; i = i + 1)
          $display("i = %d, value = %d", i, circuit.rf.r[i]);

          // Test 2: Chop hex
          $display("\n\nTest 1: 0x1234, base 16");

          #2 reset = 1;
          #2 reset = 0;

          #2
              for ( i = 0; i < 32; i = i + 1)
                circuit.rf.r[i] <= 99;

          # 2  get_new = 1;
               load_index = 1;
               load_number = 1;
               select_base = 1; // hex
               write = 0;
               number = 32'h1234;
               digits_ptr = 15;

          # 2  get_new = 0;
               write = 1;
          # 20
          for ( i = 15; i < 32; i = i + 1)
            $display("i = %d, value = %d", i, circuit.rf.r[i]);


  #10 $finish;
end

endmodule
