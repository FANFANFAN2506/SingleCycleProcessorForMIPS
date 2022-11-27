module alu_control(opcode,alu_opcode_in,alu_opcode_out);
	input [4:0] opcode,alu_opcode_in;
	output [4:0] alu_opcode_out;
	wire judge;
	
	or or_judge(judge,opcode[0],opcode[1],opcode[2],opcode[3],opcode[4]);
	
	assign alu_opcode_out = judge? 5'b00000:alu_opcode_in;
	
endmodule
	
	