// program counter
// supports both relative and absolute jumps
// use either or both, as desired
module PC #(parameter D=12)(
  input reset,					// synchronous reset
        clk,
		reljump_en,             // rel. jump enable
        absjump_en,				// abs. jump enable
  input [7:0] target,	// how far/where to jump
  output logic[D-1:0] prog_ctr
);

  always_ff @(posedge clk) begin
    if(reset)
	  prog_ctr <= 'b000000000000;
	  else if(reljump_en) begin
	    prog_ctr <= prog_ctr - (128 * target[7]) + target[6:0];
    end
    else if(absjump_en)
	    prog_ctr <= target;
	  else
	    prog_ctr <= prog_ctr + 'b1;
  end

endmodule