// control decoder
module Control #(parameter opwidth = 3, mcodebits = 9)(
  input [mcodebits-1:0] instr,    // subset of machine code (any width you need)
  output logic  Branch, MemtoReg, MemWrite, RegWrite, setRegRead, negAddi,
  output logic [1:0] RegDst, ALUSrc, LUTSrc,
  output logic [opwidth-1:0] ALUOp);	   // for up to 8 ALU operations

always_comb begin
// defaults
  RegDst 	=   'b00;   // 0:last 3 bits; 1:last 2 bits;  2:write to R0
  Branch 	=   'b0;   // 1: branch (jump)
  MemWrite  =	'b0;   // 1: store to memory
  ALUSrc 	=	'b00;   // 0: read data 2; 1: immediate;  2: from lut, 3: from R0
  RegWrite  =	'b1;   // 0: for store or no op  1: most other operations 
  MemtoReg  =	'b0;   // 1: load -- route memory instead of ALU to reg_file data in
  ALUOp	    = 'b111; // pass through
  LUTSrc = 'b00; //0: andi; 1: ls; 2: addi
  setRegRead = 'b0;
  negAddi = 'b0;
// sample values only -- use what you need
case(instr[8:6])    // override defaults with exceptions
  'b000:  // copy operation
      RegDst = 'b00; //dst is specified register
  'b001: begin //load/store/or/andi
    case (instr[1:0]) 
      'b00: begin//load
        RegDst = 'b10;
        MemtoReg = 'b1;
      end
      'b01: begin //store
        MemWrite = 'b1;
        RegWrite = 'b0;
      end
      'b10: begin //bitwise OR
        RegDst = 'b10;
        ALUSrc = 'b11; //InB = R0
        ALUOp = 'b010; //bitwise OR
      end
      'b11: begin //andi
        RegDst = 'b10;
        ALUSrc = 'b10;
        ALUOp = 'b011; //and
      end
    endcase
  end
  'b010:  begin //logial_shift/addi
    if (instr[0] == 0) begin //logical_shift
        RegDst = 'b10; //writes to R0
        ALUSrc = 'b10; //from lut
        ALUOp = 'b001; //logical_shift;
        LUTSrc = 'b01; //ls
      end
    else begin //addi instr[0] == 1
      RegDst = 'b10; //write to R0
      ALUSrc = 'b10; //from lut
      ALUOp = 'b000; //add
      LUTSrc = 'b10; //addi
      negAddi = 'b1;
      

    end
  end 
  'b011: begin //beq
    Branch = 'b1;
    RegWrite = 'b0;
    ALUOp = 'b101;
  end
  'b100: begin //add
    RegDst = 'b10; 
    ALUOp = 'b000; //add
  end
  'b101: begin //xor
    RegDst = 'b10; 
    ALUOp = 'b100; //xor
  end
  'b110: begin //and
    RegDst = 'b10; 
    ALUOp = 'b011; //and
  end
  'b111: begin //set
    RegDst = 'b01; // last 2 bits
    ALUSrc = 'b01;
    ALUOp = 'b110;
    setRegRead = 1;
  end

endcase
end
	
endmodule