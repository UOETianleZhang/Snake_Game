`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: the University of Edinburgh
// Engineer: Tianle Zhang s1678924
// 
// Create Date: 14.11.2016 09:23:29
// Design Name: Snake_Game
// Module Name: Random_7
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

//This module is used to produce a fake 7-bit random number,
//by using a Linear Feedback shift Register (LFSR). 
//It is a synchronous device which shifts all of its bits each clock cycle, but instead of
//taking its input from an external source, it creates the new value from a series of 
//"Taps" (connections to various bits along the length of the shift register), which are
//combined with XNOR gates.
module Random_7(
    input               RESET,    
    input               CLK,     
    input      [6:0]    Start,     
    input               Reached_Target,        
    output     [6:0]    Random_7_OUT  
);

//    reg     [6:0]    random_7 = 7'b0101001;
    reg     [6:0]    random_7;
    assign Random_7_OUT = random_7;


    always@(posedge CLK) begin
        if(RESET)
            random_7 <= Start;
        else if(Reached_Target) begin
            random_7[0] <= random_7[6] ~^ random_7[5];
            random_7[1] <= random_7[0];
            random_7[2] <= random_7[1];
            random_7[3] <= random_7[2];
            random_7[4] <= random_7[3];
            random_7[5] <= random_7[4];
            random_7[6] <= random_7[5];
        end
    end

endmodule
