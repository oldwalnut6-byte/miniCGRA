# MiniCGRA

一个用于学习 CGRA 架构和开发方法的小工程。硬件使用 sbt + Chisel 开发，通过 Verilator 和 C++ 程序进行仿真。

工程实现了一个 2×2 PE 阵列，支持配置运算和数据来源。目前运行的 kernel 是 `y = a * b + c`，用它验证配置加载、邻接互连和流水计算。

## 硬件架构

`MiniCGRA` 顶层包含四个 PE、两个输入块 IB、两个输出块 OB，以及配置译码逻辑。IB 和 OB 统称 IOB。

```text
                  MiniCGRA

  IB[0] ──→ PE[0][0] ⇄ PE[0][1] ──→ OB[0]
                ⇅          ⇅
  IB[1] ──→ PE[1][0] ⇄ PE[1][1] ──→ OB[1]

  cfgAddr / cfgIn / cfgWrite ──→ 各 PE 的配置寄存器
  clock / reset             ──→ 各 PE 和 IOB
```

PE 按 `[行][列]` 编号，行从上向下、列从左向右增加。PE 之间采用 N2N（neighbor-to-neighbor）连接，只连接上下左右的邻居，边界缺失的输入接零。每个 PE 的同一路输出可以同时送往邻居和 OB。

配置和计算数据使用独立接口。外部程序先复位、写入四个 PE 的配置，再送入数据。阵列没有 `start/done` 或 `valid/ready` 信号，所有 PE 每周期更新，数据何时有效由仿真程序根据流水延迟判断。

### PE

```text
  ZERO / N / E / S / W / IB0 / IB1
                   │
          ┌────────┴────────┐
          ▼                 ▼
       MUX A             MUX B
          └────────┬────────┘
                   ▼
                  ALU
                   │
                   ▼
               输出寄存器 ──→ out

  配置寄存器控制两个 MUX 和 ALU
```

数据通路宽度为 16 bit，使用无符号数。ALU 支持 PASS、ADD 和 MUL，加法与乘法均保留结果的低 16 bit。

每个 PE 的输出经过一级寄存器，MUX 和 ALU 为组合逻辑。PASS 既可以转发数据，也可以用来对齐不同路径的流水延迟。

### IOB

IB 的每路输出和 OB 的输出都带一级 16 bit 寄存器，每个上升沿采样输入，复位时清零。IOB 与 PE 共用时钟和复位，没有独立配置或使能。

| 模块 | 输入 | 输出 | 连接方式 |
| --- | --- | --- | --- |
| `InputBlock` | 两路 16 bit | 两路 16 bit | 寄存一拍，顶层按行广播给两个 PE |
| `OutputBlock` | 一路 16 bit | 一路 16 bit | 将本行最右侧 PE 的输出再寄存一拍后导出 |

对于第 `r` 行，连接关系为：

```text
ibIn[r][0] → IB[r] → PE[r][0].ib0、PE[r][1].ib0
ibIn[r][1] → IB[r] → PE[r][0].ib1、PE[r][1].ib1

PE[r][1].out → OB[r] → obOut[r]
```

两个 IB 共提供四路独立输入。同一行的两个 PE 看到相同的输入对，各自通过 MUX 选择是否使用。IB 通道与 N/E/S/W 邻接输入相互独立，不占用西侧端口。

两个 OB 共导出两路数据，具体哪一路作为计算结果由 kernel 映射决定。

### 顶层接口

下表省略 `io.` 前缀。时钟和复位使用 Chisel 模块的 `clock`、`reset`，复位高有效，复位时需要推进时钟。

| 端口 | 方向 | 宽度 | 含义 |
| --- | --- | --- | --- |
| `ibIn` | 输入 | 2 行 × 2 路 × 16 bit | `[行号][通道号]` |
| `obOut` | 输出 | 2 路 × 16 bit | 每行一路输出 |
| `cfgAddr` | 输入 | 2 bit | PE 地址，`row * 2 + col` |
| `cfgIn` | 输入 | 8 bit | PE 配置字 |
| `cfgWrite` | 输入 | 1 bit | 配置写使能 |

### 配置 ISA

每个 PE 保存一个 8 bit 静态配置字。配置写入后，PE 每周期重复执行指定操作。

| 位段 | 字段 | 含义 |
| --- | --- | --- |
| `[7:6]` | `op` | ALU 操作 |
| `[5:3]` | `selB` | 操作数 B 来源 |
| `[2:0]` | `selA` | 操作数 A 来源 |

```cpp
uint8_t config = (op << 6) | (selB << 3) | selA;
```

| 选择编码 | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 来源 | ZERO | N | E | S | W | IB0 | IB1 | 保留，接零 |

| 操作编码 | 0 | 1 | 2 | 3 |
| --- | --- | --- | --- | --- |
| 操作 | PASS A | ADD | MUL | 保留，输出零 |

`cfgWrite` 为高时，在上升沿将配置写入 `cfgAddr` 指定的 PE，其他 PE 保持配置。地址 0、1、2、3 分别对应 PE[0][0]、PE[0][1]、PE[1][0]、PE[1][1]。

复位时 PE 配置、PE 输出和 IOB 寄存器清零。配置 `0x00` 用于空闲 PE，使其每周期输出零。配置期间数据通路仍在运行，输出应忽略；重新配置之前，需要先取完旧任务的结果。

## 乘加 kernel

计算目标为：

```text
y = (a * b + c) mod 65536
```

`a`、`b`、`c` 同周期输入，均为 16 bit 无符号数。`a/b` 接 IB[0] 的两路输入，`c` 接 IB[1] 的第 0 路，第 1 路暂不使用。

```text
 a、b → PE[0][0]: MUL ──→ PE[0][1]: ADD ──→ OB[0]: y
                                ↑
        PE[1][0]: 空闲    PE[1][1]: PASS
                                ↑
                                c
```

| 地址 | PE | 配置字 | 功能 |
| --- | --- | --- | --- |
| 0 | PE[0][0] | `0xB5` | IB0 × IB1 |
| 1 | PE[0][1] | `0x5C` | W + S |
| 2 | PE[1][0] | `0x00` | 输出零 |
| 3 | PE[1][1] | `0x05` | 转发 IB0，将 c 延迟一拍 |

乘积和 c 各经过一个 PE 寄存器后，同时到达 ADD。结果从 OB[0] 输出，OB[1] 可以观察延迟后的 c。

完整数据路径为 `IB 寄存器 → MUL/PASS 寄存器 → ADD 寄存器 → OB 寄存器`。

| 上升沿 | 外部输入 | IB 输出 | MUL / PASS 输出 | ADD 输出 | OB[0] |
| --- | --- | --- | --- | --- | --- |
| E0 | 第 0 组 | 第 0 组 | 忽略 | 忽略 | 忽略 |
| E1 | 第 1 组 | 第 1 组 | p₀ / c₀ | 忽略 | 忽略 |
| E2 | 第 2 组 | 第 2 组 | p₁ / c₁ | y₀ | 忽略 |
| E3 | 第 3 组 | 第 3 组 | p₂ / c₂ | y₁ | y₀ |
| E4 | 第 4 组 | 第 4 组 | p₃ / c₃ | y₂ | y₁ |

E0 被 IB 采样的输入，在 E3 更新后从 OB[0] 得到结果，之后每周期输出一组。最后一组输入采样后，再推进三个上升沿取完结果。OB[1] 的路径少经过一个 PE，因此 c₀ 在 E2 更新后可见。

## Verilator 仿真

C++ 程序直接驱动 Verilator 生成的电路模型，不使用 SV 测试顶层。

```text
Chisel → Verilog → Verilator 模型
                         ↑ 时钟、复位、配置、输入
                         ↓ 输出
                      C++ 测试程序
```

仿真使用软件参考函数计算期望值，再按流水时序与电路输出逐项比较：

```cpp
uint16_t reference(uint16_t a, uint16_t b, uint16_t c) {
    return static_cast<uint16_t>(uint64_t(a) * b + c);
}
```

参考函数只表达算法，不模拟 PE 内部结构。使用宽整数完成运算，再截断为 16 bit，使数值含义与硬件一致。

每次送入一组数据时，软件保存输入和期望值。模型推进到对应结果的上升沿后，检查 OB[0]；不能将当前输出直接与当前输入的参考结果比较。对于上述映射，E3 检查第 0 组，E4 检查第 1 组。启动时忽略无效输出，输入结束后取完流水中的结果。

当前测试程序为 `sim/test_minicgra.cpp`，包含互连、边界接零、保留编码、复位和配置保持检查，以及两轮共 2012 组乘加输入。乘加测试包括边界值和固定种子的随机数据，已通过 2095 个周期的仿真。发生不匹配时返回非零退出码。

独立 PE 的完整测试和 VCD 波形输出尚未加入。

### 运行

需要 JDK、sbt、Verilator、C++ 编译器和 make。项目使用 Scala 2.13.7、Chisel 3.5.4、sbt 1.12.4。

```bash
make gen   # 生成完整阵列 RTL 到 generated/
make sim   # 生成 RTL、构建并运行 C++ 仿真
```

已经生成 RTL 时，也可以单独构建和运行：

```bash
verilator --cc --exe --build --top-module MiniCGRA \
  generated/*.v sim/test_minicgra.cpp
./obj_dir/VMiniCGRA
```

## 目录

```text
src/scala/
├── ALU.scala
├── OperandMux.scala
├── PEConfigReg.scala
├── PEOutputReg.scala
├── ConfigurablePE.scala
├── InputBlock.scala
├── OutputBlock.scala
├── MiniCGRA.scala
└── Generate.scala
sim/test_minicgra.cpp    # C++ 激励与结果检查
build.sbt               # Chisel 构建配置
Makefile                # 生成与仿真命令
generated/              # 生成的 RTL
```
