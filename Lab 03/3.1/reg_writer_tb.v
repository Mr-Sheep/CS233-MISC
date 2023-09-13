module reg_writer_test;
    reg       clock = 0;
    always #1 clock = !clock;

    reg go = 0;
    reg reset = 1;
    reg direction = 0;
    reg [31:0] data;
    wire done;
    wire [4:0] regnum;
    integer i;

    wire [31:0] writtenValue;
    reg_writer writer(regnum, done, go, direction, clock, reset);
    regfile rf (, , , , regnum, data, ~done, clock, reset);

    initial begin
        $dumpfile("reg_writer.vcd");
        $dumpvars(0, reg_writer_test);
        # 2      reset = 0;

	// Test writing down
	# 2 go = 1; data = 32'hd00; direction = 0;
	# 2 go = 0; data = 32'hd01;
	# 2 data = 32'hd02;
	# 2 data = 32'hd03;
	# 2 data = 32'hd04;
	# 2 data = 32'hd05;

	# 6 // Finish our run

    // Print contents of registers 3-13 to the terminal
    $display ( "First Run" );
    $display ( "Dumping register state: " );
    $display ( "  Register :  hex-value (  dec-value )" );
    for (i = 3 ; i < 14 ; i = i + 1)
        $display ( "%d: 0x%x ( %d ) %d", i, rf.r[i], rf.r[i], done);
    // $display ( "%d: 0x%x ( %d )  %d", 0, rf.r[0], rf.r[0], done);
    


	# 2 reset = 1; // Reset the machine
	# 2 reset = 0;

	// Test writing up
	# 2 go = 1; data = 32'hdFF; direction = 1;
	# 2 go = 0; data = 32'hdFE;
	# 2 data = 32'hdFD;
	# 2 data = 32'hdFC;
	# 2 data = 32'hdFB;
	# 2 data = 32'hdFA;

    #6  // Finish a run

    // Print contents of registers 3-13 to the terminal
    $display ( "Second Run" );
    $display ( "  Register :  hex-value (  dec-value )" );
    for (i = 4 ; i < 14 ; i = i + 1)
        $display ( "%d: 0x%x ( %d ) %d", i, rf.r[i], rf.r[i], done);
    // $display ( "%d: 0x%x ( %d ) %d", 0, rf.r[0], rf.r[0], done);
    $display ( "Done.  Simulation ending." );

    // Add your own testcases here!

    $finish;
    end

endmodule
