module divclk_060(     
	input 		inclk_060,  
	output      outclk_060   
	);
    
parameter INCLK_060      = 100_000_000       	, 
          INCLK_060DIV2 = INCLK_060 / 500		,
		  INCLK_060DIV4 = INCLK_060DIV2 >> 1	;
    
reg [31:0]  inclkcnt_060 = 0;

always@(posedge inclk_060 )begin
    if( INCLK_060DIV2 == inclkcnt_060 + 1 ) 
        inclkcnt_060 <= 'd0;
	else
		inclkcnt_060 <= inclkcnt_060 + 1'b1;
end

reg outclktemp_060 = 0 ;

always@(posedge inclk_060 )begin
    if( INCLK_060DIV4 == inclkcnt_060 + 1 ) 
        outclktemp_060 <= 1;
	else
    if( INCLK_060DIV2 ==  inclkcnt_060 + 1 )
		outclktemp_060 <= 0;
end
	
assign outclk_060 = outclktemp_060;

endmodule
