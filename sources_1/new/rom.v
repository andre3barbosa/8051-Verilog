`timescale 1ns / 1ps

module rom(

input rom_en,
input [15:0] rom_addr,
output [7:0] rom_byte

);
    
reg [7:0] ROM[0:1040];  //1k
    
    
initial begin
    
    
    ROM[3] = 8'b01110100;   //direct to acc
    ROM[4] = 8'h0f;         //direct is P1   
    ROM[5] = 8'b11110101;   //add imm to acc
    ROM[6] = 8'h90;         //add one
    ROM[7] = 8'b00110010;   //Mov Acc to direct 8ch
    ROM[8] = 8'h00;
    
    
    //Subtract 1 to the value of R1
    ROM[11] = 8'b11101001;  //get the value of R1 to acc
    ROM[12] = 8'h00;
    ROM[13] = 8'b10010100;  //subtrat 1 to the value of acc
    ROM[14] = 8'h01;
    ROM[15] = 8'b11111001; //updat R1 with acc value
    ROM[16] = 8'h00;
    
    //Jump if R1 is 0
    ROM[17] = 8'b01110000;  //jump if not zero
    ROM[18] = 8'h08;
    //If zero, increment the value of P0
    ROM[19] = 8'b11100101;   //direct to acc
    ROM[20] = 8'h90;         //direct is P1   
    ROM[21] = 8'b00100100;   //add imm to acc
    ROM[22] = 8'h01;         //add one
    ROM[23] = 8'b11110101;   //Mov Acc to direct 8ch
    ROM[24] = 8'h90;
    //Update again the value of R1 to ff
    ROM[25] = 8'b01111001;   //update the value of R1 to ff
    ROM[26] = 8'hff;
    //Reti
    ROM[27] = 8'b00110010;   //Mov Acc to direct 89h
    ROM[28] = 8'h00;



//********** Turn on led and when timer on call isr ************//
    ROM[59] = 8'b01110100;   //mov imm to acc
    ROM[60] = 8'b00000001;   //value
    ROM[61] = 8'b11110101;   //mov acc to dir P1
    ROM[62] = 8'h90;        //position in memory
    ROM[63] = 8'b01110100;   //mov imm to acc
    ROM[64] = 8'h01;         //TMOD 0
    ROM[65] = 8'b11110101;   //Mov Acc to direct 88h
    ROM[66] = 8'h88;
    ROM[67] = 8'b01110100;   //mov imm to acc
    ROM[68] = 8'h00;         //load TL0
    ROM[69] = 8'b11110101;   //Mov Acc to direct 8ch
    ROM[70] = 8'h8a;
    ROM[71] = 8'b01110100;   //mov imm to acc -----------------
    ROM[72] = 8'h00;         //load TH0 
    ROM[73] = 8'b11110101;   //Mov Acc to direct 8ch
    ROM[74] = 8'h8c;
    ROM[75] = 8'b01110100;   //mov imm to acc
    ROM[76] = 8'b10000011;   //enable EA
    ROM[77] = 8'b11110101;   //Mov Acc to direct 89h EA
    ROM[78] = 8'ha8;
    ROM[79] = 8'b01110100;   //mov imm to acc
    ROM[80] = 8'b00010000;   //enable TR0
    ROM[81] = 8'b11110101;   //Mov Acc to direct 89h
    ROM[82] = 8'h89; 
    ROM[83] = 8'b01111001;   //update the value of R1 to ff
    ROM[84] = 8'hff;
    
    //HALT
    ROM[85]= 8'b10011000;   //halt
    ROM[86]= 8'h00;
    ROM[87]= 8'b10011000;   //halt
    ROM[88]= 8'h00;
        
end
   

assign rom_byte = (rom_en == 1'b1) ? ROM[rom_addr] : 8'hzz;

                
endmodule
