module ConfigurablePE(
  input         clock,
  input         reset,
  input  [15:0] io_north,
  input  [15:0] io_east,
  input  [15:0] io_south,
  input  [15:0] io_west,
  input  [15:0] io_ib0,
  input  [15:0] io_ib1,
  input  [2:0]  io_cfgIn_selA,
  input  [2:0]  io_cfgIn_selB,
  input  [1:0]  io_cfgIn_op,
  input         io_cfgWrite,
  output [15:0] io_out
);
  wire  configReg_clock; // @[ConfigurablePE.scala 23:25]
  wire  configReg_reset; // @[ConfigurablePE.scala 23:25]
  wire [2:0] configReg_io_in_selA; // @[ConfigurablePE.scala 23:25]
  wire [2:0] configReg_io_in_selB; // @[ConfigurablePE.scala 23:25]
  wire [1:0] configReg_io_in_op; // @[ConfigurablePE.scala 23:25]
  wire  configReg_io_write; // @[ConfigurablePE.scala 23:25]
  wire [2:0] configReg_io_out_selA; // @[ConfigurablePE.scala 23:25]
  wire [2:0] configReg_io_out_selB; // @[ConfigurablePE.scala 23:25]
  wire [1:0] configReg_io_out_op; // @[ConfigurablePE.scala 23:25]
  wire [15:0] muxA_io_in_1; // @[ConfigurablePE.scala 24:25]
  wire [15:0] muxA_io_in_2; // @[ConfigurablePE.scala 24:25]
  wire [15:0] muxA_io_in_3; // @[ConfigurablePE.scala 24:25]
  wire [15:0] muxA_io_in_4; // @[ConfigurablePE.scala 24:25]
  wire [15:0] muxA_io_in_5; // @[ConfigurablePE.scala 24:25]
  wire [15:0] muxA_io_in_6; // @[ConfigurablePE.scala 24:25]
  wire [2:0] muxA_io_sel; // @[ConfigurablePE.scala 24:25]
  wire [15:0] muxA_io_out; // @[ConfigurablePE.scala 24:25]
  wire [15:0] muxB_io_in_1; // @[ConfigurablePE.scala 25:25]
  wire [15:0] muxB_io_in_2; // @[ConfigurablePE.scala 25:25]
  wire [15:0] muxB_io_in_3; // @[ConfigurablePE.scala 25:25]
  wire [15:0] muxB_io_in_4; // @[ConfigurablePE.scala 25:25]
  wire [15:0] muxB_io_in_5; // @[ConfigurablePE.scala 25:25]
  wire [15:0] muxB_io_in_6; // @[ConfigurablePE.scala 25:25]
  wire [2:0] muxB_io_sel; // @[ConfigurablePE.scala 25:25]
  wire [15:0] muxB_io_out; // @[ConfigurablePE.scala 25:25]
  wire [15:0] alu_io_a; // @[ConfigurablePE.scala 26:25]
  wire [15:0] alu_io_b; // @[ConfigurablePE.scala 26:25]
  wire [1:0] alu_io_op; // @[ConfigurablePE.scala 26:25]
  wire [15:0] alu_io_out; // @[ConfigurablePE.scala 26:25]
  wire  outputReg_clock; // @[ConfigurablePE.scala 27:25]
  wire  outputReg_reset; // @[ConfigurablePE.scala 27:25]
  wire [15:0] outputReg_io_in; // @[ConfigurablePE.scala 27:25]
  wire [15:0] outputReg_io_out; // @[ConfigurablePE.scala 27:25]
  PEConfigReg configReg ( // @[ConfigurablePE.scala 23:25]
    .clock(configReg_clock),
    .reset(configReg_reset),
    .io_in_selA(configReg_io_in_selA),
    .io_in_selB(configReg_io_in_selB),
    .io_in_op(configReg_io_in_op),
    .io_write(configReg_io_write),
    .io_out_selA(configReg_io_out_selA),
    .io_out_selB(configReg_io_out_selB),
    .io_out_op(configReg_io_out_op)
  );
  OperandMux muxA ( // @[ConfigurablePE.scala 24:25]
    .io_in_1(muxA_io_in_1),
    .io_in_2(muxA_io_in_2),
    .io_in_3(muxA_io_in_3),
    .io_in_4(muxA_io_in_4),
    .io_in_5(muxA_io_in_5),
    .io_in_6(muxA_io_in_6),
    .io_sel(muxA_io_sel),
    .io_out(muxA_io_out)
  );
  OperandMux muxB ( // @[ConfigurablePE.scala 25:25]
    .io_in_1(muxB_io_in_1),
    .io_in_2(muxB_io_in_2),
    .io_in_3(muxB_io_in_3),
    .io_in_4(muxB_io_in_4),
    .io_in_5(muxB_io_in_5),
    .io_in_6(muxB_io_in_6),
    .io_sel(muxB_io_sel),
    .io_out(muxB_io_out)
  );
  ALU alu ( // @[ConfigurablePE.scala 26:25]
    .io_a(alu_io_a),
    .io_b(alu_io_b),
    .io_op(alu_io_op),
    .io_out(alu_io_out)
  );
  PEOutputReg outputReg ( // @[ConfigurablePE.scala 27:25]
    .clock(outputReg_clock),
    .reset(outputReg_reset),
    .io_in(outputReg_io_in),
    .io_out(outputReg_io_out)
  );
  assign io_out = outputReg_io_out; // @[ConfigurablePE.scala 54:10]
  assign configReg_clock = clock;
  assign configReg_reset = reset;
  assign configReg_io_in_selA = io_cfgIn_selA; // @[ConfigurablePE.scala 29:22]
  assign configReg_io_in_selB = io_cfgIn_selB; // @[ConfigurablePE.scala 29:22]
  assign configReg_io_in_op = io_cfgIn_op; // @[ConfigurablePE.scala 29:22]
  assign configReg_io_write = io_cfgWrite; // @[ConfigurablePE.scala 30:22]
  assign muxA_io_in_1 = io_north; // @[ConfigurablePE.scala 33:{24,24}]
  assign muxA_io_in_2 = io_east; // @[ConfigurablePE.scala 33:{24,24}]
  assign muxA_io_in_3 = io_south; // @[ConfigurablePE.scala 33:{24,24}]
  assign muxA_io_in_4 = io_west; // @[ConfigurablePE.scala 33:{24,24}]
  assign muxA_io_in_5 = io_ib0; // @[ConfigurablePE.scala 33:{24,24}]
  assign muxA_io_in_6 = io_ib1; // @[ConfigurablePE.scala 33:{24,24}]
  assign muxA_io_sel = configReg_io_out_selA; // @[ConfigurablePE.scala 46:15]
  assign muxB_io_in_1 = io_north; // @[ConfigurablePE.scala 33:{24,24}]
  assign muxB_io_in_2 = io_east; // @[ConfigurablePE.scala 33:{24,24}]
  assign muxB_io_in_3 = io_south; // @[ConfigurablePE.scala 33:{24,24}]
  assign muxB_io_in_4 = io_west; // @[ConfigurablePE.scala 33:{24,24}]
  assign muxB_io_in_5 = io_ib0; // @[ConfigurablePE.scala 33:{24,24}]
  assign muxB_io_in_6 = io_ib1; // @[ConfigurablePE.scala 33:{24,24}]
  assign muxB_io_sel = configReg_io_out_selB; // @[ConfigurablePE.scala 47:15]
  assign alu_io_a = muxA_io_out; // @[ConfigurablePE.scala 49:13]
  assign alu_io_b = muxB_io_out; // @[ConfigurablePE.scala 50:13]
  assign alu_io_op = configReg_io_out_op; // @[ConfigurablePE.scala 51:13]
  assign outputReg_clock = clock;
  assign outputReg_reset = reset;
  assign outputReg_io_in = alu_io_out; // @[ConfigurablePE.scala 53:19]
endmodule
