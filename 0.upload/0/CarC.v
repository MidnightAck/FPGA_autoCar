`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/01/01 18:42:56
// Design Name: 
// Module Name: CarC
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


`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/20 23:34:53
// Design Name: 
// Module Name: sport
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
module speed(
input key1,
input key2,
input key3,
output [3:0]mod
);

reg[3:0]speedmod;
assign mod=speedmod;

always@(*)
begin
    speedmod=4'd00;
	if(key1==1) speedmod=4'd10;
	if(key2==1) speedmod=4'd13;
	if(key3==1) speedmod=4'd15;
end
endmodule


module pwm(
input clk,
input [3:0]pulse_width,
output out
);

reg [3:0]cnt;
reg wave;
assign out = wave;
always @(posedge clk )
if(cnt<4'hF)
 cnt <= cnt + 1;
else 
 cnt <= 0;
 
always @(posedge clk)
if(cnt<pulse_width)
 wave <= 1;
else 
 wave <= 0;

endmodule


module sport(IN1,IN2,IN3,IN4,iS1,iS2,StepEnable,pwm,up,down,left,right);   
// input clk; 
// input hwx;
    input StepEnable; 
	input iS1;
	input iS2;
	input up;
	input down;
	input left;
	input right;
	input pwm;
    output reg IN1; 
    output reg IN2; 
    output reg IN3; 
    output reg IN4; 
  
	 
    always @(*)
    //always @(posedge clk or negedge hwx)
    //if (!hwx)
        //begin
         //IN1=0;
        //IN2=0;
         // IN3=0;
          // IN4=0;
      //  end
    //else
    begin 	
        IN1=0;
                    IN2=0;
                    IN3=0;
                    IN4=0;
		if(StepEnable==1) 
		begin
		if(iS1==0&&iS2==0)
            begin 
                IN1=0;
                IN2=pwm;
                IN3=pwm;
                IN4=0;
            end
            
            else if(iS1==0&&iS2==1)
            begin 
                IN1=0;
                IN2=pwm;
                IN3=0;
                IN4=0;
            end
            
            else  if(iS1==1&&iS2==0)
            begin 
                IN1=0;
                IN2=0;
                IN3=pwm;
                IN4=0;
            end
            
            else if(iS1==1&&iS2==1)
            begin 
                IN1=0;
                IN2=0;
                IN3=0;
                IN4=0;
            end
       end
       else
       begin
            if(up==1&&down==0&&left==0&&right===0)
                   begin 
                       IN1=0;
                       IN2=pwm;
                       IN3=pwm;
                       IN4=0;
                   end
            else   if(up==1&&down==0&&left==0&&right===1)
                    begin 
                    IN1=0;
                     IN2=pwm;
                     IN3=0;
                     IN4=0;
                     end
             else   if(up==1&&down==0&&left==1&&right===0)
                             begin 
                             IN1=0;
                              IN2=0;
                              IN3=pwm;
                              IN4=0;
                              end
            else   if(up==0&&down==1&&left==0&&right===0)
                                      begin 
                                      IN1=pwm;
                                       IN2=0;
                                       IN3=0;
                                       IN4=pwm;
                                       end            
             else   if(up==0&&down==1&&left==1&&right===0)
                                                                 begin 
                                                                 IN1=0;
                                                                  IN2=0;
                                                                  IN3=0;
                                                                  IN4=pwm;
                                                                  end
    else   if(up==0&&down==1&&left==1&&right===0)
                           begin 
                           IN1=pwm;
                                 IN2=0;
                                     IN3=0;
                                        IN4=0;
                                                                                                                                   end                                                                            
       end   
    end
endmodule

module Divider(
    input I_CLK,
    input rst,
    output O_CLK
    );
    parameter N =20;
    integer count =20;
    reg tempO_CLK = 0;
    
    always @ (posedge I_CLK)
    begin
        if(count == N+1 || rst ==1)
            count = 0;
        if(count <= N / 2)
            tempO_CLK = 0;
        else
            tempO_CLK = 1;
        count = count + 1;
    end
    assign O_CLK = tempO_CLK;
endmodule

module carMove(
 
    inout               I_O_sda ,
    output    [7:0]  O_seg_060       ,
	output    [7:0]  O_sel_060,   
    input key1,
    input key2,
    input key3,
    input CLK,
    input hwx,
     input iS1,
     input iS2,
     input up,
      input down,
       input left,
        input right,
     input StepEnable,
     output IN1,
     output IN2,
     output IN3,
     output IN4
    );

    //?????????
    wire[3:0] mod;
    speed spe1(
    .key1(key1),
    .key2(key2),
    .key3(key3),
    .mod(mod)
    );
    
    wire O_CLK;
    Divider Divider1(
    .I_CLK(CLK),
    .rst(hwx),
    .O_CLK(O_CLK)
    );
    
    //PWM???
    wire pwmout;
    pwm pwm1(
    .clk(O_CLK),
    .pulse_width(mod),
    .out(pwmout)
    );
    
    //?????????? IN1,IN2,IN3,IN4,iS1,iS2,clk,StepEnable,pwm
    sport sp1
    (
    .up(up),
    .left(left),
    .right(right),
    .down(down),
    .IN1(IN1), 
    .IN2(IN2), 
    .IN3(IN3), 
    .IN4(IN4), 
   .iS1(iS1),
   .iS2(iS2),
   
    .StepEnable(StepEnable),
    .pwm(pwmout)
    );
    
    process_060 pro(
        .I_clk(CLK),
        . I_O_sda(I_O_sda) ,
        .O_seg_060(O_seg_060),
        .O_sel_060(O_sel_060)   
    );
endmodule

