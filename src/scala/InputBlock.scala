package minicgra

import chisel3._

/** Two registered input channels; row broadcast is wired by MiniCGRA. */
class InputBlock extends Module {
  val io = IO(new Bundle {
    val in  = Input(Vec(2, UInt(16.W)))
    val out = Output(Vec(2, UInt(16.W)))
  })

  val data = RegInit(VecInit(Seq.fill(2)(0.U(16.W))))
  data := io.in
  io.out := data
}
