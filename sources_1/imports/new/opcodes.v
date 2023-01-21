
`ifndef _OPCODES_V_
`define _OPCODES_V_
// instruction set

//opcode [7:3]
`define MOV_RI  8'b0111_1xxx
`define MOV_AR  8'b1110_1xxx
`define MOV_RA  8'b1111_1xxx
//`define ADD_RI  8'b0010_011x      //not in ISA
//opcode [7:1]
`define SUBB_RI 8'b1001_011x
`define ORL_RI  8'b0100_011x
`define ANL_RI  8'b0101_011x    
`define SJMP    8'b1000_0000
`define JMP     8'b0111_0011    

//opcodes [7:0]
`define MOV_AI  8'b0111_0100
`define ADD_AI  8'b0010_0100
`define SUBB_AI 8'b1001_0100
`define ORL_AI  8'b0100_0100
`define ANL_AI  8'b0101_0100
`define XRL_AI  8'b0110_0100
`define JNZ     8'b0111_0000
`define JZ      8'b0110_0000
`define JNC     8'b1010_0000
`define MOV_DLA 8'b1010_0001
`define MOV_DHA 8'b1010_0010
`define MOV_AD  8'b1110_0101         //move direct to Acc
`define MOV_DA  8'b1111_0101         //move Acc to A
//ALU instructions
`define ADD     8'b0010_01xx
`define SUBB    8'b1001_01xx
`define ANL     8'b0101_01xx
`define ORL     8'b0100_01xx
`define XRL     8'b0110_01xx


`endif