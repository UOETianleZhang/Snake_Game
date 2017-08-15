`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: the University of Edinburgh
// Engineer: Tianle Zhang s1678924
// 
// Create Date: 14.11.2016 09:23:29
// Design Name: Snake_Game
// Module Name: VGA_Wrapper
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

//This module includes 4 submodules : VGA_Control, Success_VGA, Fail_VGA and IDLE_VGA.
//This module is used to display differnt modes according to the state of Master State Machine.
//

module VGA_Wrapper(
    input CLK,
    input [2:0] Master_state_out,
    input  [11:0] COLOR,
    output [11:0] COLOR_OUT,
    input BTNL,
    input BTNR,
    output [9:0] X, //hrizontal ordinate of pixels
    output [9:0] Y, //vertical ordinate of pixels
    output HS,
    output VS
    );
    reg [11:0] COLOR_IN;    //the colour put into VGA Control

    wire [11:0] IDLE_COLOR_OUT;
    wire [11:0] FAIL_COLOR_OUT;
    wire [11:0] SUCCESS_COLOR_OUT;
    
    parameter BLUE = 12'hF00;       
    parameter RED = 12'h00F;                       
    parameter GREEN = 12'h0F0;
    parameter WHITE = 12'hFFF;                       
                    
    VGA_Control uut(
            .CLK(CLK),
            .COLOR_IN(COLOR_IN),
            .ADDRH(X),
            .ADDRV(Y),
            .COLOR_OUT(COLOR_OUT),
            .HS(HS),
            .VS(VS)
            );
            
    Success_VGA Success_Colour(
            .CLK(CLK),
            .X(X),   
            .Y(Y),   
            .SUCCESS_COLOR_OUT(SUCCESS_COLOR_OUT)
            );

    Fail_VGA Fail_Colour(
            .CLK(CLK),
            .X(X),   
            .Y(Y),
            .BTNL(BTNL),
            .BTNR(BTNR),
            .RESET(RESET),   
            .FAIL_COLOR_OUT(FAIL_COLOR_OUT)
            );
            
    IDLE_VGA Idle_Colour(
            .CLK(CLK),
            .X(X),   
            .Y(Y),   
            .IDLE_COLOR_OUT(IDLE_COLOR_OUT)
            );
    //display differnt modes according to the state of Master State Machine.    
    always@(posedge CLK) begin 
        case(Master_state_out)    
            2'd0    :begin  //IDLE
                COLOR_IN <= IDLE_COLOR_OUT;    
            end
            
            2'd1    :begin  //PLAY(Level 1)
                COLOR_IN <= COLOR; 
            end
            
            2'd2    :begin  //Fail
                COLOR_IN <= SUCCESS_COLOR_OUT;    
            end
            
            2'd3    :begin  //WIN(Level 2)
                COLOR_IN <= FAIL_COLOR_OUT;    
            end
            
        endcase
    end            
    
        
    
endmodule
