package minicgra

import chisel3._

/** Fixed 2x2 array with row-broadcast inputs and nearest-neighbor links. */
class MiniCGRA extends Module {
  val io = IO(new Bundle {
    val ibIn     = Input(Vec(2, Vec(2, UInt(16.W))))
    val obOut    = Output(Vec(2, UInt(16.W)))
    val cfgAddr  = Input(UInt(2.W))
    val cfgIn    = Input(UInt(8.W))
    val cfgWrite = Input(Bool())
  })

  val pes = Seq.fill(2, 2)(Module(new ConfigurablePE))
  val inputBlocks = Seq.fill(2)(Module(new InputBlock))
  val outputBlocks = Seq.fill(2)(Module(new OutputBlock))

  // Explicit ISA decoding: [7:6] op, [5:3] selB, [2:0] selA.
  val config = Wire(new PEConfig)
  config.op   := io.cfgIn(7, 6)
  config.selB := io.cfgIn(5, 3)
  config.selA := io.cfgIn(2, 0)

  for (row <- 0 until 2) {
    inputBlocks(row).io.in := io.ibIn(row)
    outputBlocks(row).io.in := pes(row)(1).io.out
    io.obOut(row) := outputBlocks(row).io.out

    for (col <- 0 until 2) {
      val pe = pes(row)(col)
      pe.io.ib0 := inputBlocks(row).io.out(0)
      pe.io.ib1 := inputBlocks(row).io.out(1)
      pe.io.cfgIn := config
      pe.io.cfgWrite := io.cfgWrite && (io.cfgAddr === (row * 2 + col).U)

      // Missing neighbors are zero; links always carry registered PE outputs.
      pe.io.north := (if (row > 0) pes(row - 1)(col).io.out else 0.U(16.W))
      pe.io.south := (if (row < 1) pes(row + 1)(col).io.out else 0.U(16.W))
      pe.io.west  := (if (col > 0) pes(row)(col - 1).io.out else 0.U(16.W))
      pe.io.east  := (if (col < 1) pes(row)(col + 1).io.out else 0.U(16.W))
    }
  }
}
