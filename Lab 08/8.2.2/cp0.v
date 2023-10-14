`define STATUS_REGISTER 5'd12
`define CAUSE_REGISTER  5'd13
`define EPC_REGISTER    5'd14

module cp0(rd_data, EPC, TakenInterrupt,
           wr_data, regnum, next_pc,
           MTC0, ERET, TimerInterrupt, clock, reset);
    output [31:0] rd_data;
    output [29:0] EPC;
    output        TakenInterrupt;
    input  [31:0] wr_data;
    input   [4:0] regnum;
    input  [29:0] next_pc;
    input         MTC0, ERET, TimerInterrupt, clock, reset;

    // your Verilog for coprocessor 0 goes here

    wire [31:0] decoder32_out, user_status, status_register, cause_register;
    wire [29:0] taken_interrupt_out;
    wire exception_level;

    assign TakenInterrupt = (cause_register[15] & status_register[15]) & (~status_register[1] & status_register[0]);
    assign status_register = {16'b0, user_status[15:8], 6'b0, exception_level, user_status[0]};
    assign cause_register = {16'b0, TimerInterrupt, 15'b0};
    
    decoder32 decoder(decoder32_out, regnum, MTC0);
    mux2v #(30) taken_interrupt_mux(taken_interrupt_out, wr_data[31:2], next_pc, TakenInterrupt);

    register #(32) reg_user_status(user_status, wr_data, clock, decoder32_out[12], reset);
    dffe dffe_exception_level(exception_level, 1'b1, clock, TakenInterrupt, reset | ERET);
    register #(30) epc_register(EPC, taken_interrupt_out, clock, decoder32_out[14] | TakenInterrupt, reset);

    // The mfc0 instruction is used to read coprocessor 0 registers.
    // We'll use a 32-to-1 mux to select which register value to output. 
    // Inputs 12, 13, and 14 will be connected to the status, cause, and EPC registers, respectively; 
    // the rest will be connected to 0s (since we don't implement any other registers).
    mux32v #(32) rd_data_mux(rd_data, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, status_register, cause_register, {EPC, 2'b00}, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, regnum);

endmodule
