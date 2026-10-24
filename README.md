# 8-bit Accumulator CPU (VHDL)

A small single-cycle 8-bit accumulator CPU written in VHDL.
Made for the **CSE 450 (VLSI Lab) Final Project**, University of Asia Pacific.

- **Name:** Nazmul Mridha
- **Student ID:** 22201161
- **Instruction set (Set 1):** `LDI`, `ADD`, `SUB`, `AND`, `OR`

## What it does
The CPU reads 12-bit instructions from a 16-word ROM (4-bit opcode + 8-bit operand),
executes one instruction per clock cycle and keeps the result in the accumulator (ACC).
A flag `Z` is set when the result is zero.

| Mnemonic | Opcode | Operation |
|---|---|---|
| LDI imm | 0001 | ACC <= imm |
| ADD imm | 0010 | ACC <= ACC + imm |
| SUB imm | 0011 | ACC <= ACC - imm (mod 256) |
| AND imm | 0100 | ACC <= ACC AND imm |
| OR  imm | 0101 | ACC <= ACC OR imm |

## Files
| Folder | Content |
|---|---|
| `src/` | `pc.vhd`, `rom.vhd`, `control.vhd`, `alu.vhd`, `acc_z.vhd`, `cpu.vhd` |
| `tb/` | testbenches for every module and `cpu_tb.vhd` for the full CPU |
| `docs/` | project report |

## How to run
Open the files in Xilinx ISE (or any VHDL simulator), set `cpu_tb` as the top
simulation module and run the simulation. The testbench checks ACC, Z and PC
against the expected results and reports any mismatch.

## Result
All 8 cycles of the test program match the expected values (final ACC = `0xFF`).
