// combinational -- no clock
// sample -- change as desired
module alu(
  input[2:0] alu_cmd,    // ALU instructions -> 3 bits wide
  input [7:0] inA, inB,	 // 8-bit wide data path
  input      sc_i, negAddi,     // shift_carry in
  output logic[7:0] rslt,
  output logic sc_o,     // shift_carry out
               pari,     // reduction XOR (output)
			   zero      // NOR (output)
);


always_comb begin 
  rslt = 'b0;            
  sc_o = 'b0;    
  zero = 'b0;
  pari = ^rslt;
  case(alu_cmd) 
    3'b000: begin// add 2 8-bit unsigned; automatically makes carry-out
      if(negAddi)
      rslt = inA - (inB[7] * 128) + inB[6:0];
      else
      {sc_o,rslt} = inA + inB;
  end
      
	  3'b001: // logical_shift
      begin
	      {sc_o,rslt} = {inA, sc_i};
        if(inB[7] == 1) //1 = shift right
          rslt = inA >> inB[6:0];
        else //shift left
          rslt = inA << inB[6:0];
        /*
		    rslt[7:1] = inA[6:0];
		    rslt[0]   = sc_i;
		    sc_o      = inA[7];
        */
      end
  
    3'b010: // bitwise or
	    rslt = inA | inB;

    3'b011: //bitwise and
      rslt = inA & inB;

    3'b100: //bitwise XOR
      rslt = inA ^ inB;

    3'b101: //beq
      if(inA == inB) zero = 'b1;

    3'b110: //set 4 least sig bits
      begin
        rslt [7:4] = inA[7:4];
        rslt [3:0] = inB[3:0];
      end
      
    default: //pass
      rslt = inA;

  endcase
end
   
endmodule


/*
1. pass through (copy, load/store)
2. or
3. Andi and and
4. LSR
5. LSL
6. Addi and add
7. beq
8. XOR
9. set

*/