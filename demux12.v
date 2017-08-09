module demux12(in, sel, outA, outB);
input [15:0]in;
input sel;
output reg [15:0] outA, outB;

always begin
	if(sel)
		outB <= in; 
   else 
      		outA <= in;
	end
endmodule
