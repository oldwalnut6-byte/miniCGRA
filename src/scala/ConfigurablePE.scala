package minicgra

import chisel3._

class ConfigurablePE extends Module {
  val io = IO(new Bundle {
    //inputs from other PEs
    val north = Input(UInt(16.W))
    val east  = Input(UInt(16.W))
    val south = Input(UInt(16.W))
    val west  = Input(UInt(16.W))

    //IB input
    val ib0   = Input(UInt(16.W))
    val ib1   = Input(UInt(16.W))

    val cfgIn    = Input(new PEConfig)  //PE confige data input
    val cfgWrite = Input(Bool())        //PE confige data write enable
    val out      = Output(UInt(16.W))   //PE output
  })

  //shi li hua
  val configReg = Module(new PEConfigReg)
  val muxA      = Module(new OperandMux)
  val muxB      = Module(new OperandMux)
  val alu       = Module(new ALU)
  val outputReg = Module(new PEOutputReg)

  configReg.io.in    := io.cfgIn
  configReg.io.write := io.cfgWrite

  //a inputs vector
  val sources = VecInit(Seq(
    0.U(16.W), // 0: ZERO
    io.north,  // 1: N
    io.east,   // 2: E
    io.south,  // 3: S
    io.west,   // 4: W
    io.ib0,    // 5: IB0
    io.ib1,    // 6: IB1
    0.U(16.W)  // 7: 保留
  ))

  muxA.io.in  := sources
  muxB.io.in  := sources
  muxA.io.sel := configReg.io.out.selA
  muxB.io.sel := configReg.io.out.selB

  alu.io.a  := muxA.io.out
  alu.io.b  := muxB.io.out
  alu.io.op := configReg.io.out.op

  outputReg.io.in := alu.io.out
  io.out := outputReg.io.out
}