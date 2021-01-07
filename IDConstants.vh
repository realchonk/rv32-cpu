
`define make_mask(i) (1 << (i))

// Indexes
`define PPC_OE		0
`define PPC_WE		1
`define PPC_INC	2
`define PPC_OE2	3
`define PIR_WE		4
`define PMAR_WE	5
`define PMAR_OE	6
`define PRS1_EN	7
`define PRS2_EN	8
`define PRD_WE		9
`define PMEM_RW	10
`define PSE_EN		11
`define PIMM_ENA	12
`define PIMM_ENB	13
`define PIMM_ENC	14
`define PF3_OV		15
`define PMDB_EN	16
`define PALU_OE	17
`define PSE_OE		18
`define PF3_VAL	23:20
`define PMEM_SIZE	25:24
`define PHLT		30
`define PT_RST		31


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
`define MHLT	 	`make_mask(`PHLT)
`define MT_RST 	`make_mask(`PT_RST)

`define MF3_VAL(x)	(((x) &  15) << 20)
`define MMEM_SIZE(x)	(((x) & 3) << 24)
