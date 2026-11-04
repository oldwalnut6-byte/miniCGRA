package minicgra

import chisel3.stage.{ChiselGeneratorAnnotation, ChiselStage}

object Generate extends App {
  (new ChiselStage).execute(
    Array("--target-dir", "generated", "--emit-modules", "verilog"),
    Seq(ChiselGeneratorAnnotation(() => new MiniCGRA))
  )
}
