package minicgra

import chisel3._

class ALU extends Module {
  val io = IO(new Bundle {
    val a   = Input(UInt(16.W))
    val b   = Input(UInt(16.W))
    val op  = Input(UInt(2.W))
    val out = Output(UInt(16.W))
  })

  val pass = io.a
  val sum = (io.a +& io.b)(15, 0)
  val product = (io.a * io.b)(15, 0)

  val results = VecInit(Seq(
    pass,      // 0: PASS
    sum,       // 1: ADD
    product,   // 2: MUL
    0.U(16.W)  // 3: 保留
  ))

  io.out := results(io.op)
}


