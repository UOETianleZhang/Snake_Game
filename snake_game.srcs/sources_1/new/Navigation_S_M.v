`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: the University of Edinburgh
// Engineer: Tianle Zhang s1678924
// 
// Create Date: 14.11.2016 09:23:29
// Design Name: Snake_Game
// Module Name: Navigation_S_M
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

//This module is used to change the direction of the snake,
//by controling Navi_State_Out.
//To be noticed, the snake can just turn 90 degree, 
//i.e., it can only go to left or right direction when in up or down direcion,
//and vise versa
module Navigation_S_M(
    input CLK,
    input RESET,
    input BTNL,
    input BTNU,
    input BTNR,
    input BTND,
    input [1:0] Master_state_out,
    output [2:0] Navi_State_Out
    );
    
    reg [2:0] Navi_Curr_state = 0;
    reg [2:0] Navi_Next_state = 0;

    assign Navi_State_Out = Navi_Curr_state;

    always@(posedge CLK) begin
        if(RESET)
            Navi_Curr_state  <= 2'b00;
        else
            Navi_Curr_state <= Navi_Next_state;
    end
    
    always@(BTNL or BTNR or BTNU or BTND or Navi_Curr_state) begin
        case (Navi_Curr_state)     
            3'd0    :begin  //IDLE
                if(Master_state_out==2'b01)
                //no matter which button is pressed, the initial direction of the snake is down                    
                    Navi_Next_state <= 3'b001;  
                else  Navi_Next_state <= 3'b000;
            end

            3'd1    :begin  //DOWN
                if(BTNL)    Navi_Next_state <= 3'b100;
                else if(BTNR) Navi_Next_state <= 3'b010;
                else  Navi_Next_state <= 3'b001;
            end

            3'd2    :begin  //Right 
                if(BTNU)    Navi_Next_state <= 3'b001;
                else if(BTND) Navi_Next_state <= 3'b011;
                else  Navi_Next_state <= 3'b010;
            end
            
            3'd3    :begin  //UP
                if(BTNL)    Navi_Next_state <= 3'b100;
                else if(BTNR) Navi_Next_state <= 3'b010;
                else  Navi_Next_state <= 3'b011;
            end
            
            3'd4    :begin  //Left
                if(BTNU)    Navi_Next_state <= 3'b001;
                else if(BTND) Navi_Next_state <= 3'b011;
                else  Navi_Next_state <= 3'b100;
            end
            
        endcase
    end

    
endmodule
