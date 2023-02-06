`timescale 1ns / 1ps

module program_counter(

input clock, 
input reset, 
input inc,
input inc_offset,
input jmp_z, 
input jmp_nz,
input jmp_nc,
input psw_c,
input [7:0] newValue_8bit,
input int,
input [7:0] int_vec,    
input pop_1_stack,
input pop_2_stack,
input [7:0] accValue,
input [7:0] stack_out,

output reg int_ack,
output reg[7:0] stack_in,

output push_stack, 
output reg[15:0] count

);

reg [1:0]state;
wire set_vec;

parameter s_idle  =  2'b00, //if an extra cycle is required to execute the instruction
          s_push1 =  2'b01,
          s_push2 =  2'b10;

initial begin
    count <= 15'h003B;  //reset value of counter
    state <= s_idle;
    int_ack <= 1'b0;
    stack_in <= 8'hzz;
end

always @ (posedge clock)
begin
    if(reset)
        count <= 15'h003B;  //reset value of counter
    else if (inc)
        count <= count + 1;
    else if (inc_offset)
        count <= count + newValue_8bit;
    else if(jmp_z & accValue == 8'b0) begin
        count <= count + newValue_8bit;
    end
    else if(jmp_nz & accValue != 8'b0) begin
        count <= count + newValue_8bit;
    end
    else if(jmp_nc & (~psw_c)) begin
        count <= count + newValue_8bit;
    end
    else if(pop_1_stack) begin
        count[15:8] <= stack_out;
    end
    else if(pop_2_stack) begin
        count[7:0] <= stack_out; 
        int_ack <= 1'b0; 
    end
    else if(set_vec==1'b1) begin
        count <= {8'h00 , int_vec}; 
        int_ack <= 1'b1;
    end
end

always @ (posedge clock)
begin : FSM
	begin
		case(state)
			s_idle :
			 begin
                if(int == 1'b1) begin
                    state <= s_push1;
                    stack_in <= count[7:0]; //first push to stack
			    end
			 end 
			s_push1: 
                begin
			    stack_in <= count[15:8];  //second push
                state <= s_push2;    
                end
            s_push2:
                begin
                  state <= s_idle;  
		        end 	        
		    default: 
		        state <= s_idle;   
        endcase
    end
end

assign push_stack = (state == s_push1 || state == s_push2) ? 1'b1 : 1'b0;
assign set_vec = (state == s_push2) ? 1'b1 : 1'b0;

endmodule
