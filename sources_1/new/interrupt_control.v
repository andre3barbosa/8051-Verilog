`timescale 1ns / 1ps
 
 

module interrupt_control(clock, reset, int_en, int_req, int_pend, int, int_vec, int_ack);

input clock;
input reset;
input int_en;       // to see if can be interrupted
input int_req;      // signal is the input interrupt request from the external interrupt signal.
input int_pend;     // interrupt pendent to identy if is by timer or external
//input [7:0]ie_sfr;  // to decide if it will interrupt
input int_ack;

output int;     //interrupt acknowledge signal from the 8051 CPU to the external device.
output int_vec;

reg [7:0]ie_sfr;

initial begin
    ie_sfr <= 8'b10000010;
end

// pend=1 vector=0x0B
// pend=0 vector=0x03
assign int_vec = (int_pend == 1'b1 && int_req == 1'b1 && (ie_sfr[1] == 1'b1 || ie_sfr[7] == 1'b1)) ? 8'h0B :        //timer
                 (int_pend == 1'b0 && int_req == 1'b1 && (ie_sfr[0] == 1'b1 || ie_sfr[7] == 1'b1)) ? 8'h03 : 8'hzz; //external

//interrupt
assign int = (int_en == 1'b1 && int_req == 1'b1 && (int_vec == 8'h0B || int_vec == 8'h03) && int_ack == 1'b0) ? 1'b1 : 1'b0; 


//always @(posedge clock or negedge reset) begin
//  if (reset) begin
//    int_ack <= 1'b0;
//  end 
//  else begin
//    if (int_req) begin
//      int_ack <= 1'b1;
//    end else begin
//      int_ack <= 1'b0;
//    end
//  end
//end


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
