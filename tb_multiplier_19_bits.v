module tb_multiplier_19_bits(
	);
	
	reg [18:0] A ;
	reg [18:0] B ;
	wire [37:0] mul ;
	
	integer i;
	
	initial
	begin
		for(i=1;i<37 ;i=i+1)
		begin
			#10 A=2**i-1;
			B=2**(i-1)-1 ;
		end
 	end
	
	multiplier_19_bits dut_dadda (A,B,mul);
	
endmodule