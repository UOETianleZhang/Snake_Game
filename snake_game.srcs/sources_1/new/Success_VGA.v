`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: the University of Edinburgh
// Engineer: Tianle Zhang s1678924
// 
// Create Date: 14.11.2016 09:23:29
// Design Name: Snake_Game
// Module Name: Success_VGA
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

//This module is used to display the win mode after achieving the aim score of the snake game.
//There 3 letters : Z, O and E.
//o will become bigger and bigger as time goes.
//E will rotate, and the colour of it makes the E look like "3D"
module Success_VGA(
    input CLK,
    input [9:0] X,   //hrizontal ordinate of pixels
    input [9:0] Y,   //vertical ordinate of pixels
    output [11:0] SUCCESS_COLOR_OUT
    
    );
    assign SUCCESS_COLOR_OUT = COLOR_t;
    
    reg [11:0] COLOR_t;     //final input color put into VGA interface 
 
    wire [7:0] T;  //output of an extra counter"TCount", an individual viable changed as time passes by
    wire [6:0] T1;
    wire [11:0] COLO;   // //output of an extra counter"COLORIN", representing a colour at one time
    wire CLKTriggOut;
   
    parameter BLUE = 12'hF00;       
    parameter RED = 12'h00F;                       
    parameter GREEN = 12'h0F0;
    parameter WHITE = 12'hFFF;
    
    parameter bais=470;
    parameter bais2=310;
    parameter bais3=160;
   
   
    //adjust frequency of displaying
    Generic_counter # (.COUNTER_WIDTH(30),
                       .COUNTER_MAX(5000000)
                       )
                       CO_LOCKKK(
                       .CLK(CLK),
                       .RESET(1'b0),
                       .ENABLE(1'b1),
                       .TRIG_OUT(CLKTriggOut)
                       );
                       
    //produce "COLO"                        
    Generic_counter # (.COUNTER_WIDTH(12),
                       .COUNTER_MAX(WHITE)
                       )
                       COLORIN(
                       .CLK(CLK),
                       .RESET(1'b0),
                       .ENABLE(CLKTriggOut),
                       //.TRIG_OUT(CLKTriggOut)
                       .COUNT(COLO)
                       );
                       
    //produce "T", whose period is 200
    Generic_counter # (.COUNTER_WIDTH(8),
                       .COUNTER_MAX(200)
                       )
                       TCount(
                       .CLK(CLK),
                       .RESET(1'b0),
                       .ENABLE(CLKTriggOut),
                       //.TRIG_OUT(CLKTriggOut)
                       .COUNT(T)
                       );
     
      //produce "T1", whose period is 100                  
     Generic_counter # (.COUNTER_WIDTH(7),
                       .COUNTER_MAX(100)
                       )
                       T1Count(
                       .CLK(CLK),
                       .RESET(1'b0),
                       .ENABLE(CLKTriggOut),
                       //.TRIG_OUT(CLKTriggOut)
                       .COUNT(T1)
                       );
                                       
    wire [20:0] X1; //left edge of "E"
    wire [20:0] X2; //right edge of "E"
    
    assign X1=(-(9*(T1-50)*(T1-50)/500)+535);   //The speed of changing is fast than slow than fast
    assign X2=(9*(T1-50)*(T1-50)/500+565);     
            
    always@(posedge CLK) begin
       if((X<=405)&&(X>=370)&&(Y<=370)&&(Y>=95))   //display I
             COLOR_t= 12'h8F8;
             
       else begin
            if(T1<50) begin     //fist half period
                if((((X<(X2-bais))&&(X>(X1-bais))&&(Y<125)&&(Y>95)) || (((X<(X2-bais))&&(X>(X1-bais)))&&(Y<255)&&(Y>225)) || (((X<(X1+30-bais)))&&(X>(X1-bais)))&&(Y<370)&&(Y>95)))
                    COLOR_t= 12'h8F8;      //display "F" and rotate it
                else if((((X<(X2))&&(X>(X1))&&(Y<370)&&(Y>340)) || (((X<(X1+30)))&&(X>(X1)))&&(Y<370)&&(Y>95)))
                    COLOR_t= 12'h8F8;      //display "L" and rotate it
                else if( ((X<(X2-bais3))&&(X>(X1-bais3))&&(Y<125)&&(Y>95)) ||(((X<(X2-bais3))&&(X>(X1-bais3))&&(Y<370)&&(Y>340)) ))
                    COLOR_t= 12'h8F8;      //display "I" and rotate it
                else if((((X<(X2-bais2))&&(X>(X1-bais2))&&(Y<125)&&(Y>95))) || 
                        (((X<(X2-bais2)))&&(X>(X1-bais2))&&(Y<255)&&(Y>225)) || 
                        (((X<(X1+30-bais2)))&&(X>(X1-bais2))&&(Y<370)&&(Y>95)) || 
                        (((X<(X2-bais2)))&&(X>(X2-30-bais2))&&(Y<370)&&(Y>95)))
                    //display "A" and rotate it
                    COLOR_t= 12'h8F8;     
                else
                    COLOR_t= WHITE;
            end
            else begin          //second half period
                if(((X<(X2-bais))&&(X>(X1-bais))&&(Y<125)&&(Y>95)) || (((X<(X2-bais))&&(X>(X1-bais)))&&(Y<255)&&(Y>225)) || ((X<(X2-bais))&&(X>(X2-30-bais))&&(Y<370)&&(Y>95)))
                    COLOR_t= 12'h8F8;     
                else if(((X<(X2))&&(X>(X1))&&(Y<370)&&(Y>340)) || ((X<(X2))&&(X>(X2-30))&&(Y<370)&&(Y>95)))
                    COLOR_t= 12'h8F8; 
                else if(((X<(X2-bais3))&&(X>(X1-bais3))&&(Y<125)&&(Y>95)) ||(((X<(X2-bais3))&&(X>(X1-bais3))&&(Y<370)&&(Y>340)) ))
                    COLOR_t= 12'h8F8;      //display "I" and rotate it
                else if((((X<(X2-bais2))&&(X>(X1-bais2))&&(Y<125)&&(Y>95))) || 
                            (((X<(X2-bais2)))&&(X>(X1-bais2))&&(Y<255)&&(Y>225)) || 
                            (((X<(X1+30-bais2)))&&(X>(X1-bais2))&&(Y<370)&&(Y>95)) || 
                            (((X<(X2-bais2)))&&(X>(X2-30-bais2))&&(Y<370)&&(Y>95)))
                        COLOR_t= 12'h8F8;     
            else
                COLOR_t= WHITE;  
            end
        end
             
     end
             
                   
endmodule

