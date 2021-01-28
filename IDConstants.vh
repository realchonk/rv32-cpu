
`define make_mask(i) (32'b1 << (i))

// Indexes
`define PPC_OE		0		// Program Counter Output Enable to bus A
`define PPC_WE		1		// Program Counter Write Enable
`define PPC_INC	2		// Program Counter Increment
`define PPC_OE2	3		// Program Counter Output Enable to address bus
`define PIR_WE		4		// Instruction Register Write Enable
`define PMAR_WE	5		// Memory Address Register Write Enable
`define PMAR_OE	6		// Memory Address Register Output Enable
`define PRS1_EN	7		// Source Register 1 Output Enable
`define PRS2_EN	8		// Source Register 2 Output Enable
`define PRD_WE		9		// Destination Register Write Enable
`define PMEM_RW	10		// Memory Read=0/Write=1
`define PSE_EN		11		// Sign Extender Enable
`define PIMM_ENA	12		// Immediate Output to bus A
`define PIMM_ENB	13		// Immediate Output to bus B
`define PIMM_ENC	14		// Immediate Output to bus C
`define PF3_OV		15		// funct3 override enable
`define PMDB_EN	16		// Copy bus B to mem_data Enable
`define PALU_OE	17		// ALU output enable
`define PSE_OE		18		// Sign Extender Output Enable
`define PBT			19		// Branch Tester Check
`define PF3_VAL	23:20	// funct3 override value
`define PMEM_SIZE	25:24	// memory size 0=disabled 1=byte 2=hword 3=word
`define PHLT		30		// Halt
`define PT_RST		31		// Timer Reset


// Masks
`define MPC_OE		`make_mask(`PPC_OE)
`define MPC_WE		`make_mask(`PPC_WE)
`define MPC_INC	`make_mask(`PPC_INC)
`define MPC_OE2	`make_mask(`PPC_OE2)
`define MIR_WE		`make_mask(`PIR_WE)
`define MMAR_WE	`make_mask(`PMAR_WE)
`define MMAR_OE	`make_mask(`PMAR_OE)
`define MRS1_EN	`make_mask(`PRS1_EN)
`define MRS2_EN	`make_mask(`PRS2_EN)
`define MRD_WE		`make_mask(`PRD_WE)
`define MMEM_RW	`make_mask(`PMEM_RW)
`define MSE_EN		`make_mask(`PSE_EN)
`define MIMM_ENA	`make_mask(`PIMM_ENA)
`define MIMM_ENB	`make_mask(`PIMM_ENB)
`define MIMM_ENC	`make_mask(`PIMM_ENC)
`define MF3_OV		`make_mask(`PF3_OV)
`define MMDB_EN	`make_mask(`PMDB_EN)
`define MALU_OE	`make_mask(`PALU_OE)
`define MSE_OE		`make_mask(`PSE_OE)
`define MBT			`make_mask(`PBT)
`define MHLT	 	`make_mask(`PHLT)
`define MT_RST 	`make_mask(`PT_RST)

`define MF3_VAL(x)	(((x) &  15) << 20)	// Generate funct3 override mask
`define MMEM_SIZE(x)	(((x) & 3) << 24)		// Generate mem_size mask
