`timescale 1 ns / 1 ps
/**
Instruction Decode block
This block accepts instuction code as an input.
The output of the blocks are two registers in operation and an offset, if applicable.
*/
module decode(data, reg1, reg2, reg3, offset, opcode);

input [15:0] data;
output reg [15:0] offset;
output reg [3:0] reg1, reg2, reg3, opcode; //reg1 -> usually sp or pc, reg2 -> source register, reg3 -> destination register


localparam  push=0, pop=1, sub_sp=2, cmp=3, movs=4, mov=5, ldr=6, str=7, 
            ldr_nop=8, add_sp=9, branch_nc= 10, adds_3op=11, branch_c=12, strb=13, ldrb=14, adds_2op=15;


always @ (data) begin

	case(data[15:12]) 

			4'hB: if(data[11:10]==2'b01) begin
					//PUSH rlist, lr
					$display("Push to Stack");				
					reg1 = 4'b0111; //R7
					reg2 = 4'b1110; //LR
					reg3 = 4'b0;
					offset = 16'b0;
					opcode = push;
				end
			    else if (data[11:10]==2'b11) begin
					//POP rlist, lr
					$display("Pull from Stack");
					reg1 = 4'b0111; //R7
					reg2 = 4'b1110; //LR
					reg3 = 4'b0;
					offset = 16'b0;
					opcode = pop;
				end
			    else begin
					//SUB SP,Imm
					$display("Subtract offset from Static Pointer");
					reg1 = 4'b1101; //SP
					reg2 = 4'b0;
					reg3 = 4'b0;
					offset = ((data << 2) & 16'h01ff);
					opcode = sub_sp;
				end

			4'h2: if(data[11]==1'b1) begin
					//CMP r3, imm
					$display("Compare Immediate");
					reg1 = 4'b0;
					reg2 = 4'b0;
					reg3 = {1'b0, data[10:8]};
					offset = {8'b0, data[7:0]};
					opcode = cmp;
				end
			    else begin
					//MOVS r3, imm
					$display("Move Immediate");
					reg1 = 4'b0;
					reg2 = 4'b0;
					reg3 = {1'b0, data[10:8]};
					offset = {8'b0, data[7:0]};	
					opcode = movs;			
				end

			4'h4: if(data[11]==1'b0) begin
				//MOV 
				$display("High Register Operation Exchange");
				if(data[9:8] == 2'b10 && data[7:6] == 2'b01) begin
					//MOV Rd, Hs
					reg1 = 4'b0;
					reg2 = {1'b1, data[2:0]};
					reg3 = {1'b0, data[5:3]};
					opcode = mov;
				end
				else if(data[9:8] == 2'b10 && data[7:6] == 2'b10) begin
					//MOV Hd, Rs
					reg1 = 4'b0;
					reg2 = {1'b0, data[5:3]};
					reg3 = {1'b1, data[2:0]};
					offset = 16'b0;
					opcode = mov;
				end
				else if(data[9:8] == 2'b10 && data[7:6] == 2'b11) begin
					//MOV Hd, Hs
					reg1 = 4'b0;
					reg2 = {1'b1,data[5:3]};
					reg3 = {1'b1,data[2:0]};
					opcode = mov;
				end
				end
			    else begin
					//LDR r3, [pc, imm]
					$display("PC Relative Load");
					reg1 = 4'b1111; //PC
					reg2 = 4'b0;
					reg3 = {1'b0, data[10:8]};
					offset = (data << 2) & 16'h03ff; 
					opcode = ldr;
				end

			4'h6: begin
				reg1 = 4'b0;
				reg2 = {1'b0, data[5:3]};
				reg3 = {1'b0, data[2:0]};
				offset = {11'b0, data[10:6]}; 
				if(data[11]==1'b0) begin
					//STR r2, [r3, imm]
					$display("Store Immediate");					
					opcode = str;
				end
			    else begin
				//LDR(NOP)
					$display("Load Immediate"); 
					opcode = ldr_nop;
				end
				end

			4'hA: //ADD_SP -> add r7, sp, imm
				begin
				$display("Load Address");
				reg1 = 4'b1101; //SP
				reg2 = 4'b0;
				reg3 = {1'b0, data[10:8]};
				offset = (data << 2) & 16'h03ff; 
				opcode = add_sp;
				end

			4'hE: //branch nc
				begin
				$display("Unconditional Branch");
				reg1 = 4'b0;
				reg2 = 4'b0;
				reg3 = 4'b0;
				offset = (data[10:0] << 1) & 16'h07ff;
				opcode = branch_nc;
				end
			
			4'h1: //ADDS with 3 operands -> adds r2, r3, imm
				begin
				$display("Add with 3 operands");
				reg1 = 4'b0;
				reg2 = {1'b0, data[5:3]};
				reg3 = {1'b0, data[2:0]};
				offset = {13'b0, data[8:6]};
				opcode = adds_3op;
				end

			4'hD: //branch c
				begin
				$display("Conditional Branching");
				reg1 = 4'b0;
				reg2 = 4'b0;
				reg3 = 4'b0;
				offset = {8'b0, data[7:0]};
				opcode = branch_c;
				end

			4'h5: begin
				reg1 = data[8:6]; //offset register
				reg2 = data[5:3]; //base register
				reg3 = data[2:0]; //destination register
				offset = {8'b0, data[7:0]};
				if(data[11]==1'b0) begin
					//strb r3, [r2, r1]
					$display("Store with Register Offset");
					opcode = strb;
				end
			    else begin
					//ldrb r3, [r3, r2]
					$display("Load with register Offset");
					opcode = ldrb;
				end
				end

			4'h3: begin
				if(data[0] == 1'b0) begin
					//adds with 2 operands -> add r3, imm
					$display("Add Immediate");
					reg1 = 4'b0;
					reg2 = 4'b0;
					reg3 = {1'b0,data[10:8]};
					offset = {8'b0, data[7:0]};
					opcode = adds_2op;
				end
				end

			default: begin
						reg1 = 4'b0;
						reg2 = 4'b0;
						reg3 = 4'b0;
						offset = 16'b0;
						opcode = 4'b0;
					end
	
		endcase

end

endmodule 