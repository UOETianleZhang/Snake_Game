`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/10/30 18:50:41
// Design Name: 
// Module Name: State_Machine
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


module State_Machine(
    input CLK,
    input RESET,
    input BTNL,
    input BTNC,
    input BTNR,
    output [2:0] STATE_OUT
    );
    
    reg [2:0] Curr_state;
    reg [2:0] Next_state;
    
    assign STATE_OUT = Curr_state;
    
    always@(posedge CLK) begin
        if(RESET)
            Curr_state  <= 3'b000;
        else
            Curr_state <= Next_state;
    end
    
    always@(BTNL or BTNR or BTNC or Curr_state) begin
        case (Curr_state)     
            3'd0    :begin
                if(BTNL)    Next_state <= 0;
                else if(BTNR) Next_state <= 0;
                else if(BTNC) Next_state <= 6;
                else  Next_state <= 0;
            end

            3'd1    :begin
                if(BTNL)    Next_state <= 5;
                else if(BTNR) Next_state <= 2;
                else if(BTNC) Next_state <= 1;
                else  Next_state <= 1;
            end

            3'd2    :begin
                if(BTNL)    Next_state <= 0;
                else if(BTNR) Next_state <= 2;
                else if(BTNC) Next_state <= 1;
                else  Next_state <= 2;
            end

            3'd3    :begin
                if(BTNL)    Next_state <= 4;
                else if(BTNR) Next_state <= 2;
                else if(BTNC) Next_state <= 3;
                else  Next_state <= 3;
            end

            3'd4    :begin
                if(BTNL)    Next_state <= 4;
                else if(BTNR) Next_state <= 7;
                else if(BTNC) Next_state <= 6;
                else  Next_state <= 4;
            end

            3'd5    :begin
                if(BTNL)    Next_state <= 5;
                else if(BTNR) Next_state <= 0;
                else if(BTNC) Next_state <= 3;
                else  Next_state <= 5;
            end

            3'd6    :begin
                if(BTNL)    Next_state <= 0;
                else if(BTNR) Next_state <= 2;
                else if(BTNC) Next_state <= 6;
                else  Next_state <= 6;
            end

            3'd7    :begin
                if(BTNL)    Next_state <= 7;
                else if(BTNR) Next_state <= 7;
                else if(BTNC) Next_state <= 7;
                else  Next_state <= 7;
            end
            
            default:
                Next_state <= 0;
        endcase
    end
                   
    
    
endmodule
