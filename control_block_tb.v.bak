`timescale 10ns/1ns

module control_block_tb();

reg clk;

reg [3:0]opcode;
wire mem_reg, reg_write, branch, mem_read, mem_write, mem_enable, ALU_src, reg_dst;
wire [3:0]ALU_op;

control_block cbk1(.clk(), 
				  .opcode(opcode), 
				  .mem_reg(mem_reg), 
              .reg_write(reg_write), 
				  .branch(branch), 
				  .mem_read(mem_read), 
              .mem_write(mem_write), 
              .mem_enable(mem_enable), 
              .ALU_op(ALU_op), 
              .ALU_src(ALU_src), 
              .reg_dst(reg_dst)

);


initial begin
clk = 0;
opcode = 2;
end

always@(*)
	#5 clk <= !clk ;

always@(posedge clk) begin
	$monitor("%h %d %d %d %d %d %d %d %d %d", opcode, mem_reg, reg_write, branch, mem_read, mem_write, mem_enable, ALU_op, ALU_src, reg_dst);
	
	opcode = 0;
	#10;
	opcode = 2;
	#10;
	opcode = 0;
	#10;
	opcode = 2;
	#10;

end


endmodule
