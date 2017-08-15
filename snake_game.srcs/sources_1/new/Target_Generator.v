`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: the University of Edinburgh
// Engineer: Tianle Zhang s1678924
// 
// Create Date: 14.11.2016 09:23:29
// Design Name: Snake_Game
// Module Name: Target_Generator
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

//This module is used to produce a fake random address of the food and the poison.
//At the positive edge of Reached_Target(food is eaten),
//the address will refresh.
module Target_Generator(
    input CLK,
    input RESET,
    input Reached_Target,
    input Reached_Poison,
    output [14:0] Random_Target_Address,
    output [14:0] Random_Poison_Address
    );
    
    reg [7:0] X;
    reg [6:0] Y;
    reg [7:0] X_P;
    reg [6:0] Y_P;
    wire [7:0] Random_8_OUT;
    wire [6:0] Random_7_OUT;
    wire [7:0] Random_8_OUT_P;
    wire [6:0] Random_7_OUT_P;
    
    Random_8 hori_rad(  
           .RESET(RESET),    
           .CLK(CLK), 
           .Start(8'b00110011),    
           .Reached_Target(Reached_Target),        
           .Random_8_OUT(Random_8_OUT)       //get a 8-bit random number
    );
    
    Random_7 vert_rad(
           .RESET(RESET),    
           .CLK(CLK),     
           .Start(7'b0101001),    
           .Reached_Target(Reached_Target),        
           .Random_7_OUT(Random_7_OUT)      //get a 7-bit random number
    );
    
    Random_8 hori_rad_P(  
           .RESET(RESET),    
           .CLK(CLK), 
           .Start(8'b00110010),    
           .Reached_Target(Reached_Poison),        
           .Random_8_OUT(Random_8_OUT_P)       //get a 8-bit random number for the poison
    );
    
    Random_7 vert_rad_P(
           .RESET(RESET),    
           .CLK(CLK),     
           .Start(7'b0110101),    
           .Reached_Target(Reached_Poison),        
           .Random_7_OUT(Random_7_OUT_P)      //get a 7-bit random number for the poison
    );
    
    
    always@(posedge CLK) begin
        if(Random_8_OUT >= 160)
            X <= 80;
        else if(Random_8_OUT<=0)
            X <= 80;
        else
            X <= Random_8_OUT;   
    end

    always@(posedge CLK) begin
        if(Random_7_OUT >= 120)
            Y <= 60;
        else if(Random_7_OUT<=0)
            Y <= 60;
        else
            Y <= Random_7_OUT;   
    end
    
    always@(posedge CLK) begin
        if(Random_8_OUT_P >= 160)
            X_P <= 80;
        else if(Random_8_OUT_P<=2)
            X_P <= 80;
        else
            X_P <= Random_8_OUT_P;   
    end

    always@(posedge CLK) begin
        if(Random_7_OUT_P >= 120)
            Y_P <= 60;
        else if(Random_7_OUT_P<=2)
            Y_P <= 60;
        else
            Y_P <= Random_7_OUT_P;   
    end

    
    assign Random_Target_Address = {Y, X};
    assign Random_Poison_Address = {Y_P, X_P};
    
endmodule
