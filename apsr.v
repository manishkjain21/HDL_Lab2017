//APSR Register

module apsr(rst, clk, in, out);

input clk, rst;
input [15:0] in;
output reg [15:0] out;


always @(posedge clk) begin
	if(rst) out <= 16'h0;
	else out <= in; 
	end

endmodule
