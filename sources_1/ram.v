`timescale 1ns / 1ps

module ram(
    input clock,
    input reset,
    input ram_rd_en_reg,
    input ram_wr_en_reg,
    input [2:0] ram_reg_in_sel,
    input [2:0] ram_reg_out_sel,
    input ram_rd_en_data,
    input ram_rd_en_sfr,
    input ram_wr_en_data,
    input [7:0]ram_rd_addr,
    input [7:0]ram_wr_addr,
    input [7:0]ram_wr_byte,
    output [7:0]ram_rd_byte,
    
    
    //stack
    input enable_stack,
    input [7:0] stack_in,
    input push_1_stack,
    input push_2_stack,
    input pop_1_stack,
    input pop_2_stack,

    input tf0_flag,
    input tr0_flag,
    input [7:0]P0,  //Io port 0
    
    output [7:0]sfr_tmod,
    output [7:0]sfr_tcon, 
    output [7:0]sfr_tl0, 
    output [7:0]sfr_th0, 
    
    output [7:0]stack_out,
    //output int_pend,
    //output int_req,
    output [7:0]ie_sfr
    
    );
    
    parameter tmod_addr = 8'h88, tcon_addr = 8'h89, tl0_addr  = 8'h8a, th0_addr  = 8'h8c, tr0_bit = 3'b100, tf0_bit = 3'b101;   
    parameter ie_addr = 8'ha8, ae_bit = 3'b111, ex0_bit = 3'b000, et0_bit = 3'b001;
    parameter p0_addr = 8'h80, ext0_bit = 'd0, p0_0_bit = 'd1; 
    
    reg [7:0] mem [0:255];
    integer i;
    
    register_bank REG(clock,reset,ram_wr_en_reg,ram_rd_en_reg,ram_reg_in_sel,ram_reg_out_sel,ram_wr_byte,ram_rd_byte);
    
    
    always @(posedge clock)
    begin
    //mem.fill(8'b0);
        if(reset)
        begin
            for(i=0; i < 256 ; i = i + 1)
            begin
                mem[i] = 8'b00000000;
            end
        end
     end
     
     always @(posedge clock)
     begin
        if(ram_wr_en_data)
        begin
            mem[ram_wr_addr] = ram_wr_byte;
        end
     end
     
     //assign to the output of ram the value associated to the read address
     //This is the case to read from general purpose memory
     assign ram_rd_byte = (ram_rd_en_data == 1'b1 && ram_rd_en_reg == 1'b0) ? mem[ram_rd_addr] : 8'hzz;
     
     
    //****************************************** 
    //*************** stack ********************
    //******************************************
    reg [7:0]stack_pointer;
    
    initial begin
        stack_pointer <= 8'h08;
//        int_req <= 1'b0;
//        int_pend <= 1'b0;
    end


    always@(posedge clock)begin
        if(reset==1'b1) begin
            stack_pointer = 8'h08;
        end
        else if(enable_stack==1'b1)begin
            
            if(push_1_stack==1'b1 || push_2_stack==1'b1)begin // push, make sure stack is not full
                stack_pointer = stack_pointer + 1'b1;
                mem[stack_pointer] <= stack_in; //stack_int
            end
        end   
         
        if(pop_1_stack==1'b1 || pop_2_stack==1'b1) begin   
           stack_pointer = stack_pointer - 1'b1;  
        end
                
         
     end  
     
     assign  stack_out = mem[stack_pointer]; 
     
     
     //****************************************** 
    //*************** Timer ********************
    //******************************************
    //Always the TR0 flag has a transition to one
//     always @(posedge mem[tcon_addr][4]) begin
//        if(mem[tmod_addr][1:0] == 2'h2)         //if Mode 2
//            mem[tl0_addr] <= mem[th0_addr];     //update the tl0 with th0
//     end
     
//     always @(posedge clock)
//     begin
//        if(mem[tcon_addr][4]== 1'b1) begin   //if TR0 is 1
//            case(mem[tmod_addr][1:0])
//            0:  //mode 0
//                //Th0 holds the MSBs bits and Tl0 holds the five LSBs in TL0.4-TL0.0
//                //The 4 MSB bits of TL0 should be undeterminate and masked out
//                if(mem[tmod_addr][2] == 1'b0) begin         //timer mode
                    
//                    if(mem[tl0_addr] == 8'h1f) begin        //if tl0 equals 0x1f
//                        if(mem[th0_addr] == 8'hff)          //if th0 equal 0xff
//                            mem[tcon_addr][5] <= 1'b1;      //put flag overflow to one 
                        
//                        mem[th0_addr] <= mem[th0_addr] + 1;
//                    end
                    
//                    mem[tl0_addr] <= (mem[tl0_addr] + 1) & 8'b00011111; //mask the tl0 register
//                end       
                        
                         
//                    /*if(mem[tl0_addr] 8'h1F) begin
//                        if(mem[th0_addr]==8'hff) begin
//                            mem[tcon_addr][5] <= 1'b1;    //put flag overflow to one
//                            mem[th0_addr] <= mem[th0_addr] + 1;
//                        end
//                        else
//                            mem[th0_addr] <= mem[th0_addr] + 1; 
//                        end
//                        else
//                            mem[tl0_addr] <= mem[tl0_addr] + 1;           
//                end*/
//            1:  //Mode 1 - 16-bit timer/counter
            
//                if(mem[tmod_addr][2] == 1'b0) begin         //timer mode
                    
//                    if(mem[tl0_addr] == 8'hff) begin        //if tl0 equals 0x1f
//                        if(mem[th0_addr] == 8'hff)          //if th0 equal 0xff
//                            mem[tcon_addr][5] <= 1'b1;      //put flag overflow to one 
                        
//                        mem[th0_addr] <= mem[th0_addr] + 1; //increment the th0 reg
//                    end
                    
//                    mem[tl0_addr] <= (mem[tl0_addr] + 1);   //increment the tl0 reg
//                end  
            
//            2:  //mode 2
//                if(mem[tmod_addr][2] == 1'b0) begin //timer mode
//                    mem[tl0_addr] <= mem[tl0_addr] + 1;
//                    if(mem[tl0_addr]==8'hff) begin
//                        //ov_flag <= 1'b1;
//                        mem[tcon_addr][5] <= 1'b1;    //put flag overflow to one
//                    end
//                end
//            3:
//            ;
    
//            endcase
        
        
//        end    
//     end
     
//     //deals with overflow of timer
//     always @(posedge mem[tcon_addr][5] == 1'b1)
//     begin
//            case(mem[tmod_addr][1:0])
//            0:  mem[tcon_addr][4] <= 1'b0; //reset TR0
//            1:  mem[tcon_addr][4] <= 1'b0; //reset TR0            
//            2:  begin
//                mem[tl0_addr] <= mem[th0_addr];    //put flag overflow to one
//                mem[tcon_addr][5] <= 1'b0;
//                end
//            3:;
//            endcase
//     end     
     always @(posedge tf0_flag) begin
        mem[tcon_addr][tf0_bit] <= 1'b1;
     end
     always @(negedge tr0_flag) begin
        mem[tcon_addr][tr0_bit] <= 1'b0;
     end
     always @(posedge clock) begin
        mem[] <= P0;
     end 
     

    assign sfr_tmod = mem[tmod_addr];
    assign sfr_tcon = mem[tcon_addr];
    assign sfr_tl0  = mem[tl0_addr];
    assign sfr_th0  = mem[th0_addr];
     
     //assign int_req = mem[tcon_addr][5];
     //assign int_pend = (mem[tcon_addr][5]==1'b1)? 1'b1 : 1'bz;
     assign ie_sfr[7:0] = mem[ie_addr];
            
    
endmodule
