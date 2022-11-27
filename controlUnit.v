module controlUnit (Rwe, Rsw, ALUinB, DMwe, Rwd, J, JAL, BEX, BNE, BLT, JR, SETX, judge_R, judge_addi, opcode);

	input [4:0] opcode;
	output Rwe, Rsw, ALUinB, DMwe, Rwd, J, JAL, BEX, BNE, BLT, JR, SETX, judge_R, judge_addi;
	
	wire judge_addi, judge_sw, judge_lw, judge_R;
	wire judge_j, judge_bne, judge_jal, judge_jr, judge_blt, judge_bex, judge_setx;
	
	//R type
	and is_R (judge_R, ~opcode[4], ~opcode[3], ~opcode[2], ~opcode[1], ~opcode[0]);//R:00000
	
	//I type
	and is_addi (judge_addi, ~opcode[4], ~opcode[3], opcode[2], ~opcode[1], opcode[0]);//addi:00101
	and is_sw (judge_sw, ~opcode[4], ~opcode[3], opcode[2], opcode[1], opcode[0]);//sw:00111
	and is_lw (judge_lw, ~opcode[4], opcode[3], ~opcode[2], ~opcode[1], ~opcode[0]);//lw:01000
	
	//J type
	and is_j (judge_j, ~opcode[4], ~opcode[3], ~opcode[2], ~opcode[1], opcode[0]);//j:00001
	and is_bne (judge_bne, ~opcode[4], ~opcode[3], ~opcode[2], opcode[1], ~opcode[0]);//bne:00010
	and is_jal (judge_jal, ~opcode[4], ~opcode[3], ~opcode[2], opcode[1], opcode[0]);//jal:00011
	and is_jr (judge_jr, ~opcode[4], ~opcode[3], opcode[2], ~opcode[1], ~opcode[0]);//jr:00100
	and is_blt (judge_blt, ~opcode[4], ~opcode[3], opcode[2], opcode[1], ~opcode[0]);//blt:00110
	and is_bex (judge_bex, opcode[4], ~opcode[3], opcode[2], opcode[1], ~opcode[0]);//bex:10110
	and is_setx (judge_setx, opcode[4], ~opcode[3], opcode[2], ~opcode[1], opcode[0]);//bex:10101
	
	
	assign DMwe = judge_sw;
	assign Rwe = judge_R || judge_addi || judge_lw ||judge_setx || judge_jal;
	assign Rwd = judge_lw;
	assign Rsw = judge_sw||judge_jr||judge_bne||judge_blt;// read from rd if sw
	assign ALUinB = judge_addi || judge_lw || judge_sw;
  	//assign ALUop = 0;//Not sure how to write this one
	assign J = judge_j;
	assign JAL = judge_jal;
	assign BEX = judge_bex;
	assign BNE = judge_bne;
	assign BLT = judge_blt;
	assign JR = judge_jr;
	assign SETX = judge_setx;
endmodule