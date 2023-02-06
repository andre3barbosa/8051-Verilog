`timescale 1ns / 1ps


module datapath(

input clock,
input reset,
input [7:0] ram_rd_byte,
input [7:0] rom_byte,
input ram_rd_en_reg,    
input ram_wr_en_reg,    //write in register 
input ram_rd_en_data,   //read from data
input ram_wr_en_data,   //write from data

input pc_inc,
input pc_inc_offset,
input ir_load_high,
input ir_load_low,
input acc_load,

input pc_jmp_z,
input pc_jmp_nz,
input pc_jmp_nc,

input int,
input [7:0] int_vec,
input pop_1_stack,
input pop_2_stack,
input [7:0] stack_out,

output [7:0] opcode,
output int_ack,

output [7:0]stack_in,
output push_stack,

output [7:0] ram_rd_addr,   //ram address to read
output [7:0] ram_wr_addr,   //ram address to write
output [7:0] ram_wr_byte,   //data to write    
output wire [15:0] rom_addr //rom address

);

wire [15:0] IR;
reg [7:0] PSW;
wire psw_c;

wire [8:0]ALU_result;
wire [7:0]acc_in = (ram_rd_en_reg == 1'b1 || ram_rd_en_data == 1'b1) ? ram_rd_byte : ALU_result[7:0];
wire [7:0] acc_out;


instruction_register ir(clock, reset, ir_load_high, ir_load_low, rom_byte, IR);

arithmetic_logic_unit alu(clock, reset, acc_out, IR[7:0], opcode[7:0], ALU_result[8:0], psw_c);

register_8bit acc(clock, reset, acc_load, acc_in, acc_out);

program_counter pc_dp(clock, reset, pc_inc, pc_inc_offset, pc_jmp_z, pc_jmp_nz, pc_jmp_nc, psw_c, IR[7:0], int, int_vec, pop_1_stack, pop_2_stack,acc_out, stack_out, int_ack, stack_in[7:0], push_stack, rom_addr);


assign opcode = IR[15:8];

assign ram_wr_addr = (ram_wr_en_data == 1'b1) ? IR[7:0] : 8'hzz;

assign ram_rd_addr = (ram_rd_en_data == 1'b1) ? IR[7:0] : 8'hzz;

assign ram_wr_byte = (ram_wr_en_reg == 1'b1) ? 
                    ((opcode[7:3] == 5'b11111) ? acc_out : IR[7:0])
                    :(ram_wr_en_data == 1'b1) ? acc_out : 8'hzz;
                            
endmodule
