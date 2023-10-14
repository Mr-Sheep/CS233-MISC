module timer(TimerInterrupt, cycle, TimerAddress,
             data, address, MemRead, MemWrite, clock, reset);
    output        TimerInterrupt;
    output [31:0] cycle;
    output        TimerAddress;
    input  [31:0] data, address;
    input         MemRead, MemWrite, clock, reset;

    // added wires
    wire   [31:0] alu_out, cycle_counter_out, interrupt_cycle_out;
    wire          interrupt_enable, Acknowledge, TimerRead, TimerWrite;

    assign interrupt_enable = (interrupt_cycle_out == cycle_counter_out);

    assign Acknowledge = (32'hffff006c == address) & MemWrite;
    assign TimerRead = (32'hffff001c == address) & MemRead;
    assign TimerAddress = (32'hffff001c == address) | (32'hffff006c == address);
    assign TimerWrite =  (32'hffff001c == address) & MemWrite;
    // complete the timer circuit here

    // HINT: make your interrupt cycle register reset to 32'hffffffff
    //       (using the reset_value parameter)
    //       to prevent an interrupt being raised the very first cycle

    alu32 the_one_and_only(alu_out, , , 3'h0, cycle_counter_out, 32'b1);
    register cycle_counter(cycle_counter_out, alu_out, clock, 1'b1, reset);
    register #(32, 32'hffffffff) interrupt_cycle(interrupt_cycle_out, data, clock, 1'b1, reset);
    tristate cycle_tristate(cycle, cycle_counter_out, TimerRead);
    dffe interrupt_line(TimerInterrupt, 1'b1, clock, interrupt_enable, Acknowledge | reset);

endmodule
