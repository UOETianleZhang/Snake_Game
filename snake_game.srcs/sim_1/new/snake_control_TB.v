module snake_control_TB(
    );
    
    
        reg CLK;
        reg RESET;
        reg BTNL;
        reg BTNU;
        reg BTNR;
        reg BTND;
        
        reg CHEAT=0;
        reg Speed_Up=0;
        reg Fail_Control=0;
    
        wire [11:0] COLOR_OUT;
        wire HS;
        wire VS;
        wire [3:0] SEG_SELECT;
        wire [7:0] DEC_OUT;
    
    
    
    
    
//    parameter BLUE = 12'hF00;       
//    parameter RED = 12'h00F;                       
//    parameter GREEN = 12'h0F0;
    
    wire [1:0] Master_state_out;
    wire [11:0] COLOR;
    wire [9:0] X;
    wire [9:0] Y;
    wire [2:0] Navi_State_Out;
    wire [14:0] Random_Target_Address; 
    wire [14:0] Random_Poison_Address; 
    wire Reached_Target;
    wire Reached_Poison;
    wire Failed;
    wire [16:0] Current_Score;
    
    initial begin
        RESET = 1;
        BTNL = 1;
        BTNU = 0;
        BTNR = 0;
        BTND = 0;
        
        #500;
        RESET = 0;
        BTNL = 0;
        BTNU = 1;
        BTNR = 0;
        BTND = 0;
        
        #500;
        BTNL = 0;
        BTNU = 1;
        BTNR = 0;
        BTND = 0;
        
        #2000;
        BTNL = 0;
        BTNU = 0;
        BTNR = 1;
        BTND = 0;
    end
    
    initial begin
        CLK = 0;
        forever #10 CLK = ~CLK; 
    end

    
    Master_statemachine master(
            .RESET(RESET),
            .CLK(CLK),
            .BTNL(BTNL),
            .BTNU(BTNU),
            .BTNR(BTNR),
            .BTND(BTND),
            .Failed(Fail_Control||Failed),
            .Current_Score(Current_Score),
            .Master_state_out(Master_state_out)   
            );
        
     VGA_Wrapper V(
            .CLK(CLK),
            .Master_state_out(Master_state_out),
            .COLOR(COLOR),
            .COLOR_OUT(COLOR_OUT),
            .BTNL(BTNL),
            .BTNR(BTNR),
            .X(X),
            .Y(Y),
            .HS(HS),
            .VS(VS)
            );

     Navigation_S_M Navi(
            .RESET(RESET),
            .CLK(CLK),
            .BTNL(BTNL),
            .BTNU(BTNU),
            .BTNR(BTNR),
            .BTND(BTND),
            .Master_state_out(Master_state_out),
            .Navi_State_Out(Navi_State_Out)            
            );
    

    Score_counter segment(
            .RESET(RESET),
            .CLK(CLK),
            .ENABLE(Reached_Target),
            .MINUS(Reached_Poison),
            .Current_Score(Current_Score),   
            .SEG_SELECT(SEG_SELECT),
            .CHEAT(CHEAT),
            .DEC_OUT(DEC_OUT)
    );


    Snake_Control Control(
            .Navi_State_Out(Navi_State_Out),
            .X(X),
            .Y(Y),
            .RESET(RESET),
            .CLK(CLK),
            .Failed(Failed),
            .Speed_Up(Speed_Up),
            .Current_Score(Current_Score),
            .Random_Target_Address(Random_Target_Address),
            .Random_Poison_Address(Random_Poison_Address),
            .Reached_Target(Reached_Target),
            .Reached_Poison(Reached_Poison),
            .COLOR(COLOR)
            );
            
            
    Target_Generator Ran_Y_X(
            .CLK(CLK),
            .RESET(RESET),
            .Reached_Target(Reached_Target),
            .Reached_Poison(Reached_Poison),
            .Random_Target_Address(Random_Target_Address),
            .Random_Poison_Address(Random_Poison_Address)
            );

endmodule
