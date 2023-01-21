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
    output [7:0]ram_rd_byte
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
     
     
            
    
endmodule
