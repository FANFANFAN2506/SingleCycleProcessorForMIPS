# Checkpoint5_PC5_submit
This is the ECE550D checkpoint5 accomplished by **__Xincheng Zhong (NetID:xz353)__**, and **__Shiyang Pan (NetID:sp645)__**, and **__Fan Yang (NetID:fy62)__**
***
This checkpoint is to design a full processor which supports the MIPS32 instructions (add, sub, addi, and, or, sra, sll, sw, lw, j, bne, jal, jr, blt, bex, setx).
Other than the v files we included in the pc4, there is no additional module seperate out, all the additional datapath and necessary components are acomplished in the processor.v

We added another alu unit, for the branch instruction, to find the next PC which is PC+1+N.
There are several muxes are added for the selection of next PC, between PC+1, PC+1+N, and tag.

The tag is a 27-bit immediate obtained from the instruction opcode, and do the bit-extension by adding 0(unsigned) to the front to maintain a 32-bit address. 

Most of the functionalities are achieved by the muxes and different logical combination of the control signal, which will only introduce small space increase to implement the instructions. However, the abstraction, and the readability may be tradeoff.
