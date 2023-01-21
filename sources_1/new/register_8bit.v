`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/04/2023 03:27:46 PM
// Design Name: 
// Module Name: register_8bit
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


module register_8bit(
    input clk, rst, set_acc,
    input [7:0]value,
    output reg [7:0] out
    );
    

initial begin
    out <= 8'b0;
end
always @(*)
begin
    if(rst)
        out <= 8'b0;
    else if (set_acc) begin
        out <= value;
    end
end

endmodule
