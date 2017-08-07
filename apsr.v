//APSR Register

module apsr(clk,in,out);

input clk;
input [15:0] in;
output reg [15:0] out;

always @(posedge clk) begin
	out <= in; 
	end

endmodule
