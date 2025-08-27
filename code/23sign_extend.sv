module sign_extend23(
    input [1:0] in,
    output logic [2:0] rslt);

  always_comb begin
    rslt[1:0] = in;
    rslt[2] = 'b0;
  end
endmodule