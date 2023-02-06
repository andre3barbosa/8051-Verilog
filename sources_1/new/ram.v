`timescale 1ns / 1ps

module ram(

input clock,
input reset,
input ram_rd_en_reg,            //enable read from register bank
input ram_wr_en_reg,            //enable write from register bank
input [2:0] ram_reg_in_sel,     //input of register bank to specify the register to write 
input [2:0] ram_reg_out_sel,    //input of register bank to specify the register to read 
input ram_rd_en_data,           //enable read from ram memory
input ram_wr_en_data,           //enable write from ram memory
input [7:0]ram_rd_addr,         //specify the address of the data that will be read
input [7:0]ram_wr_addr,         //specify the address of the data that will be write
input [7:0]ram_wr_byte,         //specify the data input of ram
output [7:0]ram_rd_byte,        //specify the data output of ram


input [7:0] stack_in,           //direct input data to the position pointed from the SP
input push_stack,               
input pop_1_stack,
input pop_2_stack,

input tf0_flag,
input tr0_flag,
input [7:0]P0,  

output int_tf0,
output int_ext0,
output [7:0]P1,

output [7:0]sfr_tmod,
output [7:0]sfr_tcon, 
output [7:0]sfr_tl0, 
output [7:0]sfr_th0, 

output [7:0]stack_out

);

parameter tmod_addr = 8'h88, tcon_addr = 8'h89, tl0_addr  = 8'h8a, th0_addr  = 8'h8c, tr0_bit = 3'b100, tf0_bit = 3'b101;   
parameter ie_addr = 8'ha8, ae_bit = 3'b111, ex0_bit = 3'b000, et0_bit = 3'b001;
parameter p0_addr = 8'h80, ext0_bit = 'd0, p0_0_bit = 'd1; 
parameter p1_addr = 8'h90;

reg [7:0] mem [0:255];
integer i;
    
register_bank REG(clock,reset,ram_wr_en_reg,ram_rd_en_reg,ram_reg_in_sel,ram_reg_out_sel,ram_wr_byte,ram_rd_byte);

reg [7:0]stack_pointer;

/*To detect positive edge*/
reg last_tr0;
reg last_tf0;
wire pe_tf0;
wire pe_tr0;
wire p0_0_deb; //output of p0_1 debounce 


initial begin
    for(i=0; i < 256 ; i = i + 1)
        mem[i] = 8'b00000000;
                
    stack_pointer = 8'h08;
end
     
/*Get the positive edge of tr0 and tf0 flags from timer*/   
always @(posedge clock) begin
    last_tr0 <= tr0_flag;
    last_tf0 <= tf0_flag;
end 



always @(posedge clock)
begin
    if(reset==1'b1) begin    
        for(i=0; i < 256 ; i = i + 1)
            mem[i] = 8'b00000000;
            
        stack_pointer <= 8'h08;
    end    
    else if(ram_wr_en_data)  //write data to ram memmory
    begin
        mem[ram_wr_addr] <= ram_wr_byte;
    end
    else if(push_stack == 1'b1) begin
        stack_pointer = stack_pointer + 1'b1;
        mem[stack_pointer] <= stack_in;                 
    end
    else if(pop_1_stack==1'b1 || pop_2_stack==1'b1) begin   
       stack_pointer <= stack_pointer - 1'b1;  
    end
    else begin
    /*Timer*/
        if(pe_tf0)
            mem[tcon_addr][tf0_bit] <= 1'b1;
        if(pe_tr0)
        mem[tcon_addr][tr0_bit] <= 1'b1;
        
        mem[p0_addr] <= P0;
    end
end
     


//assign to the output of ram the value associated to the read address
//This is the case to read from general purpose memory
assign ram_rd_byte = (ram_rd_en_data == 1'b1 && ram_rd_en_reg == 1'b0) ? mem[ram_rd_addr] : 8'hzz;


assign sfr_tmod = mem[tmod_addr];
assign sfr_tcon = mem[tcon_addr];
assign sfr_tl0  = mem[tl0_addr];
assign sfr_th0  = mem[th0_addr];

/*Deals with external interrupt ext 0*/

//P0_1 debounce
debounce deb(clock,P0[0],p0_0_deb);

assign pe_tf0 = tf0_flag & ~last_tf0;
assign pe_tr0 = tr0_flag & ~last_tr0; 

assign int_ext0 = ((mem[ie_addr][ex0_bit] == 1'b1 || mem[ie_addr][ae_bit] == 1'b1) && p0_0_deb == 1'b1) ? 1'b1 : 1'b0;  //assign the bit one P0 to flag that will inform                          //the interrupt controller of the occurence
//assign int_ext0 = P0[0];
assign int_tf0  = ((mem[ie_addr][et0_bit] == 1'b1 || mem[ie_addr][ae_bit] == 1'b1) && tf0_flag == 1'b1) ? 1'b1 : 1'b0;

/*Assign the sfr P0 to output wire*/
assign P1 = mem[p1_addr]; 

assign  stack_out = mem[stack_pointer]; 
      

endmodule
