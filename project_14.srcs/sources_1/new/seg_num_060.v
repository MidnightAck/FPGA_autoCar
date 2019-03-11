module seg_num_060(    
	input      [3:0]  num_060, 
	output reg [7:0]  seg_060  
	);
    
always@(*)
	case(num_060)
		0:   seg_060 = 8'hC0;   	
		1:   seg_060 = 8'hF9;		
		2:	 seg_060 = 8'hA4;		
		3:   seg_060 = 8'hB0;		
		4:   seg_060 = 8'h99;		
		5:   seg_060 = 8'h92;		
		6:   seg_060 = 8'h82;		
		7:   seg_060 = 8'hF8;		
		8:   seg_060 = 8'h80;		
		9:   seg_060 = 8'h90;		
        10:  seg_060 = 8'h88;		
		11:  seg_060 = 8'h83;		
		12:  seg_060 = 8'hC6;		
		13:  seg_060 = 8'hA1;		
		14:  seg_060 = 8'h86;		
		15:  seg_060 = 8'h8E;		
		default:seg_060 = 8'hFF;   
	endcase
	
endmodule
