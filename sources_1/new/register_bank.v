`timescale 1ns / 1ps


module register_bank(

input clock,
input reset,
input write_data,
input read_data,
input [2:0] reg_in_select,  //register to write in
input [2:0] reg_out_select, //register to read from
input [7:0] reg_in_data,
output [7:0] reg_out_data

);
    
reg[7:0] registerb [7:0];   //register bank
wire [7:0] output_value;
integer i;
    
always @(posedge clock)
begin
    if(reset)
    begin
        for(i = 0; i < 8; i = i+1) begin
            registerb[i] <= 8'd0;
        end
    end
    else if(write_data)
    begin
        registerb[reg_in_select] <= reg_in_data;
    end
 end 
     
assign reg_out_data = (read_data == 1'b1) ?  registerb[reg_out_select] : 8'hzz;
    
endmodule
