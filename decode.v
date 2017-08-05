`timescale 1 ns / 1 ps
/**
Instruction Decode block
This block accepts instuction code as an input.
The output of the blocks are two registers in operation and an offset, if applicable.
*/
module decode(data, reg1, reg2, offset, opcode);

input [15:0] data;
output reg [11:0] offset;
output reg [3:0] reg1, reg2, opcode; //reg1 = destination & source register(usually), reg2 = source register
//reg [11:0] address;
//reg [15:0] apsr;

localparam  push=0, pop=1, sub_sp=2, cmp=3, movs=4, mov=5, ldr=6, str=7, 
            ldr_nop=8, add_sp=9, branch_nc= 10, adds_3op=11, branch_c=12, strb=13, ldrb=14, adds_2op=15;

/**initial begin
	reg1 <= 4'b0000; 
	reg2 <= 4'b0000;
	opcode <= 4'b0000; 
	offset <= 12'b0;
	//address <= 0;
end*/

always @ (data) begin

	case(data[15:12]) 

			4'hB: if(data[11:10]==2'b01) begin
				//PUSH
				$display("Push to Stack");				
				reg1 <= 4'b0111; //R7
				reg2 <= 4'b1110; //LR
				offset <= 12'b0;
				opcode <= push;
				end
			      else if (data[11:10]==2'b11) begin
				//POP
				$display("Pull from Stack");
				reg1 <= 4'b0111; //R7
				reg2 <= 4'b1110; //LR
				offset <= 12'b0;
				opcode <= pop;
				end
			      else begin
				//SUB SP,Imm
				$display("Subtract offset from Static Pointer");
				reg1 <= 4'b1101; //SP
				reg2 <= 4'b0;
				offset <= (data << 2) & 4'h01ff;
				opcode <= sub_sp;
				end

			4'h2: if(data[11]==1'b1) begin
				//CMP
				$display("Compare Immediate");
				reg1 <= {1'b0,data[10:8]};
				reg2 <= 4'b0;
				offset <= data[7:0];
				opcode <= cmp;
				end
			      else begin
				//MOVS
				$display("Move Immediate");
				reg1 <= {1'b0,data[10:8]};
				reg2 <= 4'b0;
				offset <= data[7:0];	
				opcode <= movs;			
				end

			4'h4: if(data[11]==1'b0) begin
				//MOV
				$display("High Register Operation Exchange");
				//if(data[9:8] == 2'b10 && data[7:6] == 2'b01) begin
				  //MOV Rd, Hs
				 // rd <= {4{0},data[2:0]};
				  //rs <= {4{1},data[5:3]};
				//end
				//else if(data[9:8] == 2'b10 && data[7:6] ==2'b10) begin
				  //MOV Hd, Rs
				  reg1 <= {1'b1,data[2:0]};
				  reg2 <= {1'b0,data[5:3]};
				  offset <= 12'b0;
				  opcode <= mov;
				//end
				//else if(data[9:8] == 2'b10 && data[7:6] ==2'b11) begin
				  //MOV Hd, Hs
				  //rd <= {4{1},data[2:0]};
				  //rs <= {4{1},data[5:3]};
				//end
				end
			      else begin
				//LDR
				$display("PC Relative Load");
				reg1 <= {1'b0,data[10:8]};
				reg2 <= 4'b0;
				offset <= (data << 2) & 4'h03ff; 
				opcode <= ldr;
				end

			4'h6: if(data[11]==1'b0) begin
				//STR
				$display("Store Immediate");
				reg1 <= {1'b0,data[2:0]};
				reg2 <= {1'b0,data[5:3]};
				offset[4:0] <= data[10:6]; 
				opcode <= str;
				end
			      else begin
				//LDR(NOP)
				$display("Load Immediate");
				offset[4:0] <= data[10:6]; 
				reg1 <= {1'b0,data[2:0]};
				reg2 <= {1'b0,data[5:3]};
				offset <= 12'b0;
				opcode <= ldr_nop;
				end

			4'hA: //ADD_SP
				begin
				$display("Load Address");
				reg1 <= {1'b0,data[10:8]};
				reg2 <= 4'b1101; //SP
				offset <= (data << 2) & 4'h03ff; 
				opcode <= add_sp;
				end

			4'hE: //branch nc
				begin
				$display("Unconditional Branch");
				reg1 <= 4'b0;
				reg2 <= 4'b0;
				offset <= (data[10:0]<<1) & 4'h07ff;
				opcode <= branch_nc;
				end
			
			4'h1: //ADDS with 3 operands
				begin
				$display("Add");
				reg1 <= {1'b0,data[2:0]};
				reg2 <= {1'b0,data[5:3]};
				offset <= data[8:6];
				opcode <= adds_3op;
				end

			4'hD: //branch c
				begin
				$display("Conditional Branching");
				reg1 <= 4'b0;
				reg2 <= 4'b0;
				offset <= data[7:0];
				opcode <= branch_c;
				end

			4'h5: if(data[11]==1'b0) begin
				//strb
				reg1 <= 4'b0;
				reg2 <= 4'b0;
				offset <= data[7:0];
				opcode <= strb;
				end
			      else begin
				//ldrb
				reg1 <= 4'b0;
				reg2 <= 4'b0;
				offset <= data[7:0];
				opcode <= ldrb;
				end

			4'h3: if(data[0] == 1'b0) begin
				//adds with 2 operands
				reg1 <= 4'b0;
				reg2 <= 4'b0;
				offset <= data[7:0];
				opcode <= adds_2op;
				end

			default: begin
				 reg1 <= 4'b0;
				 reg2 <= 4'b0;
				 offset <= data[7:0];
				 opcode <= 4'b0;
				 end
	
		endcase

end

endmodule 