module PEConfigReg(
  input        clock,
  input        reset,
  input  [2:0] io_in_selA,
  input  [2:0] io_in_selB,
  input  [1:0] io_in_op,
  input        io_write,
  output [2:0] io_out_selA,
  output [2:0] io_out_selB,
  output [1:0] io_out_op
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
`endif // RANDOMIZE_REG_INIT
  reg [2:0] config_selA; // @[Reg.scala 35:20]
  reg [2:0] config_selB; // @[Reg.scala 35:20]
  reg [1:0] config_op; // @[Reg.scala 35:20]
  assign io_out_selA = config_selA; // @[PEConfigReg.scala 22:10]
  assign io_out_selB = config_selB; // @[PEConfigReg.scala 22:10]
  assign io_out_op = config_op; // @[PEConfigReg.scala 22:10]
  always @(posedge clock) begin
    if (reset) begin // @[Reg.scala 35:20]
      config_selA <= 3'h0; // @[Reg.scala 35:20]
    end else if (io_write) begin // @[Reg.scala 36:18]
      config_selA <= io_in_selA; // @[Reg.scala 36:22]
    end
    if (reset) begin // @[Reg.scala 35:20]
      config_selB <= 3'h0; // @[Reg.scala 35:20]
    end else if (io_write) begin // @[Reg.scala 36:18]
      config_selB <= io_in_selB; // @[Reg.scala 36:22]
    end
    if (reset) begin // @[Reg.scala 35:20]
      config_op <= 2'h0; // @[Reg.scala 35:20]
    end else if (io_write) begin // @[Reg.scala 36:18]
      config_op <= io_in_op; // @[Reg.scala 36:22]
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
  config_selA = _RAND_0[2:0];
  _RAND_1 = {1{`RANDOM}};
  config_selB = _RAND_1[2:0];
  _RAND_2 = {1{`RANDOM}};
  config_op = _RAND_2[1:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
