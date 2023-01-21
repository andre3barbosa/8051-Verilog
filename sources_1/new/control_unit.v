`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/08/2022 06:21:44 PM
// Design Name: 
// Module Name: control_unit
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


module control_unit(
    input clock,
    input reset,
    input [7:0] opcode,
    output ram_rd_en_reg,
    output ram_wr_en_reg,
    output [2:0] ram_reg_in_sel,
    output [2:0] ram_reg_out_sel,
    output ram_rd_en_data,
    output ram_rd_en_sfr,
    output ram_wr_en_data,
    output rom_en,
    output pc_inc,
    output pc_inc_offset,
    output pc_set,
    output dptr_load_high,
    output dptr_load_low, 
    output ir_load_high,
    output ir_load_low,
    output acc_load
    );
   
    `include "opcodes.v"

    
    reg [4:0] state;
    
    //=========== Internal Constants =====================
    parameter s_start   = 5'b00000, //if an extra cycle is required to execute the instruction
              s_fetch_1 = 5'b00001,
              s_fetch_2 = 5'b00010, 
              s_decode  = 5'b00011, 
              s_mov_ri  = 5'b00100, 
              s_mov_ai  = 5'b00101, 
              s_mov_ar  = 5'b00110, 
              s_add_ai  = 5'b00111,
              s_mov_ra  = 5'b01000, 
              //s_add_ri  = 5'b01000,
              s_subb_ai = 5'b01001,
              s_subb_ri = 5'b01010,
              s_orl_ai  = 5'b01011,
              s_orl_ri  = 5'b01100,
              s_anl_ai  = 5'b01101,
              s_anl_ri  = 5'b01110,
              s_xrl_ai  = 5'b01111,
              s_xrl_ri  = 5'b10000,
              s_jnz     = 5'b10001,
              s_jz      = 5'b10010,
              s_jmp     = 5'b11000,
              s_sjmp    = 5'b10011,
              s_jnc     = 5'b10100,
              s_mov_dha = 5'b11001,
              s_mov_dla = 5'b11010,
              s_mov_ar_2 = 5'b11011,
              s_mov_ad   = 5'b11100,
              s_mov_da   = 5'b11101,
              s_mov_ad_2 = 5'b11111;
    //====================================================

  
initial begin
    state <= s_start;
end
   
assign rom_en = (state == s_fetch_1 || state == s_fetch_2) ? 1'b1 : 1'b0;
assign pc_inc = (state == s_fetch_1 || state == s_fetch_2) ? 1'b1 : 1'b0;

assign ir_load_high = (state == s_fetch_1) ? 1'b1 : 1'b0;
assign ir_load_low = (state == s_fetch_2) ? 1'b1 : 1'b0;

//xxxxxx Ram storage in register xxxxxx
//enable the storage at register
assign ram_wr_en_reg = (state == s_mov_ri || state == s_mov_ra || state == s_start) ? 1'b1 : 1'b0;
//Get for which register should be storeed
assign ram_reg_in_sel = (state == s_mov_ri || state == s_mov_ra || state == s_start) ? opcode[2:0] : 3'bzzz;

//xxxxxx Ram load to register xxxxxx
assign ram_rd_en_reg = (state == s_mov_ar || state == s_mov_ar_2) ? 1'b1 : 1'b0;
assign ram_reg_out_sel = (state == s_mov_ar || state == s_mov_ar_2) ? opcode[2:0] : 3'bzzz;

//xxxxxx Ram storage in direct xxxxxx 
assign ram_wr_en_data = (state == s_mov_da) ? 1'b1 : 1'b0;
assign ram_rd_en_data = (state == s_mov_ad || state == s_mov_ad_2) ? 1'b1 : 1'b0;

//assign ram_rd_addr = (state == s_mov_da) ? IR[7:0] : 3'bzzz;

//xxxxxx acc_load control signal xxxxxx 
assign acc_load = (state == s_mov_ai || state == s_add_ai || state == s_mov_ar_2 || state == s_mov_ad_2 || state == s_xrl_ai) ? 1'b1 : 1'b0;
//assign acc_load = (state == s_mov_ai || state == s_add_ai || state == s_mov_ar_2) ? 1'b1: 1'b0;
assign alu_en = (state == s_decode) ? 1'b1 : 1'b0;

assign pc_inc_offset = (state == s_sjmp) ? 1'b1 : 1'b0;


//Assign the control signal of dptr load
assign dptr_load_high = (state == s_mov_dha) ? 1'b1 : 1'b0;
assign dptr_load_low = (state == s_mov_dla) ? 1'b1 : 1'b0;

assign pc_set = (state == s_jmp) ? 1'b1 : 1'b0;

always @ (posedge clock)                                //CU - start -fetch1-wait-fetch2-decode-execute
begin : FSM
	if (reset == 1'b1) begin // reset
		state <=  s_start;   
	end
	else begin
		case(state)
			s_start :
			    if(reset != 1'b1)
			    begin
				    state <= s_fetch_1;
				end
			s_fetch_1:
				state <= s_fetch_2;
		    s_fetch_2:
		        state <= s_decode;
			s_decode :
                casex(opcode) 
				    `MOV_RI:
				        state <= s_mov_ri;
				    `MOV_DLA:   //move value of A to dptr low
				        state <= s_mov_dla;
				    `MOV_DHA:   //move value of A to dptr high
				        state <= s_mov_dha;
                    `SUBB_RI:
                        state <= s_subb_ri;
                    `ORL_RI:
                        state <= s_orl_ri;
                    `ANL_RI:
                        state <= s_anl_ri;
                    `SJMP:
                        state <= s_sjmp;
                    `MOV_AI:
                        state <= s_mov_ai;
                    `MOV_AR:
                        state <= s_mov_ar;
                    `MOV_RA:
                        state <= s_mov_ra;
                    `MOV_DA:
                        state <= s_mov_da;         
                    `MOV_AD:
                        state <= s_mov_ad;
                    `ADD_AI:
                        state <= s_add_ai;
                    `SUBB_AI:
                        state <= s_subb_ai;
                    `ORL_AI:
                        state <= s_orl_ai;
                    `ANL_AI:
                        state <= s_anl_ai;
                    `XRL_AI:
                        state <= s_xrl_ai;
                    `JNZ:
                        state <= s_jnz;
                    `JZ:
                        state <= s_jz;
                    `JNC:
                        state <= s_jnc;
                    `JMP:
                        state <= s_jmp;                    
                    default : 
			            state <= s_fetch_1;
                 endcase
            s_mov_ri:
                state <= s_start;
            s_mov_ai:
                state <= s_fetch_1;
            s_mov_ar:
                state <= s_mov_ar_2;
            s_mov_ra:
                state <= s_start;
            s_mov_ad:
                state <= s_mov_ad_2;
            s_mov_da:
                state <= s_fetch_1;
            s_add_ai:
                state <= s_fetch_1;
            s_subb_ai:
                state <= s_fetch_1;
            s_subb_ri:
                state <= s_fetch_1;
            s_orl_ai:
                state <= s_fetch_1;
            s_orl_ri:
                state <= s_fetch_1;
            s_anl_ai:
                state <= s_fetch_1;
            s_anl_ri:
                state <= s_fetch_1;
            s_xrl_ai:
                state <= s_fetch_1;
            s_xrl_ri:
                state <= s_fetch_1;
            s_jnz:
                state <= s_fetch_1;
            s_jz:
                state <= s_fetch_1;
            s_jmp:
                state <= s_fetch_1;
            s_sjmp:
                state <= s_fetch_1;
            s_jnc:
                state <= s_fetch_1;
            s_mov_ar_2:
                state <= s_fetch_1;
            s_mov_ad_2:
                state <= s_fetch_1;         
            default : 
			    state <= s_start;
		endcase
	end	
end


      
endmodule