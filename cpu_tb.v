`timescale 1 ns / 1 ps

module cpu_tb();

wire [11:0]addr_tb;
wire [15:0]dout, din_1;
wire mem_en, mem_read, mem_write;
reg clk, reset;
reg [15:0]din;

cpu cp1(.clk(clk), 
.reset(reset), 
.addr_tb(addr_tb), 
.mem_en(mem_en), 
.mem_read(mem_read), 
.mem_write(mem_write), 
.dout(dout), 
.din(din));

memory mem1 (.clk(clk),
	     .en(mem_en),
	     .rd_en(mem_read),
	     .wr_en(mem_write),
	     .addr(addr_tb),
	     .din(dout),    //Reg_data2
	     .dout(din_1));

initial begin 
	$display("\t time, \t clk, \t reset, \t din, \t addr_tb, \t mem_en, \t mem_read, \t mem_write");
	$monitor("%d, \t%b, \t%b, \t%h, \t%h, \t%b, \t%b, \t%b",
         $time, clk, reset, din, addr_tb, mem_en, mem_read, mem_write);	
	clk = 1; 
	reset = 1; 
	din = 16'h0000;
	#1 reset = 0;
	#1 din = 16'hb081;
	#2 din = 16'haf00;
	#2 din = 16'h1c3a;
	#2 din = 16'h2300;
	#6 $finish;
	end  

always begin
	#1 clk =!clk ;
	end


endmodule
