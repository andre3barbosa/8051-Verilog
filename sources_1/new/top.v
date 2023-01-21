`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/29/2022 06:16:30 AM
// Design Name: 
// Module Name: top
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


module top(
    input clock,
    input reset
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
wire data_vld;
 

 
control_unit ctrl_unit(
	
    .clock(clock),
    .reset(reset),
    .opcode(opcode),
    .ram_rd_en_reg(ram_rd_en_reg),
    .ram_wr_en_reg(ram_wr_en_reg),
    .ram_reg_in_sel(ram_reg_in_sel),
    .ram_reg_out_sel(ram_reg_out_sel),
    .ram_rd_en_data(ram_rd_en_data),
    .ram_rd_en_sfr(ram_rd_en_sfr),
    .ram_wr_en_data(ram_wr_en_data),
    .rom_en(rom_en),
    .pc_inc(pc_inc),
    .pc_inc_offset(pc_inc_offset),
    .pc_set(pc_set),
    .dptr_load_high(dptr_load_high),
    .dptr_load_low(dptr_load_low),
    .ir_load_high(ir_load_high),
    .ir_load_low(ir_load_low),
    .acc_load(acc_load)
);

datapath data_path(

    .clock(clock),
    .reset(reset),
    .ram_rd_byte(ram_rd_byte),
    .rom_byte(rom_byte),
    .ram_rd_en_reg(ram_rd_en_reg),
    .ram_wr_en_reg(ram_wr_en_reg),
    .ram_rd_en_data(ram_rd_en_data),
    .ram_rd_en_sfr(ram_rd_en_sfr),
    .ram_wr_en_data(ram_wr_en_data),
    .rom_en(rom_en),
    .data_vld(data_vld),
    .pc_inc(pc_inc),
    .pc_inc_offset(pc_inc_offset),
    .pc_set(pc_set),
    .dptr_load_high(dptr_load_high),
    .dptr_load_low(dptr_load_low),
    .ir_load_high(ir_load_high),
    .ir_load_low(ir_load_low),
    .acc_load(acc_load),
    .int_a(int_ack),
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
    .ram_rd_en_sfr(ram_rd_en_sfr),
    .ram_wr_en_data(ram_wr_en_data),
    .ram_rd_addr(ram_rd_addr),
    .ram_wr_addr(ram_wr_addr),
    .ram_wr_byte(ram_wr_byte),
    .ram_rd_byte(ram_rd_byte)
);

rom rom(
    .clock(clock),
    .reset(reset),
    .rom_en(rom_en),
    .rom_addr(rom_addr),
    .rom_byte(rom_byte),
    .data_vld(data_vld)
);

timer_8051 timer_8051(
    .clock(clock),        // System clock
    .reset(reset),        // System reset
    .set_TMOD(set_TMOD),
    .set_TCON(set_TCON), 
    .set_TL0(set_TL0), 
    .set_TH0(set_TH0),
    .ram_rd_byte(ram_rd_byte),   //read from the output of ram
    .int_req(int_req)
);

interrupt_control interrupt_control(
    .clock(clock),
    .reset(reset),
    .int_req(int_req),
    .int_ack(int_ack)
);


endmodule
