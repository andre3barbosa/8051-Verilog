`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/29/2022 05:47:19 AM
// Design Name: 
// Module Name: ram
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


module ram(
    input clock,
    input reset,
    input ram_rd_en_reg,
    input ram_wr_en_reg,
    input [2:0] ram_reg_in_sel,
    input [2:0] ram_reg_out_sel,
    input ram_rd_en_data,
    input ram_rd_en_sfr,
    input ram_wr_en_data,
    input [7:0]ram_rd_addr,
    input [7:0]ram_wr_addr,
    input [7:0]ram_wr_byte,
    output [7:0]ram_rd_byte,
    
    
    //stack
    input enable_stack,
    input [7:0]stack_in,
    input push_1_stack,
    input push_2_stack,
    input pop_1_stack,
    input pop_2_stack,

    output reg[7:0]stack_out,
    output reg stack_empty,
    output reg stack_full,
    output reg int_pend,
    output reg int_req
    
    
    );
    
    reg [7:0] mem [0:255];
    integer i;
    
    register_bank REG(clock,reset,ram_wr_en_reg,ram_rd_en_reg,ram_reg_in_sel,ram_reg_out_sel,ram_wr_byte,ram_rd_byte);
    
    
    
    always @(posedge clock)
    begin
    //mem.fill(8'b0);
        if(reset)
        begin
            for(i=0; i < 255 ; i = i + 1)
            begin
                mem[i] = 8'b00000000;
            end
        end
     end
     
     always @(posedge clock)
     begin
        if(ram_wr_en_data)
        begin
            mem[ram_wr_addr] = ram_wr_byte;
        end
     end
     
     //assign to the output of ram the value associated to the read address
     //This is the case to read from general purpose memory
     assign ram_rd_byte = (ram_rd_en_data == 1'b1 && ram_rd_en_reg == 1'b0) ? mem[ram_rd_addr] : 8'hzz;
     
     
     
    

    reg [7:0]stack_pointer;
    
    initial begin
        stack_pointer <= 1'h07;
        int_req <= 1'b0;
        int_pend <= 1'b1;
    end


    always@(posedge clock or negedge reset)begin
        if(reset==1'b0) begin
            stack_pointer = 8'b0;
            stack_empty = 1'b1;
            stack_full = 1'b0;
        end
        else if(enable_stack==1'b1)begin
            
            if((push_1_stack==1'b1 || push_2_stack==1'b1) && stack_full==1'b0)begin // push, make sure stack is not full
                stack_empty <= 1'b0;
                stack_pointer = stack_pointer + 1'b1;
                mem[stack_pointer] <= stack_in; //stack_int
                    
                    if(stack_pointer==8'h20) //127
                        stack_full <= 1'b1;
            end
        end
        else if((pop_1_stack==1'b1 || pop_2_stack==1'b1) && stack_empty==1'b0)begin // pop, make sure stack is not already empty
                stack_full <= 1'b0;
                stack_out <= mem[stack_pointer];
                stack_pointer = stack_pointer - 1'b1;
    
                    if(stack_pointer==8'h07)
                        stack_empty <= 1'b1;
            
        end
          
     end   
            
    
endmodule
