`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: the University of Edinburgh
// Engineer: Tianle Zhang s1678924
// 
// Create Date: 14.11.2016 09:23:29
// Design Name: Snake_Game
// Module Name: SNAKE_WRAPPER
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

//This project is a set of small games.
//It includes two games: the famous snake game and a "Break the Bricks" game.

//At the very beginning, there is a big "GO" displayed on the screen, which is in "idle" state.
//If any a button is pressed, the procedure will go to "play" state , i.e., the snake game.
//In the snake game, you can change the direction of the snake by pressing buttons.
//To be noticed, the snake can just turn 90 degree, 
//i.e., it can only go to left or right direction when in up or down direction, and vice versa.
//After the snake eating the food, 
//the length of snake and the score displayed on 7-segments  will individually increase by one, 
//and the speed of the snake will also increase.
//Apart from that, you can accelerate the snake by switching on the very left switch,
//and you can even "cheat" by switching on the very right switch to get scores quickly.
//if your snake hit itself, the procedure will go to "fail" state, with some letters appearing.

//If you get the aim score (20 here), the procedure will go to "win" state, 
//with the second level: "Break the Bricks" game starting.
//In this game, you will control a board by buttons to protect the bottom line from hitting.
//The ball will reflect when encountering walls and the front of the board.
//Take it easy, there is no any punishment at this procedure, please have fun! :)

//This module is to connect all submodules together in this project.                            
module SNAKE_WRAPPER(
    input CLK,
    input RESET,
    input BTNL,
    input BTNU,
    input BTNR,
    input BTND,
    
    input CHEAT,
    input Speed_Up,
    input Fail_Control,

    output [11:0] COLOR_OUT,
    output HS,
    output VS,
    output [3:0] SEG_SELECT,
    output [7:0] DEC_OUT

    );
    
    parameter BLUE = 12'hF00;       
    parameter RED = 12'h00F;                       
    parameter GREEN = 12'h0F0;
    
    //Except inputs and outpus of wrapper, connect every ports by wires
    wire [1:0] Master_state_out;
    wire [11:0] COLOR;
    wire [9:0] X;
    wire [9:0] Y;
    wire [2:0] Navi_State_Out;
    wire [14:0] Random_Target_Address; 
    wire [14:0] Random_Poison_Address; 
    wire Reached_Target;
    wire Reached_Poison;
    wire Failed;
    wire [16:0] Current_Score;

    //This module is to control the toppest states of the snake game. 
    //It includes four states : idle, play(level1), success(level 2) and fail.
    Master_statemachine master(
            .RESET(RESET),
            .CLK(CLK),
            .BTNL(BTNL),
            .BTNU(BTNU),
            .BTNR(BTNR),
            .BTND(BTND),
            .Failed(Fail_Control||Failed),
            .Current_Score(Current_Score),
            .Master_state_out(Master_state_out)   
            );
            
    //This module includes 4 submodules : VGA_Control, Success_VGA, Fail_VGA and IDLE_VGA.
    //This module is used to display differnt modes according to the state of Master State Machine.
     VGA_Wrapper V(
            .CLK(CLK),
            .Master_state_out(Master_state_out),
            .COLOR(COLOR),
            .COLOR_OUT(COLOR_OUT),
            .BTNL(BTNL),
            .BTNR(BTNR),
            .X(X),
            .Y(Y),
            .HS(HS),
            .VS(VS)
            );

    //This module is used to change the direction of the snake,
     Navigation_S_M Navi(
            .RESET(RESET),
            .CLK(CLK),
            .BTNL(BTNL),
            .BTNU(BTNU),
            .BTNR(BTNR),
            .BTND(BTND),
            .Master_state_out(Master_state_out),
            .Navi_State_Out(Navi_State_Out)            
            );
    
    //This module is used to calculate Current_Score, 
    //and display the value of it by 7-segments
    Score_counter segment(
            .RESET(RESET),
            .CLK(CLK),
            .ENABLE(Reached_Target),
            .MINUS(Reached_Poison),
            .Current_Score(Current_Score),   
            .SEG_SELECT(SEG_SELECT),
            .CHEAT(CHEAT),
            .DEC_OUT(DEC_OUT)
    );

    //This module is a very big one to display the snake, the poison and the food on the screen.
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
            
    //This module is used to produce a fake random address of the food and the poison.
    Target_Generator Ran_Y_X(
            .CLK(CLK),
            .RESET(RESET),
            .Reached_Target(Reached_Target),
            .Reached_Poison(Reached_Poison),
            .Random_Target_Address(Random_Target_Address),
            .Random_Poison_Address(Random_Poison_Address)
            );

endmodule
