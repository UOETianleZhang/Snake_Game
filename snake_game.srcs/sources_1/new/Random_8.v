`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: the University of Edinburgh
// Engineer: Tianle Zhang s1678924
// 
// Create Date: 14.11.2016 09:23:29
// Design Name: Snake_Game
// Module Name: Random_8
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

//This module is used to produce a fake 8-bit random number,
//by using a Linear Feedback shift Register (LFSR). 
//It is a synchronous device which shifts all of its bits each clock cycle, but instead of
//taking its input from an external source, it creates the new value from a series of 
//"Taps" (connections to various bits along the length of the shift register), which are
//combined with XNOR gates.
module Random_8(
    input               RESET,    
    input               CLK,
    input      [7:0]    Start,     
    input               Reached_Target,        
    output     [7:0]    Random_8_OUT  
);

//    reg [7:0] random_8 = 8'b00110011;
    reg [7:0] random_8;
    assign Random_8_OUT = random_8;
    

    always@(posedge CLK) begin
        if(RESET)
            random_8 <= Start;
        else if(Reached_Target) begin
            random_8[0] <= ((random_8[7] ~^ random_8[5]) ~^ random_8[4]) ~^ random_8[3];
            random_8[1] <= random_8[0];
            random_8[2] <= random_8[1];
            random_8[3] <= random_8[2];
            random_8[4] <= random_8[3];
            random_8[5] <= random_8[4];
            random_8[6] <= random_8[5];
            random_8[7] <= random_8[6];
        end
    end

endmodule

