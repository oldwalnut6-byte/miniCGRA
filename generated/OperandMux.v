module OperandMux(
  input  [15:0] io_in_1,
  input  [15:0] io_in_2,
  input  [15:0] io_in_3,
  input  [15:0] io_in_4,
  input  [15:0] io_in_5,
  input  [15:0] io_in_6,
  input  [2:0]  io_sel,
  output [15:0] io_out
);
  wire [15:0] _GEN_1 = 3'h1 == io_sel ? io_in_1 : 16'h0; // @[OperandMux.scala 12:{10,10}]
  wire [15:0] _GEN_2 = 3'h2 == io_sel ? io_in_2 : _GEN_1; // @[OperandMux.scala 12:{10,10}]
  wire [15:0] _GEN_3 = 3'h3 == io_sel ? io_in_3 : _GEN_2; // @[OperandMux.scala 12:{10,10}]
  wire [15:0] _GEN_4 = 3'h4 == io_sel ? io_in_4 : _GEN_3; // @[OperandMux.scala 12:{10,10}]
  wire [15:0] _GEN_5 = 3'h5 == io_sel ? io_in_5 : _GEN_4; // @[OperandMux.scala 12:{10,10}]
  wire [15:0] _GEN_6 = 3'h6 == io_sel ? io_in_6 : _GEN_5; // @[OperandMux.scala 12:{10,10}]
  assign io_out = 3'h7 == io_sel ? 16'h0 : _GEN_6; // @[OperandMux.scala 12:{10,10}]
endmodule
