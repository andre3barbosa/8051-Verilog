`timescale 1ns / 1ps

module stack(clock, reset, enable, pushpop, data_in, data_out, stack_empty, stack_full);

input clock;
input reset;
input enable;
input pushpop;
input [7:0]data_in;

output reg[7:0]data_out;
output reg stack_empty;
output reg stack_full;

reg [7:0]stack_memory[0:15];
reg [3:0]stack_pointer;


always@(posedge clock or negedge reset)begin
    if(reset==0) begin
        stack_pointer = 4'd0;
        stack_empty = 1'b1;
        stack_full = 1'b0;
    end
    else if(enable==1)begin
        
        if(pushpop==1 && stack_full==0)begin // push, make sure stack is not full
            stack_empty <= 0;
            stack_pointer = stack_pointer + 1;
            stack_memory[stack_pointer] <= data_in;
                
                if(stack_pointer==4'd7)
                    stack_full <= 1;
        end
    end
    else if(pushpop==0 && stack_empty==0)begin // pop, make sure stack is not already empty
            stack_full <= 0;
            data_out <= stack_memory[stack_pointer];
            stack_pointer = stack_pointer - 1;

                if(stack_pointer==4'd0)
                    stack_empty <= 1;
        
    end
      
 end   
   
    
endmodule
