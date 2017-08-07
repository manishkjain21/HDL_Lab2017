
module control_block(clk, rst, opcode, mem_reg, reg_write, branch, mem_read, mem_write, mem_enable, ALU_op, ALU_src, reg_dst, Intr_fetch);


input [3:0] opcode;
input clk, rst;

output reg [3:0]ALU_op;
output reg mem_reg, reg_write;  //Select the appropriate Memory for Register Selection and Address Selection
output reg branch, mem_read, mem_write, mem_enable; // 
output reg ALU_src, reg_dst, Intr_fetch;

localparam  push=0,    pop=1,    sub_sp=2,      cmp=3,       movs=4,      mov=5,   ldr=6,   str=7, 
            ldr_nop=8, add_sp=9, branch_nc= 10, adds_3op=11, branch_c=12, strb=13, ldrb=14, adds_2op=15;

always @(posedge clk) begin
	if(rst) begin
       //Set the Control Block
					mem_reg    = 0;   // Take Data from the ALU
					reg_write  = 0;   // Write to Register
					branch     = 0;   //
					mem_read   = 1;   //
					mem_write  = 0;   //
					mem_enable = 1;
					ALU_op     = opcode;
					ALU_src    = 0;   // For Reg_data_2
					reg_dst    = 0;   // Register_Destination	- To mux for selection of Destination Register  
               Intr_fetch = 1;
   end
	else begin
		case(opcode)
		push: begin
					//Set the Control Block
					mem_reg    = 1;   // Take Data from the ALU
					reg_write  = 1;   // Write to Register
					branch     = 0;   //
					mem_read   = 0;   //
					mem_write  = 1;   //
					mem_enable = 1;
					ALU_op     = opcode;
					ALU_src    = 0;   // For Reg_data_2
					reg_dst    = 0;   // Register_Destination
		      end
      add_sp: begin
				   //Set the Control Block
					mem_reg    = 1;   // Take Data from the ALU
					reg_write  = 1;   // Write to Register
					branch     = 0;   //
					mem_read   = 0;   //
					mem_write  = 0;   //
					mem_enable = 0;
					ALU_op     = opcode;
					ALU_src    = 1;   // For Reg_data_2
					reg_dst    = 0;   // Register_Destination	- To mux for selection of Destination Register 
				   Intr_fetch = 1;
				  end 
	   default: begin
		//Set the Control Block
					mem_reg    = 0;   // Take Data from the ALU
					reg_write  = 0;   // Write to Register
					branch     = 0;   //
					mem_read   = 0;   //
					mem_write  = 0;   //
					mem_enable = 0;
					ALU_op     = 0;
					ALU_src    = 0;   // For Reg_data_2
					reg_dst    = 0;   // Register_Destination
		end

	   endcase
   end
end 



endmodule

