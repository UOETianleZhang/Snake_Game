`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: the University of Edinburgh
// Engineer: Tianle Zhang s1678924
// 
// Create Date: 14.11.2016 09:23:29
// Design Name: Snake_Game
// Module Name: Generic_counter
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

//This module is used to creat a generic counter, 
//with COUNTER_WIDTH and COUNTER_MAX able to be adjusted in instantiation
module Generic_counter(
        CLK,
        RESET,
        ENABLE,
        MINUS,     
        TRIG_OUT,   //high when reach COUNTER_MAX
        MINUS_OUT,  //high when reach 0
        COUNT       //output current number counted
    );
    
    parameter COUNTER_WIDTH=4;
    parameter COUNTER_MAX=9;
    
    input   CLK;
    input   RESET;
    input   ENABLE;
    input   MINUS;
    output  MINUS_OUT;
    output  TRIG_OUT;
    output  [COUNTER_WIDTH-1:0] COUNT;
    
    reg [COUNTER_WIDTH-1:0] count_value = 0;    
    reg Trigger_out;
    reg Minus_Trigger_out;
    
    //Synchronous logic for value of count_value
    always@( posedge CLK) begin
        if(RESET)
            count_value <=0;
        else begin
            if(ENABLE) begin
                if(count_value == COUNTER_MAX)
                    count_value <= 0;
                else
                    count_value <= count_value+1;
             end
            else if(MINUS) begin
                 if(count_value == 0)
                     count_value <= COUNTER_MAX;
                 else
                     count_value <= count_value-1;
              end
         end
     end

    //Synchronous logic for Trigger_out and Minus_Trigger_out
    always@( posedge CLK) begin
         if(RESET) begin
            Minus_Trigger_out<=0;
            Trigger_out <= 0;
         end
         else begin
             if(ENABLE && (count_value == COUNTER_MAX))
                Trigger_out<=1;
             else
                Trigger_out<=0;
             if(MINUS && (count_value == 0))
                Minus_Trigger_out<=1;
                else
                Minus_Trigger_out<=0;
          end
      end
      
      assign COUNT      = count_value;
      assign TRIG_OUT   = Trigger_out;
      assign MINUS_OUT   = Minus_Trigger_out;
endmodule
