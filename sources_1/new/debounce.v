`timescale 1ns / 1ps


module debounce(

input clock,
input button,
output outDeb

);      

reg [9:0] ctr_d, ctr_q;
reg [1:0] sync_d, sync_q;
  
initial begin
    ctr_d <= 0;
    ctr_q <= 0;
    sync_d <= 0;
    sync_q <= 0;
end

always @(*) begin
    sync_d[0] = button;
    sync_d[1] = sync_q[0];
    ctr_d = ctr_q + 1'b1;

if (ctr_q == {10{1'b1}}) begin
  ctr_d = ctr_q;
end

if (!sync_q[1])
  ctr_d = 10'd0;
end
 
always @(posedge clock) begin
    ctr_q <= ctr_d;
    sync_q <= sync_d;
end
 
assign outDeb = ctr_q == {10{1'b1}}; 
 
endmodule
