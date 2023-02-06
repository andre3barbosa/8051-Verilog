`timescale 1ns / 1ps

module control_unit(

input clock,
input reset,
input [7:0] opcode,
input int,
output ram_rd_en_reg,
output ram_wr_en_reg,
output [2:0] ram_reg_in_sel,
output [2:0] ram_reg_out_sel,
output ram_rd_en_data,
output ram_wr_en_data,
output rom_en,
output pc_inc,
output pc_inc_offset,
output pc_jmp_z,
output pc_jmp_nz,
output pc_jmp_nc,
output ir_load_high,
output ir_load_low,
output acc_load,
output int_en,
output pop_1_stack,
output pop_2_stack

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
          s_sjmp    = 5'b10011,
          s_jnc     = 5'b10100,
          s_halt    = 5'b10101,
          s_reti1   = 5'b11001,   //first pop
          s_reti2   = 5'b11010,   //second pop
          s_mov_ar_2 = 5'b11011,
          s_mov_ad   = 5'b11100,
          s_mov_da   = 5'b11101,
          s_extra_wr = 5'b11110,
          s_mov_ad_2 = 5'b11111;
//====================================================

  
initial begin
    state <= s_start;
end
   
always @ (posedge clock)  //CU - start -fetch1-wait-fetch2-decode-execute
begin : FSM
	if (reset == 1'b1) begin 
		state <=  s_start;   
	end
	else if(int == 1'b0)begin
		case(state)
			s_start : 
			begin
			    if(reset != 1'b1)
			    begin
				    state <= s_fetch_1;
				end
		    end
			s_fetch_1:
				state <= s_fetch_2;
		    s_fetch_2:
		        state <= s_decode;
			s_decode :
                casex(opcode) 
				    `MOV_RI:
				        state <= s_mov_ri;
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
                    `RETI:
                        state <= s_reti1;
                    `HALT:
                        state <= s_halt;  
                    default : 
			            state <= s_halt;
                 endcase
            s_mov_ri:
                state <= s_extra_wr;
            s_mov_ai:
                state <= s_start;
            s_mov_ar:
                state <= s_mov_ar_2;
            s_mov_ra:
                state <= s_extra_wr;
            s_mov_ad:
                state <= s_mov_ad_2;
            s_mov_da:
                state <= s_start;
            s_add_ai:
                state <= s_start;
            s_subb_ai:
                state <= s_start;
            s_subb_ri:
                state <= s_start;
            s_orl_ai:
                state <= s_start;
            s_orl_ri:
                state <= s_start;
            s_anl_ai:
                state <= s_start;
            s_anl_ri:
                state <= s_start;
            s_xrl_ai:
                state <= s_start;
            s_xrl_ri:
                state <= s_start;
            s_jnz:
                state <= s_start;
            s_jz:
                state <= s_start;
            s_sjmp:
                state <= s_start;
            s_jnc:
                state <= s_start;
            s_mov_ar_2:
                state <= s_start;
            s_mov_ad_2:
                state <= s_start;
            s_reti1:
                state <= s_reti2;
            s_reti2:
                state <= s_start;
            s_extra_wr:
                state <= s_start;
            s_halt:            
                state <= s_halt;             
            default : 
			    state <= s_halt;
		endcase
	end
	else begin
	   if(state == s_halt)
	       //state <= s_fetch_1;
	       state <= s_start;
	end	
end

assign rom_en = (state == s_fetch_1 || state == s_fetch_2) ? 1'b1 : 1'b0;
assign pc_inc = ((state == s_fetch_1 || state == s_fetch_2)) ? 1'b1 : 1'b0;

assign ir_load_high = (state == s_fetch_1) ? 1'b1 : 1'b0;
assign ir_load_low = (state == s_fetch_2) ? 1'b1 : 1'b0;

//Ram storage in register
//enable the storage at register
assign ram_wr_en_reg = (state == s_mov_ri || state == s_mov_ra || state == s_extra_wr) ? 1'b1 : 1'b0;

//Get for which register should be storeed
assign ram_reg_in_sel = (state == s_mov_ri || state == s_mov_ra || state == s_extra_wr) ? opcode[2:0] : 3'bzzz;

//Ram load to register
assign ram_rd_en_reg = (state == s_mov_ar || state == s_mov_ar_2) ? 1'b1 : 1'b0;
assign ram_reg_out_sel = (state == s_mov_ar || state == s_mov_ar_2) ? opcode[2:0] : 3'bzzz;

//Ram storage in direct 
assign ram_wr_en_data = (state == s_mov_da) ? 1'b1 : 1'b0;
assign ram_rd_en_data = (state == s_mov_ad || state == s_mov_ad_2) ? 1'b1 : 1'b0;

//acc_load control signal
assign acc_load = (state == s_mov_ai || state == s_add_ai || state == s_subb_ai || state == s_mov_ar_2 || state == s_mov_ad_2 || state == s_xrl_ai) ? 1'b1 : 1'b0;

assign alu_en = (state == s_decode) ? 1'b1 : 1'b0;


//Short jump with offset
assign pc_inc_offset = (state == s_sjmp) ? 1'b1 : 1'b0;
//Jump if not zero
assign pc_jmp_z = (state == s_jz) ? 1'b1 : 1'b0;
//Jump if zero
assign pc_jmp_nz = (state == s_jnz) ? 1'b1 : 1'b0;
//Jump if not cary
assign pc_jmp_nc = (state == s_jnc) ? 1'b1 : 1'b0;

assign int_en = (state == s_start || state == s_halt) ? 1'b1 : 1'b0;
    
// stack
assign pop_1_stack = (state == s_reti1) ? 1'b1 : 1'b0;
assign pop_2_stack = (state == s_reti2) ? 1'b1 : 1'b0;


      
endmodule