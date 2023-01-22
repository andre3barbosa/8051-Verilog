`timescale 1ns / 1ps


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
