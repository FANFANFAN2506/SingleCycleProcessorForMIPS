module reg32(q, d, clk, en, clr);
	parameter n = 32;
	input [n-1:0] d;
	input clk, en, clr;
	output [n-1:0] q;
	
	genvar i;
	generate
		for(i=0;i<n;i=i+1)
		begin:dffe
			dffe_ref dffe(q[i],d[i],clk,en,clr);
		end
	endgenerate
	
	
endmodule

	