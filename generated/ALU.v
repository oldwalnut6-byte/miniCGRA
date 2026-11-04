module ALU(
  input  [15:0] io_a,
  input  [15:0] io_b,
  input  [1:0]  io_op,
  output [15:0] io_out
);
  wire [16:0] _sum_T = io_a + io_b; // @[ALU.scala 14:19]
  wire [15:0] sum = _sum_T[15:0]; // @[ALU.scala 14:27]
  wire [31:0] _product_T = io_a * io_b; // @[ALU.scala 15:23]
  wire [15:0] product = _product_T[15:0]; // @[ALU.scala 15:30]
  wire [15:0] _GEN_1 = 2'h1 == io_op ? sum : io_a; // @[ALU.scala 24:{10,10}]
  wire [15:0] _GEN_2 = 2'h2 == io_op ? product : _GEN_1; // @[ALU.scala 24:{10,10}]
  assign io_out = 2'h3 == io_op ? 16'h0 : _GEN_2; // @[ALU.scala 24:{10,10}]
endmodule
