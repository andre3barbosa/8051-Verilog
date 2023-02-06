`timescale 1ns / 1ps

module instruction_register(

input clock,
input reset,
input ir_load_high,
input ir_load_low,
input [7:0] rom_byte,
output reg [15:0] IR

);

initial begin
    IR = 0;
end
    
always @(posedge clock)
begin
    if(reset)
    begin
        IR <= 0;
    end
    else if(ir_load_high)
    begin
        IR[15:8] <= rom_byte;
    end
    else if (ir_load_low)
    begin
        IR[7:0] <= rom_byte;
    end
end
  
      
endmodule
