`timescale 1ns / 1ps

module top(

input clock,
input reset,
input [7:0]P0,   //external interrupt pin input
output [7:0]P1  //io port in read mode

);

wire [7:0] opcode; 
wire [15:0] rom_addr;
wire [7:0] ram_rd_addr;
wire [7:0] ram_wr_addr;
wire [7:0] ram_rd_byte;
wire [7:0] ram_wr_byte;
wire [7:0] rom_byte;
wire [2:0] ram_reg_in_sel;
wire [2:0] ram_reg_out_sel;

wire [7:0]stack_in;
wire [7:0]stack_out;
wire [7:0]int_vec;

wire [7:0]sfr_tmod;
wire [7:0]sfr_tcon;
wire [7:0]sfr_tl0;
wire [7:0]sfr_th0;

 
control_unit ctrl_unit(
	
    .clock(clock),
    .reset(reset),
    .opcode(opcode),
    .int(int),
    .ram_rd_en_reg(ram_rd_en_reg),
    .ram_wr_en_reg(ram_wr_en_reg),
    .ram_reg_in_sel(ram_reg_in_sel),
    .ram_reg_out_sel(ram_reg_out_sel),
    .ram_rd_en_data(ram_rd_en_data),
    .ram_wr_en_data(ram_wr_en_data),
    .rom_en(rom_en),
    .pc_inc(pc_inc),
    .pc_inc_offset(pc_inc_offset),
    .pc_jmp_z(jmp_z),
    .pc_jmp_nz(jmp_nz),
    .pc_jmp_nc(pc_jmp_nc),
    .ir_load_high(ir_load_high),
    .ir_load_low(ir_load_low),
    .acc_load(acc_load),
    .int_en(int_en),
    .pop_1_stack(pop_1_stack),
    .pop_2_stack(pop_2_stack)
);

datapath data_path(
    .clock(clock),
    .reset(reset),
    .ram_rd_byte(ram_rd_byte),
    .rom_byte(rom_byte),
    .ram_rd_en_reg(ram_rd_en_reg),
    .ram_wr_en_reg(ram_wr_en_reg),
    .ram_rd_en_data(ram_rd_en_data),
    .ram_wr_en_data(ram_wr_en_data),
    .pc_inc(pc_inc),
    .pc_inc_offset(pc_inc_offset),
    .ir_load_high(ir_load_high),
    .ir_load_low(ir_load_low),
    .acc_load(acc_load),
    .pc_jmp_z(jmp_z),
    .pc_jmp_nz(jmp_nz),
    .pc_jmp_nc(pc_jmp_nc),
    .int(int),
    .int_vec(int_vec),
    .pop_1_stack(pop_1_stack),
    .pop_2_stack(pop_2_stack),
    .stack_out(stack_out),
    .int_ack(int_ack),
    .stack_in(stack_in),
    .push_stack(push_stack),
    .ram_rd_addr(ram_rd_addr),
    .ram_wr_addr(ram_wr_addr),
    .ram_wr_byte(ram_wr_byte),
    .opcode(opcode),
    .rom_addr(rom_addr)
);

ram ram(
    .clock(clock),
    .reset(reset),
    .ram_rd_en_reg(ram_rd_en_reg),
    .ram_wr_en_reg(ram_wr_en_reg),
    .ram_reg_in_sel(ram_reg_in_sel),
    .ram_reg_out_sel(ram_reg_out_sel),
    .ram_rd_en_data(ram_rd_en_data),
    .ram_wr_en_data(ram_wr_en_data),
    .ram_rd_addr(ram_rd_addr),
    .ram_wr_addr(ram_wr_addr),
    .ram_wr_byte(ram_wr_byte),
    .ram_rd_byte(ram_rd_byte),
    .stack_in(stack_in),
    .push_stack(push_stack),
    .pop_1_stack(pop_1_stack),
    .pop_2_stack(pop_2_stack),
    .tf0_flag(tf0_flag),
    .tr0_flag(tr0_flag),
    .P0(P0),
    .int_tf0(int_tf0),
    .int_ext0(int_ext0),
    .P1(P1),
    .sfr_tmod(sfr_tmod),
    .sfr_tcon(sfr_tcon), 
    .sfr_tl0(sfr_tl0), 
    .sfr_th0(sfr_th0),
    .stack_out(stack_out)
);

rom rom(
    .rom_en(rom_en),
    .rom_addr(rom_addr),
    .rom_byte(rom_byte)
);

timer_8051 timer_8051(
    .clock(clock),        // System clock
    .reset(reset),        // System reset
    .sfr_tmod(sfr_tmod),
    .sfr_tcon(sfr_tcon),
    .sfr_tl0(sfr_tl0),
    .sfr_th0(sfr_th0),
    .P0_1(P0[1]),       //pin 1 is the counter source
    .int_ack(int_ack),
    .tf0_flag(tf0_flag),
    .tr0_flag(tr0_flag)
);

interrupt_control interrupt_control(
    .clock(clock),
    .reset(reset),
    .int_en(int_en),
    .int_tf0(int_tf0),
    .int_ext0(int_ext0),
    .int(int),
    .int_vec(int_vec),
    .int_ack(int_ack)
);
 

endmodule
