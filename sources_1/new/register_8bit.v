`timescale 1ns / 1ps

module register_8bit(

input clock,
input reset,
input set_acc,
input [7:0]value,
output reg [7:0] out

);
    
initial begin
    out <= 8'b0;
end

always @(negedge clock)
begin
    if(reset)
        out <= 8'b0;
    else if (set_acc) begin
        out <= value;
    end
end

endmodule
