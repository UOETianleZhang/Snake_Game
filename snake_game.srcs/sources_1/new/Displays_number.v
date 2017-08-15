`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/11/16 00:23:24
// Design Name: 
// Module Name: Displays_number
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Displays_number(
    input [9:0] Number_To_Display=8890,
    output [3:0] SEG_SELECT,
    output [7:0] DEC_OUT
    );
    reg  [9:0] number_to_display;
    wire [9:0] Number;
    assign Number = number_to_display;
    reg Digit1 [9:0];
    reg Digit2 [9:0];
    reg Digit3 [9:0];
    reg Digit4 [9:0];
    
    wire [4:0] MuxOut;
    wire [1:0] StrobeCount;
    
    
    
    always@(CLK) begin
       // Number_To_Display =8890;
    
        //number_to_display = Number_To_Display;
        
        Digit1 <= Number; //% 10;
        
        number_to_display = number_to_display/10;
        Digit2 <= Number;//%10;
    
        number_to_display = number_to_display/10;
        Digit3 <= Number;//%10;
        
        number_to_display = number_to_display/10;
        Digit4 <= Number;//%10;
    end
    
    Decoding Seg7(
                .SEG_SELECT_IN(StrobeCount),
                .BIN_IN(MuxOut[3:0]),
                .DOT_IN(MuxOut[4]),
                .SEG_SELECT_OUT(SEG_SELECT),
                .HEX_OUT(DEC_OUT)
                );
                
                
    Generic_counter # (.COUNTER_WIDTH(2),   //StrobeCount generator
                                  .COUNTER_MAX(3)
                                  )
                                  Bit2Count (
                                  .CLK(CLK),
                                  .RESET(1'b0),
                                  .ENABLE(1'b1),
                                  .COUNT(StrobeCount)
                                  );                       



                
    Multiplexer Mux4(
                        .CONTROL(StrobeCount),
                        .IN0(Digit1),
                        .IN1(Digit2),
                        .IN2(Digit3),
                        .IN3(Digit4),
                        .OUT(MuxOut)
                        );

 
    
    
endmodule
