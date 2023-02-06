`timescale 1ns / 1ps


module tb_mov();
    
    reg clock   = 1'b0;
    reg reset   = 1'b0;
    reg [7:0]value_8bit = 8'h00;
    reg [7:0]int_vec = 8'h00;
    reg [7:0]acc  = 8'h00;
    reg [7:0]stack_out  = 8'h00;
    
    
    reg pc_inc    = 1'b0;
    reg pc_inc_offset = 1'b0;
    reg pc_jmp_z    = 1'b0;
    reg pc_jmp_nz = 1'b0;
    reg int    = 1'b0;
    reg pop_1_stack = 1'b0; 
    reg pop_2_stack = 1'b0;
    
    
    wire int_ack;
    wire push_stack;
    wire [7:0]stack_in;
    wire [15:0] count;
    
     program_counter pc_dp(clock, reset, pc_inc, pc_inc_offset,pc_jmp_z,pc_jmp_nz, value_8bit, int, int_vec, 
     pop_1_stack, pop_2_stack,acc, stack_out, int_ack, stack_in, push_stack, count);
    
        
always #50 clock = ~clock;
    
    
// Test
initial begin
// Reset
@(negedge clock) begin
reset = 1'b1;
end

//sinalize timer flag
@(negedge clock) begin
    reset = 1'b0;
    //interrupt detected
    int = 1'b1;
    int_vec = 8'h0b;
end


@(negedge clock) begin
    int = 1'b0;
end


$finish;
end
endmodule

