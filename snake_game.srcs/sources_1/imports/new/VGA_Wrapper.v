`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.10.2016 16:39:27
// Design Name: 
// Module Name: VGA_Wrapper
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

//This module is to display letters "ZOE" on the screen by applying VGA
//Colour will fill "Z" from bottom 
//"O" will become increasingly large and move downwards, but the colour of it keep stable 
//"E" will rotate, and the color of one side of it keep stable, which looks like a fake "3D" 

//NB: when changing wrappers, the codes in XDC file should also be changed,
//    and all parts are written, just using differnt lines of XDC is OK


module VGA_Wrapper(
    input [11:0] COLOR,
    input CLK,
    output [11:0] COLOR_OUT,
    output HS,
    output VS
    );
    
    wire [9:0] X;   //hrizontal ordinate of pixels
    wire [9:0] Y;   //vertical ordinate of pixels
    reg [11:0] COLOR_t;     //final input color put into VGA interface 
 
    wire [7:0] T;  //output of an extra counter"TCount", an individual viable changed as time passes by
    wire [6:0] T1;
    wire [11:0] COLO;   // //output of an extra counter"COLORIN", representing a colour at one time
    wire CLKTriggOut;
   
    //adjust frequency of displaying
    Generic_counter # (.COUNTER_WIDTH(30),
                       .COUNTER_MAX(10000000)
                       )
                       CO_LOCKKK(
                       .CLK(CLK),
                       .RESET(1'b0),
                       .ENABLE(1'b1),
                       .TRIG_OUT(CLKTriggOut)
                       );
                       
    //produce "COLO"                        
    Generic_counter # (.COUNTER_WIDTH(12),
                       .COUNTER_MAX(4095)
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
                           
    VGA_Control uut(
                    .CLK(CLK),
                    .COLOR_IN(COLOR_t),
                    .ADDRH(X),
                    .ADDRV(Y),
                    .COLOR_OUT(COLOR_OUT),
                    .HS(HS),
                    .VS(VS)
                    );
            
    wire [20:0] X1; //left edge of "E"
    wire [20:0] X2; //right edge of "E"
    
    assign X1=(-(9*(T1-50)*(T1-50)/500)+535);   //The speed of changing is fast than slow than fast
    assign X2=(9*(T1-50)*(T1-50)/500+565);     
            
    always@(posedge CLK) begin
       if(((X<150)&&(X>30)&&(Y<125)&&(Y>95)) || (((X<150)&&(X>30))&&(Y<370)&&(Y>340)) || ((Y<((-2*X)+430))&&(Y>((-2*X)+395))&&(X>30)&&(X<150)))//display "Z"       
            COLOR_t= COLO + X/50 + Y/10;        //the Color of "Z" varies by X, Y and time 
            
        else if((X-320)*(X-320)+(Y-140-T)*(Y-140)<2500) //display "O", the size of which varies by time
            COLOR_t =~(12'b100100011011)+ Y/50 +X/80;    //although  the size of "O" varies by time, the colour of it is fixed
            
        else begin
            if(T1<50) begin     //fist half period
                if((((X<X2)&&(X>X1)&&(Y<125)&&(Y>95)) || (((X<X2)&&(X>X1))&&(Y<370)&&(Y>340)) || (((X<X2)&&(X>X1))&&(Y<255)&&(Y>225)) || (((X<(X1+30)))&&(X>X1))&&(Y<370)&&(Y>95)))
                //display "E" and rotate it
                     COLOR_t = (X + X1 +15)/15; //make it look like 3D
                else
                    COLOR_t= 4095;
            end
            else begin          //second half period
                if(((X<X2)&&(X>X1)&&(Y<125)&&(Y>95)) || (((X<X2)&&(X>X1))&&(Y<370)&&(Y>340)) || ((X<X2)&&(X>X1)&&(Y<255)&&(Y>225)) || ((X<X2)&&(X>(X2-30))&&(Y<370)&&(Y>95)))
                    COLOR_t = (X + X2 -15)/15;
            else
                COLOR_t= 4095;  //white
            end
        end
             
     end
             
                   
endmodule
