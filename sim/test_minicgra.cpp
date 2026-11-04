#include "VMiniCGRA.h"
#include "verilated.h"
#include <cstdint>
#include <cstdio>

// 推进一个完整时钟周期，上升沿之后模型的寄存器完成更新。
void tick(VMiniCGRA* dut) {
    dut->clock = 0;
    dut->eval();
    dut->clock = 1;
    dut->eval();
    dut->clock = 0;
    dut->eval();
}

// 软件 golden：保留乘加结果的低 16 bit，与硬件一致。
uint16_t golden(uint16_t a, uint16_t b, uint16_t c) {
    return static_cast<uint16_t>(uint64_t(a) * b + c);
}

// 初始化输入，保持复位两个时钟周期。
void reset_cgra(VMiniCGRA* dut) {
    dut->clock = 0;
    dut->reset = 1;
    dut->io_cfgWrite = 0;
    dut->io_cfgAddr = 0;
    dut->io_cfgIn = 0;
    dut->io_ibIn_0_0 = 0;
    dut->io_ibIn_0_1 = 0;
    dut->io_ibIn_1_0 = 0;
    dut->io_ibIn_1_1 = 0;
    tick(dut);
    tick(dut);      //复位两个时钟周期
    dut->reset = 0; //reset拉低 启动电路
}

// 按地址依次写入四个 PE 的配置。
void configure_cgra(VMiniCGRA* dut, const uint8_t config[4]) {
    for (int i = 0; i < 4; ++i) {
        dut->io_cfgAddr = i;        //配置地址
        dut->io_cfgIn = config[i];  //配置数据ISA
        dut->io_cfgWrite = 1;       //配置数据写使能
        tick(dut);
        std::printf("PE[%d][%d] config = 0x%02X\n", i / 2, i % 2,
                    static_cast<unsigned>(config[i]));
    }
    dut->io_cfgWrite = 0;       //拉低写是能
}

// 连续输入并保存结果。E0 采样、E3 输出，最后多跑三个周期排空流水。
void run_cgra(VMiniCGRA* dut, const uint16_t a[], const uint16_t b[],
              const uint16_t c[], uint16_t result[], int count) {
                
    dut->io_ibIn_1_1 = 0;

    for (int cycle = 0; cycle < count + 3; ++cycle) {
        dut->io_ibIn_0_0 = cycle < count ? a[cycle] : 0;
        dut->io_ibIn_0_1 = cycle < count ? b[cycle] : 0;
        dut->io_ibIn_1_0 = cycle < count ? c[cycle] : 0;
        tick(dut);
        if (cycle >= 3) {
            //CGRA的计算数据需要3个时钟周期才能从IB寄存器中输出出来
            result[cycle - 3] = dut->io_obOut_0;
        }
    }
}

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    VMiniCGRA dut;

    //测试集
    const int count = 10;
    const uint16_t a[count] = {2, 3, 10, 0, 1, 256, 65535, 65535, 123, 42};
    const uint16_t b[count] = {3, 4, 20, 65535, 65535, 256, 65535, 1, 456, 7};
    const uint16_t c[count] = {4, 5, 30, 17, 1, 1, 65535, 0, 789, 9};
    uint16_t result[count] = {};



    // 1. 上电复位，然后依次写入四个 PE 的配置。
    std::printf("=== 1. Reset and configure ===\n");
    reset_cgra(&dut);



    // PE00: MUL，PE01: ADD，PE10: 空闲，PE11: PASS c。 配置PE
    const uint8_t config[4] = {0xB5, 0x5C, 0x00, 0x05};
    configure_cgra(&dut, config);

    std::printf("\n=== 2. Run CGRA (%d inputs) ===\n", count);

    //为CGRA输入数据进行计算并保存结果到result.
    run_cgra(&dut, a, b, c, result, count);


    // 3. 打印 CGRA 结果和软件 golden，逐组比较。
    std::printf("\n=== 3. Compare with golden ===\n");
    int errors = 0;

    //逐行打印比对信息。
    for (int i = 0; i < count; ++i) {
        const uint16_t expected = golden(a[i], b[i], c[i]);     //计算标准数据
        const bool pass = result[i] == expected;
        std::printf("[%2d] a=%5u b=%5u c=%5u | CGRA=%5u golden=%5u | %s\n",
                    i, static_cast<unsigned>(a[i]), static_cast<unsigned>(b[i]),
                    static_cast<unsigned>(c[i]), static_cast<unsigned>(result[i]),
                    static_cast<unsigned>(expected), pass ? "PASS" : "FAIL");
        if (!pass) ++errors;
    }
    std::printf("\n%d/%d passed\n", count - errors, count);
    dut.final();
    return errors == 0 ? 0 : 1;
}
