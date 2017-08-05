//Module for Register File
// The register File consists of R0 - R15
// R0 - R12 - General Purpose Registers
// R13 (SP) - Stack Pointer
// R14 (LR) - Link Register
// R15 (PC) - Program Counter

module register_file(clock,WE,InData,WrReg,ReadA,ReadB,OutA,OutB); 

    input [3:0] WrReg, ReadA, ReadB; 
    input WE,clock; 
    input [15:0] InData; 
    output [15:0] OutA,OutB; 
     
    reg [15:0] OutA, OutB;//2 16-bit output reg 
    reg signed [15:0] regfile[15:0];//16 16-bit registers 
     
    initial begin 
        OutA = -2072; //random values for initial 
        OutB = -367; 
        
		  regfile[0] = 16'h0000;
	     regfile[1] = 16'h0000;
	     regfile[2] = 16'h0000;
	     regfile[3] = 16'h0000;
	     regfile[4] = 16'h0000;
	     regfile[5] = 16'h0000;
	     regfile[6] = 16'h0000;
	     regfile[7] = 16'h0000;
	     
	     regfile[13] = 16'h2000; // Value for Stack Pointer
        regfile[15] = 16'h0000;
    end
     
    always@(clock,InData,WrReg,WE) 
    begin 
      if(WE && clock) // For transferring the data on the positive level of the clock
        begin 
         regfile[WrReg]<=InData;//write to register 
         $display("Does WrReg: %d Data: %d",WrReg,InData); 
        end 

    end 
     
    always @ (clock,ReadA,ReadB,WrReg) 
    begin 
      if(~clock)  // For transferring the data on the negative level of the clock
        begin 
      OutA <= regfile[ReadA];//read values from registers 
      OutB <= regfile[ReadB]; 
      $monitor  ("R0:  %d  R1:  %d  R2  %d  R7:  %d  SP:  %d  PC:  %d",regfile[0],regfile[1],regfile[2],regfile[7],regfile[13],regfile[15]); 
      end 
    end 
 
 
endmodule 
