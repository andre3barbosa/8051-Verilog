`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/29/2022 05:27:19 AM
// Design Name: 
// Module Name: rom
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
module rom(
    input clock,
    input reset,
    input rom_en,
    input [15:0] rom_addr,
    output [7:0] rom_byte,
    output reg data_vld
    );
    
    reg [7:0] ROM[0:1040];  //1k
    
    
    initial begin
//        ROM[0]  = 8'b01110100;  //mov to acc the immediate 1
//        ROM[1]  = 8'b00000001;
//        ROM[2]  = 8'b00100100;  //add a,i
//        ROM[3]  = 8'b00000001; 
//        ROM[4]  = 8'b00100100; //add a,i
//        ROM[5]  = 8'b00000011;
//        ROM[6]  = 8'b10000000; //sjump to address 254
//        ROM[7]  = 8'hf6;               
//        ROM[254]  = 8'b00100100; //add a,i
//        ROM[255]  = 8'b00000011;
//        ROM[256]  = 8'b10100001; //load dptr low   
//        ROM[257]  = 8'b00000010;
//        ROM[258]  = 8'b10100010; //load dptr high   
//        ROM[259]  = 8'b00000000;
//        ROM[260]  = 8'b01110100;  //mov to acc the immediate 0
//        ROM[261]  = 8'b00000000;
//        ROM[262]  = 8'b01110011; //jmp absolute   
//        ROM[263]  = 8'b00000000;

////    Code to perform mov tests
//        ROM[0]  = 8'b01111001;  //Mov to reg1 the immediate
//        ROM[1]  = 8'h03;        //value 3       
//        ROM[2]  = 8'b01111111;  //Mov to reg7 the immediate
//        ROM[3]  = 8'h06;        //value 6 
//        ROM[4]  = 8'b11101111;  //Mov to A the value of reg7
//        ROM[5]  = 8'h00;       
//        ROM[6]  = 8'b11101001;  //Mov to A the value of reg1
//        ROM[7]  = 8'h00;

////    Code to perform other mov tests
        //        ROM[0] = 8'b01110100;   //mov imm to acc
        //        ROM[1] = 8'h02;
        //        ROM[2] = 8'b11111011;   //Mov Acc to reg3
        //        ROM[3] = 8'h00;
        //        //now acc to dir
        //        ROM[4] = 8'b01110100;
        //        ROM[5] = 8'h03;
        //        ROM[6] = 8'b11110101;   //Mov Acc to direct 70h
        //        ROM[7] = 8'h70;
        //        ROM[8] = 8'b01110100;   //mov imm to acc
        //        ROM[9] = 8'h04;
        //        ROM[10] = 8'b1110_0101;   //Mov Acc to direct 70h
        //        ROM[11] = 8'h70;
        
//        ROM[8] = 8'b01110100;
//        ROM[9] = 8'h05;
//        ROM[10] = 8'b11110101;   //Mov Acc to direct 70h
//        ROM[11] = 8'h70;
        //ROM[256]  = 8'b11100111;  //jmp to 00 addres
        //ROM[257]  = 8'h00;
        
        
//         ROM[0] = 8'b01110100;   //mov imm to acc
//         ROM[1] = 8'b11000000;   //tr0   c0
//         ROM[2] = 8'b01100100;   //xrl acc ^ imm
//         ROM[3] = 8'b00010000;   // 1
        
        
        ROM[0] = 8'b01110100;   //mov imm to acc
        ROM[1] = 8'b11000000;   //tr0   c0
        ROM[2] = 8'b11110101;   //Mov Acc to direct 08h
        ROM[3] = 8'h08;
        
        
        
        
        
        //data_vld = 1'b0;
    end
       
    
    assign rom_byte = (rom_en == 1'b1) ? ROM[rom_addr] : 8'hzz;
    
                
endmodule
