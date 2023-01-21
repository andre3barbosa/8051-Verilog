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
    input clk, rst, inc, inc_offset, set,
    input [7:0] newValue_8bit,
    input [15:0] newValue_16bit,
    input [7:0] accValue,
    input int_ack,
    
    output reg[15:0] count
);
    
initial begin
    count <= 15'b0;
end

always @ (posedge clk)
begin
    if(rst)
        count <= 0;
    else if (int_ack)
        count <= 16'h00ab;  
    else if (inc)
        count <= count + 1;
    else if (set)
        count <= accValue + newValue_16bit;
    else if (inc_offset)
        count <= count + newValue_8bit;
   
            //else if (setH)
     //   count[15:8] <= newValue_16bit[15;    //see endianess
    //else if (setL)
     //   count[7:0] <= newValue_16bit;    //see endianess
end

endmodule
