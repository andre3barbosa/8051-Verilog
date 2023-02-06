`ifndef _OPCODES_V_
`define _OPCODES_V_

//Data transfer
`define MOV_RI  8'b0111_1xxx
`define MOV_AR  8'b1110_1xxx
`define MOV_RA  8'b1111_1xxx
`define MOV_AI  8'b0111_0100
`define MOV_AD  8'b1110_0101  
`define MOV_DA  8'b1111_0101  

//Arithemtic
`define ADD     8'b0010_01xx
`define ADD_AI  8'b0010_0100
`define SUBB    8'b1001_01xx
`define SUBB_AI 8'b1001_0100

//Logical
`define ANL     8'b0101_01xx
`define ANL_AI  8'b0101_0100
`define ORL     8'b0100_01xx
`define ORL_AI  8'b0100_0100
`define XRL     8'b0110_01xx
`define XRL_AI  8'b0110_0100

//Bolean
`define JNC     8'b1010_0000

//Program Branching
`define JZ      8'b0110_0000
`define JNZ     8'b0111_0000
`define SJMP    8'b1000_0000
`define RETI    8'b0011_0010

`define HALT    8'b1001_1000

`endif 