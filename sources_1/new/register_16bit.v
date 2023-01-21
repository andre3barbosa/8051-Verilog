`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/04/2023 04:27:51 PM
// Design Name: 
// Module Name: register_16bit
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


module register_16bit(
    input clk, rst, setHigh, setLow,
    input [7:0]value,
    output reg [15:0] out
    );
    
always @(posedge clk)
begin
    if(rst)
        out <= 0;
    else if (setHigh & ~setLow)
        out[15:8] <= value;    //see endianess
    else if (setLow & ~setHigh)
        out[7:0] <= value;    //see endianess
end 
endmodule
