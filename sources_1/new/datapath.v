`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/28/2022 06:17:30 AM
// Design Name: 
// Module Name: datapath
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


module datapath(
    input clock,
    input reset,
    input [7:0] ram_rd_byte,
    input [7:0] rom_byte,
    input ram_rd_en_reg,    
    input ram_wr_en_reg,    //write in register 
    input ram_wr_en_sfr,    //write in sfr
    input ram_rd_en_data,   //read from data
    input ram_rd_en_sfr,    //read from sfr
    input ram_wr_en_data,   //write from data
    input rom_en,
    input data_vld,
    input pc_inc,
    input pc_inc_offset,
    input pc_set,
    input dptr_load_high,
    input dptr_load_low,   
    input ir_load_high,
    input ir_load_low,
    input acc_load,
    
    input int_a,
    
    output [7:0] ram_rd_addr,       //ram address to read
    //output reg [7:0] ram_rd_addr,   //ram address to read
    output [7:0] ram_wr_addr,   //ram address to write
    output [7:0] ram_wr_byte,   //data to write
    output [7:0] opcode,
    output wire [15:0] rom_addr     //rom address
    );
    
    //wire [15:0] pc_jmp_addr;

    wire [15:0] IR;
    //reg [7:0] ACC;
    wire [7:0] operand2_alu;
    wire [7:0] acc_out;
    wire [15:0] dptr_out;
    reg [7:0] PSW;
    
    wire [8:0]ALU_result;
    
    wire [7:0]acc_in = (ram_rd_en_reg == 1'b1 || ram_rd_en_data == 1'b1) ? ram_rd_byte : ALU_result[7:0];
    
    //program_counter pc(clock, reset, pc_inc, pc_set,IR[7:0], rom_addr);
    instruction_register ir(clock,reset,ir_load_high,ir_load_low,rom_byte,IR);
    arithmetic_logic_unit alu(clock,reset,acc_out,IR[7:0],opcode[7:0],alu_en,ALU_result[8:0]);
    register_8bit acc(clock, reset, acc_load, acc_in, acc_out);
  
//    program_counter pc_dp(clock, reset,pc_inc, pc_inc_offset, pc_set, operand2_alu[7:0], dptr_out, acc_out, rom_addr);
    program_counter pc_dp(clock, reset,pc_inc, pc_inc_offset, pc_set, operand2_alu[7:0], dptr_out, acc_out, int_a, rom_addr);
    
    
    register_16bit dptr_dp(clock, reset, dptr_load_high, dptr_load_low, IR[7:0], dptr_out);  
    
    
   // interrupt_control ISR(clock, reset, int_r, int_a, rom_addr);
    
    assign opcode = IR[15:8];
    
    //assign acc_copy = ACC;
    
    initial begin
        //ACC = 0;
    end
    
    assign ram_wr_addr = (ram_wr_en_data == 1'b1) ? IR[7:0] : 8'hzz;
    assign ram_rd_addr = (ram_rd_en_data == 1'b1) ? IR[7:0] : 8'hzz;
    
    assign ram_wr_byte = (ram_wr_en_reg == 1'b1) ? 
                        ((opcode[7:3] == 5'b11111) ? acc_out : IR[7:0])
                        :(ram_wr_en_data == 1'b1) ? acc_out : 8'hzz;
                        
//    always @(posedge clock)
//    begin 
//        if(ram_wr_en_reg == 1'b1)   begin
//            if(opcode[7:3] == 5'b11111)
//                ram_wr_byte = acc_out;
//            else 
//                ram_wr_byte = IR[7:0];
//        end
//        else if(ram_wr_en_data == 1'b1) begin
//            ram_wr_byte = acc_out;
            
//        end
//    end
    
    
    
endmodule
