`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/05/2022 01:57:29 PM
// Design Name: 
// Module Name: arithmetic_logic_unit
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


module arithmetic_logic_unit(
    input clock,
    input reset,
    input [7:0]operand1,
    input [7:0]operand2,
    input [7:0]opcode,
    input en,
    output reg [8:0]result,
    output reg psw_c,
    output reg psw_ac,
    output reg psw_ov
    );
    
    `include "opcodes.v"
    
    initial begin
        result = 0;
        psw_c = 0;
        psw_ac = 0;
        psw_ov = 0;
        result = 0;
    end
   
    
    always @(posedge reset)
    begin
            result = 0;
            psw_c = 0;
            psw_ac = 0;
            psw_ov = 0;
    end
        
    always @(posedge clock)
    begin
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
           //      default:
           //         result=result;
            //endcase     
            //case(opcode[7:2])  
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
endmodule
