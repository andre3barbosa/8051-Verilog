`timescale 1ns / 1ps


module tb_top();
    
    reg clock = 1'b0;
    reg reset;
    reg [7:0]P0;
    wire [7:0]P1;
  
    top c8051(
        .clock(clock),
        .reset(reset),
        .P0(P0),
        .P1(P1)
    ); 
    wire out;
    reg P0_1 = 1'b0;
    
//    initial begin
//        P0_1 <= 1'b00;
//    end
    
//    debounce deb(clock,P0_1,out);
//    debounce deb(
//        .clock(clock),
//        .pin_i(P0_1),
//        .pin_o(out)
//    );
    
    initial begin
        clock = 0;
        reset = 1;
        P0 = 8'h01;  
        
        #30;
		reset = 0;
    end
    
    always #5 clock = ~clock;


//// Test
//initial begin
//// Reset
//@(negedge clock) begin
//P0_1 <= 1'b0;
//end

//always @(posedge clock) begin

//end

//@(negedge clock) begin
//P0_1 <= 1'b1;
//end


//// Load a value
//@(negedge clock) begin
//P0_1 <= 1'b0;
//end

//@(negedge clock) begin
//P0_1 <= 1'b1;
//end

//@(negedge clock) begin
//end

//@(negedge clock) begin

//end


endmodule
