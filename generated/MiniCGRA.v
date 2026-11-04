module MiniCGRA(
  input         clock,
  input         reset,
  input  [15:0] io_ibIn_0_0,
  input  [15:0] io_ibIn_0_1,
  input  [15:0] io_ibIn_1_0,
  input  [15:0] io_ibIn_1_1,
  output [15:0] io_obOut_0,
  output [15:0] io_obOut_1,
  input  [1:0]  io_cfgAddr,
  input  [7:0]  io_cfgIn,
  input         io_cfgWrite
);
  wire  pes_0_0_clock; // @[MiniCGRA.scala 15:34]
  wire  pes_0_0_reset; // @[MiniCGRA.scala 15:34]
  wire [15:0] pes_0_0_io_north; // @[MiniCGRA.scala 15:34]
  wire [15:0] pes_0_0_io_east; // @[MiniCGRA.scala 15:34]
  wire [15:0] pes_0_0_io_south; // @[MiniCGRA.scala 15:34]
  wire [15:0] pes_0_0_io_west; // @[MiniCGRA.scala 15:34]
  wire [15:0] pes_0_0_io_ib0; // @[MiniCGRA.scala 15:34]
  wire [15:0] pes_0_0_io_ib1; // @[MiniCGRA.scala 15:34]
  wire [2:0] pes_0_0_io_cfgIn_selA; // @[MiniCGRA.scala 15:34]
  wire [2:0] pes_0_0_io_cfgIn_selB; // @[MiniCGRA.scala 15:34]
  wire [1:0] pes_0_0_io_cfgIn_op; // @[MiniCGRA.scala 15:34]
  wire  pes_0_0_io_cfgWrite; // @[MiniCGRA.scala 15:34]
  wire [15:0] pes_0_0_io_out; // @[MiniCGRA.scala 15:34]
  wire  pes_0_1_clock; // @[MiniCGRA.scala 15:34]
  wire  pes_0_1_reset; // @[MiniCGRA.scala 15:34]
  wire [15:0] pes_0_1_io_north; // @[MiniCGRA.scala 15:34]
  wire [15:0] pes_0_1_io_east; // @[MiniCGRA.scala 15:34]
  wire [15:0] pes_0_1_io_south; // @[MiniCGRA.scala 15:34]
  wire [15:0] pes_0_1_io_west; // @[MiniCGRA.scala 15:34]
  wire [15:0] pes_0_1_io_ib0; // @[MiniCGRA.scala 15:34]
  wire [15:0] pes_0_1_io_ib1; // @[MiniCGRA.scala 15:34]
  wire [2:0] pes_0_1_io_cfgIn_selA; // @[MiniCGRA.scala 15:34]
  wire [2:0] pes_0_1_io_cfgIn_selB; // @[MiniCGRA.scala 15:34]
  wire [1:0] pes_0_1_io_cfgIn_op; // @[MiniCGRA.scala 15:34]
  wire  pes_0_1_io_cfgWrite; // @[MiniCGRA.scala 15:34]
  wire [15:0] pes_0_1_io_out; // @[MiniCGRA.scala 15:34]
  wire  pes_1_0_clock; // @[MiniCGRA.scala 15:34]
  wire  pes_1_0_reset; // @[MiniCGRA.scala 15:34]
  wire [15:0] pes_1_0_io_north; // @[MiniCGRA.scala 15:34]
  wire [15:0] pes_1_0_io_east; // @[MiniCGRA.scala 15:34]
  wire [15:0] pes_1_0_io_south; // @[MiniCGRA.scala 15:34]
  wire [15:0] pes_1_0_io_west; // @[MiniCGRA.scala 15:34]
  wire [15:0] pes_1_0_io_ib0; // @[MiniCGRA.scala 15:34]
  wire [15:0] pes_1_0_io_ib1; // @[MiniCGRA.scala 15:34]
  wire [2:0] pes_1_0_io_cfgIn_selA; // @[MiniCGRA.scala 15:34]
  wire [2:0] pes_1_0_io_cfgIn_selB; // @[MiniCGRA.scala 15:34]
  wire [1:0] pes_1_0_io_cfgIn_op; // @[MiniCGRA.scala 15:34]
  wire  pes_1_0_io_cfgWrite; // @[MiniCGRA.scala 15:34]
  wire [15:0] pes_1_0_io_out; // @[MiniCGRA.scala 15:34]
  wire  pes_1_1_clock; // @[MiniCGRA.scala 15:34]
  wire  pes_1_1_reset; // @[MiniCGRA.scala 15:34]
  wire [15:0] pes_1_1_io_north; // @[MiniCGRA.scala 15:34]
  wire [15:0] pes_1_1_io_east; // @[MiniCGRA.scala 15:34]
  wire [15:0] pes_1_1_io_south; // @[MiniCGRA.scala 15:34]
  wire [15:0] pes_1_1_io_west; // @[MiniCGRA.scala 15:34]
  wire [15:0] pes_1_1_io_ib0; // @[MiniCGRA.scala 15:34]
  wire [15:0] pes_1_1_io_ib1; // @[MiniCGRA.scala 15:34]
  wire [2:0] pes_1_1_io_cfgIn_selA; // @[MiniCGRA.scala 15:34]
  wire [2:0] pes_1_1_io_cfgIn_selB; // @[MiniCGRA.scala 15:34]
  wire [1:0] pes_1_1_io_cfgIn_op; // @[MiniCGRA.scala 15:34]
  wire  pes_1_1_io_cfgWrite; // @[MiniCGRA.scala 15:34]
  wire [15:0] pes_1_1_io_out; // @[MiniCGRA.scala 15:34]
  wire  inputBlocks_0_clock; // @[MiniCGRA.scala 16:39]
  wire  inputBlocks_0_reset; // @[MiniCGRA.scala 16:39]
  wire [15:0] inputBlocks_0_io_in_0; // @[MiniCGRA.scala 16:39]
  wire [15:0] inputBlocks_0_io_in_1; // @[MiniCGRA.scala 16:39]
  wire [15:0] inputBlocks_0_io_out_0; // @[MiniCGRA.scala 16:39]
  wire [15:0] inputBlocks_0_io_out_1; // @[MiniCGRA.scala 16:39]
  wire  inputBlocks_1_clock; // @[MiniCGRA.scala 16:39]
  wire  inputBlocks_1_reset; // @[MiniCGRA.scala 16:39]
  wire [15:0] inputBlocks_1_io_in_0; // @[MiniCGRA.scala 16:39]
  wire [15:0] inputBlocks_1_io_in_1; // @[MiniCGRA.scala 16:39]
  wire [15:0] inputBlocks_1_io_out_0; // @[MiniCGRA.scala 16:39]
  wire [15:0] inputBlocks_1_io_out_1; // @[MiniCGRA.scala 16:39]
  wire  outputBlocks_0_clock; // @[MiniCGRA.scala 17:40]
  wire  outputBlocks_0_reset; // @[MiniCGRA.scala 17:40]
  wire [15:0] outputBlocks_0_io_in; // @[MiniCGRA.scala 17:40]
  wire [15:0] outputBlocks_0_io_out; // @[MiniCGRA.scala 17:40]
  wire  outputBlocks_1_clock; // @[MiniCGRA.scala 17:40]
  wire  outputBlocks_1_reset; // @[MiniCGRA.scala 17:40]
  wire [15:0] outputBlocks_1_io_in; // @[MiniCGRA.scala 17:40]
  wire [15:0] outputBlocks_1_io_out; // @[MiniCGRA.scala 17:40]
  ConfigurablePE pes_0_0 ( // @[MiniCGRA.scala 15:34]
    .clock(pes_0_0_clock),
    .reset(pes_0_0_reset),
    .io_north(pes_0_0_io_north),
    .io_east(pes_0_0_io_east),
    .io_south(pes_0_0_io_south),
    .io_west(pes_0_0_io_west),
    .io_ib0(pes_0_0_io_ib0),
    .io_ib1(pes_0_0_io_ib1),
    .io_cfgIn_selA(pes_0_0_io_cfgIn_selA),
    .io_cfgIn_selB(pes_0_0_io_cfgIn_selB),
    .io_cfgIn_op(pes_0_0_io_cfgIn_op),
    .io_cfgWrite(pes_0_0_io_cfgWrite),
    .io_out(pes_0_0_io_out)
  );
  ConfigurablePE pes_0_1 ( // @[MiniCGRA.scala 15:34]
    .clock(pes_0_1_clock),
    .reset(pes_0_1_reset),
    .io_north(pes_0_1_io_north),
    .io_east(pes_0_1_io_east),
    .io_south(pes_0_1_io_south),
    .io_west(pes_0_1_io_west),
    .io_ib0(pes_0_1_io_ib0),
    .io_ib1(pes_0_1_io_ib1),
    .io_cfgIn_selA(pes_0_1_io_cfgIn_selA),
    .io_cfgIn_selB(pes_0_1_io_cfgIn_selB),
    .io_cfgIn_op(pes_0_1_io_cfgIn_op),
    .io_cfgWrite(pes_0_1_io_cfgWrite),
    .io_out(pes_0_1_io_out)
  );
  ConfigurablePE pes_1_0 ( // @[MiniCGRA.scala 15:34]
    .clock(pes_1_0_clock),
    .reset(pes_1_0_reset),
    .io_north(pes_1_0_io_north),
    .io_east(pes_1_0_io_east),
    .io_south(pes_1_0_io_south),
    .io_west(pes_1_0_io_west),
    .io_ib0(pes_1_0_io_ib0),
    .io_ib1(pes_1_0_io_ib1),
    .io_cfgIn_selA(pes_1_0_io_cfgIn_selA),
    .io_cfgIn_selB(pes_1_0_io_cfgIn_selB),
    .io_cfgIn_op(pes_1_0_io_cfgIn_op),
    .io_cfgWrite(pes_1_0_io_cfgWrite),
    .io_out(pes_1_0_io_out)
  );
  ConfigurablePE pes_1_1 ( // @[MiniCGRA.scala 15:34]
    .clock(pes_1_1_clock),
    .reset(pes_1_1_reset),
    .io_north(pes_1_1_io_north),
    .io_east(pes_1_1_io_east),
    .io_south(pes_1_1_io_south),
    .io_west(pes_1_1_io_west),
    .io_ib0(pes_1_1_io_ib0),
    .io_ib1(pes_1_1_io_ib1),
    .io_cfgIn_selA(pes_1_1_io_cfgIn_selA),
    .io_cfgIn_selB(pes_1_1_io_cfgIn_selB),
    .io_cfgIn_op(pes_1_1_io_cfgIn_op),
    .io_cfgWrite(pes_1_1_io_cfgWrite),
    .io_out(pes_1_1_io_out)
  );
  InputBlock inputBlocks_0 ( // @[MiniCGRA.scala 16:39]
    .clock(inputBlocks_0_clock),
    .reset(inputBlocks_0_reset),
    .io_in_0(inputBlocks_0_io_in_0),
    .io_in_1(inputBlocks_0_io_in_1),
    .io_out_0(inputBlocks_0_io_out_0),
    .io_out_1(inputBlocks_0_io_out_1)
  );
  InputBlock inputBlocks_1 ( // @[MiniCGRA.scala 16:39]
    .clock(inputBlocks_1_clock),
    .reset(inputBlocks_1_reset),
    .io_in_0(inputBlocks_1_io_in_0),
    .io_in_1(inputBlocks_1_io_in_1),
    .io_out_0(inputBlocks_1_io_out_0),
    .io_out_1(inputBlocks_1_io_out_1)
  );
  PEOutputReg outputBlocks_0 ( // @[MiniCGRA.scala 17:40]
    .clock(outputBlocks_0_clock),
    .reset(outputBlocks_0_reset),
    .io_in(outputBlocks_0_io_in),
    .io_out(outputBlocks_0_io_out)
  );
  PEOutputReg outputBlocks_1 ( // @[MiniCGRA.scala 17:40]
    .clock(outputBlocks_1_clock),
    .reset(outputBlocks_1_reset),
    .io_in(outputBlocks_1_io_in),
    .io_out(outputBlocks_1_io_out)
  );
  assign io_obOut_0 = outputBlocks_0_io_out; // @[MiniCGRA.scala 28:19]
  assign io_obOut_1 = outputBlocks_1_io_out; // @[MiniCGRA.scala 28:19]
  assign pes_0_0_clock = clock;
  assign pes_0_0_reset = reset;
  assign pes_0_0_io_north = 16'h0; // @[MiniCGRA.scala 38:19]
  assign pes_0_0_io_east = pes_0_1_io_out; // @[MiniCGRA.scala 41:19]
  assign pes_0_0_io_south = pes_1_0_io_out; // @[MiniCGRA.scala 39:19]
  assign pes_0_0_io_west = 16'h0; // @[MiniCGRA.scala 40:19]
  assign pes_0_0_io_ib0 = inputBlocks_0_io_out_0; // @[MiniCGRA.scala 32:17]
  assign pes_0_0_io_ib1 = inputBlocks_0_io_out_1; // @[MiniCGRA.scala 33:17]
  assign pes_0_0_io_cfgIn_selA = io_cfgIn[2:0]; // @[MiniCGRA.scala 23:26]
  assign pes_0_0_io_cfgIn_selB = io_cfgIn[5:3]; // @[MiniCGRA.scala 22:26]
  assign pes_0_0_io_cfgIn_op = io_cfgIn[7:6]; // @[MiniCGRA.scala 21:26]
  assign pes_0_0_io_cfgWrite = io_cfgWrite & io_cfgAddr == 2'h0; // @[MiniCGRA.scala 35:37]
  assign pes_0_1_clock = clock;
  assign pes_0_1_reset = reset;
  assign pes_0_1_io_north = 16'h0; // @[MiniCGRA.scala 38:19]
  assign pes_0_1_io_east = 16'h0; // @[MiniCGRA.scala 41:19]
  assign pes_0_1_io_south = pes_1_1_io_out; // @[MiniCGRA.scala 39:19]
  assign pes_0_1_io_west = pes_0_0_io_out; // @[MiniCGRA.scala 40:19]
  assign pes_0_1_io_ib0 = inputBlocks_0_io_out_0; // @[MiniCGRA.scala 32:17]
  assign pes_0_1_io_ib1 = inputBlocks_0_io_out_1; // @[MiniCGRA.scala 33:17]
  assign pes_0_1_io_cfgIn_selA = io_cfgIn[2:0]; // @[MiniCGRA.scala 23:26]
  assign pes_0_1_io_cfgIn_selB = io_cfgIn[5:3]; // @[MiniCGRA.scala 22:26]
  assign pes_0_1_io_cfgIn_op = io_cfgIn[7:6]; // @[MiniCGRA.scala 21:26]
  assign pes_0_1_io_cfgWrite = io_cfgWrite & io_cfgAddr == 2'h1; // @[MiniCGRA.scala 35:37]
  assign pes_1_0_clock = clock;
  assign pes_1_0_reset = reset;
  assign pes_1_0_io_north = pes_0_0_io_out; // @[MiniCGRA.scala 38:19]
  assign pes_1_0_io_east = pes_1_1_io_out; // @[MiniCGRA.scala 41:19]
  assign pes_1_0_io_south = 16'h0; // @[MiniCGRA.scala 39:19]
  assign pes_1_0_io_west = 16'h0; // @[MiniCGRA.scala 40:19]
  assign pes_1_0_io_ib0 = inputBlocks_1_io_out_0; // @[MiniCGRA.scala 32:17]
  assign pes_1_0_io_ib1 = inputBlocks_1_io_out_1; // @[MiniCGRA.scala 33:17]
  assign pes_1_0_io_cfgIn_selA = io_cfgIn[2:0]; // @[MiniCGRA.scala 23:26]
  assign pes_1_0_io_cfgIn_selB = io_cfgIn[5:3]; // @[MiniCGRA.scala 22:26]
  assign pes_1_0_io_cfgIn_op = io_cfgIn[7:6]; // @[MiniCGRA.scala 21:26]
  assign pes_1_0_io_cfgWrite = io_cfgWrite & io_cfgAddr == 2'h2; // @[MiniCGRA.scala 35:37]
  assign pes_1_1_clock = clock;
  assign pes_1_1_reset = reset;
  assign pes_1_1_io_north = pes_0_1_io_out; // @[MiniCGRA.scala 38:19]
  assign pes_1_1_io_east = 16'h0; // @[MiniCGRA.scala 41:19]
  assign pes_1_1_io_south = 16'h0; // @[MiniCGRA.scala 39:19]
  assign pes_1_1_io_west = pes_1_0_io_out; // @[MiniCGRA.scala 40:19]
  assign pes_1_1_io_ib0 = inputBlocks_1_io_out_0; // @[MiniCGRA.scala 32:17]
  assign pes_1_1_io_ib1 = inputBlocks_1_io_out_1; // @[MiniCGRA.scala 33:17]
  assign pes_1_1_io_cfgIn_selA = io_cfgIn[2:0]; // @[MiniCGRA.scala 23:26]
  assign pes_1_1_io_cfgIn_selB = io_cfgIn[5:3]; // @[MiniCGRA.scala 22:26]
  assign pes_1_1_io_cfgIn_op = io_cfgIn[7:6]; // @[MiniCGRA.scala 21:26]
  assign pes_1_1_io_cfgWrite = io_cfgWrite & io_cfgAddr == 2'h3; // @[MiniCGRA.scala 35:37]
  assign inputBlocks_0_clock = clock;
  assign inputBlocks_0_reset = reset;
  assign inputBlocks_0_io_in_0 = io_ibIn_0_0; // @[MiniCGRA.scala 26:28]
  assign inputBlocks_0_io_in_1 = io_ibIn_0_1; // @[MiniCGRA.scala 26:28]
  assign inputBlocks_1_clock = clock;
  assign inputBlocks_1_reset = reset;
  assign inputBlocks_1_io_in_0 = io_ibIn_1_0; // @[MiniCGRA.scala 26:28]
  assign inputBlocks_1_io_in_1 = io_ibIn_1_1; // @[MiniCGRA.scala 26:28]
  assign outputBlocks_0_clock = clock;
  assign outputBlocks_0_reset = reset;
  assign outputBlocks_0_io_in = pes_0_1_io_out; // @[MiniCGRA.scala 27:29]
  assign outputBlocks_1_clock = clock;
  assign outputBlocks_1_reset = reset;
  assign outputBlocks_1_io_in = pes_1_1_io_out; // @[MiniCGRA.scala 27:29]
endmodule
