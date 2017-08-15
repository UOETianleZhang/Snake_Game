`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: the University of Edinburgh
// Engineer: Tianle Zhang s1678924
// 
// Create Date: 14.11.2016 09:23:29
// Design Name: Snake_Game
// Module Name: Fail_VGA
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

//This module is used to display the failure mode after the snake hit itself.
//This a "Break the Bricks" game, the ball will change its direction when
//encounterring walls or the board.

module Fail_VGA(
    input CLK,
    input RESET,
    input BTNL,
    input BTNR,
    input [9:0] X,   //hrizontal ordinate of pixels
    input [9:0] Y,   //vertical ordinate of pixels
    output [11:0] FAIL_COLOR_OUT
    
    );
    
    parameter BLUE = 12'hFAA;       
    parameter RED = 12'h00F;                       
    parameter GREEN = 12'h0F0;
    parameter YELLOW = 12'h055;
    parameter WHITE = 12'hFFF;
    parameter BLACK = 12'h000;
    parameter ORANGE = 12'h36F;
    
    parameter MaxX = 640;
    parameter MaxY = 480;
    parameter BoardY = 350;
    parameter Radius = 9;
    parameter Period_For_Speed = 1000000;
    parameter Half_Board_Width = 70;
    parameter Board_High = 25;
    
    assign FAIL_COLOR_OUT = COLOR_Fail;
    
    reg [11:0] COLOR_Fail;     //final input color put into VGA interface
    reg [25:0] count = 0;
    reg [25:0] Board_count = 0;
    reg [1:0] Direction = 2'b10; 
    reg [9:0] Ball_X = 320;   //hrizontal ordinate of pixels
    reg [9:0] Ball_Y = 100;   //vertical ordinate of pixels
    reg [9:0] Board_X = 320;   //hrizontal ordinate of pixels
    
    wire Bit17TriggOut;
    wire SlowTriggOut;
    
    //control the speed of the ball by "count"
    always@( posedge CLK) begin 
        if(RESET)
            count <=0;
        else begin
            if(2'b01) begin
                if(count >= Period_For_Speed)
                    count <= 0;
                else
                //if you want to make the whole game quiker or slower, 
                //you can adjust the value of Period_For_Speed(10000000) and 1 here.
                    count <= count + 1;
             end
         end
     end
     
//control the speed of the board by "Board_count"
    always@( posedge CLK) begin 
         if(RESET)
             Board_count <=0;
         else begin
             if(2'b01) begin
                 if(Board_count >= (Period_For_Speed/2))
                     Board_count <= 0;
                 else
                     Board_count <= Board_count + 1;
              end
          end
      end

    //colour the board and the ball
    always@(posedge CLK) begin
         if((X-Ball_X)*(X-Ball_X) + (Y-Ball_Y)*(Y-Ball_Y) <= Radius*Radius) //the ball is round
            COLOR_Fail <= BLACK;
         //the board is a rectangle
         else if(((X>=(Board_X-Half_Board_Width))
                && (X<=(Board_X+Half_Board_Width))
                && (Y>=BoardY)&&(Y<=(BoardY+Board_High))))
            COLOR_Fail <= ORANGE;
         else
            COLOR_Fail <= WHITE;
    end        

    //move the ball by its direction
    always@(posedge CLK) begin
        if(RESET) begin
            Ball_X <= 320;
            Ball_Y <= 100;
            Direction <= 2'b01;
        end
        else if(count == 0) begin
            case(Direction)
                2'b00    :begin      //Left Up, get back when encounterring the wall
                    if((Ball_Y - Radius) <= 0) //when encounterring the wall, change its direction
                        Direction <= 2'b01;
                    else if((Ball_X - Radius) <= 0)
                            Direction <= 2'b10;
                    else begin
                        Ball_Y <= Ball_Y - 1;
                        Ball_X <= Ball_X - 1;
                    end
                end
                2'b01    :begin      //Left Down, get back when encounterring the wall
                    if((Ball_Y + Radius) >= MaxY)
                        Direction <= 2'b00;
                    else if((Ball_X - Radius) <= 0)
                            Direction <= 2'b11;
                    //when encounterring the board, change its direction
                    else if(((Ball_Y + Radius) == BoardY)   
                            &&(Ball_X<=(Board_X+Half_Board_Width))
                            &&(Ball_X>=(Board_X-Half_Board_Width)))
                            Direction <= 2'b00;
                    else begin
                        Ball_Y <= Ball_Y + 1;
                        Ball_X <= Ball_X - 1;
                    end
                end
                2'b10    :begin      //Right Up, get back when encounterring the wall
                    if((Ball_Y - Radius) <= 0)
                        Direction <= 2'b11;
                    else if((Ball_X + Radius) >= MaxX)
                            Direction <= 2'b00;
                    else begin
                        Ball_Y <= Ball_Y - 1;
                        Ball_X <= Ball_X + 1;
                    end
                end
                2'b11    :begin      //Right Down, get back when encounterring the wall
                    if((Ball_Y + Radius) >= MaxY)
                        Direction <= 2'b10;
                    else if((Ball_X + Radius) >= MaxX)
                        Direction <= 2'b01;
                    //when encounterring the board, change its direction
                   else if(((Ball_Y + Radius) == BoardY)
                            && (Ball_X<=(Board_X+Half_Board_Width))
                            && (Ball_X>=(Board_X-Half_Board_Width)))
                        Direction <= 2'b10;
                    else begin
                        Ball_Y <= Ball_Y + 1;
                        Ball_X <= Ball_X + 1;
                    end
                end                
            endcase
        end
    end

    //move the board by BTNL and BTNR, and stop when encounterring walls
    always@(posedge CLK) begin
        if(RESET) begin
            Board_X <= 320;
        end
        else if(Board_count == 0) begin
            if(BTNL && ((Board_X-Half_Board_Width)>0)) 
                Board_X <= Board_X - 1;
            else if(BTNR && ((Board_X+Half_Board_Width) <= MaxX))
                Board_X <= Board_X + 1;
        end
    end
endmodule
