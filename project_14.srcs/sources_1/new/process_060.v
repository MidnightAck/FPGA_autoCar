`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/01/01 12:33:35
// Design Name: 
// Module Name: process_060
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


module process_060(
	input 		        I_clk,  
    inout               I_O_sda ,
    output    [7:0]  O_seg_060       ,
	output    [7:0]  O_sel_060   
);

wire clk_1khz ;
wire clk_100khz;
wire      [3:0]   O_num1  ;
wire      [3:0]   O_num2  ;
wire      [3:0]   O_num3  ;
wire      [3:0]   O_num4  ;
wire      [3:0]   O_num5  ;
wire      [3:0]   O_num6  ;
wire      [3:0]   O_num7  ;
wire      [3:0]   O_num8  ;


det
det
(
	.I_clk   ( I_clk ),  //100khz
    .I_O_sda ( I_O_sda    ),
    .O_num1  ( O_num1     ),
    .O_num2  ( O_num2     ),
    .O_num3  ( O_num3     ),
    .O_num4  ( O_num4     ),
    .O_num5  ( O_num5     ),
    .O_num6  ( O_num6     ),
    .O_num7  ( O_num7     ),
    .O_num8  ( O_num8     )

);

divclk_060
divclk_060
(     
	.inclk_060  ( I_clk       ),  
	.outclk_060 ( clk_1khz    )  
);

sel_det_060
u_sel
( 
   .I_clk_div_060 ( clk_1khz ), 
    //  .I_clk_div_060 ( clk_seg_060 ), 
   .I_num1_060    ( O_num1      ), 
   .I_num2_060    ( O_num2      ), 
   .I_num3_060    ( O_num3      ), 
   .I_num4_060    ( O_num4      ), 
   .I_num5_060    ( O_num5      ), 
   .I_num6_060    ( O_num6      ), 
   .I_num7_060    ( O_num7      ), 
   .I_num8_060    ( O_num8      ),     
   .O_seg_060     ( O_seg_060  ),
   .O_sel_060     ( O_sel_060  )
	);


endmodule

