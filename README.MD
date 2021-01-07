# RISC-V 32-bit CPU
## Semi-Short Description
A simple CPU that I've written in Verilog for a school project.<br>
This is a pretty bad design, but it's my first one.<br>
I DO NOT recommend using it in the real world.<br>
Issues and Pull Requests are appreciated!<br>

## Features
- ISA: RV32I
- Multi-Cycle CPU
- No Pipelining
- Upto 4 GiB RAM
- Von-Neumann Architecture
- Unaligned Memory Access
- Simple Memory Controller for testing/evaluation
- Inspired by: Ben Eaters 8-bit CPU, LMARV-1 (Robert Baruch)
- No interrupts
- No Privilleged ISA
- Phase-Shifted Memory Clock

## Known differences from the specification
- FENCE and ECALL are NOPs
- EBREAK halts the processor (hlt=1)

## Known bugs

## Tested on
- ModelSim-Altera

## TODO (priority: top=highest)
- Finding bugs and fixing them
- Testing on real hardware
- More Useful README
- Documentation and Comments
- More Optimizations
- Add DDR2 SDR-SDRAM Controller
- Memory Mapped IO Controller

## How YOU can help me
I couldn't find any useful and cheap rescources for designing hardware in Verilog.<br>
I would appreciate it if you could provide the knowledge that I'm searching for.<br>
Google and DuckDuckGo only found beginner's tutorials for Verilog newbies.<br>
My topics of interest are:
- Deeper Computer Design
- SDRAM Controller for DE10-Lite
- SPI master/slave
Languages of choice: English, German<br>

## Sources
- https://en.wikipedia.org/wiki/RISC-V
- https://five-embeddev.com/quickref/tools.html
- https://riscv.org/wp-content/uploads/2018/05/13.15-13-50-Talk-riscv-base-isa-20180507.pdf
- Robert Baruch: https://www.youtube.com/channel/UCBcljXmuXPok9kT_VGA3adg
- Ben Eater: https://eater.net/8bit
