module MUX2 (
    input [7:0] inA, inB,
    input Control,
    output logic [7:0] select);

  always_comb case(Control)
    0: select = inA;        
	default: select = inB; 
  endcase

endmodule