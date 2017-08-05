`timescale 1ns/1ps

module alu(opcode, inA, inB,in_apsr, out, out_apsr);

input [3:0] opcode;
input [15:0] inA, inB, in_apsr;
output reg [15:0] out, out_apsr; 

localparam  push=0, pop=1, sub_sp=2, cmp=3, movs=4, mov=5, ldr=6, str=7, 
            ldr_nop=8, add_sp=9, branch_nc= 10, adds_3op=11, branch_c=12, strb=13, ldrb=14, adds_2op=15;

`define in_carry in_apsr[1]
`define in_zero in_apsr[2]
`define in_overflow in_apsr[0]
`define in_negative in_apsr[3]


`define out_overflow out_apsr[0]
`define out_carry out_apsr[1]
`define out_zero out_apsr[2]
`define out_negative out_apsr[3]

always @(opcode, inA, inB) begin

	case(opcode)
	push: begin //inA= Stack Pointer  
		out <= inA-1;
		`out_carry = `in_carry ;
		`out_overflow = `in_overflow ;
		`out_negative = `in_negative ;
		`out_zero = `in_zero ; 
		$display("PUSH");
	      end 

	pop: begin
		//SP increment 
		
		//SP increase by 2 as registers both are being poped
		$display("POP");
	     end

	sub_sp: begin
//		 out = inA - inB;
		 //if(out==0) `out_zero = 0;
		 $display("SUB_SP");
	     end
	
	add_sp: begin
//		{`out_overflow, out} = inA + inB + `in_carry; 
	     end
   
        adds_2op: begin
//		{`out_overflow, out} = inA + inB + `in_carry; 
	     end
      
        adds_3op: begin
//		{`out_overflow, out} = inA + inB + `in_carry; 
	     end
       
	cmp: begin
//		 if(inA==inB) `out_zero = 0;
	     end
	
	str: begin
	     end

	ldr: begin
	     end

	branch_c: begin
	
	     end

	branch_nc: begin
		out=inA;
	    end

	mov: begin
	     end


	endcase

end 

endmodule