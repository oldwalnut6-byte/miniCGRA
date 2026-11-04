package minicgra

import chisel3._

/** Registers the array output for one additional pipeline stage. */
class OutputBlock extends Module {
  val io = IO(new Bundle {
    val in  = Input(UInt(16.W))
    val out = Output(UInt(16.W))
  })

  val data = RegInit(0.U(16.W))
  data := io.in
  io.out := data
}
