module test;

   // these are inputs to "circuit under test"
   reg A=0;
   reg B=0;
   reg C=0;
  
   // wires for the outputs of "circuit under test"
   wire out;
  
   // the circuit under test
   odd_even3 oe1(out, A, B, C);  
    
   initial begin               // initial = run at beginning of simulation
                               // begin/end = associate block with initial
      
      $dumpfile("odd_even3.vcd");  // name of dump file to create
      $dumpvars(0, test);     // record all signals of module "test" and sub-modules
                              // remember to change "test" to the correct
                              // module name when writing your own test benches

      // test all input combinations
      A = 0; B = 0; C = 0; #10
      A = 0; B = 0; C = 1; #10
      A = 0; B = 1; C = 0; #10
      A = 0; B = 1; C = 1; #10
      A = 1; B = 0; C = 0; #10
      A = 1; B = 0; C = 1; #10
      A = 1; B = 1; C = 0; #10
      A = 1; B = 1; C = 1; #10
          
      $finish;        // end the simulation
   end                      
   
   initial begin
     $display("inputs = A B C  outputs = out");
     $monitor("inputs = %b %b %b  outputs = %b   ",
              A, B, C, out);
   end
endmodule // test
