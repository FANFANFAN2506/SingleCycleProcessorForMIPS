/**
 * READ THIS DESCRIPTION!
 *
 * The processor takes in several inputs from a skeleton file.
 *
 * Inputs
 * clock: this is the clock for your processor at 50 MHz
 * reset: we should be able to assert a reset to start your pc from 0 (sync or
 * async is fine)
 *
 * Imem: input data from imem
 * Dmem: input data from dmem
 * Regfile: input data from regfile
 *
 * Outputs
 * Imem: output control signals to interface with imem
 * Dmem: output control signals and data to interface with dmem
 * Regfile: output control signals and data to interface with regfile
 *
 * Notes
 *
 * Ultimately, your processor will be tested by subsituting a master skeleton, imem, dmem, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file acts as a small wrapper around your processor for this purpose.
 *
 * You will need to figure out how to instantiate two memory elements, called
 * "syncram," in Quartus: one for imem and one for dmem. Each should take in a
 * 12-bit address and allow for storing a 32-bit value at each address. Each
 * should have a single clock.
 *
 * Each memory element should have a corresponding .mif file that initializes
 * the memory element to certain value on start up. These should be named
 * imem.mif and dmem.mif respectively.
 *
 * Importantly, these .mif files should be placed at the top level, i.e. there
 * should be an imem.mif and a dmem.mif at the same level as process.v. You
 * should figure out how to point your generated imem.v and dmem.v files at
 * these MIF files.
 *
 * imem
 * Inputs:  12-bit address, 1-bit clock enable, and a clock
 * Outputs: 32-bit instruction
 *
 * dmem
 * Inputs:  12-bit address, 1-bit clock, 32-bit data, 1-bit write enable
 * Outputs: 32-bit data at the given address
 *
 */
module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for regfile
    ctrl_writeReg,                  // O: Register to write to in regfile
    ctrl_readRegA,                  // O: Register to read from port A of regfile
    ctrl_readRegB,                  // O: Register to read from port B of regfile
    data_writeReg,                  // O: Data to write to for regfile
    data_readRegA,                  // I: Data from port A of regfile
    data_readRegB                  // I: Data from port B of regfile
);
    // Control signals
    input clock, reset;

    // Imem
    output [11:0] address_imem;
    input [31:0] q_imem;

    // Dmem
    output [11:0] address_dmem;
    output [31:0] data;
    output wren;
    input [31:0] q_dmem;

    // Regfile
    output ctrl_writeEnable;
    output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
    output [31:0] data_writeReg;
    input [31:0] data_readRegA, data_readRegB;
    /* YOUR CODE STARTS HERE */
	 //*****************************declaration**************************************************
	 //instruction field
	 wire [4:0] opcode;
	 wire [4:0] rd,rs,rt;
	 wire [4:0] shamt;
	 wire [4:0] ALUop;
	 wire [1:0] zeroes;
	 wire [16:0] immediate;
	 //control
	 wire Rwe, Rsw, ALUinB, DMwe, Rwd, JP, J, JAL, BEX, BNE, BLT, JR, SETX;
	 wire is_addi, is_R;
	 //regfile_part
	 wire [4:0] ctrl_rd_rt;
	 wire [31:0] data_dmem_alu;
	 //regfile_rstatus
	 wire [31:0] rstatus_out;
	 wire write_30;
	 //main_alu_part
	 wire [31:0] data_A, data_B_rtype, data_B, alu_result;
	 wire [4:0] ALUopin;
	 wire isNotEqual, isLessThan, overflow;
	 wire [31:0] sign_extended;
	 //branch
	 wire [31:0] branch_imme, branch_pc, branch_pc_select,JP_pc_select;
	 wire branch_ctrl, neq_ctrl, lt_ctrl;
	 //J
	 wire [4:0] ctrl_writeReg_or_rstatus;
	 wire [31:0]tag;
	 wire bex_ctrl;
	 //PC
	 wire [31:0] pc,pc_plus4;
	 //****************************Control_signal*********************************************
	 controlUnit control(Rwe, Rsw, ALUinB, DMwe, Rwd, J, JAL, BEX, BNE, BLT, JR, SETX, is_R, is_addi, opcode);
	 alu_control alu_opcode_control(opcode,ALUop,ALUopin);
	 //*****************************DATAPATH****************************************************
	 //instruction field
	 assign {opcode,rd,rs,rt,shamt,ALUop,zeroes} = q_imem;
	 assign immediate = q_imem[16:0];
	 //regfile_part
	 assign ctrl_readRegA = BEX ? 5'b11110 : rs;
	 assign ctrl_readRegB = Rsw?rd:rt;
	 wire w30_or_setx;
	 or OR_w30_or_setx(w30_or_setx,write_30,SETX);
	 assign ctrl_writeReg_or_rstatus = w30_or_setx?5'b11110:rd;//rstatus
	 assign ctrl_writeReg = JAL?5'b11111:ctrl_writeReg_or_rstatus;
	 assign ctrl_writeEnable = Rwe;
	 assign data_dmem_alu = Rwd?q_dmem:alu_result;
	 wire [31:0] data_writeReg_or_rstatus;
	 wire [31:0] data_writeReg_other_than_setx;
	 assign data_writeReg_or_rstatus = write_30?rstatus_out:data_dmem_alu;
	 assign data_writeReg_other_than_setx = JAL?pc_plus4:data_writeReg_or_rstatus;
	 assign data_writeReg = SETX?tag:data_writeReg_other_than_setx;
	 ////regfile_rstatus
	 rstatus r_status(is_addi,is_R,ALUopin,overflow,rd,rstatus_out,write_30);
	 //main_alu_part
	 alu ALU_main(data_A,data_B,ALUopin,shamt,alu_result,isNotEqual, isLessThan, overflow);
	 assign sign_extended = {{16{immediate[16]}},immediate[15:0]};
	 assign data_A = data_readRegA;
	 assign data_B_rtype = ALUinB?sign_extended:data_readRegB;
	 assign data_B = BEX ? 32'b0 : data_B_rtype;
	 //dmem_part
	 assign data = data_readRegB;
	 assign address_dmem = alu_result[11:0];
	 assign wren = DMwe;
	 //PC
	 wire [31:0] JR_pc_select;
	 reg32 PC_reg(pc,JR_pc_select,clock,1,reset);
	 alu ALU_pc_plus4(.data_operandA(1), //word-addressed 
							.data_operandB(pc),
							.ctrl_ALUopcode(0),
							.ctrl_shiftamt(0),
							.data_result(pc_plus4),
							.isNotEqual(), 
							.isLessThan(), 
							.overflow());

	 //imem_part
	 assign address_imem = pc[11:0];

	// Branch (bne, blt)
	assign branch_imme = sign_extended;
	alu ALU_pc_branch(.data_operandA(pc_plus4), //word-addressed 
							.data_operandB(branch_imme),
							.ctrl_ALUopcode(0),
							.ctrl_shiftamt(0),
							.data_result(branch_pc),
							.isNotEqual(), 
							.isLessThan(), 
							.overflow());
	and a1(neq_ctrl, BNE, isNotEqual);
	and a2(lt_ctrl, BLT, ~isLessThan,isNotEqual);
	or o1(branch_ctrl, neq_ctrl, lt_ctrl);
    assign branch_pc_select = branch_ctrl ? branch_pc : pc_plus4;
	 
	 //JI
	assign tag = {{5{1'b0}}, q_imem[26:0]};
	and bex_c(bex_ctrl, BEX, isNotEqual);
	or J_ctrl(JP, bex_ctrl, J, JAL);
	assign JP_pc_select = JP ? tag : branch_pc_select;

	//JII (jr)
	assign JR_pc_select = JR?alu_result:JP_pc_select;



endmodule
