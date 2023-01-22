`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2022 08:10:31 AM
// Design Name: 
// Module Name: program_counter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module program_counter(
    input clk, rst, inc, inc_offset,
    input [7:0] newValue_8bit,
    input [7:0] accValue,
    
    input int,
    input int_vec,    
   
    input pop_1_stack,
    input pop_2_stack,
    input [7:0]stack_out,
    
    output reg enable_stack,
    output reg int_ack,
    
    output reg[7:0]stack_in,
    output reg push_1_stack,
    output reg push_2_stack,
    output reg[15:0] count
);

reg [1:0]state;

parameter s_idle   = 2'b00, //if an extra cycle is required to execute the instruction
          s_push1 =  2'b01,
          s_push2 =  2'b11;     

initial begin
    count <= 15'b0;
    state <= s_idle;
end


always @ (posedge int)
begin
    state <= s_push1;
end

always @ (posedge clk)
begin

    if(rst)
        count <= 0;
    else if (pop_1_stack) begin
        enable_stack <= 1'b1;
        count[15:8] <= stack_out;
    end
    else if (pop_2_stack) begin
        enable_stack <= 1'b1;
        count[7:0] <= stack_out; 
        int_ack <= 1'b0;  
    end
    else if (inc)
        count <= count + 1;
    else if (inc_offset)
        count <= count + newValue_8bit;
  
end

always @ (posedge clk)
begin : FSM
	begin
		case(state)
			s_idle :;
			   
			s_push1: 
                begin
                  stack_in <= count[7:0];
                  enable_stack <= 1'b1;  
                  push_1_stack <= 1'b1;
                  state <= s_push2;    
                end
            s_push2:
                begin
                  stack_in <= count[15:8];  
                  enable_stack <= 1'b1;
                  push_2_stack <= 1'b1;
                  count <= {8'h00 , int_vec}; 
                  int_ack <= 1;  
                  state <= s_idle; 
		        end
		    default: 
		        state <= s_idle;   
     endcase
    end
end




endmodule
