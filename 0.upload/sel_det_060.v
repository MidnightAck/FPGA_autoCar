module sel_det_060( 
	input		 	  I_clk_div_060 , 
    input      [3:0]  I_num1_060    , 
    input      [3:0]  I_num2_060    , 
    input      [3:0]  I_num3_060    , 
    input      [3:0]  I_num4_060    , 
    input      [3:0]  I_num5_060    , 
    input      [3:0]  I_num6_060    , 
    input      [3:0]  I_num7_060    , 
    input      [3:0]  I_num8_060    ,     
    
    output     [7:0]  O_seg_060       ,
	output    [7:0]  O_sel_060   
	);
reg [7:0] sel_060 = 8'b0000_0001  ;       
reg [3:0] num_temp_060;
	
always@(posedge I_clk_div_060 ) 
		sel_060 <= { sel_060[ 6 : 0 ] , sel_060[ 7 ] };	
 
assign O_sel_060 =  ~sel_060 ;
    
always@(*)
	case( sel_060 )
		1<<0 :  num_temp_060 = I_num1_060;   
		1<<1 :  num_temp_060 = I_num2_060;	
		1<<2 :	num_temp_060 = I_num3_060;	
		1<<3 :  num_temp_060 = I_num4_060;	
		1<<4 :  num_temp_060 = I_num5_060;	
		1<<5 :  num_temp_060 = I_num6_060;	
		1<<6 :  num_temp_060 = I_num7_060;	
		1<<7 :  num_temp_060 = I_num8_060;	        
    default :   num_temp_060 = num_temp_060;	
	endcase       

//wire [7:0]  seg_temp  ;
    
seg_num_060
seg_num
(    
	.num_060(  num_temp_060 ) , 
	.seg_060(  O_seg_060 )   
);    
        
	
endmodule
