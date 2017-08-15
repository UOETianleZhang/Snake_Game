`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: the University of Edinburgh
// Engineer: Tianle Zhang s1678924
// 
// Create Date: 14.11.2016 09:23:29
// Design Name: Snake_Game
// Module Name: Score_counter
// Project Name: Snake_Game
// Target Devices: BASYS3
// Tool Versions: unkown
// Description: /
// 
// Dependencies: /
// 
// Revision:/
// Revision 0.01 - File Created
// Additional Comments: as below
// 
//////////////////////////////////////////////////////////////////////////////////

//This module is used to calculate Current_Score, 
//and display the value of it by 7-segments
//The counter will only work when ENABLE is on.
module Score_counter(
    input CLK,
    input RESET,
    input ENABLE,
    input MINUS,
    input CHEAT,    //CHEAT is connected with the very right switch
    output [16:0] Current_Score,
    output [3:0] SEG_SELECT,
    output [7:0] DEC_OUT
    );
    
    wire Bit17TriggOut;
    wire Bit4TriggOut1;
    wire Bit4TriggOut2;
    wire Bit4TriggOut3;
    wire Bit4TriggOut4;
    wire SlowTriggOut; 
 
    wire Bit4TriggOut1_M;
    wire Bit4TriggOut2_M;
    wire Bit4TriggOut3_M;
    wire Bit4TriggOut4_M;

    
    wire [3:0] DeCount0;
    wire [3:0] DeCount1;
    wire [3:0] DeCount2;
    wire [3:0] DeCount3;
    
    wire [4:0] DeCountAndDOT0;
    wire [4:0] DeCountAndDOT1;
    wire [4:0] DeCountAndDOT2;
    wire [4:0] DeCountAndDOT3;
    
    wire [4:0] MuxOut;    
    wire [1:0] StrobeCount;
    
    //17-bit counter
    Generic_counter # (.COUNTER_WIDTH(17),
                       .COUNTER_MAX(99999)
                       )
                       Bit17Counter(
                       .CLK(CLK),
                       .RESET(1'b0),
                       .ENABLE(1'b1),
                       .TRIG_OUT(Bit17TriggOut)
                       );
                       
    //SlowTriggOut is 200 times slower than Bit17TriggOut, 
    //to control the speed of getting scores by "cheat"
    Generic_counter # (.COUNTER_WIDTH(10),
                       .COUNTER_MAX(200)
                       )
                       CheatCount (
                       .CLK(CLK),
                       .RESET(RESET),
                       .ENABLE(Bit17TriggOut),
                       .TRIG_OUT(SlowTriggOut)
                       );
    
    Generic_counter # (.COUNTER_WIDTH(2),
                       .COUNTER_MAX(2)
                       )
                       Count1 (
                       .CLK(CLK),
                       .RESET(RESET),
                       //score can be added by either Reached_Target(ENABLE here) or CHEAT
                       .ENABLE((CHEAT&&SlowTriggOut)||ENABLE),
                       .MINUS(MINUS),
                       .MINUS_OUT(Bit4TriggOut1_M),
                       .TRIG_OUT(Bit4TriggOut1)
                       );
    
    //display the least siginificant bit
    Generic_counter # (.COUNTER_WIDTH(4),
                       .COUNTER_MAX(9)
                       )
                       Bit4Count2 (
                       .CLK(CLK),
                       .RESET(RESET),
                       .ENABLE(Bit4TriggOut1),
                       .TRIG_OUT(Bit4TriggOut2),
                       .MINUS(Bit4TriggOut1_M),
                       .MINUS_OUT(Bit4TriggOut2_M),
                       .COUNT(DeCount0)
                       );

    //display the second least siginificant bit
    Generic_counter # (.COUNTER_WIDTH(4),
                       .COUNTER_MAX(9)
                       )
                       Bit4Count3 (
                       .CLK(CLK),
                       .RESET(RESET),
                       .ENABLE(Bit4TriggOut2),
                       .TRIG_OUT(Bit4TriggOut3),
                       .MINUS(Bitinput MINUS,4TriggOut2_M),
                       .MINUS_OUT(Bit4TriggOut3_M),
                       .COUNT(DeCount1)
                       );

//    //display the third least siginificant bit
//    Generic_counter # (.COUNTER_WIDTH(4),
//                      .COUNTER_MAX(9)
//                      )
//                      Bit4Count4 (
//                      .CLK(CLK),
//                      .RESET(RESET),
//                      .ENABLE(Bit4TriggOut3),
//                      .TRIG_OUT(Bit4TriggOut4),
//                      .MINUS(Bit4TriggOut3_M),
//                      .MINUS_OUT(Bit4TriggOut4_M),
//                      .COUNT(DeCount2)
//                      );
//    //display the most siginificant bit
//    Generic_counter # (.COUNTER_WIDTH(4),
//                      .COUNTER_MAX(9)
//                      )
//                      Bit4Count5 (
//                      .CLK(CLK),
//                      .RESET(RESET),
//                      .ENABLE(Bit4TriggOut4),
//                      .MINUS(Bit4TriggOut4_M),
//                      .COUNT(DeCount3)
//                      );
                      
    
    //produce StrobeCount for the Multiplexer               
    Generic_counter # (.COUNTER_WIDTH(2),
                      .COUNTER_MAX(1)
                      )
                      Bit2Count (
                      .CLK(CLK),
                      .RESET(1'b0),
                      .ENABLE(Bit17TriggOut),
                      .COUNT(StrobeCount)
                      );
                           
    //no decimal point for every number
    assign DeCountAndDOT0 = {1'b1, DeCount0};
    assign DeCountAndDOT1 = {1'b1, DeCount1};
    assign DeCountAndDOT2 = {1'b1, DeCount2};
    assign DeCountAndDOT3 = {1'b1, DeCount3};   
//    calculate Current_Score
    assign Current_Score = DeCount0 + DeCount1*10 + DeCount2*100;
    
    Multiplexer Mux4(
                    .CONTROL(StrobeCount),
                    .IN0(DeCountAndDOT0),
                    .IN1(DeCountAndDOT1),
                    .IN2(DeCountAndDOT3),
                    .IN3(DeCountAndDOT2),
                    .OUT(MuxOut)
                    );
        
    Decoding Seg7(
                    .SEG_SELECT_IN(StrobeCount),
                    .BIN_IN(MuxOut[3:0]),
                    .DOT_IN(MuxOut[4]),
                    .SEG_SELECT_OUT(SEG_SELECT),
                    .HEX_OUT(DEC_OUT)
                    );
                        
    endmodule
