module rstatus(is_addi, is_R, ALUop, overflow, rd,rstatus_out,write_30);
 input is_addi, is_R, overflow;
 input [4:0] ALUop,rd;
 output [31:0] rstatus_out;
 output write_30;
 
 wire addoverflow,suboverflow,addioverflow;
 wire [31:0] subaddioverflow,addioverflowout;
 wire rd_0;
 
 or or0(rd_0,rd[4],rd[3],rd[2],rd[1],rd[0]);//rd_0 is 0 if rd=00000
 and and1(addoverflow, is_R,~ALUop[4],~ALUop[3],~ALUop[2],~ALUop[1],~ALUop[0],overflow,rd_0);
 and and2(suboverflow, is_R,~ALUop[4],~ALUop[3],~ALUop[2],~ALUop[1],ALUop[0],overflow,rd_0);
 and and3(addioverflow, is_addi,overflow,rd_0);
 
 assign addioverflowout = addioverflow?2:0;
 assign subaddioverflow = suboverflow?3:addioverflowout;
 assign rstatus_out = addoverflow?1:subaddioverflow;
 
 or or1(write_30,addoverflow,suboverflow,addioverflow);
 
endmodule
 