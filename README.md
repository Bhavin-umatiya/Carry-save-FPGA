# 64-Bit Parameterized Carry Save Adder (CSA) – Verilog RTL

## 📌 Architecture Overview
RTL implementation of a high-performance **64-bit Carry Save Adder (CSA)** using Verilog HDL. The design efficiently computes the sum of three massive 64-bit operands simultaneously, significantly reducing the critical path delay associated with conventional carry propagation.

Designed for scalability, the module is entirely **parameterized**, allowing it to be instantiated at any arbitrary bit-width. It targets high-speed VLSI arithmetic circuits such as Wallance Tree Multipliers, DSP blocks, and FPGA arithmetic accelerators.

## 🧠 Hardware Design & Datapath
Instead of propagating carry bits sequentially across all 64 bits, the datapath operates in parallel stages:
1. **Stage 1 (Parallel Full Adders):** Simultaneously adds the three 64-bit input operands (`A`, `B`, `C`) bit-by-bit using 64 parallel Full Adders. This generates a 64-bit Partial Sum (`S`) and a 64-bit Carry (`C_out`).
2. **Stage 2 (Carry Shift):** Shifts the `C_out` vector left by one bit position to correctly align the arithmetic weight of the carries.
3. **Stage 3 (Final Merge):** A highly optimized Ripple Carry Adder (which synthesizes into dedicated Carry Lookahead or Carry Chain logic on FPGAs) merges the Partial Sum and Shifted Carry to produce the **65-bit Final Sum**.

## 🧩 RTL Module Structure

### Top Module: `csa` (Parameterized)
**Parameters**
- `WIDTH` (Default: `64`) – Defines the bit-width of the input operands.

**Ports**
- `A [WIDTH-1:0]` – First operand
- `B [WIDTH-1:0]` – Second operand
- `C [WIDTH-1:0]` – Third operand
- `Final_Sum [WIDTH:0]` – Output sum (1 bit wider to accommodate overflow)

### Submodules
- `Full_Adder`: The combinational primitives used to build the Carry Save array using generate loops.
- `Ripple_Carry_Adder`: The final addition stage, parameterized to handle `WIDTH+1` bits.

## 🚀 VLSI & FPGA Applications
- **Multipliers:** Core building block for Wallace/Dadda tree multipliers.
- **DSP Accumulators:** High-speed summation in Finite Impulse Response (FIR) filters.
- **ALU Design:** Fast multi-operand addition in custom CPU/GPU architectures.

## 🛠 Synthesis & Implementation
This parameterized module is designed for structural RTL generation. When targeting modern FPGAs (e.g., Altera Cyclone/Stratix or Xilinx Artix/Kintex), the final Ripple Carry stage maps efficiently to the dedicated fast-carry chains within the logic slices (ALMs/CLBs).
