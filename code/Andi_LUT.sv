module Andi_LUT #(parameter D=8)(
  input       addr,	  //2 options
  output logic[D-1:0] target);

  always_comb begin
    if (!addr)
        target = 1;
    else //addr == 1
        target = 3;
  end

endmodule