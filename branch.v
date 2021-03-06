module branch(clk, reset, pc, Imm_val, branch, branch_con, pc_branch);

input [15:0]pc, Imm_val;
input branch, reset, branch_con, clk;

output reg [15:0]pc_branch;

always@(posedge clk, reset) begin
	if(reset)
		pc_branch = 16'h0000;
	else begin
		if(branch)begin
			if(branch_con)
				pc_branch = pc;
			else 
				pc_branch = pc + 2 + Imm_val;
			$display("inside Branch %d %d %d", pc, Imm_val, pc_branch);
		end
		else
			pc_branch = pc;
	end
end

endmodule
