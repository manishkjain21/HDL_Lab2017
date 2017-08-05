/**
Program Counter Register
*/

module pc (pc_in, reset, pc_out);

input [15:0] pc_in;
input reset;
output reg [15:0] pc_out;

always @ (pc_in) begin

if (reset) begin
    pc_out <= 0;
end

else begin
    pc_out <= pc_in;
end

end

endmodule 
