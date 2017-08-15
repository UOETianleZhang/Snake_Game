`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.11.2016 15:49:31
// Design Name: 
// Module Name: Snake_TB
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


module Snake_TB();

    reg CLK;
    reg RESET;  
    reg [9:0] X;
    reg [9:0] Y;
    reg Speed_Up;
    reg [2:0] Navi_State_Out;
    reg [16:0] Current_Score;
    reg [14:0] Random_Target_Address;
    reg [14:0] Random_Poison_Address;
    
    reg Reached_Target;
    reg Reached_Poison;
    reg Failed;
    wire  [11:0] COLOR;



    Snake_Control Control(
        .Navi_State_Out(Navi_State_Out),
        .X(X),
        .Y(Y),
        .RESET(RESET),
        .CLK(CLK),
        .Failed(Failed),
        .Speed_Up(Speed_Up),
        .Current_Score(Current_Score),
        .Random_Target_Address(Random_Target_Address),
        .Random_Poison_Address(Random_Poison_Address),
        .Reached_Target(Reached_Target),
        .Reached_Poison(Reached_Poison),
        .COLOR(COLOR)
        );
endmodule