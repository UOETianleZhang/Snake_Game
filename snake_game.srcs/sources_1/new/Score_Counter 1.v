`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.11.2016 12:06:35
// Design Name: 
// Module Name: Score_Counter
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


module Score_Counter(
    input Reached_Target,
    input RESET,
    input CLK,
    output [3:0] SEG_SELECT,
    output [7:0] DEC_OUT
   // output [1:0] Strobe_Counter
   // output [7:0] Current_Score
    );


Timing_de segment(
        .RESET(RESET),
        .CLK(CLK),
        .ENABLE(Reached_Target),   
        .SEG_SELECT(SEG_SELECT),
        .DEC_OUT(DEC_OUT)

    );
endmodule
