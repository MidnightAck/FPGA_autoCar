module det(
	input 		        I_clk   ,  //100khz
(*mark_debug="true"*)    inout               I_O_sda ,
(*mark_debug="true"*)    output      [3:0]   O_num1  ,
(*mark_debug="true"*)    output      [3:0]   O_num2  ,
(*mark_debug="true"*)    output      [3:0]   O_num3  ,
(*mark_debug="true"*)    output      [3:0]   O_num4  ,
(*mark_debug="true"*)    output      [3:0]   O_num5  ,
(*mark_debug="true"*)    output      [3:0]   O_num6  ,
(*mark_debug="true"*)    output      [3:0]   O_num7  ,
(*mark_debug="true"*)    output      [3:0]   O_num8  

);

parameter  total_mult   = 100_000_000     ;

(*mark_debug="true"*)reg [31: 0]  clk_cnt = 0 ; 

always@(posedge I_clk )begin
    if( clk_cnt == total_mult - 1  ) 
        clk_cnt <= 0;
	else
		clk_cnt <= clk_cnt + 1'b1;
end


(*mark_debug="true"*)reg out_en;
(*mark_debug="true"*)reg sda_temp;

always@(posedge I_clk )begin
    if(( clk_cnt >= 100_000  ) && ( clk_cnt < 200_000 ) )
        out_en <= 1;
	else
        out_en <= 0;
end

always@(posedge I_clk )begin
    if(( clk_cnt >= 100_000  ) && ( clk_cnt < 200_000 )) 
        sda_temp <= 0;
	else 
        sda_temp <= 1;
end

assign I_O_sda = out_en ? sda_temp : 1'hz;

(*mark_debug="true"*)reg [1:0] sda_dly;


always@(posedge I_clk )begin
    if( !out_en )
        sda_dly <= {sda_dly , I_O_sda } ;
end

(*mark_debug="true"*)reg [ 39 : 0 ] sda_reg ;


(*mark_debug="true"*)reg [31:0] sda_high;

always@(posedge I_clk )begin
    if( sda_dly[1] )
        sda_high <= sda_high + 1;
    else
        sda_high <= 0;
end

always@(posedge I_clk )begin
    if( out_en_dly == 2'b01) 
        sda_reg <= 40'h0;
    else
    if( ( sda_dly == 2'b10 ) && ( sda_high <= 3_000) )
        sda_reg <= {sda_reg , 1'h0 };
    else
    if( ( sda_dly == 2'b10 ) && ( sda_high > 5_000) )
        sda_reg <= {sda_reg , 1'h1 };
end


(*mark_debug="true"*)reg [ 15 :0] sda_dly_cnt ;

always@(posedge I_clk )begin
    if( out_en_dly == 2'b01) 
        sda_dly_cnt <= 0;
    else
    if( sda_dly == 2'b10 )
        sda_dly_cnt <=  sda_dly_cnt + 1'h1;
end

(*mark_debug="true"*)reg [ 15 :0] temperature ;
(*mark_debug="true"*)reg [ 15 :0] humidity ;

(*mark_debug="true"*)reg [1:0]out_en_dly;

always@(posedge I_clk )begin
    out_en_dly <= { out_en_dly , out_en };      
end

always@(posedge I_clk )begin
    if( out_en_dly == 2'b01) begin
        temperature <= sda_reg[23 -: 16];
        humidity <= sda_reg[39 -: 16];   
    end        
end



assign O_num1  = temperature/100 ;
assign O_num2  = temperature%100 ;
assign O_num3  = 0 ;
assign O_num4  = 0 ;
assign O_num5  = humidity/100  ;
assign O_num6  = humidity%100 ;
assign O_num7  = 0 ;
assign O_num8  = 0 ;


endmodule

