`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/10/30 19:01:56
// Design Name: 
// Module Name: State_Wrapper
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


module State_Wrapper(
    input CLK,
    input RESET,
    input BTNL,
    input BTNC,
    input BTNR,
    output [3:0] SEG_SELECT,
    output [7:0] HEX_OUT
    );
    
    wire [2:0] STATE_OUT;
    wire [3:0] BIN_IN;
    
    State_Machine State(
        .CLK(CLK),
        .RESET(RESET),
        .BTNL(BTNL),
        .BTNC(BTNC),
        .BTNR(BTNR),
        .STATE_OUT(STATE_OUT)
        );
        
//         BasicSM_Mem StateSM(
//           .CLK(CLK),
//           .RESET(RESET),
//           .BTNL(BTNL),
//           .BTNC(BTNC),
//           .BTNR(BTNR),
//           .OUT(STATE_OUT)
//           );
        
    assign BIN_IN = {1'b0, STATE_OUT};
    
    Decoding seg7(
        .SEG_SELECT_IN(2'b00),
        .BIN_IN(BIN_IN),
        .DOT_IN(1'b0),
        .SEG_SELECT_OUT(SEG_SELECT),
        .HEX_OUT(HEX_OUT)
        );
endmodule
