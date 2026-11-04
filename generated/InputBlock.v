module InputBlock(
  input         clock,
  input         reset,
  input  [15:0] io_in_0,
  input  [15:0] io_in_1,
  output [15:0] io_out_0,
  output [15:0] io_out_1
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
`endif // RANDOMIZE_REG_INIT
  reg [15:0] data_0; // @[InputBlock.scala 12:21]
  reg [15:0] data_1; // @[InputBlock.scala 12:21]
  assign io_out_0 = data_0; // @[InputBlock.scala 14:10]
  assign io_out_1 = data_1; // @[InputBlock.scala 14:10]
  always @(posedge clock) begin
    if (reset) begin // @[InputBlock.scala 12:21]
      data_0 <= 16'h0; // @[InputBlock.scala 12:21]
    end else begin
      data_0 <= io_in_0; // @[InputBlock.scala 13:8]
    end
    if (reset) begin // @[InputBlock.scala 12:21]
      data_1 <= 16'h0; // @[InputBlock.scala 12:21]
    end else begin
      data_1 <= io_in_1; // @[InputBlock.scala 13:8]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  data_0 = _RAND_0[15:0];
  _RAND_1 = {1{`RANDOM}};
  data_1 = _RAND_1[15:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
