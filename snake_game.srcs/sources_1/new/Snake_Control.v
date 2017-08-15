`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: the University of Edinburgh
// Engineer: Tianle Zhang s1678924
// 
// Create Date: 14.11.2016 09:23:29
// Design Name: Snake_Game
// Module Name: Snake_Control
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

//This module is a very big one to display the snake, the poison and the food on the screen.
//After the snake eating the food, the length of snake will increase by one ,
//and the speed of the snake will also increase.
//To be noticed, the snake can just turn 90 degree, 
//i.e., it can only go to left or right direction when in up or down direcion, and vise versa.
module Snake_Control(
    input CLK,
    input RESET,    
    input [9:0] X,
    input [9:0] Y,
    input Speed_Up,
    input [2:0] Navi_State_Out,
    input [16:0] Current_Score,
    input [14:0] Random_Target_Address,
    input [14:0] Random_Poison_Address,
    output reg Reached_Target,
    output reg Reached_Poison,
    output reg Failed,
    output  [11:0] COLOR
    );
    
    
    parameter MaxX = 160;
    parameter MaxY = 120;
    parameter SnakeLength = 30;
    parameter Period_For_Speed = 60000000;
    
    parameter RED= 12'h00F;
    parameter GREEN= 12'h0F0;
    parameter YELLOW= 12'h088;
    parameter BLUE= 12'hF00;
    parameter WHITE= 12'hFFF;
    parameter BLACK= 12'h000;
    
    reg [7:0] SnakeState_X [0: SnakeLength-1];
    reg [7:0] SnakeState_Y [0: SnakeLength-1];
    reg [11:0] Control_Color_Out;
    reg [25:0] count = 0;
    
    wire [6:0] Length_Add=0;

    assign COLOR = Control_Color_Out;
    
    //control the speed of the snake by "count"
    always@( posedge CLK) begin 
        if(RESET)
            count <=0;
        else begin
            if(2'b01) begin
                if(count >= Period_For_Speed)
                    count <= 0;
                else
                //if you want to make the whole game quiker or slower, 
                //you can adjust the value of Period_For_Speed(60000000) and 6 here,
                //since if Current_Score is divied by a number, the outcome may go wrong
                    count <= count +6 + Current_Score + Speed_Up*6;
             end
         end
     end
        
    //judge if the snake eats the food
    always@(posedge CLK) begin
        if(((Random_Target_Address[7:0])==(SnakeState_X[0]))&&((Random_Target_Address[14:8])==(SnakeState_Y[0])))
            Reached_Target = 1;
        else
            Reached_Target = 0;
     end

    //judge if the snake eats the poison
    always@(posedge CLK) begin
        if(((Random_Poison_Address[7:0])==(SnakeState_X[0]))&&((Random_Poison_Address[14:8])==(SnakeState_Y[0])))
            Reached_Poison = 1;
        else
            Reached_Poison = 0;
     end

//    judge if the snake hits itself
    always@( posedge CLK) begin
         if(RESET)
             Failed <=0;
         else begin
            //to avoid the game fails at the very begining,the judgenment starts when the score is more than 1
            if(((SnakeState_X[0])==(SnakeState_X[1]))&&((SnakeState_Y[0])==(SnakeState_Y[1]))&&(Current_Score>0))
                Failed <=1;
            else if(((SnakeState_X[0])==(SnakeState_X[2]))&&((SnakeState_Y[0])==(SnakeState_Y[2]))&&(Current_Score>0))
                Failed <=1;
            else if(((SnakeState_X[0])==(SnakeState_X[3]))&&((SnakeState_Y[0])==(SnakeState_Y[3]))&&(Current_Score>0))
                Failed <=1;
            else if(((SnakeState_X[0])==(SnakeState_X[4]))&&((SnakeState_Y[0])==(SnakeState_Y[4]))&&(Current_Score>0))
                Failed <=1;
            else if(((SnakeState_X[0])==(SnakeState_X[5]))&&((SnakeState_Y[0])==(SnakeState_Y[5]))&&(Current_Score>0))
                Failed <=1;
            else if(((SnakeState_X[0])==(SnakeState_X[6]))&&((SnakeState_Y[0])==(SnakeState_Y[6]))&&(Current_Score>0))
                Failed <=1;
            else if(((SnakeState_X[0])==(SnakeState_X[7]))&&((SnakeState_Y[0])==(SnakeState_Y[7]))&&(Current_Score>1))
                Failed <=1;
            else if(((SnakeState_X[0])==(SnakeState_X[8]))&&((SnakeState_Y[0])==(SnakeState_Y[8]))&&(Current_Score>2))
                Failed <=1;
            else if(((SnakeState_X[0])==(SnakeState_X[9]))&&((SnakeState_Y[0])==(SnakeState_Y[9]))&&(Current_Score>3))
                Failed <=1;
            else if(((SnakeState_X[0])==(SnakeState_X[10]))&&((SnakeState_Y[0])==(SnakeState_Y[10]))&&(Current_Score>4))
                Failed <=1;
            else if(((SnakeState_X[0])==(SnakeState_X[11]))&&((SnakeState_Y[0])==(SnakeState_Y[11]))&&(Current_Score>5))
                Failed <=1;
            else if(((SnakeState_X[0])==(SnakeState_X[12]))&&((SnakeState_Y[0])==(SnakeState_Y[12]))&&(Current_Score>6))
                Failed <=1;
            else if(((SnakeState_X[0])==(SnakeState_X[13]))&&((SnakeState_Y[0])==(SnakeState_Y[13]))&&(Current_Score>7))
                Failed <=1;
            else if(((SnakeState_X[0])==(SnakeState_X[14]))&&((SnakeState_Y[0])==(SnakeState_Y[14]))&&(Current_Score>8))
                Failed <=1;
            else if((SnakeState_X[0]==SnakeState_X[15])&&(SnakeState_Y[0]==SnakeState_Y[15])&&(Current_Score>9))
                Failed <=1;
            else if((SnakeState_X[0]==SnakeState_X[16])&&(SnakeState_Y[0]==SnakeState_Y[16])&&(Current_Score>10))
                Failed <=1;
            else if((SnakeState_X[0]==SnakeState_X[17])&&(SnakeState_Y[0]==SnakeState_Y[17])&&(Current_Score>11))
                Failed <=1;
            else if((SnakeState_X[0]==SnakeState_X[18])&&(SnakeState_Y[0]==SnakeState_Y[18])&&(Current_Score>12))
                Failed <=1;
            else if((SnakeState_X[0]==SnakeState_X[19])&&(SnakeState_Y[0]==SnakeState_Y[19])&&(Current_Score>13))
                Failed <=1;
            else if((SnakeState_X[0]==SnakeState_X[20])&&(SnakeState_Y[0]==SnakeState_Y[20])&&(Current_Score>14))
                Failed <=1;
            else if((SnakeState_X[0]==SnakeState_X[21])&&(SnakeState_Y[0]==SnakeState_Y[21])&&(Current_Score>15))
                Failed <=1;
            else if((SnakeState_X[0]==SnakeState_X[22])&&(SnakeState_Y[0]==SnakeState_Y[22])&&(Current_Score>16))
                Failed <=1;
            else if((SnakeState_X[0]==SnakeState_X[23])&&(SnakeState_Y[0]==SnakeState_Y[23])&&(Current_Score>17))
                Failed <=1;
            else if((SnakeState_X[0]==SnakeState_X[24])&&(SnakeState_Y[0]==SnakeState_Y[24])&&(Current_Score>18))
                Failed <=1;
            else if((SnakeState_X[0]==SnakeState_X[25])&&(SnakeState_Y[0]==SnakeState_Y[25])&&(Current_Score>19))
                Failed <=1;
            //judge if the snake encounters the wall    
            else if(((SnakeState_X[0])<=92)&&((SnakeState_X[0])>=90)&&((SnakeState_Y[0])<=100)&&((SnakeState_Y[0])>=50))
                Failed <=1;
            else if((Current_Score==0)&&(Reached_Poison==1)) //when the score tends to being less than 0, the game also fails
                Failed <=1;
            else 
                Failed <=0;
                
         end
      end
    
    //chaging the position of the snake register
    //shift the SnakeState X and Y
    genvar PixNo;
    generate 
        for (PixNo = 0; PixNo < SnakeLength-1; PixNo= PixNo+1)
        begin: PixShift
            always@(posedge CLK) begin
                if(RESET) begin
                //middle-down part of the screen
                    SnakeState_X[PixNo+1] <=80;
                    SnakeState_Y[PixNo+1] <=100;
                end
                else if(count == 0) begin
                    SnakeState_X[PixNo+1] <= SnakeState_X[PixNo];
                    SnakeState_Y[PixNo+1] <= SnakeState_Y[PixNo];
                end
            end
        end
    endgenerate
    

    //colour the snake by length
    always@(CLK) begin
        //no matter what the score is, former 5 bits will always be coloured, 
        //which is the initial length of the snake
        if((SnakeState_X[0]==(X/4))&&(SnakeState_Y[0]==(Y/4)))
            Control_Color_Out <= GREEN;
        else if((SnakeState_X[1]==(X/4))&&(SnakeState_Y[1]==(Y/4)))
            Control_Color_Out <= YELLOW;
        else if((SnakeState_X[2]==(X/4))&&(SnakeState_Y[2]==(Y/4)))
            Control_Color_Out <= YELLOW;
        else if((SnakeState_X[3]==(X/4))&&(SnakeState_Y[3]==(Y/4)))
            Control_Color_Out <= YELLOW;
        else if((SnakeState_X[4]==(X/4))&&(SnakeState_Y[4]==(Y/4)))
            Control_Color_Out <= YELLOW;
        else if((SnakeState_X[5]==(X/4))&&(SnakeState_Y[5]==(Y/4)))
            Control_Color_Out <= YELLOW;
        //every got score will increase the length of the snake by 1
        else if((SnakeState_X[6]==(X/4))&&(SnakeState_Y[6]==(Y/4))&&(Current_Score>=1))
            Control_Color_Out <= YELLOW;
        else if((SnakeState_X[7]==(X/4))&&(SnakeState_Y[7]==(Y/4))&&(Current_Score>=2))
            Control_Color_Out <= YELLOW;
        else if((SnakeState_X[8]==(X/4))&&(SnakeState_Y[8]==(Y/4))&&(Current_Score>=3))
            Control_Color_Out <= YELLOW;
        else if((SnakeState_X[9]==(X/4))&&(SnakeState_Y[9]==(Y/4))&&(Current_Score>=4))
            Control_Color_Out <= YELLOW;
        else if((SnakeState_X[10]==(X/4))&&(SnakeState_Y[10]==(Y/4))&&(Current_Score>=5))
            Control_Color_Out <= YELLOW;
        else if((SnakeState_X[11]==(X/4))&&(SnakeState_Y[11]==(Y/4))&&(Current_Score>=6))
            Control_Color_Out <= YELLOW;
        else if((SnakeState_X[12]==(X/4))&&(SnakeState_Y[12]==(Y/4))&&(Current_Score>=7))
            Control_Color_Out <= YELLOW;
        else if((SnakeState_X[13]==(X/4))&&(SnakeState_Y[13]==(Y/4))&&(Current_Score>=8))
            Control_Color_Out <= YELLOW;
        else if((SnakeState_X[14]==(X/4))&&(SnakeState_Y[14]==(Y/4))&&(Current_Score>=9))
            Control_Color_Out <= YELLOW;
        else if((SnakeState_X[15]==(X/4))&&(SnakeState_Y[15]==(Y/4))&&(Current_Score>=10))
            Control_Color_Out <= YELLOW;
        else if((SnakeState_X[16]==(X/4))&&(SnakeState_Y[16]==(Y/4))&&(Current_Score>=11))
            Control_Color_Out <= YELLOW;
        else if((SnakeState_X[17]==(X/4))&&(SnakeState_Y[17]==(Y/4))&&(Current_Score>=12))
            Control_Color_Out <= YELLOW;
        else if((SnakeState_X[18]==(X/4))&&(SnakeState_Y[18]==(Y/4))&&(Current_Score>=13))
            Control_Color_Out <= YELLOW;
        else if((SnakeState_X[19]==(X/4))&&(SnakeState_Y[19]==(Y/4))&&(Current_Score>=14))
            Control_Color_Out <= YELLOW;
        else if((SnakeState_X[20]==(X/4))&&(SnakeState_Y[20]==(Y/4))&&(Current_Score>=15))
            Control_Color_Out <= YELLOW;
        else if((SnakeState_X[21]==(X/4))&&(SnakeState_Y[21]==(Y/4))&&(Current_Score>=16))
            Control_Color_Out <= YELLOW;
        else if((SnakeState_X[22]==(X/4))&&(SnakeState_Y[22]==(Y/4))&&(Current_Score>=17))
            Control_Color_Out <= YELLOW;
        else if((SnakeState_X[23]==(X/4))&&(SnakeState_Y[23]==(Y/4))&&(Current_Score>=18))
            Control_Color_Out <= YELLOW;
        else if((SnakeState_X[24]==(X/4))&&(SnakeState_Y[24]==(Y/4))&&(Current_Score>=19))
            Control_Color_Out <= YELLOW;
        else if((SnakeState_X[25]==(X/4))&&(SnakeState_Y[25]==(Y/4))&&(Current_Score>=20))
            Control_Color_Out <= YELLOW;
        //the maximum length of the snake is 26

        //colour the food and the poison
        else if((Random_Target_Address[7:0]==(X/4))&&(Random_Target_Address[14:8]==(Y/4)))
            Control_Color_Out <= RED;
        else if((Random_Poison_Address[7:0]==(X/4))&&(Random_Poison_Address[14:8]==(Y/4)))
            Control_Color_Out <= BLUE;
        else if(((X/4)<=92)&&((X/4)>=90)&&((Y/4)<=100)&&((Y/4)>=50))
            Control_Color_Out <= BLACK;
        else
            Control_Color_Out = WHITE;
    end

    //move the snake by Navi_State_Out, choosing a direction
    always@(posedge CLK) begin
        if(RESET) begin
            //Set the head of the snake 
            SnakeState_X[0] <=80;
            SnakeState_Y[0] <=100;
        end
        else if(count == 0) begin
            case(Navi_State_Out)
                3'd1    :begin      //Down, get back to the up edge when encounterring the wall
                    if(SnakeState_Y[0]==MaxY)
                        SnakeState_Y[0] <= 1;
                    else
                        SnakeState_Y[0] <= SnakeState_Y[0]+1;
                end
                3'd2    :begin      //Right, get back to the left edge when encounterring the wall
                    if(SnakeState_X[0]==MaxX)
                        SnakeState_X[0] <= 1;
                    else
                        SnakeState_X[0] <= SnakeState_X[0]+1;
                end
                3'd3    :begin      //Up, get back to the down edge when encounterring the wall
                    if(SnakeState_Y[0]==1)
                        SnakeState_Y[0] <= MaxY;
                    else
                        SnakeState_Y[0] <= SnakeState_Y[0]-1;
                end
                3'd4    :begin      //Left, get back to the right edge when encounterring the wall
                    if(SnakeState_X[0]==1)
                        SnakeState_X[0] <= MaxX;
                    else
                        SnakeState_X[0] <= SnakeState_X[0]-1;
                end
            endcase
        end
    end
                    
    
    
    
endmodule
