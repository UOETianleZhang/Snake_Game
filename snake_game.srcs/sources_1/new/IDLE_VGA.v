`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: the University of Edinburgh
// Engineer: Tianle Zhang s1678924
// 
// Create Date: 14.11.2016 09:23:29
// Design Name: Snake_Game
// Module Name: IDLE_VGA
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

//This module is used to display the idle mode at the very begining.
//At idle state, the screen will display "GO".
module IDLE_VGA(
    input CLK,
    input [9:0] X,   //hrizontal ordinate of pixels
    input [9:0] Y,   //vertical ordinate of pixels
    output [11:0] IDLE_COLOR_OUT
    
    );
    
    parameter BLUE = 12'hF00;       
    parameter RED = 12'h00F;                       
    parameter GREEN = 12'h0F0;
    parameter WHITE = 12'hFFF;
    parameter ORANGE = 12'h69F;
    
    
    assign IDLE_COLOR_OUT = COLOR_Idle;
    
    reg [11:0] COLOR_Idle;     //final input color put into VGA interface 
    
    always@(posedge CLK) begin
        //display "G"
        if(((X>=130)&&(X<=300)&&(Y>=100)&&(Y<=130))||
           ((X>=100)&&(X<=130)&&(Y>=100)&&(Y<=300))||
           ((X>=130)&&(X<=270)&&(Y>=270)&&(Y<=300))||
           ((X>=160)&&(X<=270)&&(Y>=200)&&(Y<=230))||
           ((X>=270)&&(X<=300)&&(Y>=200)&&(Y<=300)))
            COLOR_Idle = ORANGE;
        //display "O"
        else if(((X>370)&&(X<510)&&(Y>130)&&(Y<270)))
            COLOR_Idle = WHITE;
        else if(((X>340)&&(X<540)&&(Y>100)&&(Y<300)))
            COLOR_Idle = ORANGE;
        else
            COLOR_Idle = WHITE;
    end        
               
endmodule
