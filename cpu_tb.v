`timescale 1ns/1ps

module cpu_tb();

wire [11:0]addr_tb;
wire [15:0]dout;
wire mem_en, mem_read, mem_write;
reg clk, reset;
reg [15:0]din;

cpu cp1(.clk(clk), 
.reset(reset), 
.addr_tb(.addr_tb), 
.mem_en(mem_en), 
.mem_read(mem_read), 
.mem_write(mem_write), 
.dout(dout), 
.din(din));

initial begin 
	clk = 0; 
	reset = 0; 
	#5 din = 16'hAF00;
   #20 $finish;
	end  

always begin
	#5 clk =!clk 
	end

always begin
	$monitor("%d, \t%b, \t%b, \t%h, \t%h, \t%h, \t%b, \t%b, \t%b",
           $time, clk, reset, din, addr_tb, dout, mem_en, mem_read, mem_write);
	end

endmodule
