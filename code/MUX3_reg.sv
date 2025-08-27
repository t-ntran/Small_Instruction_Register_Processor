module MUX3_reg (
    input [1:0] inB,
    input [2:0] inA, inC,
    input [1:0] Control,
    output logic [2:0] select);

  always_comb case(Control)
    0: select = inA;   
	1: begin
        select[1:0] = inB;  
        select[2] = 'b0;
    end   
	default: select = inC; 
  endcase

endmodule