/**
* Stack module that gets called whenever push/pop operations are being executed.
*/
module stack(clk, reset, din, sp, dout);
input clk, reset;
input [15:0] din;
input [2:0] sp; //Stack pointer
output reg [15:0] dout;

reg [15:0] stack_mem[15:0];
integer i;

always @ (clk) begin
	if(reset) begin
	    dout = 16'h0000;
	    for (i = 0; i < 16; i = i +1) begin
  	  	stack_mem[i] = 16'h0000;
     	    end
	    /*stack_mem[0] = 16'h0000;
	    stack_mem[1] = 16'h0000;
	    stack_mem[2] = 16'h0000;
	    stack_mem[3] = 16'h0000;
	    stack_mem[4] = 16'h0000;
	    stack_mem[5] = 16'h0000;
	    stack_mem[6] = 16'h0000;
	    stack_mem[7] = 16'h0000;
	    stack_mem[8] = 16'h0000;
	    stack_mem[9] = 16'h0000;
	    stack_mem[10] = 16'h0000;
	    stack_mem[11] = 16'h0000;
	    stack_mem[12] = 16'h0000;
	    stack_mem[13] = 16'h0000;
	    stack_mem[14] = 16'h0000;
	    stack_mem[15] = 16'h0000;*/

	end
	else begin
		if(clk) begin
			stack_mem[sp] = din; //write the data to stack 
		end
	
		else if(~clk) begin
			dout = stack_mem[sp]; //read the data from stack
		end
	end
end
endmodule 