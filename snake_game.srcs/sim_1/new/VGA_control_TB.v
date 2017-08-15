`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.11.2016 15:26:55
// Design Name: 
// Module Name: VGA_control_TB
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


module VGA_control_TB(

    );
    
    reg CLK;
    reg [11:0] COLOR_IN;
    wire [9:0]X;
    wire [9:0]Y;
    wire HS;
    wire VS;
    wire [11:0]COLOR_OUT;
    
    
     initial begin
         COLOR_IN = 12'hFF0;
                  
         #500;
         COLOR_IN = 12'hF0F;
         
         #500;
         COLOR_IN = 12'hF00;
         
         #2000;
         COLOR_IN = 12'hFFF;

     end
     
     initial begin
     
         CLK = 0;
         forever #10 CLK = ~CLK; 
     end 
    
   VGA_Control uut(
             .CLK(CLK),
             .COLOR_IN(COLOR_IN),
             .ADDRH(X),
             .ADDRV(Y),
             .COLOR_OUT(COLOR_OUT),
             .HS(HS),
             .VS(VS)
             );    
    
endmodule
