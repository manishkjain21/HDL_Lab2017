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
	clk = 1; 
	reset = 1; 
	din = 16'h2b1f;
	#5 reset = 0;
   	#20 $finish;
	end  

always begin
	#1 clk =!clk ;
	end

initial begin
	$display("\t time, \t clk, \t reset, \t din, \t addr_tb, \t mem_en, \t mem_read, \t mem_write");
	$monitor("%d, \t%b, \t%b, \t%h, \t%h, \t%b, \t%b, \t%b",
         $time, clk, reset, din, addr_tb, mem_en, mem_read, mem_write);
	end

endmodule
