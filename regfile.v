module regfile (
    clock,
    ctrl_writeEnable,
    ctrl_reset, ctrl_writeReg,
    ctrl_readRegA, ctrl_readRegB, data_writeReg,
    data_readRegA, data_readRegB
);

   input clock, ctrl_writeEnable, ctrl_reset;
   input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
   input [31:0] data_writeReg;

   output [31:0] data_readRegA, data_readRegB;

   /* YOUR CODE HERE */
	//Instantiate 32 reg32
	wire [31:0] q[31:0];
	wire en[31:0];
		//the reset of Reg 0 is always 1, make it always output 0
	reg32 reg0(q[0],data_writeReg,clock,0,1); //enable is 0, clr is 1
		//write port
	wire [31:0] en_out;
	dec5to32 write_port(ctrl_writeEnable,ctrl_writeReg,en_out);
		//connect en_out to 1-31 regs
	genvar i;
	generate
		for(i=1;i<32;i=i+1)
		begin:reg32
		reg32 regs(q[i],data_writeReg,clock,en_out[i],ctrl_reset);
		end
	endgenerate
	
	//read_portA
	wire [31:0] selectA;
	dec5to32 decdA(1,ctrl_readRegA,selectA);
	
	//generate tri-state buffers
	genvar k;
	generate
		for(k=0;k<32;k=k+1)
		begin:bufferA
		assign data_readRegA = selectA[k]?q[k]:32'bz;
		end
	endgenerate
	
	
	
	
	//read_portA
	wire [31:0] selectB;
	dec5to32 decd(1,ctrl_readRegB,selectB);
	
	//generate tri-state buffers
	genvar j;
	generate
		for(j=0;j<32;j=j+1)
		begin:bufferB
		assign data_readRegB = selectB[j]?q[j]:32'bz;
		end
	endgenerate
	
	
	
endmodule
