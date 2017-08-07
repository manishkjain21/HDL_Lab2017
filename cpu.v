
module cpu(clk, reset, addr_tb, mem_en, mem_read, mem_write, dout, din);

output reg [11:0]addr_tb;
output reg [15:0]dout;
output wire mem_en, mem_read, mem_write;
wire [15:0]addr;
input clk, reset;
input [15:0]din;
wire [15:0] new_pc, instruction;

//4096*2B=8192B
parameter MEM_DEPTH = 2**12;
parameter ADDR_WIDTH = $clog2(MEM_DEPTH);
parameter [1:0] INCREMENT_BY = 2'b10;

wire [15:0] pc_out;
//wire [ADDR_WIDTH-1:0] addr;

mux21 m1 (.in0(pc_out), 
	  .in1(16'b0),   //pc_from_execute
	  .select(1'b0),    //memory_stage_pc_sel
	  .out(new_pc));

pc p1 (.pc_in(new_pc), 
       .reset(reset), 
       .pc_out(pc_out));

/*
memory mem1 (.clk(clk),
	     .en(mem_enable),
	     .rd_en(mem_read),
	     .wr_en(mem_write),
	     .addr(addr),
	     .din(1'b0),    //Reg_data2
	     .dout(instruction));
*/
pc_increment pc_inc1(.pc_current (pc_out),
	      .stall(1'b0),
	      .increment_by(INCREMENT_BY),
	      .pc_next(new_pc));

decode d1(
.data(dout), 
.reg1(reg1), 
.reg2(reg2), 
.offset(offset), 
.opcode(opcode)
);

control_block ctrl1(
.clk(clk),
.rst(reset), 
.opcode(opcode), 
.mem_reg(mem_reg), 
.reg_write(reg_write), 
.branch(branch), 
.mem_read(mem_read), 
.mem_write(mem_write), 
.mem_enable(mem_en), 
.ALU_op(ALU_op), 
.ALU_src(ALU_src), 
.reg_dst(reg_dst),
.Intr_fetch(Intr_fetch)
);

register_file rf1(
.clock(clk),
.rst(reset),
.WE(reg_write),
.InData(Reg_out),
.WrReg(wr_reg),
.ReadA(reg1),
.ReadB(reg2),
.OutA(Reg_data1),
.OutB(Reg_data2)
);

sign_extend sg1(
.clk(clk), 
.offset(offset), 
.signed_value(signed_value)
);

alu a1(
.opcode(ALU_op), 
.inA(Reg_Data1), 
.inB(ALU_mux),
.in_apsr(apsr_o), 
.out(ALU_out), 
.out_apsr(apsr_i)
);

mux21 m2(
.in0(Reg_data2), 
.in1(signed_value), 
.select(ALU_src), 
.out(ALU_mux)
);

//Mux for MemReg selection
mux21 m3(
.in0(demux_reg), 
.in1(ALU_out), 
.select(mem_reg), 
.out(Reg_out)
);

mux21_4bit m6(
.inA(reg1), 
.inB(4'b0), 		//Value of reg3 from Decode
.sel(reg_dst), 
.out(wr_reg)

);

mux21 m5(
.in0(ALU_out), 
.in1(pc_out), 		//Value of reg3 from Decode
.select(Intr_fetch), 
.out(addr)
);

demux12 m4(
.in(din), 
.sel(Intr_fetch), 
.outA(demux_reg), 
.outB(instr_out)
);

apsr ap1(
.clk(clk),
.in(apsr_i),
.out(apsr_o)
);

always@(posedge clk)
 addr_tb <= addr;

endmodule

