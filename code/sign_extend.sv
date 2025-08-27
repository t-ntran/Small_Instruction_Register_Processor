module sign_extend #(parameter mcodebits = 9) (
    input [mcodebits-1: 0] instr,
    output logic [7:0] rslt);

  always_comb begin
    rslt[3:0] = instr[5:2];
    rslt[7:4] = 'b0000;
  end
endmodule