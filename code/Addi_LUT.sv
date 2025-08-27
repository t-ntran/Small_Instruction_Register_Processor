module Addi_LUT #(parameter D=8)(
  input       [ 1:0] addr,	   // target 4 values
  output logic[D-1:0] target);

  always_comb case(addr)
    0: target = 8'b00000001;   // + add 1
	1: target = 8'b00000101;   // + 5
	2: target = 8'b00001111;   // + 15
	default: target = 8'b11111111;  // -1 
  endcase

endmodule