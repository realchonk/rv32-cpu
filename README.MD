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
- Inspired by: Ben Eaters 8-bit CPU, LMARV-1 (Robert Baruch)
- No interrupts
- No Privilleged ISA
- Phase-Shifted Memory Clock

## Supported Memory Attached Devices
Device | File
-------|-----
Synchronous Static RAM | RAM.v
ROM | InstructionROM.v
LEDs & Switches | IOController.v
4x 7 Segment Display | SevenSegmentController.v
32x GPIO Pins | GPIOController.v
SSRAM (without UAM) | AlignedRAM.v

## Known differences from the specification
- FENCE and ECALL are NOPs
- EBREAK halts the processor (hlt=1)

## Known bugs
- reset doesn't work

## Tested on
- ModelSim-Altera
- DE10-Lite (12.5MHz)

## TODO (priority: top=highest)
- Finding bugs and fixing them
- Documentation and Comments
- Adding GPIO pins
- Writing a boot loader
- Add DDR2 SDR-SDRAM Controller
- More Useful README
- Extending the architecture

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
