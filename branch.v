module branch(reset, pc, Imm_val, branch, pc_branch);

input [15:0]pc, Imm_val;
input branch, reset;

output reg [15:0]pc_branch;

always@(*) begin
	if(reset)
		pc_branch = 16'h0000;
	else begin
		if(branch)
			pc_branch = pc + Imm_val;
		else
			pc_branch = pc;
	end
end

endmodule
