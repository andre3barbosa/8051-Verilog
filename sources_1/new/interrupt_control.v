`timescale 1ns / 1ps
 

module interrupt_control(

input clock,
input reset,
input int_en,     

input int_tf0,
input int_ext0,

input int_ack,

output int, 
output [7:0] int_vec

);

reg done_int_ext0;  //sinalize the prev

initial begin
    done_int_ext0 <= 1'b0;
end

always @(posedge clock) begin
    if(reset == 1'b1) 
        done_int_ext0 <= 1'b0;
    else if(int_ext0 == 1'b1 && int_ack == 1'b1 && int_tf0  == 1'b0)
        done_int_ext0 <= 1'b1;
    else if(int_ext0 == 1'b0)
        done_int_ext0 <= 1'b0;  
end

assign int_vec = (int_tf0  == 1'b1) ? 8'h0B :        //timer has higher priority
                 (int_ext0 == 1'b1) ? 8'h03 : 8'h00; //external


//Indicates to the processor a request for interruption
assign int = (int_en == 1'b1 && (int_tf0  == 1'b1 || (int_ext0 == 1'b1 && done_int_ext0 == 1'b0)) && int_ack == 1'b0) ? 1'b1 : 1'b0; 


endmodule

