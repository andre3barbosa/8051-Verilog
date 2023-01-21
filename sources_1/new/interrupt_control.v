`timescale 1ns / 1ps
 
 

module interrupt_control(clock, reset, int_req, int_ack);

input clock;
input reset;

input int_req;      //signal is the input interrupt request from the external interrupt signal.
output reg int_ack; //interrupt acknowledge signal from the 8051 CPU to the external device.


always @(posedge clock or negedge reset) begin
  if (reset) begin
    int_ack <= 1'b0;
  end 
  else begin
    if (int_req) begin
      int_ack <= 1'b1;
    end else begin
      int_ack <= 1'b0;
    end
  end
end


endmodule

//module interrupt_control(clock, reset,

////timer interrupts
//        tf0, tr0,
////external interrupts
//        ie0, ie1,
////to cpu
//        reti, int_vec, int_ack,
////registers
//	    ie, tcon 

//);

//input clock;
//input reset;

//input tf0;
//output tr0;

////indicate the status of external interrupts
//input ie0; 
//input ie1;

//input reti; 
//input int_ack;


//output reg [7:0] int_vec;
//output ie;
//output tcon;



//endmodule
