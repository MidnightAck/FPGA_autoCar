module speed_060(
	input 		I_clk,  
	output      O_clk_div 
);
//I_clk 100mhz 
//O_clk_div  100khz
// I_clk/ O_clk_div = 500
parameter  total_mult        = 1000      ; //total_mult        = 500      ;


parameter  total_cnt        = total_mult      ,
           total_half_cnt   = total_mult / 2  ;

reg [ 20 : 0 ]  cnt =0 ;
reg clk_div  = 0;

always@(posedge I_clk )
    if( cnt == total_cnt - 1 )
        cnt <= 21'h0;
	else
		cnt <= cnt + 1'h1;

always@(posedge I_clk )
    if( cnt == total_half_cnt - 1 )
        clk_div <= 1'h1;
	else
    if( cnt == total_cnt - 1 )
        clk_div <= 1'h0; 
	
assign O_clk_div = clk_div;  

endmodule
