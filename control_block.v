
module control_block(rst, opcode, mem_reg, reg_write, branch, mem_read, mem_write, mem_enable, ALU_op, ALU_src, reg_dst, Intr_fetch);


input [3:0] opcode;
input rst;

output reg [3:0]ALU_op;
output reg mem_reg, reg_write;  //Select the appropriate Memory for Register Selection and Address Selection
output reg branch, mem_read, mem_write, mem_enable; // 
output reg ALU_src, reg_dst, Intr_fetch;

localparam  push=0,    pop=1,    sub_sp=2,      cmp=3,       movs=4,      mov=5,   ldr=6,   str=7, 
            ldr_nop=8, add_sp=9, branch_nc= 10, adds_3op=11, branch_c=12, strb=13, ldrb=14, adds_2op=15;

always @(opcode,rst) begin
	
	if(rst) begin
			$display("Reset %d:", opcode);
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
               Intr_fetch = 1;	//intrs_out - 1 ; mem_data_out - 0
   end
	else begin
		case(opcode)
			push: begin
					$display("Push %d:", opcode);		
					//Set the Control Block
					mem_reg    = 1;   // Take Data from the ALU
					reg_write  = 1;   // Write to Register
					branch     = 0;   //
					mem_read   = 0;   //
					mem_write  = 1;   //
					mem_enable = 1;
					ALU_op     = opcode;
					ALU_src    = 0;   // For Reg_data_2
					reg_dst    = 1;   // Register_Destination -0 - reg2, 1-reg3 selected
					Intr_fetch = 1;   //intrs_out - 1 ; mem_data_out - 0
		   end
      	add_sp: begin
				   //Set the Control Block
					$display("Add :%d", opcode);
					mem_reg    = 1;   // Take Data from the ALU
					reg_write  = 1;   // Write to Register
					branch     = 0;   //
					mem_read   = 0;   //
					mem_write  = 0;   //
					mem_enable = 0;
					ALU_op     = opcode;
					ALU_src    = 1;   // For Immediate Value
					reg_dst    = 1;   // Register_Destination	- 0 - reg2, 1 - reg3 
				   Intr_fetch = 1;   //intrs_out - 1 ; mem_data_out - 0
			end 
	   	pop:begin
					//Set the Control Block
					mem_reg    = 1;   // Take Data from the ALU
					reg_write  = 1;   // Write to SP to Register-13
					branch     = 0;   //
					mem_read   = 1;   //
					mem_write  = 0;   //
					mem_enable = 1;
					ALU_op     = opcode;
					ALU_src    = 0;   // For Reg_data_2
					reg_dst    = 1;   // Register_Destination	- 0 - reg2, 1 - reg3  
				   Intr_fetch = 0;   //intrs_out - 1 ; mem_data_out - 0
			end
			sub_sp:begin
					//Set the Control Block
					mem_reg    = 1;   // Take Data from the ALU for writing
					reg_write  = 1;   // Write to SP to Register-13
					branch     = 0;   //
					mem_read   = 0;   //
					mem_write  = 0;   //
					mem_enable = 0;
					ALU_op     = opcode;
					ALU_src    = 1;   // For reg_dat2 - 0; Immediate Value - 1
					reg_dst    = 1;   // Register_Destination	- 0 - reg2, 1 - reg3  
				   Intr_fetch = 1;   //intrs_out - 1 ; mem_data_out - 0
			end
			cmp:begin
					//Set the Control Block
					mem_reg    = 1;   // Take Data from the ALU for writing
					reg_write  = 0;   // No write needed to memory
					branch     = 0;   // 
					mem_read   = 0;   //
					mem_write  = 0;   //
					mem_enable = 0;   // No mem enable required
					ALU_op     = opcode;
					ALU_src    = 1;   // For 0- Reg_data2 1- Immediate Value
					reg_dst    = 1;   // Register_Destination	- 0 - reg2, 1 - reg3  
				   Intr_fetch = 1;   //intrs_out - 1 ; mem_data_out - 0
			end	
			movs:begin
					//Set the Control Block
					mem_reg    = 1;   // Take Data from the ALU for writing
					reg_write  = 1;   // write needed to memory
					branch     = 0;   // 
					mem_read   = 1;   //
					mem_write  = 0;   //
					mem_enable = 1;   // No mem enable required
					ALU_op     = opcode;
					ALU_src    = 1;   // For 0- Reg_data2 1- Immediate Value
					reg_dst    = 1;   // Register_Destination	- 0 - reg2, 1 - reg3  
				   Intr_fetch = 1;   //intrs_out - 1 ; mem_data_out - 0
			end	

			branch_c:begin
					//Set the Control Block
					mem_reg    = 1;   // Take Data from the ALU for writing
					reg_write  = 1;   // write needed to register file
					branch     = 1;   // 
					mem_read   = 0;   //
					mem_write  = 0;   //
					mem_enable = 0;   // No mem enable required
					ALU_op     = opcode;
					ALU_src    = 1;   // For 0- Reg_data2 1- Immediate Value
					reg_dst    = 1;   // Register_Destination	- 0 - reg2, 1 - reg3  
				   Intr_fetch = 1;   //intrs_out - 1 ; mem_data_out - 0
			end

			mov:begin
					//Set the Control Block
					mem_reg    = 1;   // Take Data from the ALU for writing
					reg_write  = 1;   // write needed to register file
					branch     = 0;   // 
					mem_read   = 0;   //
					mem_write  = 0;   //
					mem_enable = 0;   // No mem enable required
					ALU_op     = opcode;
					ALU_src    = 0;   // For 0- Reg_data2 1- Immediate Value
					reg_dst    = 1;   // Register_Destination	- 0 - reg2, 1 - reg3  
				   Intr_fetch = 1;   //intrs_out - 1 ; mem_data_out - 0
			end	
	
			ldr:begin
					//Set the Control Block
					mem_reg    = 0;   // Take Data from the memory for writing
					reg_write  = 1;   // write needed to register file
					branch     = 0;   // No branching
					mem_read   = 1;   //
					mem_write  = 0;   //
					mem_enable = 1;   // No mem enable required
					ALU_op     = opcode;
					ALU_src    = 1;   // For 0- Reg_data2 1- Immediate Value
					reg_dst    = 1;   // Register_Destination	- 0 - reg2, 1 - reg3  
				   Intr_fetch = 1;   //intrs_out - 1 ; mem_data_out - 0
			end
			
			str:begin
					//Set the Control Block
					mem_reg    = 0;   // Take Data from the ALU for writing
					reg_write  = 0;   // write needed to register file
					branch     = 0;   // 
					mem_read   = 0;   //
					mem_write  = 1;   //
					mem_enable = 1;   // No mem enable required
					ALU_op     = opcode;
					ALU_src    = 0;   // For 0- Reg_data2 1- Immediate Value
					reg_dst    = 1;   // Register_Destination	- 0 - reg2, 1 - reg3  
				   Intr_fetch = 1;   //intrs_out - 1 ; mem_data_out - 0
			end
			
			branch_nc:begin
					//Set the Control Block
					mem_reg    = 1;   // Take Data from the ALU for writing
					reg_write  = 0;   // write needed to register file
					branch     = 1;   // Branching needed
					mem_read   = 1;   //
					mem_write  = 0;   //
					mem_enable = 1;   // No mem enable required
					ALU_op     = opcode;
					ALU_src    = 1;   // For 0- Reg_data2 1- Immediate Value
					reg_dst    = 1;   // Register_Destination	- 0 - reg2, 1 - reg3  
				   Intr_fetch = 1;   //intrs_out - 1 ; mem_data_out - 0
			end
			ldr_nop:begin
					//Set the Control Block
					mem_reg    = 1;   // Take Data from the ALU for writing
					reg_write  = 1;   // write needed to register file
					branch     = 0;   // 
					mem_read   = 0;   //
					mem_write  = 1;   //
					mem_enable = 1;   // No mem enable required
					ALU_op     = opcode;
					ALU_src    = 0;   // For 0- Reg_data2 1- Immediate Value
					reg_dst    = 1;   // Register_Destination	- 0 - reg2, 1 - reg3  
				   Intr_fetch = 1;   //intrs_out - 1 ; mem_data_out - 0
			end
			adds_3op:begin
					//Set the Control Block
					mem_reg    = 1;   // Take Data from the ALU for writing
					reg_write  = 1;   // write needed to register file
					branch     = 0;   // 
					mem_read   = 0;   //
					mem_write  = 0;   //
					mem_enable = 0;   // No mem enable required
					ALU_op     = opcode;
					ALU_src    = 1;   // For 0- Reg_data2 1- Immediate Value
					reg_dst    = 1;   // Register_Destination	- 0 - reg2, 1 - reg3  
				   Intr_fetch = 1;   //intrs_out - 1 ; mem_data_out - 0
			end
			strb:begin
					//Set the Control Block
					mem_reg    = 1;   // Take Data from the ALU for writing
					reg_write  = 1;   // write needed to register file
					branch     = 0;   // 
					mem_read   = 0;   //
					mem_write  = 1;   //
					mem_enable = 1;   // No mem enable required
					ALU_op     = opcode;
					ALU_src    = 0;   // For 0- Reg_data2 1- Immediate Value
					reg_dst    = 1;   // Register_Destination	- 0 - reg2, 1 - reg3  
				   Intr_fetch = 1;   //intrs_out - 1 ; mem_data_out - 0
			end
			ldrb:begin
					//Set the Control Block
					mem_reg    = 1;   // Take Data from the ALU for writing
					reg_write  = 1;   // write needed to register file
					branch     = 0;   // 
					mem_read   = 1;   //
					mem_write  = 0;   //
					mem_enable = 1;   // No mem enable required
					ALU_op     = opcode;
					ALU_src    = 0;   // For 0- Reg_data2 1- Immediate Value
					reg_dst    = 1;   // Register_Destination	- 0 - reg2, 1 - reg3  
				   Intr_fetch = 1;   //intrs_out - 1 ; mem_data_out - 0
			end
			adds_2op:begin
					//Set the Control Block
					mem_reg    = 1;   // Take Data from the ALU for writing
					reg_write  = 1;   // write needed to register file
					branch     = 0;   // 
					mem_read   = 0;   //
					mem_write  = 0;   //
					mem_enable = 0;   // No mem enable required
					ALU_op     = opcode;
					ALU_src    = 1;   // For 0- Reg_data2 1- Immediate Value
					reg_dst    = 1;   // Register_Destination	- 0 - reg2, 1 - reg3  
				   Intr_fetch = 1;   //intrs_out - 1 ; mem_data_out - 0
			end
	
		default: begin
					//Set the Control Block
					mem_reg    = 0;   // Take Data from the ALU
					reg_write  = 0;   // 
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

