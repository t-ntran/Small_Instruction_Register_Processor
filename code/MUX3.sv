module MUX3 (
    input [7:0] inA, inB, inC,
    input [1:0] Control,
    output logic [7:0] select);

  always_comb case(Control)
    0: select = inA;   
	  1: select = inB;     
	  default: select = inC; 
  endcase

endmodule