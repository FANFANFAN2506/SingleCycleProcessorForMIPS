module dec4to16(enable4to16,In_4,Out_16);
	input enable4to16;
	input [3:0] In_4;
	output [15:0] Out_16;
	wire [3:0] z;
		
	dec2to4 dec24_1(enable4to16,In_4[3:2],z[3:0]);
	dec2to4 dec24_2(z[3],In_4[1:0],Out_16[15:12]);
	dec2to4 dec24_3(z[2],In_4[1:0],Out_16[11:8]);
	dec2to4 dec24_4(z[1],In_4[1:0],Out_16[7:4]);
	dec2to4 dec24_5(z[0],In_4[1:0],Out_16[3:0]);
endmodule
