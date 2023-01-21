`timescale 1ns / 1ps

module timer_8051(
    input clock,        // System clock
    input reset,        // System reset
    input set_TMOD,
    input set_TCON, 
    input set_TL0, 
    input set_TH0,
    input [7:0]ram_rd_byte,   //read from the output of ram
    //input tim_en
        output int_req
    
    );
    reg [7:0]tmod;
    reg [7:0]tcon;
    reg [7:0]tl0;
    reg [7:0]th0;
    initial begin
        tmod = 8'h02;   //mode 2 - 8-bit autoreload
        tcon = 8'h10;     
        tl0 = 8'h00;     //holds the count value
        th0 = 8'h80;    //reload value  
    end
    
    //output of register
//    wire [7:0]TL0_out;
//    wire [7:0]TH0_out;
//    wire [7:0]TMOD_out;
//    wire [7:0]TCON_out;
//    reg [3:0]up;
    
//    register_8bit sfr_TL0(clock,reset,set_TL0, ram_rd_byte,TL0_out);
//    register_8bit sfr_TH0(clock,reset,set_TH0, ram_rd_byte,TH0_out);
//    register_8bit sfr_TMOD(clock,reset,set_TMOD, ram_rd_byte,TMOD_out);
//    register_8bit sfr_TCON(clock,reset,set_TCON, ram_rd_byte,TCON_out);
    
//    always @(posedge clock) begin
//        if(up[0] == 1'b1)  //TCON modified
//        begin
            
//            up[0] == 1'b0;
//        end
//        else if(up[1] == 1'b1)
//        begin
        
//            up[0] == 1'b0;
//        end
//        else if(up[2] == 1'b1)
//        begin
        
//            up[0] == 1'b0;
//        end
//        else if(up[3] == 1'b1)
//        begin
        
//            up[0] == 1'b0;
//        end
//    end
//    `define TOM =   TMOD_out[1:0];  //timer 0 mode select
//    `define C_T0 =  TMOD_out[2];   
//    `define GATE0 = TMOD_out[3];
//    //Tcon
//    `define TR0 = TCON_out[4];
//    `define TF0 = TCON_out[5];
    
    
//    always @(posedge set_TL0) begin
//        up <= {1'b1,up[2:0]};
//    end
//        always @(posedge set_TH0) begin
//        up <= {up[3],1'b1,up[1:0]};
//    end
//        always @(posedge set_TMOD) begin
//        up <= {up[3:2],1'b1,up[0]};
//    end
//        always @(posedge set_TCON) begin
//        up <= {up[3:1],1'b1};
//    end
    
always @(posedge clock) begin
    case(tmod[1:0])
    0:  //mod
    ;
    1:
    ;
    2:  //mode 2
        if(tmod[2] == 1'b0) begin //timer mode
            tl0 <= tl0 + 1;
        end
    3:
    ;
    
    endcase
    if(tl0 == 8'h00) begin
        tcon[5] <= 1'b1;    //put flag overflow to one
    end 
    //if(tcon[5] == 
    
end

always @(posedge clock) begin
    if(tl0 == 8'hff) begin
        tcon[5] <= 1'b1;    //put flag overflow to one

    end
end

//every time reaches overflow enable interrupt request
assign int_req = (tcon[5] == 1'b1) ? 1'b1 : 1'b0;

always @(posedge clock) begin
    if(tcon[5] == 1'b1) begin
    case(tmod[1:0])
    0:  //mod
        
        ;
    1:
        
        ;
    2:  //mode 2
        tl0 <= th0;
        
    3:
        ;
    endcase
        tcon[5] <= 1'b0;    
    end
end

endmodule

