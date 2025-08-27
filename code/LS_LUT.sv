module LS_LUT #(parameter D=8)(
  input       [ 1:0] addr,	   // target 4 values
  output logic[D-1:0] target);

  always_comb case(addr)
    'b00: target = 'b00000001;   // shift left by 1
	'b01: target = 'b10000001;   // shift right by 1
	'b10: target = 'b00000100;   //shift left by 4
	default: target = 'b10000100;  // shift right by 4 
  endcase

endmodule