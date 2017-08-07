// Integrated Electronic Systems Lab
// TU Darmstadt
// Author:	Dipl.-Ing. Boris Traskov
// Modified by M.Sc. Haoyuan Ying Dual 8-bit Memory Port -> Single 16-bit
// Email: 	boris.traskov@ies.tu-darmstadt.de

`timescale 1 ns / 1 ps

module fetch_tb();

// PARAMETERS
parameter MEM_DEPTH   		= 2**12;	//8192 Bytes 4096*2B
parameter ADDR_WIDTH   		= $clog2(MEM_DEPTH);
parameter string filename	= "sources/software/count32.bin";

// INTERNAL SIGNALS
integer file, status; // needed for file-io
logic			clk;
logic			rst;
logic			en;
logic			rd_en;
logic  	wr_en;
logic [15:0]	data_cpu2mem;
logic [15:0]	data_mem2cpu;
logic [ADDR_WIDTH-1:0] addr;
logic [15:0] pc_from_execute;

wire [15:0] new_pc, instruction;


assign en	= 1'b1;
assign rd_en	= 1'b1;
assign wr_en	= 1'b0;

// CPU INSTANTIATION
//cpu  
//cpu_i (
//    .clk 	(clk),
//    .rst 	(rst),
//    .addr	(addr)
	// add more signals here
//);

// MODULE INSTANTIATION
memory #(
	.MEM_DEPTH (MEM_DEPTH)) 
memory_i (
    .clk 	(clk),
    .addr	(addr),
    .en  	(en),
    .rd_en  (rd_en),
    .wr_en  (wr_en),
    .din (data_cpu2mem),
    .dout(data_mem2cpu)); 

fetch fetch_i ( .reset(rst), .clk(clk), 
                .memory_stage_pc_sel(memory_stage_pc_sel), .pc_from_execute(pc_from_execute), .new_pc(new_pc), .instruction(instruction) );
  
//CLOCK GENERATOR
initial begin
	clk = 1'b0;
	pc_from_execute=0;
	forever #1  clk = !clk;
end

//RESET GENERATOR  
initial begin
	rst		= 1'b0;
	file		= $fopen(filename, "r");
	#3 rst		= 1'b1;     // 3   ns
	status		= $fread(memory_i.ram, file);
	#2.1 rst	= 1'b0;  //2.1 ns
	$finish;
end

always begin
	#2 pc_from_execute= pc_from_execute + 1; 
	$monitor("%d,\t%b,\t%h,\t%h,\t%h, \t%d",$time, clk, pc_from_execute, new_pc, instruction);
end

endmodule