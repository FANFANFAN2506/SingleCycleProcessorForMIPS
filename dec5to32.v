module dec5to32(En, In_5, Out_32);
	input En;
	input [4:0] In_5;
	output [31:0] Out_32;
	
	wire [1:0] ctrl_z;
	
	and and5to32_1(ctrl_z[0],En,~In_5[4]);
	and and5to32_2(ctrl_z[1],En,In_5[4]);
	dec4to16 dec4to16_2(ctrl_z[1],In_5[3:0],Out_32[31:16]); //ms16
	dec4to16 dec4to16_3(ctrl_z[0],In_5[3:0],Out_32[15:0]); //ls16

endmodule
