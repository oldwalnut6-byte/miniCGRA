package minicgra

import chisel3._
import chisel3.util.RegEnable

class PEConfig extends Bundle {
  val selA = UInt(3.W)
  val selB = UInt(3.W)
  val op   = UInt(2.W)
}

class PEConfigReg extends Module {
  val io = IO(new Bundle {
    val in    = Input(new PEConfig)
    val write = Input(Bool())
    val out   = Output(new PEConfig)
  })


  //reg write enable
  val config = RegEnable(io.in, 0.U.asTypeOf(new PEConfig), io.write)
  io.out := config
}