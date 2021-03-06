`timescale 1 ns / 1 ps
/**
Instruction Decode block
This block accepts instuction code as an input.
The output of the blocks are two registers in operation and an offset, if applicable.
*/
module decode(
	data,
	reset,
	reg1,
	reg2,
	reg3,
	r_list,
	r_list_size,
	cond,
	offset,
	opcode);

//inputs
input [15:0] data; //instruction code coming from Fetch block
input reset; //Active high Synchronous reset

//outputs
output reg [15:0] offset; //immediate value
output reg [3:0] reg1, reg2, reg3; //reg1 -> usually sp or pc or lr, reg2 -> source register, reg3 -> destination register
output reg [7:0] r_list; //register list for push and pop instructions
output reg [3:0] cond; //condtion for branching
output reg [3:0] r_list_size; //count of the registers to be pushed or popped excluding LR
output reg [4:0] opcode;


localparam  PUSH = 0, POP = 1, SUB_SP = 2, CMP = 3, MOVS = 4, MOV = 5, LDR = 6, STR = 7, 
            LDR_NOP = 8, ADD_SP = 9, BRANCH_NC = 10, ADDS_3OP = 11, BRANCH_C = 12, STRB = 13, LDRB = 14, ADDS_2OP = 15, NOP = 16;


always @ (data, reset) begin
	if(reset) begin
		reg1 = 4'b0;
		reg2 = 4'b0;
		reg3 = 4'b0;
		r_list = 8'b0;
		r_list_size = 3'b0;
		cond = 4'b0;
		offset = 16'b0;
		opcode = 5'b0;
	end

	else begin
	
	case(data[15:12]) 
				
				4'hB: begin 
					if(data[11:10]==2'b01) begin
						//PUSH r_list, lr
						$display("Push to Stack");				
						reg1 = 4'b1110; //LR
						r_list = data[7:0];
						r_list_size = r_list[0] + r_list[1] + r_list[2] + r_list[3] + r_list[4] + r_list[5] + r_list[6] + r_list[7];
						opcode = PUSH;
					end
					else if (data[11:10]==2'b11) begin
						//POP rlist, lr
						$display("Pull from Stack");
						reg1 = 4'b1110; //LR
						r_list = data[7:0]; 
						r_list_size = r_list[0] + r_list[1] + r_list[2] + r_list[3] + r_list[4] + r_list[5] + r_list[6] + r_list[7];
						opcode = POP;
					end
					else begin
						//SUB SP,Imm
						$display("Subtract offset from Static Pointer");
						reg1 = 4'b1101; //SP
						reg3 = 4'b1101;
						offset = ((data << 2) & 16'h01ff);
						opcode = SUB_SP;
					end
				end
	
				4'h2: begin
					if(data[11]==1'b1) begin
						//CMP r3, imm
						$display("Compare Immediate");
						reg3 = {1'b0, data[10:8]};
						offset = {8'b0, data[7:0]};
						opcode = CMP;
					end
					else begin
						//MOVS r3, imm
						$display("Move Immediate");
						reg3 = {1'b0, data[10:8]};
						offset = {8'b0, data[7:0]};	
						opcode = MOVS;			
					end
				end
	
				4'h4: begin
					if(data[11]==1'b0) begin
						//MOV 
						$display("High Register Operation Exchange");
						if(data[9:8] == 2'b10 && data[7:6] == 2'b01) begin
							//MOV Rd, Hs
							reg1 = 4'b0;
							reg2 = {1'b1, data[2:0]};
							reg3 = {1'b0, data[5:3]};
							opcode = MOV;
						end
						else if(data[9:8] == 2'b10 && data[7:6] == 2'b10) begin
							//MOV Hd, Rs
							reg1 = 4'b0;
							reg2 = {1'b0, data[5:3]};
							reg3 = {1'b1, data[2:0]};
							offset = 16'b0;
							opcode = MOV;
						end
						else if(data[9:8] == 2'b10 && data[7:6] == 2'b11) begin
							//MOV Hd, Hs
							reg1 = 4'b0;
							reg2 = {1'b1,data[5:3]};
							reg3 = {1'b1,data[2:0]};
							opcode = MOV;
						end
					end
					else begin
						//LDR r3, [pc, imm]
						$display("PC Relative Load");
						reg1 = 4'b1111; //PC
						reg3 = {1'b0, data[10:8]};
						offset = (data << 2) & 16'h03ff; 
						opcode = LDR;
					end
				end
					
				4'h6: begin
					reg1 = {1'b0, data[5:3]};
					reg2 = 4'b0;
					reg3 = {1'b0, data[2:0]};
					offset = {11'b0, data[10:6]}; 
					if(data[11]==1'b0) begin
						//STR r2, [r3, imm]
						$display("Store Immediate");					
						opcode = STR;
					end
					else begin
					//LDR(NOP)
						$display("Load Immediate"); 
						opcode = LDR_NOP;
					end
				end

				4'hA: //ADD_SP -> add r7, sp, imm
				begin
					$display("Load Address");
					reg1 = 4'b1101; //SP
					reg3 = {1'b0, data[10:8]};
					offset = (data << 2) & 16'h03ff; 
					opcode = ADD_SP;
				end

				4'hE: //branch nc
				begin
					$display("Unconditional Branch");
					offset = (data[10:0] << 1) & 16'h07ff;
					opcode = BRANCH_NC;
				end
			
				4'h1: //ADDS with 3 operands -> adds r2, r3, imm
				begin
					$display("Add with 3 operands");
					reg2 = {1'b0, data[5:3]};
					reg3 = {1'b0, data[2:0]};
					offset = {13'b0, data[8:6]};
					opcode = ADDS_3OP;
				end

				4'hD: //branch c
				begin
					$display("Conditional Branching");
					offset = data[7]? {7'b1, (data[7:0] << 1)}:{7'b0, (data[7:0] << 1)};
					cond = data[11:8];
					opcode = BRANCH_C;
				end

				4'h5: begin
					reg1 = data[8:6]; //offset register
					reg2 = data[5:3]; //base register
					reg3 = data[2:0]; //destination register
					offset = {8'b0, data[7:0]};
					if(data[11]==1'b0) begin
						//strb r3, [r2, r1]
						$display("Store with Register Offset");
						opcode = STRB;
					end
					else begin
						//ldrb r3, [r3, r2]
						$display("Load with register Offset");
						opcode = LDRB;
					end
				end

				4'h3: begin
					//adds with 2 operands -> add r3, imm
					$display("Add Immediate");
					reg3 = {1'b0,data[10:8]};
					offset = {8'b0, data[7:0]};
					opcode = ADDS_2OP;
				end
				
				
				
				default: begin
						reg1 = 4'b0;
						reg2 = 4'b0;
						reg3 = 4'b0;
						offset = 16'b0;
						opcode = 5'b10000;
					end	
			endcase
		end
	end


endmodule 