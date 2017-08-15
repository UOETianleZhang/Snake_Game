`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.10.2016 09:43:59
// Design Name: 
// Module Name: Decoding
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


module Decoding(
    input [1:0] SEG_SELECT_IN,
    input [3:0] BIN_IN,
    input DOT_IN,
    output [3:0] SEG_SELECT_OUT,
    output [7:0] HEX_OUT
    );
        wire A,B,C,D;
        
        assign B=BIN_IN[0];
        assign A=BIN_IN[1];
        assign D=BIN_IN[2];
        assign C=BIN_IN[3];
        
        assign HEX_OUT[0]=((~A)&B&(~C)&(~D))|((~A)&(~B)&(~C)&D)|((~A)&B&C&D)|(A&B&C&(~D));
        assign HEX_OUT[1]=((~A)&B&(~C)&D)|((~A)&(~B)&C&D)|(A&(~B)&D)|(A&B&C);
        assign HEX_OUT[2]=(A&(~B)&(~C)&(~D))|((~B)&C&D)|(A&C&D);
        assign HEX_OUT[3]=((~A)&B&(~D))|((~A)&(~B)&(~C)&D)|(A&B&D)|(A&(~B)&C&(~D));
        assign HEX_OUT[4]=(B&(~C))|((~A)&(~C)&D)|((~A)&B&(~D));
        assign HEX_OUT[5]=(B&(~C)&(~D))|(A&B&(~C))|((~A)&B&C&D)|(A&(~C)&(~D));
        assign HEX_OUT[6]=((~A)&(~C)&(~D))|(A&B&(~C)&D)|((~A)&(~B)&C&D);
        assign HEX_OUT[7]=DOT_IN;
        
        wire E,F;
        
        assign E=SEG_SELECT_IN[0];
        assign F=SEG_SELECT_IN[1];
        assign SEG_SELECT_OUT[0]=~((~F)&(~E));
        assign SEG_SELECT_OUT[1]=~((~F)&E);
        assign SEG_SELECT_OUT[2]=~(F&E);
        assign SEG_SELECT_OUT[3]=~(F&(~E));
        
    
endmodule
