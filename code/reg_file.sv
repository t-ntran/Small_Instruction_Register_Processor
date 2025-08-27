// cache memory/register file
// default address pointer width = 4, for 16 registers
//change: width = 3, for 8 registers
module reg_file #(parameter pw=3)(
  input reset,
  input[7:0] dat_in,
  input      clk,
  input      wr_en,           // write enable
  input[pw-1:0] wr_addr,		  // write address pointer
              rd_addrA,		  // read address pointers
			  rd_addrB,
  output logic[7:0] datA_out, // read data
                    datB_out,
					dat0_out,
					r1,
					r2,
					r3,
					r4,
					r5,
					r6,
					r7);

  logic[7:0] core[2**pw];    // 2-dim array  8 wide  16 deep

// reads are combinational
  assign datA_out = core[rd_addrA];
  assign datB_out = core[rd_addrB];
  assign dat0_out = core[0];
  assign r1 = core[1];
  assign r2 = core[2];
  assign r3 = core[3];
  assign r4 = core[4];
  assign r5 = core[5];
  assign r6 = core[6];
  assign r7 = core[7];

// writes are sequential (clocked)
  always_ff @(posedge clk)	begin
  if(reset) begin
	core[0] <= 8'b00000000;
	core[1] <= 8'b00000000;
	core[2] <= 8'b00000000;
	core[3] <= 8'b00000000;
	core[4] <= 8'b00000000;
	core[5] <= 8'b00000000;
	core[6] <= 8'b00000000;
	core[7] <= 8'b00000000;
  end
    if(wr_en & !reset)				   // anything but stores or no ops
      core[wr_addr] <= dat_in; 
  end

endmodule
/*
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
*/