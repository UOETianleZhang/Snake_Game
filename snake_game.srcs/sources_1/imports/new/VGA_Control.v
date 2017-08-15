`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: the University of Edinburgh
// Engineer: Tianle Zhang s1678924
// 
// Create Date: 14.11.2016 09:23:29
// Design Name: Snake_Game
// Module Name: VGA_Control
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

//This module is used to display a acquired colour by VGA interface.
module VGA_Control(
    input CLK,
    input [11:0] COLOR_IN,
    output reg [9:0] ADDRH=0,     //Horizantal address
    output reg [9:0] ADDRV=0,     //Vertical address
    output reg [11:0] COLOR_OUT=0,
    output reg HS=0,
    output reg VS=0
    

    );
    
    //Time in Vertical Lines
    parameter VertTimeToPulseWidthEnd   = 10'd2;
    parameter VertTimeToBackPorchEnd    = 10'd31;
    parameter VertTimeToDisplayTimeEnd  = 10'd511;
    parameter VertTimeToFrontPorchEnd   = 10'd521;
    
    //Time in Front Horizontal Lines
    parameter HorzTimeToPulseWidthEnd   = 10'd96;
    parameter HorzTimeToBackPorchEnd    = 10'd144;
    parameter HorzTimeToDisplayTimeEnd  = 10'd784;
    parameter HorzTimeToFrontPorchEnd   = 10'd800;
    
    wire [9:0] HoriCount;
    wire [9:0] VertCount;
    
    wire HoriTriggOut;
    wire CLKTriggOut;

                               
    Generic_counter # (.COUNTER_WIDTH(2),
                       .COUNTER_MAX(3)
                       )
                       CLKCounter(
                       .CLK(CLK),
                       .RESET(1'b0),
                       .ENABLE(1'b1),
                       .TRIG_OUT(CLKTriggOut)
                       );
    //adjust frenquency for screen display to 25 MHz

    Generic_counter # (.COUNTER_WIDTH(10),
                       .COUNTER_MAX(HorzTimeToFrontPorchEnd - 1)
                       )
                       HoriCounter(
                       .CLK(CLK),
                       .RESET(1'b0),
                       .ENABLE(CLKTriggOut),
                       .TRIG_OUT(HoriTriggOut),
                       .COUNT(HoriCount)
                       );
    //horizontal counter
                       
    Generic_counter # (.COUNTER_WIDTH(10),
                       .COUNTER_MAX(VertTimeToFrontPorchEnd - 1)
                       )
                       VertCounter(
                       .CLK(CLK),
                       .RESET(1'b0),
                       .ENABLE(HoriTriggOut),
                       .COUNT(VertCount)
                       );
    //vertical counter
                       
    always@(posedge CLK) begin 
        if(HoriCount< HorzTimeToPulseWidthEnd)
            HS <= 0;
        else
            HS <= 1;
    end
    
    always@(posedge CLK) begin
            if(VertCount< VertTimeToPulseWidthEnd)
                VS <= 0;
            else
                VS <= 1;
        end
    
    always@(posedge CLK) begin
        if((VertCount < VertTimeToDisplayTimeEnd) && (VertCount > VertTimeToBackPorchEnd) && (HoriCount > HorzTimeToBackPorchEnd) && (HoriCount < HorzTimeToDisplayTimeEnd))
            COLOR_OUT <= COLOR_IN;
        else
            COLOR_OUT <= 0;
    end
    //dispaly color in display time 
    
    always@(posedge CLK) begin
        if((HoriCount > HorzTimeToBackPorchEnd) && (HoriCount <HorzTimeToDisplayTimeEnd))
            ADDRH <= HoriCount-HorzTimeToBackPorchEnd;  //get hrizontal ordinate of pixels
        else
            ADDRH <= 0;
    end
        
    always@(posedge CLK) begin
        if((VertCount < VertTimeToDisplayTimeEnd) && (VertCount > VertTimeToBackPorchEnd))
            ADDRV <= VertCount-VertTimeToBackPorchEnd;  //vertical ordinate of pixels
        else
            ADDRV <= 0;
    end
    
endmodule
