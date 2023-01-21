`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/05/2023 12:54:52 AM
// Design Name: 
// Module Name: tb_mov
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


module tb_mov();
    
    reg clock;
    reg reset;
  
    top c8051(
        .clock(clock),
        .reset(reset)
    ); 
    
    initial begin
        clock = 0;
        reset = 1;
        
        #30;
		reset = 0;
    end
    
    always #5 clock = ~clock;
    

endmodule
