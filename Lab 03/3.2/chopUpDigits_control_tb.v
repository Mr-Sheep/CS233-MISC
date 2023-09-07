module chopUpDigits_control_test;
    reg       clk = 0;
    always #1 clk = !clk;  // Do not reduce below 2.

    reg go = 0;
    reg reset = 1;
    reg[31:0] number;
    reg base;
    reg [4:0] digits_ptr;

    integer i;

    wire number_is_0; // chopUpDigits_circuit's output
    wire done, get_new, load_index, load_number, select_base, write; // chopUpDigits_control's output
    chopUpDigits_circuit circuit(number_is_0, get_new, load_index, load_number, select_base, write, number, digits_ptr, clk, reset);
    chopUpDigits_control control(done, get_new, load_index, load_number, select_base, write, base, number_is_0, go, clk, reset);

    initial begin
        $dumpfile("chopUpDigits_control.vcd");
        $dumpvars(0, chopUpDigits_control_test);

        #2      reset = 0;

        // Test 1: Chop 0
        $display("\n\nTest 1: o0, base 8");

        for ( i = 0; i < 32; i = i + 1)
          circuit.rf.r[i] <= 99;

        # 2  go = 1;
             number = 32'o0;
             digits_ptr = 15;
             base = 0;

      	# 2  go = 0;
        # 20
        for ( i = 14; i < 23; i = i + 1)
          $display("i = %d, value = %d", i, $signed(circuit.rf.r[i]));



        // Test 2: Chop hex
        $display("\n\nTest 2: 0x12340, base 16");

        #2
        for ( i = 0; i < 32; i = i + 1)
          circuit.rf.r[i] <= 99;

        # 2  go = 1;
             number = 32'h12340;
             digits_ptr = 15;
             base = 1;

      	# 2  go = 0;
        # 100
        for ( i = 14; i < 23; i = i + 1)
          $display("i = %d, value = %d", i, $signed(circuit.rf.r[i]));



        // Test 3: Mid run base change
        $display("\n\nTest 3: 0x5678912 , base 16");

        #2
        for ( i = 0; i < 32; i = i + 1)
          circuit.rf.r[i] <= 99;

        # 2  go = 1;
             number = 32'h5678912;
             digits_ptr = 15;
             base = 1;

        # 2  go = 0;
        # 2  base = 0;
        # 100
        for ( i = 14; i < 26; i = i + 1)
          $display("i = %d, value = %d", i, $signed(circuit.rf.r[i]));

        #10 $finish;
    end

    initial begin
        $monitor("done = %d", done);

        // You can also explore wires inside the modules. For example to
        // monitor value of write_data wire inside the circuit, in addition
        // to done signal, you should change the monitor statement to:
        // $monitor("done = %d, write_data = %d", done, circuit.write_data);

        // It is best to monitor only the signals that you are exploring at a particular time.
        // FOR DEBUGGING: It will be really useful to monitor your states inside the control module.
    end

endmodule
