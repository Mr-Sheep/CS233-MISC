module odd_counter(o, i, clock, reset);

  input i;             // data input
  input clock, reset;  // synchronizing inputs

  output o;

  // declare one wire per current state variable
  // we recommend the naming convention of starting with
  // the letter 's' followed by a meaningful name
  // to help you know that the wire is for a state 
  wire sEven, sOdd; 

  // Declare one wire per next-state variable
  // Each next-state wire should match the Boolean expression derived from the next-state table
  // The reset signal is synchronously resetting the FSM to the sEven state
  // The Boolean expression for your start state should be OR'd with reset. 
  // All other states' Boolean expressions should be AND'd with ~reset.
  // SOMETHING IS WRONG IN THE FOLLOWING TWO LINES
  // FOCUS ON THE BOOLEAN EXPRESSIONS IN THE PARENTHESES

  wire sEven_next = ((sOdd & i) | (sEven & ~i)) | reset;
  wire sOdd_next = ((sEven & i) | (sOdd & ~i)) & ~reset;

  // dffe stands for d flip-flop with enable
  // dffe module is defined below
  // The reset of the flip-flop is asynchronous, set it to 0

  dffe fsEven(sEven, sEven_next, clock, 1'b1, 1'b0);
  dffe fsOdd(sOdd, sOdd_next, clock, 1'b1, 1'b0);

  // Set the output to be equal to the OR of all states that output 1

  assign o = sOdd;
  
endmodule // end odd_counter

// dffe: D-type flip-flop with enable
//
// q      (output) - Current value of flip flop
// d      (input)  - Next value of flip flop
// clk    (input)  - Clock (positive edge-sensitive)
// enable (input)  - Load new value? (yes = 1, no = 0)
// reset  (input)  - Asynchronous reset   (reset =  1)
//
module dffe(q, d, clk, enable, reset);
   output q;
   reg    q;
   input  d;
   input  clk, enable, reset;

   always@(reset)
     if (reset == 1'b1)
       q <= 0;

   always@(posedge clk)
     if ((reset == 1'b0) && (enable == 1'b1))
       q <= d;
endmodule // dffe
