package minicgra

import chisel3._

class OperandMux extends Module {
  val io = IO(new Bundle {
    val in  = Input(Vec(8, UInt(16.W)))
    val sel = Input(UInt(3.W))
    val out = Output(UInt(16.W))
  })

  io.out := io.in(io.sel)
}