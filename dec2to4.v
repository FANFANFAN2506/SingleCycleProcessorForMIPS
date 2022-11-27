module dec2to4(enable2to4,In_2, Out_4);
	input enable2to4;
	input [1:0] In_2;
	output [3:0] Out_4;
		
	and and2to4_1(Out_4[0],enable2to4,~In_2[1],~In_2[0]);//00->0001
	and and2to4_2(Out_4[1],enable2to4,~In_2[1],In_2[0]); //01->0010
	and and2to4_3(Out_4[2],enable2to4,In_2[1],~In_2[0]);//10->0100
	and and2to4_4(Out_4[3],enable2to4,In_2[1],In_2[0]);//11->1000
endmodule
