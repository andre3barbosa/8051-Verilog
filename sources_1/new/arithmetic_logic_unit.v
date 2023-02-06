`timescale 1ns / 1ps


module arithmetic_logic_unit(

input clock,
input reset,
input [7:0]operand1,
input [7:0]operand2,
input [7:0]opcode,
output reg [8:0]result,
output reg psw_c

);
    
`include "opcodes.v"

reg psw_ac;
reg psw_ov;

initial begin
    result = 0;
    psw_c = 0;
    psw_ac = 0;
    psw_ov = 0;
    result = 0;
end
      
always @(posedge clock)
begin
    if(reset)   begin
       result = 0;
        psw_c = 0;
        psw_ac = 0;
        psw_ov = 0;
    end 
    else    begin
        casex(opcode)     
            `MOV_AI : begin   // MOV to the accumulator
                result = operand2;
                end 
            `MOV_AR : begin   // MOV to the accumulator
                result = operand2;
                end 
            `MOV_RI : begin
                result = operand2;
                end
            `ADD : begin
                result = operand1 + operand2;
                psw_c = result[8];
                psw_ac = result[4];
                psw_ov = result[8]&&~result[7] || result[7]&&~result[8]; 
                end
            `SUBB : begin
                result = operand1 - operand2;
                psw_c = result[8];
                psw_ac = result[4];
                psw_ov = result[8]&&~result[7] || result[7]&&~result[8]; 
                 end
            `ANL: begin
                result = operand1 & operand2;
                end
            `ORL:begin
                result = operand1 | operand2;
                end
            `XRL:begin
                result = operand1 ^ operand2;
                end
             default:
                result=result;
        endcase 
    end           
end  
endmodule
