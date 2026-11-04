#include "VMiniCGRA.h"
#include "verilated.h"
#include <array>
#include <cstdint>
#include <iostream>
#include <random>
#include <stdexcept>
#include <vector>

uint16_t reference(uint16_t a, uint16_t b, uint16_t c) {
    return static_cast<uint16_t>(uint64_t(a) * b + c);
}

class Testbench {
public:
    VMiniCGRA dut;
    unsigned cycles = 0;

    void tick() {
        dut.clock = 0;
        dut.eval();
        dut.clock = 1;
        dut.eval();
        ++cycles;
        dut.clock = 0;
        dut.eval();
    }

    void expect(unsigned row, uint16_t expected) {
        const auto actual = row == 0 ? dut.io_obOut_0 : dut.io_obOut_1;
        if (actual != expected) {
            throw std::runtime_error("cycle=" + std::to_string(cycles) +
                " row=" + std::to_string(row) + " expected=" +
                std::to_string(expected) + " actual=" + std::to_string(actual));
        }
    }

    void reset() {
        dut.io_cfgWrite = 0;
        dut.io_cfgAddr = 0;
        dut.io_cfgIn = 0;
        inputs(0, 0, 0, 0);
        dut.reset = 1;
        tick();
        expect(0, 0);
        expect(1, 0);
        dut.reset = 0;
    }

    void configure(const std::array<uint8_t, 4>& words) {
        for (unsigned addr = 0; addr < 4; ++addr) {
            dut.io_cfgAddr = addr;
            dut.io_cfgIn = words[addr];
            dut.io_cfgWrite = 1;
            tick();
        }
        dut.io_cfgWrite = 0;
        // Changing the bus without write enable must not change any config.
        dut.io_cfgIn = 0xff;
    }

    void inputs(uint16_t a, uint16_t b, uint16_t c, uint16_t d) {
        dut.io_ibIn_0_0 = a;
        dut.io_ibIn_0_1 = b;
        dut.io_ibIn_1_0 = c;
        dut.io_ibIn_1_1 = d;
    }
};

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    try {
        Testbench tb;
        tb.reset();
        // Route both rows' IB channels through left PEs and west links.
        for (uint8_t source : {5, 6}) {
            tb.configure({source, 4, source, 4});
            tb.inputs(11, 22, 33, 44);
            for (int i = 0; i < 4; ++i) tb.tick();
            tb.expect(0, source == 5 ? 11 : 22);
            tb.expect(1, source == 5 ? 33 : 44);
        }
        // East links into left PEs, then vertical links, then west to OB.
        tb.configure({2, 5, 1, 4});
        tb.inputs(1234, 0, 0, 0);
        for (int i = 0; i < 6; ++i) tb.tick();
        tb.expect(1, 1234);
        tb.configure({3, 4, 2, 5});
        tb.inputs(0, 0, 4321, 0);
        for (int i = 0; i < 6; ++i) tb.tick();
        tb.expect(0, 4321);
        // Missing boundary sources and reserved source/op produce zero.
        for (uint8_t source : {0, 1, 2, 7}) {
            tb.configure({0, source, 0, 3});
            tb.tick();
            tb.tick();
            tb.expect(0, 0);
            tb.expect(1, 0);
        }
        tb.configure({0, 0xc5, 0, 0xc6});
        tb.tick();
        tb.tick();
        tb.expect(0, 0);
        tb.expect(1, 0);

        // Run the kernel twice, including a reset and full reconfiguration.
        std::mt19937 rng(20261103);
        const std::array<std::array<uint16_t, 3>, 6> edges = {{{0,0,0},
            {0,65535,17}, {1,65535,0}, {65535,65535,65535},
            {256,256,1}, {1,65535,1}}};
        for (int run = 0; run < 2; ++run) {
            tb.reset();
            tb.configure({0xb5, 0x5c, 0x00, 0x05});
            std::vector<std::array<uint16_t, 3>> samples;
            for (unsigned i = 0; i < 1006; ++i) {
                const uint16_t a = i < edges.size() ? edges[i][0] : rng();
                const uint16_t b = i < edges.size() ? edges[i][1] : rng();
                const uint16_t c = i < edges.size() ? edges[i][2] : rng();
                samples.push_back({a, b, c});
            }
            // Input sampled at E0 reaches OB[0] at E3 and OB[1] at E2.
            // Three extra edges drain the final results from the pipeline.
            for (unsigned i = 0; i < samples.size() + 3; ++i) {
                const auto input = i < samples.size() ? samples[i] :
                    std::array<uint16_t, 3>{0, 0, 0};
                tb.inputs(input[0], input[1], input[2], rng());
                tb.tick();
                if (i >= 3) {
                    const auto sample = samples[i - 3];
                    try {
                        tb.expect(0, reference(sample[0], sample[1], sample[2]));
                    } catch (const std::exception&) {
                        std::cerr << "run=" << run << " sample=" << i - 3
                                  << " a=" << sample[0] << " b=" << sample[1]
                                  << " c=" << sample[2] << '\n';
                        throw;
                    }
                }
                if (i >= 2 && i - 2 < samples.size()) {
                    tb.expect(1, samples[i - 2][2]);
                }
            }
        }
        tb.dut.final();
        std::cout << "PASS: routing, reset, configuration, and 2012 kernel inputs ("
                  << tb.cycles << " cycles)\n";
        return 0;
    } catch (const std::exception& error) {
        std::cerr << "FAIL: " << error.what() << '\n';
        return 1;
    }
}
