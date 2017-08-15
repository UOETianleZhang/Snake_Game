`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: the University of Edinburgh
// Engineer: Tianle Zhang s1678924
// 
// Create Date: 14.11.2016 09:23:29
// Design Name: Snake_Game
// Module Name: Master_statemachine
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

//This module is to control the toppest states of the snake game. 
//It includes four states : idle, play(level1), success(level 2) and fail.
//in the idle state,a big "GO" will be displayed on the screen.
//"Play" state is referred to the snake game
//In the "Fail" state, a big "Fail" will be displayed on the screen, with "F" rotating.
//"Success" state is referred to the "Break the Bricks" game.
module Master_statemachine(
    input CLK,
    input RESET,
    input BTNL,
    input BTNU,
    input BTNR,
    input BTND,
    input Failed,   
    input [16:0] Current_Score,
    output [1:0] Master_state_out   
    );

    reg [1:0] Master_Curr_state=0;
    reg [1:0] Master_Next_state=0;
    
    assign Master_state_out = Master_Curr_state;

    always@(posedge CLK) begin  
        if(RESET)
            Master_Curr_state  <= 2'b00;
        else
            Master_Curr_state <= Master_Next_state;
    end
    
    always@(BTNL or BTNR or BTNU or BTND ) begin    
        case (Master_Curr_state)     
            2'd0    :begin  //IDLE
                if(BTNL || BTNR || BTNU || BTND)    //Go to Play state when pressing a button
                    Master_Next_state <= 2'b01;
                else  Master_Next_state <= 2'b00;
            end

           2'd1    :begin  //PLAY(Level 1)
                if(Current_Score==20)    Master_Next_state <= 3;    //Succeed after getting the aim score
                else if(Failed) Master_Next_state <=2;
                else        Master_Next_state <=1;
            end

//            2'd2    :begin  //WIN
//                else        Master_Next_state <= 2;
//            end
            
//            2'd3    :begin  //Level 2
//                if(BTNR)    Master_Next_state <= 3;
//                else        Master_Next_state <= 3;
//            end
        endcase
    end

    
endmodule
