`timescale 1ns / 1ps

module timer_8051(

input clock,        // System clock
input reset,        // System reset
input [7:0]sfr_tmod,
input [7:0]sfr_tcon, 
input [7:0]sfr_tl0, 
input [7:0]sfr_th0,
input  P0_1,
input int_ack,      //if an interrupt has handled -> to clear the overflow flag by hardware
output tf0_flag,
output tr0_flag

);

reg [7:0]tmod;
reg [7:0]tcon;
reg [7:0]tl0;
reg [7:0]th0;

reg last_P0_1;
reg p0_edge;
reg tr0_edge;
reg last_tr0;
wire pe_P0_1;

parameter tr0_bit = 3'b100, tf0_bit = 3'b101;  


initial begin
    tmod = 8'h00;       //mode 2 - 8-bit autoreload
    tcon = 8'h00;     
    tl0 = 8'h00;        //holds the count value
    th0 = 8'h00;        //reload value 
    last_P0_1 = 1'b0;
    p0_edge = 1'b0;
end

/* Get the positive transition of P0_1*/
always @(posedge clock) begin
    last_P0_1 <= P0_1;
end 

assign pe_P0_1 = P0_1 & ~last_P0_1;




//Always the TR0 flag has a transition to one
 
//timer mode
always @(posedge clock)
begin

if(reset == 1'b1) begin
tmod <= 8'h00;
tcon <= 8'h00;
th0 <= 8'h00;
tl0 <= 8'h00;
end
else
if(sfr_tcon[4]== 1'b0) begin
    tmod <= sfr_tmod;
    tcon <= sfr_tcon; 
    th0  <= sfr_th0;
    if(sfr_tmod[1:0] == 2'h2)       //if Mode 2
        tl0 <= sfr_th0;             //update the tl0 with th0
    else
        tl0  <= sfr_tl0;
end
else if(tmod[2] == 1'b0) begin   //if TR0 is 1 and timer mode
    tcon[4] <= 1'b1;
    case(tmod[1:0])
    0:  //mode 0
        //Th0 holds the MSBs bits and Tl0 holds the five LSBs in TL0.4-TL0.0
        //The 4 MSB bits of TL0 should be undeterminate and masked out
        //if(tmod[2] == 1'b0) begin         //timer mode
        begin    
            if(tl0 == 8'h1f) begin          //if tl0 equals 0x1f
                if(th0 == 8'hff)            //if th0 equal 0xff
                    tcon[5] <= 1'b1;        //put flag overflow to one 
                
                th0 <= th0 + 1;
            end
            
            tl0 <= (tl0 + 1) & 8'b00011111; //mask the tl0 register
        end       

    1:  //Mode 1 - 16-bit timer/counter
    
        begin    
            if(tl0 == 8'hff) begin        //if tl0 equals 0x1f
                if(th0 == 8'hff)          //if th0 equal 0xff
                    tcon[5] <= 1'b1;      //put flag overflow to one 
                
                th0 <= th0 + 1; //increment the th0 reg
            end
            
            tl0 <= tl0 + 1;     //increment the tl0 reg
        end  
    
    2:  //mode 2
        //if(tmod[2] == 1'b0) begin //timer mode
        begin
            tl0 <= tl0 + 1;
            if(tl0==8'hff) begin
                tcon[5] <= 1'b1;    //put flag overflow to one
            end
        end
    endcase
end
else if(pe_P0_1 == 1'b1) begin
    tcon[4] <= 1'b1;
    if(tcon[4]== 1'b1 && tmod[2] == 1'b1) begin   //if TR0 is 1 and counter mode
        case(tmod[1:0])
        0:  //mode 0
            //Th0 holds the MSBs bits and Tl0 holds the five LSBs in TL0.4-TL0.0
            //The 4 MSB bits of TL0 should be undeterminate and masked out
            begin
                
                if(tl0 == 8'h1f) begin        //if tl0 equals 0x1f
                    if(th0 == 8'hff)          //if th0 equal 0xff
                        tcon[5] <= 1'b1;      //put flag overflow to one 
                    
                    th0 <= th0 + 1;
                end
                
                tl0 <= (tl0 + 1) & 8'b00011111; //mask the tl0 register       
            end        

        1:  //Mode 1 - 16-bit timer/counter
        
            begin    //counter mode
                
                if(tl0 == 8'hff) begin        //if tl0 equals 0x1f
                    if(th0 == 8'hff)          //if th0 equal 0xff
                        tcon[5] <= 1'b1;      //put flag overflow to one 
                    
                    th0 <= th0 + 1; //increment the th0 reg
                end
                
                tl0 <= tl0 + 1;   //increment the tl0 reg
            end  
        
        2:  //mode 2
            begin //counter mode
                tl0 <= tl0 + 1;
                if(tl0==8'hff) begin                   
                    tcon[5] <= 1'b1;    //put flag overflow to one
                end
            end    
        endcase
    end
end

 if(tcon[5] == 1'b1)
 begin
        case(tmod[1:0])
        0:  ;//tcon[4] <= 1'b0; //reset TR0
        1:  ;//tcon[4] <= 1'b0; //reset TR0            
        2:  begin
            tl0 <= th0;    //put flag overflow to one
            //tcon[4] <= 1'b0;
            //tcon[5] <= 1'b0;
            end
        endcase
        if(int_ack)     
            tcon[5] <= 1'b0;   //clear flag by hardware when interrupt is called
 end  
     
end
 
assign tf0_flag = tcon[5];
assign tr0_flag = tcon[4];

endmodule

