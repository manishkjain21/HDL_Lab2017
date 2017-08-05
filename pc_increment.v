/**
Program Counter Incrementer
*/

module pc_incrementer(pc_current, stall, increment_by, pc_next);
input [15:0] pc_current;
input [1:0] increment_by;
input stall;
output [15:0] pc_next;

wire [15:0] pc_next;

assign pc_next = stall ? pc_current : (pc_current + increment_by);

endmodule

