// sample top level design
module top_level(
  input        clk, reset, //req, 
  output logic done);
  parameter D = 12,             // program counter width
    A = 3;             		  // ALU command bit width
  
  //wire[D-1:0] target; //jump target
  wire[7:0]   dat1,dat2;		  // from RegFile
  /*
  logic sc_in,   				  // shift/carry out from/to ALU
   		  pariQ,              	  // registered parity flag from ALU
		    zeroQ;                    // registered zero flag from ALU 
  */
  //wire  relj;                     // from control to PC; relative jump enable
  /*
  wire  pari,
        zero,
		    sc_clr,
		    sc_en;
        */

  //wire[2:0] rd_addrA, rd_adrB;    // address pointers to reg_file

  wire[1:0] LUTSrc, RegDst, ALUSrc;


  //Fetch wires
  wire[D-1:0] IAddr; //PC -> IMem
  //wire[D-1:0] PCNext; //mux (PCmux2) -> PC
  //Register wires
  wire[2:0] Reg1, regSetSx; //IMem -> Read reg1
  wire[2:0] Reg2; //IMem -> Read reg2
  wire[7:0] dat0, r1, r2, r3, r4, r5, r6, r7, d0, d1; //data from zero reg
  //wire[8:0] Control; //IMem -> Control unit
  wire RegWrite, MemtoReg, MemWrite, setRegRead, negAddi;
  wire[2:0] ALUOp, WrtReg; //Mux (RDm3) -> Write register
  wire[1:0] SetRegDst; //IMem (RegDst Set)-> Mux (RDm3)
  wire[2:0] ZeroDst; //IMem -> Mux (RDm3)
  wire[8:0] mach_code;     // machine code
  wire[1:0] LUT; //IMem -> the 3 LUT
  wire[7:0] SXRslt; //sign-extend -> Mux (ALUm4)

  //LUT
  wire[7:0] andi; //andi -> mux (LUTm3)
  wire[7:0] ls; //ls -> mux(LUTm3)
  wire[7:0] addi; //addi -> mux (LUTm3)
  wire[7:0] LUTrslt; //mux (LUTm3) -> mux (ALUm4)

  //ALU
  wire[7:0] ALUinB; //mux(ALUm4) -> ALU
  wire[7:0] ALURslt; // ALU -> DatMem

  //DataMem
  wire[7:0] DataMemRslt; //DataMem -> mux (DMm2)
  wire[7:0] WriteDat; //mux (DMm2) -> Write data (reg)
  wire[2:0] Reg1m2rslt;

// fetch subassembly
  PC #(.D(D)) 					  // D sets program counter width
     pc1 (.reset            ,
         .clk              ,
		 .reljump_en (zero),      //no relative jump
		 .absjump_en (),
		 .target (dat0)         ,
		 .prog_ctr (IAddr)         );

// lookup table to facilitate jumps/branches
/*
  PC_LUT #(.D(D))
    pl1 (.addr  (how_high),
         .target          );  
         */ 

// contains machine code
  instr_ROM ir1(.prog_ctr (IAddr),
               .mach_code (mach_code));

// control decoder
  Control ctl1(.instr(mach_code),
  .RegDst  (RegDst), 
  .Branch  (absj)  , 
  .MemWrite (MemWrite) , 
  .ALUSrc (ALUSrc)  , 
  .RegWrite (RegWrite)  ,     
  .MemtoReg(MemtoReg),
  .ALUOp(ALUOp),
  .LUTSrc (LUTSrc),
  .setRegRead(setRegRead),
  .negAddi(negAddi));

  assign Reg1 = mach_code[5:3];
  assign Reg2 = mach_code[2:0];
  assign SetRegDst = mach_code[1:0];
  assign ZeroDst = 0; 

  sign_extend signext (.instr(mach_code),
    .rslt(SXRslt));

  sign_extend23 sx23 (.in(SetRegDst),
    .rslt(regSetSx));

  assign LUT = mach_code[2:1];

  Andi_LUT andilut(.addr(LUT[1]),
    .target(andi));

  LS_LUT lslut(.addr(LUT),
  .target(ls));

  Addi_LUT addilut(.addr(LUT),
      .target(addi));


  reg_file #(.pw(3)) rf1(.reset,
  .dat_in(WriteDat),	   // loads, most ops
              .clk         ,
              .wr_en   (RegWrite),
              .rd_addrA(Reg1m2rslt),
              .rd_addrB(Reg2),
              .wr_addr (WrtReg),      // in place operation
              .datA_out(dat1),
              .datB_out(dat2),
              .dat0_out(dat0),
              .r1,
              .r2,
              .r3,
              .r4,
              .r5,
              .r6,
              .r7); 

  //assign muxB = ALUSrc? immed : datB;

  alu alu1(.alu_cmd(ALUOp),
         .inA    (dat1),
		 .inB    (ALUinB), //TODO
		 .sc_i   (),   // output from sc register
     .negAddi(negAddi),
		 .rslt  (ALURslt)     ,
		 .sc_o   (), // input to sc register
		 .pari(),  //??
     .zero (zero)  );  

  dat_mem dm1(.dat_in(dat0)  ,  // from reg_file
             .clk       ,
			 .wr_en  (MemWrite), // stores
			 .addr   (ALURslt),
             .dat_out(DataMemRslt),
             .d0,
             .d1);

  /*
  MUX2 PCm2 (.inA(IAddr),
    .inB(dat0),
    .Control(zero),
    .select(PCNext)); 
    */

  MUX2 Reg1m2 (.inA(Reg1),
  .inB(regSetSx),
  .Control(setRegRead),
  .select(Reg1m2rslt));

  MUX2 M2Rm2 (.inA(ALURslt),
  .inB(DataMemRslt),
  .Control(MemtoReg),
  .select(WriteDat)); 

  MUX3_reg RDm3 (.inA(Reg2),
  .inB(SetRegDst),
  .inC(ZeroDst),
  .Control(RegDst),
  .select(WrtReg));

  MUX3 LUTm3 (.inA(andi),
  .inB(ls),
  .inC(addi),
  .Control(LUTSrc),
  .select(LUTrslt)); 

  MUX4 ALUm4 (.inA(dat2),
  .inB(SXRslt),
  .inC(LUTrslt),
  .inD(dat0),
  .Control(ALUSrc),
  .select(ALUinB));


// registered flags from ALU\
/*
  always_ff @(posedge clk) begin
    pariQ <= pari;
	zeroQ <= zero;
    if(sc_clr)
	  sc_in <= 'b0;
    else if(sc_en)
      sc_in <= sc_o;
  end
  */

  assign done = IAddr == 340;
 
endmodule