module demux12(in, sel,outA, outB);
input in,sel;
output wire outA, outB;

assign outA= in & (~sel);
assign outB= in & sel;

endmodule
