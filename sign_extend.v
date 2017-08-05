
module sign_extend(clk, offset, signed_value);

input clk;
input [11:0]offset;

output reg [15:0]signed_value; 

always@(posedge clk) begin
	signed_value = {offset[11], offset[11], offset[11], offset[11], offset[11:0]};
	
end

endmodule
