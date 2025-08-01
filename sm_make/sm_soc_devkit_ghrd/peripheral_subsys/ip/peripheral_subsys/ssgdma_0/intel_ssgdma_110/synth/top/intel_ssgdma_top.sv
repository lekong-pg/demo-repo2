// (C) 2001-2023 Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files from any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License Subscription 
// Agreement, Intel FPGA IP License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Intel and sold by 
// Intel or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


// synopsys translate_off
`timescale 1 ns / 1 ps
// `default_nettype wire

// synopsys translate_on

// `include "./ssgdma_macro.sv" // For internal debugging, comment away subsequent define lines and enable this one instead

`define DEVICE_AGENT_INSTANCE_EN	1
`define PREFETCHER_INSTANCE_EN		1
`define COMPLETER_INSTANCE_EN		1
`define BAM_INSTANCE_EN				1
`define TX_SCHEDULER_INSTANCE_EN	1
// `define CS_INSTANCE_EN				1
// `define BAS_INSTANCE_EN				1

import ssgdma_pkg::*;

module intel_ssgdma_top #(

parameter DEVICE_FAMILY      															= "Agilex 5",

parameter DMA_MODE																		= "DMA SoC mode",	// "DMA PCIe mode", "DMA SoC mode", "DMA only mode"
parameter MAX_PAYLOAD_SIZE																= 512, // 128, 256, 512 bytes
parameter TX_ARB_MODE																	= "Round Robin",   	// "Round Robin", "Priority"
parameter UNALIGNED_ACCESS_EN															= 0,	// 0 or 1
parameter ECC_EN																		= 0,				// 0 or 1, TBD

parameter HOST_INT_TYPE																	= "AXI4", // "AXI4", "ACE-Lite"
parameter HOST_AWD    																	= 64,	// 1 to 64
parameter HOST_IDWD    																	= 5,	// 1 to 18
parameter HOST_LWD    																	= 8,
parameter HOST_DWD    																	= 256,	// 8, 16, 32, 64, 128, 256, 512, 1024

// PCIe mode related parameter (not used)
parameter SS_ST_DWD    																	= 512,	// 256, 512, 1024
parameter EXT_TAG_EN																	= 0, // 0 or 1, 0: up to 5bits (up to 32 tags), 1: up to 8bits (256 tags)
parameter EXT_10BITS_TAG_REQ_EN															= 0, // 0 or 1, 0: up to 5bits or 8bits from EXT_TAG_EN, 1: up to 767 tags for P-tile
parameter SRIOV_EN																		= 0, // 0 or 1
parameter BAS_PORT_EN																	= 0, // 0 or 1

parameter HOST_DESCR_PORT_EN															= 0, // 0 or 1

parameter NUM_H2D_MM_PORTS																= 1, // 0 to 16
parameter NUM_H2D_ST_PORTS																= 0, // 0 to 16
parameter NUM_D2H_ST_PORTS																= 0, // 0 to 16

parameter H2D_MM0_AWD    																= 64,	// 1 to 64
parameter H2D_MM0_LWD    																= 8,
parameter H2D_MM0_IDWD    																= 8,	// 1 to 18
parameter H2D_MM0_DWD    																= 64,	// 8, 16, 32, 64, 128, 256, 512, 1024
parameter H2D_MM0_FIFO_DEPTH 															= 6144,	// 64, 128, 256, 512, 1024, 2048, 4096
parameter NUM_CHAN_PER_H2D_MM_PORT0														= 1,	// 1 to 32, not used for now


parameter AXI_ST_PORT_FREQ																	= 100,		// 200, 250, 300, 350, 400, 450, 500

parameter HOST_AXI_PROT_PRIV_ACC															= 0,		// 0 or 1
parameter HOST_AXI_PROT_SEC_ACC																= 0,		// 0 or 1
parameter HOST_AXI_PROT_DATA_ACC															= 0,		// 0 or 1
parameter HOST_AXI_AWCACHE																	= 0,		// 
parameter HOST_AXI_ARCACHE																	= 0,		// 
parameter HOST_AXI_AWBAR																	= 0,			// 
parameter HOST_AXI_ARBAR																	= 0,			// 
parameter HOST_AXI_AWDOMAIN																	= 0,		// 
parameter HOST_AXI_ARDOMAIN																	= 0,		// 
parameter HOST_AXI_AWSNOOP																	= 0,		// 
parameter HOST_AXI_ARSNOOP																	= 0,		// 

// Internal
localparam NUM_H2D_MM_CHANS																							= NUM_H2D_MM_PORTS*1, // 1 to 512 (up to 16 H2D MM ports) or 1024 (up to 32 H2D MM ports, TBD)
localparam NUM_H2D_ST_CHANS																							= NUM_H2D_ST_PORTS*1, // 1 to 512 (up to 16 H2D ST ports) or 1024 (up to 32 H2D ST ports, TBD)
localparam NUM_D2H_ST_CHANS																							= NUM_D2H_ST_PORTS*1, // 1 to 512 (up to 16 D2H ST ports) or 1024 (up to 32 D2H ST ports, TBD)


localparam SS_ST_BWD            																					= 8,
localparam SS_ST_BENWD           																					= SS_ST_DWD/SS_ST_BWD,
localparam DBG_CSR_AWD    																							= 22, // 1 to 32
localparam MAX_READ_REQUEST_SIZE																					= 512, // default values for SoC mode

localparam HOST_CSR_AWD    																							= 22, // 1 to 22
localparam HOST_CSR_DWD    																							= 32, // 

localparam TX_ARB_DWD    																							= (DMA_MODE == "DMA PCIe mode") ? SS_ST_DWD : HOST_DWD,
localparam TX_ARB_IDWD    																							= 15,	// 4 to 15
localparam TX_ARB_UWD            																					= (DMA_MODE == "DMA PCIe mode") ? 84 : 116,	//
localparam TX_ARB_BWD         											 											= 8,	// 
localparam TX_ARB_BENWD        																						= (TX_ARB_DWD/TX_ARB_BWD),	
localparam TX_ARB_UWD_INT                            																= (DMA_MODE == "DMA PCIe mode") ? TX_ARB_UWD : ((HOST_INT_TYPE == "AXI4") ? 98 : TX_ARB_UWD),  // 116 - ACE-Lite & 98 - AXI4
localparam TX_ARB_IDWD_INT                            																= 10,  // ID width from individual Packet FIFO modules entering DMA Arbiter before Agent ID concatenation

localparam RX_ARB_DWD    																							= (DMA_MODE == "DMA PCIe mode") ? SS_ST_DWD : HOST_DWD,
localparam RX_ARB_IDWD    																							= 15,	// 4 to 15
localparam RX_ARB_UWD            																					= 86,	// 116 - To/From DMA Arbiter, 86 - To/From DMA Router
localparam RX_ARB_BWD         											 											= 8,	// 
localparam RX_ARB_BENWD        																						= (RX_ARB_DWD/RX_ARB_BWD),	
localparam RX_ARB_IDWD_INT                            																= 10,  // ID width from individual Packet FIFO modules exiting DMA Router before Agent ID concatenation

localparam AGENT_DESCRIPTOR_FIFO_DEPTH																				= 32, // number of descriptors to store

localparam H2D_D2H_DD_WD                                 															= 32, // 32, 128, 256
	
localparam AGENT_DESCRIPTOR_DATA_WIDTH																				= H2D_D2H_DD_WD, //
localparam AGENT_RESPONDER_DATA_WIDTH																				= H2D_D2H_DD_WD, //

localparam MSIX_DATA_WIDTH																							= 16, 
	
localparam MAX_PAYLOAD_SIZE_DERIVED_DEFAULT																			= 	(MAX_PAYLOAD_SIZE == 128) ? 0 :
																														((MAX_PAYLOAD_SIZE == 256) ? 1 :
																														((MAX_PAYLOAD_SIZE == 512) ? 2 :
																														((MAX_PAYLOAD_SIZE == 1024) ? 3 :
																														((MAX_PAYLOAD_SIZE == 2048) ? 4 :
																														((MAX_PAYLOAD_SIZE == 4096) ? 5 : 2))))),

localparam MAX_READ_REQUEST_SIZE_DERIVED_DEFAULT																	= 	(MAX_READ_REQUEST_SIZE == 128) ? 0 :
																														((MAX_READ_REQUEST_SIZE == 256) ? 1 :
																														((MAX_READ_REQUEST_SIZE == 512) ? 2 :
																														((MAX_READ_REQUEST_SIZE == 1024) ? 3 :
																														((MAX_READ_REQUEST_SIZE == 2048) ? 4 :
																														((MAX_READ_REQUEST_SIZE == 4096) ? 5 : 2))))),

localparam NUM_TAG_SIZE_DERIVED_BITS																				= 	(EXT_10BITS_TAG_REQ_EN == 1) ? 10 : ((EXT_TAG_EN == 1) ? 8 : 5),

localparam DMA_ARBITER_PACKET_FIFO_DATA_WIDTH																		= TX_ARB_DWD,
localparam DMA_ARBITER_PREFETCH_MEM_WRITE_PACKET_FIFO_DATA_WIDTH													= (DMA_MODE	!= "DMA only mode") ? TX_ARB_DWD : 8,
localparam DMA_ARBITER_PREFETCH_MEM_READ_PACKET_FIFO_DATA_WIDTH														= 8,
localparam DMA_ARBITER_MSIX_PACKET_FIFO_DATA_WIDTH																	= (DMA_MODE	== "DMA PCIe mode") ? 32 : 8, // 
localparam DMA_ARBITER_BAS_PACKET_FIFO_DATA_WIDTH																	= (BAS_PORT_EN) ? TX_ARB_DWD : 8,
localparam DMA_ARBITER_D2H_ST_PACKET_FIFO_DATA_WIDTH																= (NUM_D2H_ST_PORTS > 0) ? TX_ARB_DWD : 8,
localparam DMA_ARBITER_H2D_ST_PACKET_FIFO_DATA_WIDTH																= 8, // 
localparam DMA_ARBITER_H2D_MM_PACKET_FIFO_DATA_WIDTH																= (NUM_H2D_MM_PORTS > 0) ? TX_ARB_DWD : 8,

localparam DMA_ROUTER_PACKET_FIFO_DATA_WIDTH																		= RX_ARB_DWD,
localparam DMA_ROUTER_PREFETCH_MEM_WRITE_PACKET_FIFO_DATA_WIDTH														= 8,
localparam DMA_ROUTER_PREFETCH_MEM_READ_PACKET_FIFO_DATA_WIDTH														= (DMA_MODE	!= "DMA only mode") ? RX_ARB_DWD : 8,
localparam DMA_ROUTER_MSIX_PACKET_FIFO_DATA_WIDTH																	= 8, // 
localparam DMA_ROUTER_BAS_PACKET_FIFO_DATA_WIDTH																	= (BAS_PORT_EN) ? RX_ARB_DWD : 8,
localparam DMA_ROUTER_D2H_ST_PACKET_FIFO_DATA_WIDTH																	= 8,
localparam DMA_ROUTER_H2D_ST_PACKET_FIFO_DATA_WIDTH																	= (NUM_H2D_ST_PORTS > 0) ? RX_ARB_DWD : 8, // 
localparam DMA_ROUTER_H2D_MM_PACKET_FIFO_DATA_WIDTH																	= (NUM_H2D_MM_PORTS > 0) ? RX_ARB_DWD : 8,

localparam NUM_H2D_MM_CHANS_DERIVED																					= (SRIOV_EN == 1) ? NUM_H2D_MM_CHANS : NUM_H2D_MM_PORTS, // 
localparam NUM_H2D_ST_CHANS_DERIVED																					= (SRIOV_EN == 1) ? NUM_H2D_ST_CHANS : NUM_H2D_ST_PORTS, // 
localparam NUM_D2H_ST_CHANS_DERIVED																					= (SRIOV_EN == 1) ? NUM_D2H_ST_CHANS : NUM_D2H_ST_PORTS, // 
	
localparam NUM_H2D_D2H_PORTS																						= NUM_H2D_MM_PORTS+NUM_H2D_ST_PORTS+NUM_D2H_ST_PORTS, // 
localparam NUM_H2D_D2H_CHANS																						= NUM_H2D_MM_CHANS_DERIVED+NUM_H2D_ST_CHANS_DERIVED+NUM_D2H_ST_CHANS_DERIVED, //

localparam NUM_H2D_D2H_PORTS_DERIVED																				= NUM_H2D_D2H_PORTS, //
localparam NUM_H2D_D2H_CHANS_DERIVED																				= (SRIOV_EN == 1) ? NUM_H2D_D2H_CHANS : NUM_H2D_D2H_PORTS, //
	
// TODO: GCSR build time parameters
localparam [0:0] UNALIGNED_ACCESS_EN_PARAM																			= UNALIGNED_ACCESS_EN,
localparam [4:0] NUM_H2D_MM_PORTS_PARAM																				= NUM_H2D_MM_PORTS, // 
localparam [4:0] NUM_H2D_ST_PORTS_PARAM																				= NUM_H2D_ST_PORTS, // 
localparam [4:0] NUM_D2H_ST_PORTS_PARAM																				= NUM_D2H_ST_PORTS, // 
localparam [1:0] NUM_BAR_PORTS_PARAM																				= 1,
localparam [1:0] DMA_MODE_PARAM																						= (DMA_MODE == "DMA PCIe mode") ? 0:
																													  (DMA_MODE == "DMA SoC mode") 	? 1:
																													  (DMA_MODE == "DMA only mode") ? 2:
																													  0,	// 

														
localparam [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0][4:0] H2D_MM_QCSR_NUM_CHAN_PER_DEVICE_PORT_PARAM	= {	5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd1 }, // 
localparam [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0][4:0] H2D_ST_QCSR_NUM_CHAN_PER_DEVICE_PORT_PARAM	= {	5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0 }, // 		
																																										
localparam [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0][0:0] H2D_ST_QCSR_PORT_DATA_TYPE_PARAM				= {	1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0 }, //
localparam [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0][0:0] H2D_ST_QCSR_PORT_INT_TYPE_PARAM				= {	1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0 }, // 
localparam [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0][0:0] H2D_ST_QCSR_PORT_PKT_MODE_PARAM				= { 1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0 }, // 
localparam [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0][0:0] H2D_ST_QCSR_PTP_PORT_EN_PARAM				= {	1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0 }, // 

localparam [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0][4:0] D2H_ST_QCSR_NUM_CHAN_PER_DEVICE_PORT_PARAM	= {	5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0 }, // 

localparam [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0][0:0] D2H_ST_QCSR_PORT_INIT_FLUSH_EN_PARAM			= {	1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0 }, // 
localparam [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0][0:0] D2H_ST_QCSR_PORT_RUNTIME_FLUSH_EN_PARAM		= {	1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0 }, // 
localparam [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0][0:0] D2H_ST_QCSR_PORT_DATA_TYPE_PARAM				= {	1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0 }, //
localparam [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0][0:0] D2H_ST_QCSR_PORT_INT_TYPE_PARAM				= {	1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0 }, // 
localparam [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0][0:0] D2H_ST_QCSR_PORT_PKT_MODE_PARAM				= {	1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0 }, //
localparam [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0][0:0] D2H_ST_QCSR_PTP_PORT_EN_PARAM				= {	1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0,1'd0 } // 
) (
///////////////////////////////////////////// I/O Ports //////////////////////////////////////////////////////
// Clocks and Resets
input  logic [1-1:0]  											axi_lite_clk,
input  logic [1-1:0]  											axi_lite_areset_n,

// Clocks and Resets for DMA SoC Mode/DMA Only Mode
input  logic [1-1:0]  											host_clk,
input  logic [1-1:0]  											host_aresetn,


// Clocks and Resets for Device Ports
input  logic [1-1:0]  											h2d0_mm_clk,
input  logic [1-1:0]  											h2d0_mm_resetn,	// Not used, just for platform designer compatibilty purpose

///////////////////////////////////////////////////////////////////////////////////
// DMA SoC Mode / DMA Only Mode Interfaces
// Host AXI-4 Inteface
output logic [1-1:0]  											host_awvalid,
output logic [HOST_AWD-1:0]  									host_awaddr,
output logic [3-1:0]  											host_awsize,
output logic [3-1:0]  											host_awprot,
output logic [HOST_LWD-1:0]  									host_awlen,
output logic [2-1:0]  											host_awburst,
output logic [HOST_IDWD-1:0]  									host_awid,
output logic [4-1:0]  											host_awcache,
input  logic [1-1:0]  											host_awready,

output logic [1-1:0]  											host_wvalid,
output logic [HOST_DWD-1:0]  									host_wdata,
output logic [1-1:0]  											host_wlast,
output logic [(HOST_DWD/8)-1:0]  								host_wstrb,
input  logic [1-1:0]  											host_wready,

output logic [1-1:0]  											host_bready,
input  logic [1-1:0]  											host_bvalid,
input  logic [2-1:0]  											host_bresp,
input  logic [HOST_IDWD-1:0]  									host_bid,

output logic [1-1:0]  											host_arvalid,
output logic [HOST_AWD-1:0]  									host_araddr,
output logic [3-1:0]  											host_arsize,
output logic [3-1:0]  											host_arprot,
output logic [HOST_LWD-1:0]  									host_arlen,
output logic [2-1:0]  											host_arburst,
output logic [HOST_IDWD-1:0]  									host_arid,
output logic [4-1:0]  											host_arcache,
input  logic [1-1:0]  											host_arready,

output logic [1-1:0]  											host_rready,
input  logic [HOST_DWD-1:0]  									host_rdata,
input  logic [1-1:0]  											host_rvalid,
input  logic [1-1:0]  											host_rlast,
input  logic [2-1:0]  											host_rresp,
input  logic [HOST_IDWD-1:0]  									host_rid,

// Host CSR AXI-4 Lite Subordinate Inteface
input  logic [1-1:0]  											host_lite_csr_awvalid,
input  logic [HOST_CSR_AWD-1:0]  								host_lite_csr_awaddr,
input  logic [3-1:0]  											host_lite_csr_awprot,
output logic [1-1:0]  											host_lite_csr_awready,

input  logic [1-1:0]  											host_lite_csr_wvalid,
input  logic [32-1:0]  											host_lite_csr_wdata,
input  logic [4-1:0]  											host_lite_csr_wstrb,
output logic [1-1:0]  											host_lite_csr_wready,

input  logic [1-1:0]  											host_lite_csr_bready,
output logic [1-1:0]  											host_lite_csr_bvalid,
output logic [2-1:0]  											host_lite_csr_bresp,	// The EXOKAY response is not supported on the read data and write response channels

input  logic [1-1:0]  											host_lite_csr_arvalid,
input  logic [HOST_CSR_AWD-1:0]  								host_lite_csr_araddr,
input  logic [3-1:0]  											host_lite_csr_arprot,
output logic [1-1:0]  											host_lite_csr_arready,

input  logic [1-1:0]  											host_lite_csr_rready,
output logic [1-1:0]  											host_lite_csr_rvalid,
output logic [32-1:0]  											host_lite_csr_rdata,
output logic [2-1:0]  											host_lite_csr_rresp, // The EXOKAY response is not supported on the read data and write response channels

// DMA SoC Mode Interfaces
// Interrupt Interface
output logic 													irq,

// Device Port Interfaces
// Host to Device AXI-4 Manager Interface (h2d_mm0) - Port 0
output logic [1-1:0]  											h2d0_awvalid,
output logic [H2D_MM0_AWD-1:0]  								h2d0_awaddr,
output logic [3-1:0]  											h2d0_awsize,
output logic [3-1:0]  											h2d0_awprot,
output logic [H2D_MM0_LWD-1:0]  								h2d0_awlen,
output logic [2-1:0]  											h2d0_awburst,
output logic [H2D_MM0_IDWD-1:0]  							h2d0_awid,
output logic [4-1:0]  											h2d0_awcache,
input  logic [1-1:0]  											h2d0_awready,

output logic [1-1:0]  											h2d0_wvalid,
output logic [H2D_MM0_DWD-1:0]  								h2d0_wdata,
output logic [1-1:0]  											h2d0_wlast,
output logic [(H2D_MM0_DWD/8)-1:0]  							h2d0_wstrb,
input  logic [1-1:0]  											h2d0_wready,

output logic [1-1:0]  											h2d0_bready,
input  logic [1-1:0]  											h2d0_bvalid,
input  logic [2-1:0]  											h2d0_bresp,
input  logic [H2D_MM0_IDWD-1:0]  							h2d0_bid,

output logic [1-1:0]  											h2d0_arvalid,
output logic [H2D_MM0_AWD-1:0]  								h2d0_araddr,
output logic [3-1:0]  											h2d0_arsize,
output logic [3-1:0]  											h2d0_arprot,
output logic [H2D_MM0_LWD-1:0]  								h2d0_arlen,
output logic [2-1:0]  											h2d0_arburst,
output logic [H2D_MM0_IDWD-1:0]  							h2d0_arid,
output logic [4-1:0]  											h2d0_arcache,
input  logic [1-1:0]  											h2d0_arready,

output logic [1-1:0]  											h2d0_rready,
input  logic [H2D_MM0_DWD-1:0]  								h2d0_rdata,
input  logic [1-1:0]  											h2d0_rvalid,
input  logic [1-1:0]  											h2d0_rlast,
input  logic [2-1:0]  											h2d0_rresp,
input  logic [H2D_MM0_IDWD-1:0]  							h2d0_rid,

/////////////////////////////////////////////////////////////////////////Debugging purposes////////////////////////////////////////////////////////////////////////
`ifdef DIRECTED_TB_CSR_STIMULUS_EN
input  logic [HOST_CSR_AWD-1:0]        																					tb_prefetch_csr_addr_i,
input  logic [1-1:0]  																									tb_prefetch_csr_wrreq_i,
input  logic [HOST_CSR_DWD-1:0]        																					tb_prefetch_csr_wdata_i,
input  logic [1-1:0]  																									tb_prefetch_csr_rdreq_i,
output logic [HOST_CSR_DWD-1:0]       																					tb_prefetch_csr_rdata_o,
output logic [1-1:0]  																									tb_prefetch_csr_rdvalid_o,
output logic [1-1:0]  																									tb_prefetch_csr_req_ack_o,
`endif // DIRECTED_TB_CSR_STIMULUS_EN

`ifdef DIRECTED_TB_ARB_STIMULUS_EN
input  logic 																											tb_arb_prefetch_fifo_mem_write_tvalid,
output logic																											tb_arb_prefetch_fifo_mem_write_tready,
input  logic [DMA_ARBITER_PREFETCH_MEM_WRITE_PACKET_FIFO_DATA_WIDTH-1:0]												tb_arb_prefetch_fifo_mem_write_tdata,
input  logic [TX_ARB_UWD-1:0]																							tb_arb_prefetch_fifo_mem_write_tuser,
input  logic 																											tb_arb_prefetch_fifo_mem_write_tlast,
input  logic [TX_ARB_IDWD_INT-1:0]																						tb_arb_prefetch_fifo_mem_write_tid,
input  logic [DMA_ARBITER_PREFETCH_MEM_WRITE_PACKET_FIFO_DATA_WIDTH/8-1:0]												tb_arb_prefetch_fifo_mem_write_tkeep,

input  logic 																											tb_arb_prefetch_fifo_mem_read_tvalid,
output logic																											tb_arb_prefetch_fifo_mem_read_tready,
input  logic [DMA_ARBITER_PREFETCH_MEM_READ_PACKET_FIFO_DATA_WIDTH-1:0]													tb_arb_prefetch_fifo_mem_read_tdata,
input  logic [TX_ARB_UWD-1:0]																							tb_arb_prefetch_fifo_mem_read_tuser,
input  logic 																											tb_arb_prefetch_fifo_mem_read_tlast,
input  logic [TX_ARB_IDWD_INT-1:0]																						tb_arb_prefetch_fifo_mem_read_tid,
input  logic [DMA_ARBITER_PREFETCH_MEM_READ_PACKET_FIFO_DATA_WIDTH/8-1:0]												tb_arb_prefetch_fifo_mem_read_tkeep,
`endif // DIRECTED_TB_ARB_STIMULUS_EN

`ifndef PREFETCHER_INSTANCE_EN
input  logic [1-1:0]  																									prefetch_engine_reset_completion,
	
output logic 																											router_prefetch_fifo_mem_write_tvalid,
input  logic																											router_prefetch_fifo_mem_write_tready,
output logic [DMA_ROUTER_PREFETCH_MEM_WRITE_PACKET_FIFO_DATA_WIDTH-1:0]													router_prefetch_fifo_mem_write_tdata,
output logic [RX_ARB_UWD-1:0]																							router_prefetch_fifo_mem_write_tuser,
output logic 																											router_prefetch_fifo_mem_write_tlast,
output logic [RX_ARB_IDWD_INT-1:0]																						router_prefetch_fifo_mem_write_tid,
output logic [DMA_ROUTER_PREFETCH_MEM_WRITE_PACKET_FIFO_DATA_WIDTH/8-1:0]												router_prefetch_fifo_mem_write_tkeep,

output logic 																											router_prefetch_fifo_mem_read_tvalid,
input  logic																											router_prefetch_fifo_mem_read_tready,
output logic [DMA_ROUTER_PREFETCH_MEM_READ_PACKET_FIFO_DATA_WIDTH-1:0]													router_prefetch_fifo_mem_read_tdata,
output logic [RX_ARB_UWD-1:0]																							router_prefetch_fifo_mem_read_tuser,
output logic 																											router_prefetch_fifo_mem_read_tlast,
output logic [RX_ARB_IDWD_INT-1:0]																						router_prefetch_fifo_mem_read_tid,
output logic [DMA_ROUTER_PREFETCH_MEM_READ_PACKET_FIFO_DATA_WIDTH/8-1:0]												router_prefetch_fifo_mem_read_tkeep,

input  logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0] 													h2d_mm_desc_axi_st_source_tvalid, //width = 1 per device port
output logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0] 													h2d_mm_desc_axi_st_source_tready, //width = 1 per device port
input  logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0][AGENT_DESCRIPTOR_DATA_WIDTH-1:0]					h2d_mm_desc_axi_st_source_tdata,  //width = 32 or 256 per device port //TO_ASK: how do we differentiate each agent's data widht?
input  logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0]														h2d_mm_desc_axi_st_source_tlast,  //width = 1 per device port

input  logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0] 													h2d_st_desc_axi_st_source_tvalid, //width = 1 per device port
output logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0] 													h2d_st_desc_axi_st_source_tready, //width = 1 per device port
input  logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0][AGENT_DESCRIPTOR_DATA_WIDTH-1:0]					h2d_st_desc_axi_st_source_tdata,  //width = 32 or 256 per device port //TO_ASK: how do we differentiate each agent's data widht?
input  logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0]														h2d_st_desc_axi_st_source_tlast,  //width = 1 per device port

input  logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0] 													d2h_st_desc_axi_st_source_tvalid, //width = 1 per device port
output logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0] 													d2h_st_desc_axi_st_source_tready, //width = 1 per device port
input  logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0][AGENT_DESCRIPTOR_DATA_WIDTH-1:0]					d2h_st_desc_axi_st_source_tdata,  //width = 32 or 256 per device port //TO_ASK: how do we differentiate each agent's data widht?
input  logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0]														d2h_st_desc_axi_st_source_tlast,  //width = 1 per device port

output logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0]														h2d_mm_agent_descriptor_taken, //Agent sends a pulse when a descriptor is taken from the agent's descriptor FIFO (a descriptor is 32 bytes)
output logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0]														h2d_st_agent_descriptor_taken, //Agent sends a pulse when a descriptor is taken from the agent's descriptor FIFO (a descriptor is 32 bytes)
output logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0]														d2h_st_agent_descriptor_taken, //Agent sends a pulse when a descriptor is taken from the agent's descriptor FIFO (a descriptor is 32 bytes)

output logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0] 													h2d_mm_resp_axi_st_sink_tvalid, //width = 1 per device port
input  logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0] 													h2d_mm_resp_axi_st_sink_tready, //width = 1 per device port
output logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0][AGENT_RESPONDER_DATA_WIDTH-1:0]						h2d_mm_resp_axi_st_sink_tdata,  //width = 32 or 256 per device port //TO_ASK: how do we differentiate each agent's data widht?
output logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0]														h2d_mm_resp_axi_st_sink_tlast,  //width = 1 per device port

output logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0] 													h2d_st_resp_axi_st_sink_tvalid, //width = 1 per device port
input  logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0] 													h2d_st_resp_axi_st_sink_tready, //width = 1 per device port
output logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0][AGENT_RESPONDER_DATA_WIDTH-1:0]						h2d_st_resp_axi_st_sink_tdata,  //width = 32 or 256 per device port //TO_ASK: how do we differentiate each agent's data widht?
output logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0]														h2d_st_resp_axi_st_sink_tlast,  //width = 1 per device port

output logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0] 													d2h_st_resp_axi_st_sink_tvalid, //width = 1 per device port
input  logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0] 													d2h_st_resp_axi_st_sink_tready, //width = 1 per device port
output logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0][AGENT_RESPONDER_DATA_WIDTH-1:0]						d2h_st_resp_axi_st_sink_tdata,  //width = 32 or 256 per device port //TO_ASK: how do we differentiate each agent's data widht?
output logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0]														d2h_st_resp_axi_st_sink_tlast,  //width = 1 per device port

output logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0]														h2d_mm_agent_responder_added, //Agent sends a pulse when a responder is filled into the agent's responder FIFO (a responder is 32 bytes)
output logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0]														h2d_st_agent_responder_added, //Agent sends a pulse when a responder is filled into the agent's responder FIFO (a responder is 32 bytes)
output logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0]														d2h_st_agent_responder_added, //Agent sends a pulse when a responder is filled into the agent's responder FIFO (a responder is 32 bytes)

output logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0]														d2h_st_agent_flush_int, //Agent asserts this signal when it requires prefetcher to send a flush MSI-X interrupt to the host. It will be cleared once prefetcher sends the ACK.
input  logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0]														d2h_st_agent_flush_ack, //Agent sends a single clock pulse to acknowledge the flush interrupt from agent. 

output logic                    																						prefetch_msix_ready,
input  logic                    																						prefetch_msix_valid,
input  logic [16-1:0]           																						prefetch_msix_data,
`endif // PREFETCHER_INSTANCE_EN

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

`ifndef BAM_INSTANCE_EN
output logic [SS_ST_DWD-1:0]																							axi_st_bam_tdata_out,
output logic																											axi_st_bam_tvalid_out,
output logic [SS_ST_BENWD-1:0]																							axi_st_bam_tkeep_out,
output logic               																								axi_st_bam_tlast_out,
output logic[SS_ST_UWD-1:0]																								axi_st_bam_tuser_out,
`endif // BAM_INSTANCE_EN

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

`ifndef CS_INSTANCE_EN
output logic [SS_ST_DWD-1:0]																							axi_st_cs_tdata_out,
output logic               																								axi_st_cs_tvalid_out,
output logic [SS_ST_BENWD-1:0]																							axi_st_cs_tkeep_out,
output logic               																								axi_st_cs_tlast_out,
output logic [1-1:0]																									axi_st_cs_tuser_out,
`endif // CS_INSTANCE_EN

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

`ifndef COMPLETER_INSTANCE_EN
input  logic                        																					id_tlpconst_rsp_valid,
input  logic [23:0]  																									id_tlpconst_rsp_trans_id, 
								
output logic                         																					txsched_p_cpl_rx_valid,
output logic  [TX_ARB_IDWD-1:0]  																						txsched_p_cpl_rx_router_id,
input  logic                        																					txsched_p_cpl_rx_hold,

input  logic [RX_ARB_DWD-1:0]																							router_completer_tdata,
input  logic               																								router_completer_tvalid,
input  logic [RX_ARB_IDWD-1:0]																							router_completer_tid,
input  logic [RX_ARB_BENWD-1:0]																							router_completer_tkeep,
input  logic               																								router_completer_tlast,
input  logic [RX_ARB_UWD-1:0]																							router_completer_tuser,
output logic																											router_completer_tready,

// To Completer
output logic [SS_ST_DWD-1:0]																							axi_st_completer_tdata_out,
output logic               																								axi_st_completer_tvalid_out,
output logic [SS_ST_BENWD-1:0]																							axi_st_completer_tkeep_out,
output logic               																								axi_st_completer_tlast_out,
output logic [1-1:0]																									axi_st_completer_tuser_out,
`endif // COMPLETER_INSTANCE_EN

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

`ifdef DIRECTED_TB_STIMULUS_EN
// output logic [SS_ST_DWD-1:0]																							axi_st_tx_scheduler_tdata_out,
// output logic               																								axi_st_tx_scheduler_tvalid_out,
// output logic [SS_ST_BENWD-1:0]																							axi_st_tx_scheduler_tkeep_out,
// output logic               																								axi_st_tx_scheduler_tlast_out,
// output logic               																								axi_st_tx_scheduler_tuser_out,

`ifdef DIRECTED_TB_CSR_STIMULUS_EN
// To access responder table & updates status registers from QCSR 
input  logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0][HOST_CSR_AWD-1:0]									tb_h2d_mm_csr_addr_i,
input  logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0][HOST_CSR_DWD-1:0]									tb_h2d_mm_csr_wdata_i,
output logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0][HOST_CSR_DWD-1:0]									tb_h2d_mm_csr_rdata_o,
input  logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0]  													tb_h2d_mm_csr_wrreq_i,
input  logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0]        												tb_h2d_mm_csr_rdreq_i,
output logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0]  													tb_h2d_mm_csr_rdvalid_o,
output logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0]  													tb_h2d_mm_csr_req_ack_o,

// To access responder table & updates status registers from QCSR 
input  logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0][HOST_CSR_AWD-1:0]									tb_h2d_st_csr_addr_i,
input  logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0][HOST_CSR_DWD-1:0]									tb_h2d_st_csr_wdata_i,
output logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0][HOST_CSR_DWD-1:0]									tb_h2d_st_csr_rdata_o,
input  logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0]        												tb_h2d_st_csr_rdreq_i,
input  logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0]  													tb_h2d_st_csr_wrreq_i,
output logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0]  													tb_h2d_st_csr_req_ack_o,
output logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0]  													tb_h2d_st_csr_rdvalid_o,

// To access responder table & updates status registers from QCSR 
input  logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0][HOST_CSR_AWD-1:0]									tb_d2h_st_csr_addr_i,
input  logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0][HOST_CSR_DWD-1:0]   								tb_d2h_st_csr_wdata_i,
output logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0][HOST_CSR_DWD-1:0]   								tb_d2h_st_csr_rdata_o,
input  logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0]  													tb_d2h_st_csr_wrreq_i,
input  logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0]        												tb_d2h_st_csr_rdreq_i,
output logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0]  													tb_d2h_st_csr_rdvalid_o,
output logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0]  													tb_d2h_st_csr_req_ack_o,

input  logic [HOST_CSR_AWD-1:0] 																						tb_msix_csr_addr_i,
input  logic                    																						tb_msix_csr_wrreq_i,
input  logic [HOST_CSR_DWD-1:0] 																						tb_msix_csr_wdata_i,
input  logic                    																						tb_msix_csr_rdreq_i,
output logic [HOST_CSR_DWD-1:0] 																						tb_msix_csr_rdata_o,
output logic                    																						tb_msix_csr_rdvalid_o,
output logic                    																						tb_msix_csr_req_ack_o,
`endif // DIRECTED_TB_CSR_STIMULUS_EN

`ifdef DIRECTED_TB_ARB_STIMULUS_EN
input  logic 																											tb_arb_bas_fifo_tvalid,
output logic																											tb_arb_bas_fifo_tready,
input  logic [DMA_ARBITER_BAS_PACKET_FIFO_DATA_WIDTH-1:0]																tb_arb_bas_fifo_tdata,
input  logic [TX_ARB_UWD-1:0]																							tb_arb_bas_fifo_tuser,
input  logic 																											tb_arb_bas_fifo_tlast,
input  logic [TX_ARB_IDWD_INT-1:0]																						tb_arb_bas_fifo_tid,
input  logic [DMA_ARBITER_BAS_PACKET_FIFO_DATA_WIDTH/8-1:0]																tb_arb_bas_fifo_tkeep,

input  logic 																											tb_arb_msix_fifo_tvalid,
output logic																											tb_arb_msix_fifo_tready,
input  logic [DMA_ARBITER_MSIX_PACKET_FIFO_DATA_WIDTH-1:0]																tb_arb_msix_fifo_tdata,
input  logic [TX_ARB_UWD-1:0]																							tb_arb_msix_fifo_tuser,
input  logic 																											tb_arb_msix_fifo_tlast,
input  logic [TX_ARB_IDWD_INT-1:0]																						tb_arb_msix_fifo_tid,
input  logic [DMA_ARBITER_MSIX_PACKET_FIFO_DATA_WIDTH/8-1:0]															tb_arb_msix_fifo_tkeep,

input  logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0]														tb_arb_h2d_mm_fifo_tvalid,
output logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0]														tb_arb_h2d_mm_fifo_tready,
input  logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0][DMA_ARBITER_H2D_MM_PACKET_FIFO_DATA_WIDTH-1:0]		tb_arb_h2d_mm_fifo_tdata,
input  logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0][TX_ARB_UWD-1:0]										tb_arb_h2d_mm_fifo_tuser,
input  logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0]														tb_arb_h2d_mm_fifo_tlast,
input  logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0][TX_ARB_IDWD_INT-1:0]								tb_arb_h2d_mm_fifo_tid,
input  logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0][DMA_ARBITER_H2D_MM_PACKET_FIFO_DATA_WIDTH/8-1:0]	tb_arb_h2d_mm_fifo_tkeep,
  
input  logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0]														tb_arb_h2d_st_fifo_tvalid,
output logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0]														tb_arb_h2d_st_fifo_tready,
input  logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0][DMA_ARBITER_H2D_ST_PACKET_FIFO_DATA_WIDTH-1:0]		tb_arb_h2d_st_fifo_tdata,
input  logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0][TX_ARB_UWD-1:0]										tb_arb_h2d_st_fifo_tuser,
input  logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0]														tb_arb_h2d_st_fifo_tlast,
input  logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0][TX_ARB_IDWD_INT-1:0]								tb_arb_h2d_st_fifo_tid,
input  logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0][DMA_ARBITER_H2D_ST_PACKET_FIFO_DATA_WIDTH/8-1:0]	tb_arb_h2d_st_fifo_tkeep,
  
input  logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0]														tb_arb_d2h_st_fifo_tvalid,
output logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0]														tb_arb_d2h_st_fifo_tready,
input  logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0][DMA_ARBITER_D2H_ST_PACKET_FIFO_DATA_WIDTH-1:0]		tb_arb_d2h_st_fifo_tdata,
input  logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0][TX_ARB_UWD-1:0]										tb_arb_d2h_st_fifo_tuser,
input  logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0]														tb_arb_d2h_st_fifo_tlast,
input  logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0][TX_ARB_IDWD_INT-1:0]								tb_arb_d2h_st_fifo_tid,
input  logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0][DMA_ARBITER_D2H_ST_PACKET_FIFO_DATA_WIDTH/8-1:0]	tb_arb_d2h_st_fifo_tkeep,

output logic                      																						tb_arb_st_source_tvalid,
output logic [DMA_ARBITER_PACKET_FIFO_DATA_WIDTH-1:0] 																	tb_arb_st_source_tdata,
output logic [TX_ARB_UWD-1:0] 																							tb_arb_st_source_tuser,
output logic                      																						tb_arb_st_source_tlast,
output logic [TX_ARB_IDWD -1:0] 																						tb_arb_st_source_tid,
output logic [DMA_ARBITER_PACKET_FIFO_DATA_WIDTH/8-1:0] 																tb_arb_st_source_tkeep,
`endif // DIRECTED_TB_ARB_STIMULUS_EN
`endif // DIRECTED_TB_STIMULUS_EN

// DMA Only mode
// input  logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0] 													h2d_mm_descrwr_axi_st_source_tvalid, 
// output logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0] 													h2d_mm_descrwr_axi_st_source_tready, 
// input  logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0][AGENT_DESCRIPTOR_DATA_WIDTH-1:0]					h2d_mm_descrwr_axi_st_source_tdata,  
// input  logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0]														h2d_mm_descrwr_axi_st_source_tlast,  

// output logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0] 													h2d_mm_descrresp_axi_st_sink_tvalid, 
// output logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0][AGENT_RESPONDER_DATA_WIDTH-1:0]						h2d_mm_descrresp_axi_st_sink_tdata,  
// output logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0]														h2d_mm_descrresp_axi_st_sink_tlast,  

///////////////////////////////////////////////////////////////////////////////////////////////////////////

// input  logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0] 													h2d_st_descrwr_axi_st_source_tvalid, 
// output logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0] 													h2d_st_descrwr_axi_st_source_tready, 
// input  logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0][AGENT_DESCRIPTOR_DATA_WIDTH-1:0]					h2d_st_descrwr_axi_st_source_tdata,  
// input  logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0]														h2d_st_descrwr_axi_st_source_tlast,  

// output logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0] 													h2d_st_descrresp_axi_st_sink_tvalid, 
// output logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0][AGENT_RESPONDER_DATA_WIDTH-1:0]						h2d_st_descrresp_axi_st_sink_tdata,  
// output logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0]														h2d_st_descrresp_axi_st_sink_tlast,  

///////////////////////////////////////////////////////////////////////////////////////////////////////////

// input  logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0] 													d2h_st_descrwr_axi_st_source_tvalid, 
// output logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0] 													d2h_st_descrwr_axi_st_source_tready, 
// input  logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0][AGENT_DESCRIPTOR_DATA_WIDTH-1:0]					d2h_st_descrwr_axi_st_source_tdata,  
// input  logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0]														d2h_st_descrwr_axi_st_source_tlast,  

// output logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0] 													d2h_st_descrresp_axi_st_sink_tvalid, 
// output logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0][AGENT_RESPONDER_DATA_WIDTH-1:0]						d2h_st_descrresp_axi_st_sink_tdata,  
// output logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0]														d2h_st_descrresp_axi_st_sink_tlast,  

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

output logic																											app_reset_status_n
);

localparam AGENT_CONTROL_PORT_PIPELINE																				= 2;

localparam NUM_RESET_OUTPUT_DUPLICATE																				= 2; // one dedicated register bit for each wrapper module
localparam PCIE_SOC_WRAPPER_RESET_INPUT_INDEX																		= 0; // 
localparam DEVICE_AGENT_WRAPPER_RESET_INPUT_INDEX																	= 1; // 


logic																												irq_bit;

logic																												watchdog_timer_en;
logic [19:0]																										watchdog_timeout;
logic 																												watchdog_timeout_error;
logic 																												bam_watchdog_timeout_error; // output pulse from BAM (PCIe mode)
logic 																												host_watchdog_timeout_error; // output pulse from Host (SoC and DMA Only modes)

logic [5-1:0]  																										pcie_pf_num;	// 
logic [5-1:0]  																										pcie_dev_num;	// 
logic [8-1:0]  																										pcie_bus_num;	// 
logic [1-1:0]  																										pcie_bus_num_valid; // 

logic [5-1:0]  																										pcie_pf_id;
logic [12-1:0]  																									pcie_vf_id;
logic [1-1:0]  																										pcie_vf_in_slot_pf;
logic [5-1:0]  																										pcie_slot_id;

logic [1-1:0]  																										pcie_bus_master_en;

logic [1-1:0]  																										pcie_msix_mask;
logic [1-1:0]  																										pcie_msix_en;

logic [1-1:0]  																										pcie_mem_space_en;

logic [1-1:0]  																										pcie_exp_rom_enable;

logic [1-1:0]  																										pcie_tph_req_en;

logic [1-1:0]  																										pcie_ats_en;

logic [1-1:0]  																										pcie_msi_en;
logic [1-1:0]  																										pcie_msi_mask;

logic [1-1:0]  																										pcie_ext_tag_en;
logic [1-1:0]  																										pcie_tag_req_10bit_en;

logic [1-1:0]  																										pcie_ptm_en;

logic [3-1:0]  																										pcie_mps;
logic [3-1:0]  																										pcie_mrrs;

logic [1-1:0]  																										pcie_vf_en;
logic [1-1:0]  																										pcie_page_req_en;

logic [5-1:0]  																										host_pf_id;
logic [12-1:0]  																									host_vf_id;
logic [1-1:0]  																										host_vf_in_slot_pf;
logic [5-1:0]  																										host_slot_id;

logic [1-1:0]  																										host_bus_master_en;
logic [1-1:0]  																										host_msix_mask;
logic [1-1:0]  																										host_msix_en;
logic [1-1:0]  																										host_mem_space_en;
logic [1-1:0]  																										host_exp_rom_enable;
logic [1-1:0]  																										host_tph_req_en;
logic [1-1:0]  																										host_ats_en;
logic [1-1:0]  																										host_msi_en;
logic [1-1:0]  																										host_msi_mask;
logic [1-1:0]  																										host_ext_tag_en;
logic [1-1:0]  																										host_tag_req_10bit_en;
logic [1-1:0]  																										host_ptm_en;
logic [3-1:0]  																										host_mps;
logic [3-1:0]  																										host_mrrs;
logic [1-1:0]  																										host_vf_en;
logic [1-1:0]  																										host_page_req_en;

logic [5-1:0]  																										host_pf_num;	// 
logic [5-1:0]  																										host_dev_num;	// 
logic [8-1:0]  																										host_bus_num;	// 
logic [1-1:0]  																										host_bus_num_valid; // 

logic [5:0]  																										txcred_dmaarb_valid;

logic [11:0] 																										txcred_dmaarb_p_head;
logic [15:0] 																										txcred_dmaarb_p_data;

logic [11:0] 																										txcred_dmaarb_np_head;
logic [15:0] 																										txcred_dmaarb_np_data;

logic [1-1:0]  																										host_reset_status_n;

logic 																												arb_bas_fifo_tvalid;
logic																												arb_bas_fifo_tready;
logic [DMA_ARBITER_BAS_PACKET_FIFO_DATA_WIDTH-1:0]																	arb_bas_fifo_tdata;
logic [TX_ARB_UWD-1:0]																								arb_bas_fifo_tuser;
logic 																												arb_bas_fifo_tlast;
logic [TX_ARB_IDWD_INT-1:0]																							arb_bas_fifo_tid;
logic [DMA_ARBITER_BAS_PACKET_FIFO_DATA_WIDTH/8-1:0]																arb_bas_fifo_tkeep;

`ifndef DIRECTED_TB_ARB_STIMULUS_EN
logic                      																							arb_st_source_tvalid;
logic                      																							arb_st_source_tready;
logic [DMA_ARBITER_PACKET_FIFO_DATA_WIDTH-1:0] 																		arb_st_source_tdata;
logic [TX_ARB_UWD-1:0] 																								arb_st_source_tuser;
logic                      																							arb_st_source_tlast;
logic [TX_ARB_IDWD -1:0] 																							arb_st_source_tid;
logic [DMA_ARBITER_PACKET_FIFO_DATA_WIDTH/8-1:0] 																	arb_st_source_tkeep;
`endif // DIRECTED_TB_ARB_STIMULUS_EN		

// `ifndef DIRECTED_TB_ARB_STIMULUS_EN
logic 																												arb_msix_fifo_tvalid;
logic																												arb_msix_fifo_tready;
logic [DMA_ARBITER_MSIX_PACKET_FIFO_DATA_WIDTH-1:0]																	arb_msix_fifo_tdata;
logic [TX_ARB_UWD-1:0]																								arb_msix_fifo_tuser;
logic 																												arb_msix_fifo_tlast;
logic [TX_ARB_IDWD_INT-1:0]																							arb_msix_fifo_tid;
logic [DMA_ARBITER_MSIX_PACKET_FIFO_DATA_WIDTH/8-1:0]																arb_msix_fifo_tkeep;

logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0]														arb_h2d_mm_fifo_tvalid;
logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0]														arb_h2d_mm_fifo_tready;
logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0][DMA_ARBITER_H2D_MM_PACKET_FIFO_DATA_WIDTH-1:0]			arb_h2d_mm_fifo_tdata;
logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0][TX_ARB_UWD-1:0]										arb_h2d_mm_fifo_tuser;
logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0]														arb_h2d_mm_fifo_tlast;
logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0][TX_ARB_IDWD_INT-1:0]									arb_h2d_mm_fifo_tid;
logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0][DMA_ARBITER_H2D_MM_PACKET_FIFO_DATA_WIDTH/8-1:0]		arb_h2d_mm_fifo_tkeep;
  
logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0]														arb_h2d_st_fifo_tvalid;
logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0]														arb_h2d_st_fifo_tready;
logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0][DMA_ARBITER_H2D_ST_PACKET_FIFO_DATA_WIDTH-1:0]			arb_h2d_st_fifo_tdata;
logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0][TX_ARB_UWD-1:0]										arb_h2d_st_fifo_tuser;
logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0]														arb_h2d_st_fifo_tlast;
logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0][TX_ARB_IDWD_INT-1:0]									arb_h2d_st_fifo_tid;
logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0][DMA_ARBITER_H2D_ST_PACKET_FIFO_DATA_WIDTH/8-1:0]		arb_h2d_st_fifo_tkeep;
  
logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0]														arb_d2h_st_fifo_tvalid;
logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0]														arb_d2h_st_fifo_tready;
logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0][DMA_ARBITER_D2H_ST_PACKET_FIFO_DATA_WIDTH-1:0]			arb_d2h_st_fifo_tdata;
logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0][TX_ARB_UWD-1:0]										arb_d2h_st_fifo_tuser;
logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0]														arb_d2h_st_fifo_tlast;
logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0][TX_ARB_IDWD_INT-1:0]									arb_d2h_st_fifo_tid;
logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0][DMA_ARBITER_D2H_ST_PACKET_FIFO_DATA_WIDTH/8-1:0]		arb_d2h_st_fifo_tkeep;
// `endif // DIRECTED_TB_ARB_STIMULUS_EN		

// `ifndef DIRECTED_TB_CSR_STIMULUS_EN
logic [HOST_CSR_AWD-1:0] 																							msix_csr_addr_i;
logic                    																							msix_csr_wrreq_i;
logic [HOST_CSR_DWD-1:0] 																							msix_csr_wdata_i;
logic                    																							msix_csr_rdreq_i;
logic [HOST_CSR_DWD-1:0] 																							msix_csr_rdata_o;
logic                    																							msix_csr_rdvalid_o;
logic                    																							msix_csr_req_ack_o;

// To access responder table & updates status registers from QCSR 
logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0][HOST_CSR_AWD-1:0]										h2d_mm_csr_addr_i;
logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0][HOST_CSR_DWD-1:0]										h2d_mm_csr_wdata_i;
logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0][HOST_CSR_DWD-1:0]										h2d_mm_csr_rdata_o;
logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0]  														h2d_mm_csr_wrreq_i;
logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0]        												h2d_mm_csr_rdreq_i;
logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0]  														h2d_mm_csr_rdvalid_o;
logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0]  														h2d_mm_csr_req_ack_o;

// To access responder table & updates status registers from QCSR 
logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0][HOST_CSR_AWD-1:0]										h2d_st_csr_addr_i;
logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0][HOST_CSR_DWD-1:0]										h2d_st_csr_wdata_i;
logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0][HOST_CSR_DWD-1:0]										h2d_st_csr_rdata_o;
logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0]        												h2d_st_csr_rdreq_i;
logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0]  														h2d_st_csr_wrreq_i;
logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0]  														h2d_st_csr_req_ack_o;
logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0]  														h2d_st_csr_rdvalid_o;

// To access responder table & updates status registers from QCSR 
logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0][HOST_CSR_AWD-1:0]										d2h_st_csr_addr_i;
logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0][HOST_CSR_DWD-1:0]   									d2h_st_csr_wdata_i;
logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0][HOST_CSR_DWD-1:0]   									d2h_st_csr_rdata_o;
logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0]  														d2h_st_csr_wrreq_i;
logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0]        												d2h_st_csr_rdreq_i;
logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0]  														d2h_st_csr_rdvalid_o;
logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0]  														d2h_st_csr_req_ack_o;
// `endif // DIRECTED_TB_CSR_STIMULUS_EN	

logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0]														router_h2d_mm_fifo_tvalid;
logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0]														router_h2d_mm_fifo_tready;
logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0][DMA_ROUTER_H2D_MM_PACKET_FIFO_DATA_WIDTH-1:0]			router_h2d_mm_fifo_tdata;
logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0][RX_ARB_UWD-1:0]										router_h2d_mm_fifo_tuser;
logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0]														router_h2d_mm_fifo_tlast;
logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0][RX_ARB_IDWD_INT-1:0]									router_h2d_mm_fifo_tid;
logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0][DMA_ROUTER_H2D_MM_PACKET_FIFO_DATA_WIDTH/8-1:0]		router_h2d_mm_fifo_tkeep;
  
logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0]														router_h2d_st_fifo_tvalid;
logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0]														router_h2d_st_fifo_tready;
logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0][DMA_ROUTER_H2D_ST_PACKET_FIFO_DATA_WIDTH-1:0]			router_h2d_st_fifo_tdata;
logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0][RX_ARB_UWD-1:0]										router_h2d_st_fifo_tuser;
logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0]														router_h2d_st_fifo_tlast;
logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0][RX_ARB_IDWD_INT-1:0]									router_h2d_st_fifo_tid;
logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0][DMA_ROUTER_H2D_ST_PACKET_FIFO_DATA_WIDTH/8-1:0]		router_h2d_st_fifo_tkeep;
  
logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0]														router_d2h_st_fifo_tvalid;
logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0]														router_d2h_st_fifo_tready;
logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0][DMA_ROUTER_D2H_ST_PACKET_FIFO_DATA_WIDTH-1:0]			router_d2h_st_fifo_tdata;
logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0][RX_ARB_UWD-1:0]										router_d2h_st_fifo_tuser;
logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0]														router_d2h_st_fifo_tlast;
logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0][RX_ARB_IDWD_INT-1:0]									router_d2h_st_fifo_tid;
logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0][DMA_ROUTER_D2H_ST_PACKET_FIFO_DATA_WIDTH/8-1:0]		router_d2h_st_fifo_tkeep;

logic 																												router_msix_fifo_tvalid;
logic																												router_msix_fifo_tready;
logic [DMA_ROUTER_MSIX_PACKET_FIFO_DATA_WIDTH-1:0]																	router_msix_fifo_tdata;
logic [RX_ARB_UWD-1:0]																								router_msix_fifo_tuser;
logic 																												router_msix_fifo_tlast;
logic [RX_ARB_IDWD_INT-1:0]																							router_msix_fifo_tid;
logic [DMA_ROUTER_MSIX_PACKET_FIFO_DATA_WIDTH/8-1:0]																router_msix_fifo_tkeep;

logic 																												router_bas_fifo_tvalid;
logic																												router_bas_fifo_tready;
logic [DMA_ROUTER_BAS_PACKET_FIFO_DATA_WIDTH-1:0]																	router_bas_fifo_tdata;
logic [RX_ARB_UWD-1:0]																								router_bas_fifo_tuser;
logic 																												router_bas_fifo_tlast;
logic [RX_ARB_IDWD_INT-1:0]																							router_bas_fifo_tid;
logic [DMA_ROUTER_BAS_PACKET_FIFO_DATA_WIDTH/8-1:0]																	router_bas_fifo_tkeep;

logic [((NUM_D2H_ST_CHANS_DERIVED==0) ? 0 : (NUM_D2H_ST_CHANS_DERIVED-1)):0]										d2h_st_byteack_valid;
logic [((NUM_D2H_ST_CHANS_DERIVED==0) ? 0 : (NUM_D2H_ST_CHANS_DERIVED-1)):0][HOST_CSR_DWD-1:0]						d2h_st_byteack;

logic [((NUM_H2D_MM_CHANS_DERIVED==0) ? 0 : (NUM_H2D_MM_CHANS_DERIVED-1)):0]										h2d_mm_q_descr_buffer_full;
logic [((NUM_H2D_MM_CHANS_DERIVED==0) ? 0 : (NUM_H2D_MM_CHANS_DERIVED-1)):0]										h2d_mm_q_descr_buffer_empty;
logic [((NUM_H2D_MM_CHANS_DERIVED==0) ? 0 : (NUM_H2D_MM_CHANS_DERIVED-1)):0]										h2d_mm_q_resp_buffer_full;
logic [((NUM_H2D_MM_CHANS_DERIVED==0) ? 0 : (NUM_H2D_MM_CHANS_DERIVED-1)):0]										h2d_mm_q_resp_buffer_empty;

logic [((NUM_H2D_ST_CHANS_DERIVED==0) ? 0 : (NUM_H2D_ST_CHANS_DERIVED-1)):0]										h2d_st_q_descr_buffer_full;
logic [((NUM_H2D_ST_CHANS_DERIVED==0) ? 0 : (NUM_H2D_ST_CHANS_DERIVED-1)):0]										h2d_st_q_descr_buffer_empty;
logic [((NUM_H2D_ST_CHANS_DERIVED==0) ? 0 : (NUM_H2D_ST_CHANS_DERIVED-1)):0]										h2d_st_q_resp_buffer_full;
logic [((NUM_H2D_ST_CHANS_DERIVED==0) ? 0 : (NUM_H2D_ST_CHANS_DERIVED-1)):0]										h2d_st_q_resp_buffer_empty;

logic [((NUM_D2H_ST_CHANS_DERIVED==0) ? 0 : (NUM_D2H_ST_CHANS_DERIVED-1)):0]										d2h_st_q_descr_buffer_full;
logic [((NUM_D2H_ST_CHANS_DERIVED==0) ? 0 : (NUM_D2H_ST_CHANS_DERIVED-1)):0]										d2h_st_q_descr_buffer_empty;
logic [((NUM_D2H_ST_CHANS_DERIVED==0) ? 0 : (NUM_D2H_ST_CHANS_DERIVED-1)):0]										d2h_st_q_resp_buffer_full;
logic [((NUM_D2H_ST_CHANS_DERIVED==0) ? 0 : (NUM_D2H_ST_CHANS_DERIVED-1)):0]										d2h_st_q_resp_buffer_empty;

logic [((NUM_H2D_MM_CHANS_DERIVED==0) ? 0 : (NUM_H2D_MM_CHANS_DERIVED-1)):0] 										h2d_mm_q_desc_completion_valid;
logic [((NUM_H2D_ST_CHANS_DERIVED==0) ? 0 : (NUM_H2D_ST_CHANS_DERIVED-1)):0] 										h2d_st_q_desc_completion_valid;
logic [((NUM_D2H_ST_CHANS_DERIVED==0) ? 0 : (NUM_D2H_ST_CHANS_DERIVED-1)):0] 										d2h_st_q_desc_completion_valid;
			
logic [((NUM_D2H_ST_CHANS_DERIVED==0) ? 0 : (NUM_D2H_ST_CHANS_DERIVED-1)):0] 										d2h_st_q_video_flushing_event_valid;

`ifdef COMPLETER_INSTANCE_EN
logic [RX_ARB_DWD-1:0]																								router_completer_tdata;
logic               																								router_completer_tvalid;
logic [RX_ARB_IDWD-1:0]																								router_completer_tid;
logic [RX_ARB_BENWD-1:0]																							router_completer_tkeep;
logic               																								router_completer_tlast;
logic [RX_ARB_UWD-1:0]																								router_completer_tuser;
logic               																								router_completer_tready;
`endif // COMPLETER_INSTANCE_EN

// `ifdef PREFETCHER_INSTANCE_EN
logic                    																							prefetch_msix_ready;
logic                    																							prefetch_msix_valid;
logic [16-1:0]           																							prefetch_msix_data;

logic [HOST_CSR_AWD-1:0]        																					prefetch_csr_addr_i;
logic [1-1:0]  																										prefetch_csr_wrreq_i;
logic [HOST_CSR_DWD-1:0]        																					prefetch_csr_wdata_i;
logic [1-1:0]  																										prefetch_csr_rdreq_i;
logic [HOST_CSR_DWD-1:0]       																						prefetch_csr_rdata_o;
logic [1-1:0]  																										prefetch_csr_rdvalid_o;
logic [1-1:0]  																										prefetch_csr_req_ack_o;

logic 																												arb_prefetch_fifo_mem_write_tvalid;
logic																												arb_prefetch_fifo_mem_write_tready;
logic [DMA_ARBITER_PREFETCH_MEM_WRITE_PACKET_FIFO_DATA_WIDTH-1:0]													arb_prefetch_fifo_mem_write_tdata;
logic [TX_ARB_UWD-1:0]																								arb_prefetch_fifo_mem_write_tuser;
logic 																												arb_prefetch_fifo_mem_write_tlast;
logic [TX_ARB_IDWD_INT-1:0]																							arb_prefetch_fifo_mem_write_tid;
logic [DMA_ARBITER_PREFETCH_MEM_WRITE_PACKET_FIFO_DATA_WIDTH/8-1:0]													arb_prefetch_fifo_mem_write_tkeep;

logic 																												arb_prefetch_fifo_mem_read_tvalid;
logic																												arb_prefetch_fifo_mem_read_tready;
logic [DMA_ARBITER_PREFETCH_MEM_READ_PACKET_FIFO_DATA_WIDTH-1:0]													arb_prefetch_fifo_mem_read_tdata;
logic [TX_ARB_UWD-1:0]																								arb_prefetch_fifo_mem_read_tuser;
logic 																												arb_prefetch_fifo_mem_read_tlast;
logic [TX_ARB_IDWD_INT-1:0]																							arb_prefetch_fifo_mem_read_tid;
logic [DMA_ARBITER_PREFETCH_MEM_READ_PACKET_FIFO_DATA_WIDTH/8-1:0]													arb_prefetch_fifo_mem_read_tkeep;

logic 																												router_prefetch_fifo_mem_write_tvalid;
logic																												router_prefetch_fifo_mem_write_tready;
logic [DMA_ROUTER_PREFETCH_MEM_WRITE_PACKET_FIFO_DATA_WIDTH-1:0]													router_prefetch_fifo_mem_write_tdata;
logic [RX_ARB_UWD-1:0]																								router_prefetch_fifo_mem_write_tuser;
logic 																												router_prefetch_fifo_mem_write_tlast;
logic [RX_ARB_IDWD_INT-1:0]																							router_prefetch_fifo_mem_write_tid;
logic [DMA_ROUTER_PREFETCH_MEM_WRITE_PACKET_FIFO_DATA_WIDTH/8-1:0]													router_prefetch_fifo_mem_write_tkeep;

logic 																												router_prefetch_fifo_mem_read_tvalid;
logic																												router_prefetch_fifo_mem_read_tready;
logic [DMA_ROUTER_PREFETCH_MEM_READ_PACKET_FIFO_DATA_WIDTH-1:0]														router_prefetch_fifo_mem_read_tdata;
logic [RX_ARB_UWD-1:0]																								router_prefetch_fifo_mem_read_tuser;
logic 																												router_prefetch_fifo_mem_read_tlast;
logic [RX_ARB_IDWD_INT-1:0]																							router_prefetch_fifo_mem_read_tid;
logic [DMA_ROUTER_PREFETCH_MEM_READ_PACKET_FIFO_DATA_WIDTH/8-1:0]													router_prefetch_fifo_mem_read_tkeep;

logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0] 														h2d_mm_desc_axi_st_source_tvalid; //width = 1 per device port
logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0] 														h2d_mm_desc_axi_st_source_tready; //width = 1 per device port
logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0][AGENT_DESCRIPTOR_DATA_WIDTH-1:0]						h2d_mm_desc_axi_st_source_tdata;  //width = 32 or 256 per device port //TO_ASK: how do we differentiate each agent's data widht?
logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0]														h2d_mm_desc_axi_st_source_tlast;  //width = 1 per device port

logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0] 														h2d_st_desc_axi_st_source_tvalid; //width = 1 per device port
logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0] 														h2d_st_desc_axi_st_source_tready; //width = 1 per device port
logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0][AGENT_DESCRIPTOR_DATA_WIDTH-1:0]						h2d_st_desc_axi_st_source_tdata;  //width = 32 or 256 per device port //TO_ASK: how do we differentiate each agent's data widht?
logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0]														h2d_st_desc_axi_st_source_tlast;  //width = 1 per device port

logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0] 														d2h_st_desc_axi_st_source_tvalid; //width = 1 per device port
logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0] 														d2h_st_desc_axi_st_source_tready; //width = 1 per device port
logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0][AGENT_DESCRIPTOR_DATA_WIDTH-1:0]						d2h_st_desc_axi_st_source_tdata;  //width = 32 or 256 per device port //TO_ASK: how do we differentiate each agent's data widht?
logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0]														d2h_st_desc_axi_st_source_tlast;  //width = 1 per device port

logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0]														h2d_mm_agent_descriptor_taken; //Agent sends a pulse when a descriptor is taken from the agent's descriptor FIFO (a descriptor is 32 bytes)
logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0]														h2d_st_agent_descriptor_taken; //Agent sends a pulse when a descriptor is taken from the agent's descriptor FIFO (a descriptor is 32 bytes)
logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0]														d2h_st_agent_descriptor_taken; //Agent sends a pulse when a descriptor is taken from the agent's descriptor FIFO (a descriptor is 32 bytes)

logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0] 														h2d_mm_resp_axi_st_sink_tvalid; //width = 1 per device port
logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0] 														h2d_mm_resp_axi_st_sink_tready; //width = 1 per device port
logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0][AGENT_RESPONDER_DATA_WIDTH-1:0]						h2d_mm_resp_axi_st_sink_tdata;  //width = 32 or 256 per device port //TO_ASK: how do we differentiate each agent's data widht?
logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0]														h2d_mm_resp_axi_st_sink_tlast;  //width = 1 per device port

logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0] 														h2d_st_resp_axi_st_sink_tvalid; //width = 1 per device port
logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0] 														h2d_st_resp_axi_st_sink_tready; //width = 1 per device port
logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0][AGENT_RESPONDER_DATA_WIDTH-1:0]						h2d_st_resp_axi_st_sink_tdata;  //width = 32 or 256 per device port //TO_ASK: how do we differentiate each agent's data widht?
logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0]														h2d_st_resp_axi_st_sink_tlast;  //width = 1 per device port

logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0] 														d2h_st_resp_axi_st_sink_tvalid; //width = 1 per device port
logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0] 														d2h_st_resp_axi_st_sink_tready; //width = 1 per device port
logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0][AGENT_RESPONDER_DATA_WIDTH-1:0]						d2h_st_resp_axi_st_sink_tdata;  //width = 32 or 256 per device port //TO_ASK: how do we differentiate each agent's data widht?
logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0]														d2h_st_resp_axi_st_sink_tlast;  //width = 1 per device port

logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0]														h2d_mm_agent_responder_added; //Agent sends a pulse when a responder is filled into the agent's responder FIFO (a responder is 32 bytes)
logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0]														h2d_st_agent_responder_added; //Agent sends a pulse when a responder is filled into the agent's responder FIFO (a responder is 32 bytes)
logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0]														d2h_st_agent_responder_added; //Agent sends a pulse when a responder is filled into the agent's responder FIFO (a responder is 32 bytes)

logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0]														d2h_st_agent_flush_int; //Agent asserts this signal when it requires prefetcher to send a flush MSI-X interrupt to the host. It will be cleared once prefetcher sends the ACK.
logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0]														d2h_st_agent_flush_ack; //Agent sends a single clock pulse to acknowledge the flush interrupt from agent. 
// `endif // PREFETCHER_INSTANCE_EN

logic [1-1:0]  																										csr_reset_n_sync;

logic [1-1:0]  						ss_axi_st_clk;

assign ss_axi_st_clk				= host_clk;
assign host_reset_status_n			= host_aresetn;

logic [((NUM_H2D_MM_CHANS_DERIVED==0) ? 0 : (NUM_H2D_MM_CHANS_DERIVED-1)):0]  										h2d_mm_q_en_wire;  				
logic [((NUM_H2D_MM_CHANS_DERIVED==0) ? 0 : (NUM_H2D_MM_CHANS_DERIVED-1)):0]  										h2d_mm_prefetch_irq_en_wire; 	
logic [((NUM_H2D_MM_CHANS_DERIVED==0) ? 0 : (NUM_H2D_MM_CHANS_DERIVED-1)):0]  										h2d_mm_wb_en_wire; 					
logic [((NUM_H2D_MM_CHANS_DERIVED==0) ? 0 : (NUM_H2D_MM_CHANS_DERIVED-1)):0]  										h2d_mm_irq_en_wire; 				
logic [((NUM_H2D_MM_CHANS_DERIVED==0) ? 0 : (NUM_H2D_MM_CHANS_DERIVED-1)):0]  										h2d_mm_q_pause_agent_control_wire; 
logic [((NUM_H2D_MM_CHANS_DERIVED==0) ? 0 : (NUM_H2D_MM_CHANS_DERIVED-1)):0]  										h2d_mm_q_sw_reset_req_wire; 		
						
logic [((NUM_H2D_ST_CHANS_DERIVED==0) ? 0 : (NUM_H2D_ST_CHANS_DERIVED-1)):0]  										h2d_st_prefetch_irq_en_wire;
logic [((NUM_H2D_ST_CHANS_DERIVED==0) ? 0 : (NUM_H2D_ST_CHANS_DERIVED-1)):0]  										h2d_st_q_en_wire;
logic [((NUM_H2D_ST_CHANS_DERIVED==0) ? 0 : (NUM_H2D_ST_CHANS_DERIVED-1)):0]  										h2d_st_irq_en_wire;
logic [((NUM_H2D_ST_CHANS_DERIVED==0) ? 0 : (NUM_H2D_ST_CHANS_DERIVED-1)):0]  										h2d_st_wb_en_wire;
logic [((NUM_H2D_ST_CHANS_DERIVED==0) ? 0 : (NUM_H2D_ST_CHANS_DERIVED-1)):0]  										h2d_st_q_pause_agent_control_wire;
logic [((NUM_H2D_ST_CHANS_DERIVED==0) ? 0 : (NUM_H2D_ST_CHANS_DERIVED-1)):0]  										h2d_st_q_sw_reset_req_wire;
  										
logic [((NUM_D2H_ST_CHANS_DERIVED==0) ? 0 : (NUM_D2H_ST_CHANS_DERIVED-1)):0]  										d2h_st_prefetch_irq_en_wire;
logic [((NUM_D2H_ST_CHANS_DERIVED==0) ? 0 : (NUM_D2H_ST_CHANS_DERIVED-1)):0]  										d2h_st_q_en_wire;
logic [((NUM_D2H_ST_CHANS_DERIVED==0) ? 0 : (NUM_D2H_ST_CHANS_DERIVED-1)):0]  										d2h_st_irq_en_wire;
logic [((NUM_D2H_ST_CHANS_DERIVED==0) ? 0 : (NUM_D2H_ST_CHANS_DERIVED-1)):0]  										d2h_st_wb_en_wire;
logic [((NUM_D2H_ST_CHANS_DERIVED==0) ? 0 : (NUM_D2H_ST_CHANS_DERIVED-1)):0]  										d2h_st_q_pause_agent_control_wire;
logic [((NUM_D2H_ST_CHANS_DERIVED==0) ? 0 : (NUM_D2H_ST_CHANS_DERIVED-1)):0]  										d2h_st_q_sw_reset_req_wire;

logic [((NUM_H2D_MM_CHANS_DERIVED==0) ? 0 : (NUM_H2D_MM_CHANS_DERIVED-1)):0]										h2d_mm_q_en_pipeline;
logic [((NUM_H2D_MM_CHANS_DERIVED==0) ? 0 : (NUM_H2D_MM_CHANS_DERIVED-1)):0]										h2d_mm_irq_en_pipeline;
logic [((NUM_H2D_MM_CHANS_DERIVED==0) ? 0 : (NUM_H2D_MM_CHANS_DERIVED-1)):0]										h2d_mm_q_pause_agent_control_pipeline;
logic [((NUM_H2D_MM_CHANS_DERIVED==0) ? 0 : (NUM_H2D_MM_CHANS_DERIVED-1)):0]										h2d_mm_q_sw_reset_req_pipeline;
								
logic [((NUM_H2D_ST_CHANS_DERIVED==0) ? 0 : (NUM_H2D_ST_CHANS_DERIVED-1)):0]										h2d_st_q_en_pipeline;
logic [((NUM_H2D_ST_CHANS_DERIVED==0) ? 0 : (NUM_H2D_ST_CHANS_DERIVED-1)):0]										h2d_st_irq_en_pipeline;
logic [((NUM_H2D_ST_CHANS_DERIVED==0) ? 0 : (NUM_H2D_ST_CHANS_DERIVED-1)):0]										h2d_st_q_pause_agent_control_pipeline;
logic [((NUM_H2D_ST_CHANS_DERIVED==0) ? 0 : (NUM_H2D_ST_CHANS_DERIVED-1)):0]										h2d_st_q_sw_reset_req_pipeline;
								
logic [((NUM_D2H_ST_CHANS_DERIVED==0) ? 0 : (NUM_D2H_ST_CHANS_DERIVED-1)):0]										d2h_st_q_en_pipeline;
logic [((NUM_D2H_ST_CHANS_DERIVED==0) ? 0 : (NUM_D2H_ST_CHANS_DERIVED-1)):0]										d2h_st_irq_en_pipeline;
logic [((NUM_D2H_ST_CHANS_DERIVED==0) ? 0 : (NUM_D2H_ST_CHANS_DERIVED-1)):0]										d2h_st_q_pause_agent_control_pipeline;
logic [((NUM_D2H_ST_CHANS_DERIVED==0) ? 0 : (NUM_D2H_ST_CHANS_DERIVED-1)):0]										d2h_st_q_sw_reset_req_pipeline;

logic 																												host_clk_internal;
logic [1-1:0]  																										app_reset_status_n_internal;

assign host_clk_internal			= host_clk;

generate
	if (NUM_H2D_MM_CHANS_DERIVED > 0) begin: H2D_MM_CHANS_CTRL_PIPELINE_GEN		
			intel_ssgdma_hyperflex_pipeline #(
			.DEVICE_FAMILY							(DEVICE_FAMILY),
			.DATA_WIDTH								(NUM_H2D_MM_CHANS_DERIVED),
			.DATA_OUTPUTS_REG_PIPELINE_DEPTH		(AGENT_CONTROL_PORT_PIPELINE)
			) h2d_mm_q_en_pipeline_inst (
			.clk									(host_clk_internal),
			.data_in								(h2d_mm_q_en_wire),
			.data_out_pipeline  					(h2d_mm_q_en_pipeline)   
			);

			intel_ssgdma_hyperflex_pipeline #(
			.DEVICE_FAMILY							(DEVICE_FAMILY),
			.DATA_WIDTH								(NUM_H2D_MM_CHANS_DERIVED),
			.DATA_OUTPUTS_REG_PIPELINE_DEPTH		(AGENT_CONTROL_PORT_PIPELINE)
			) h2d_mm_irq_en_pipeline_inst (
			.clk									(host_clk_internal),
			.data_in								(h2d_mm_irq_en_wire),
			.data_out_pipeline  					(h2d_mm_irq_en_pipeline)   
			);

			intel_ssgdma_hyperflex_pipeline #(
			.DEVICE_FAMILY							(DEVICE_FAMILY),
			.DATA_WIDTH								(NUM_H2D_MM_CHANS_DERIVED),
			.DATA_OUTPUTS_REG_PIPELINE_DEPTH		(AGENT_CONTROL_PORT_PIPELINE)
			) h2d_mm_q_pause_agent_control_pipeline_inst (
			.clk									(host_clk_internal),
			.data_in								(h2d_mm_q_pause_agent_control_wire),
			.data_out_pipeline  					(h2d_mm_q_pause_agent_control_pipeline)   
			);

			intel_ssgdma_hyperflex_pipeline #(
			.DEVICE_FAMILY							(DEVICE_FAMILY),
			.DATA_WIDTH								(NUM_H2D_MM_CHANS_DERIVED),
			.DATA_OUTPUTS_REG_PIPELINE_DEPTH		(AGENT_CONTROL_PORT_PIPELINE)
			) h2d_mm_q_sw_reset_req_pipeline_inst (
			.clk									(host_clk_internal),
			.data_in								(h2d_mm_q_sw_reset_req_wire),
			.data_out_pipeline  					(h2d_mm_q_sw_reset_req_pipeline)   
			);
	end else begin: H2D_MM_CHANS_CTRL_PIPELINE_DIS
			assign h2d_mm_q_pause_agent_control_pipeline	= '0;
			assign h2d_mm_q_sw_reset_req_pipeline			= '0;
			assign h2d_mm_q_en_pipeline						= '0;
			assign h2d_mm_irq_en_pipeline					= '0;
		end	
	
	if (NUM_H2D_ST_CHANS_DERIVED > 0) begin: H2D_ST_CHANS_CTRL_PIPELINE_GEN	
			intel_ssgdma_hyperflex_pipeline #(
			.DEVICE_FAMILY							(DEVICE_FAMILY),
			.DATA_WIDTH								(NUM_H2D_ST_CHANS_DERIVED),
			.DATA_OUTPUTS_REG_PIPELINE_DEPTH		(AGENT_CONTROL_PORT_PIPELINE)
			) h2d_st_q_en_pipeline_inst (
			.clk									(host_clk_internal),
			.data_in								(h2d_st_q_en_wire),
			.data_out_pipeline  					(h2d_st_q_en_pipeline)   
			);

			intel_ssgdma_hyperflex_pipeline #(
			.DEVICE_FAMILY							(DEVICE_FAMILY),
			.DATA_WIDTH								(NUM_H2D_ST_CHANS_DERIVED),
			.DATA_OUTPUTS_REG_PIPELINE_DEPTH		(AGENT_CONTROL_PORT_PIPELINE)
			) h2d_st_irq_en_pipeline_inst (
			.clk									(host_clk_internal),
			.data_in								(h2d_st_irq_en_wire),
			.data_out_pipeline  					(h2d_st_irq_en_pipeline)   
			);

			intel_ssgdma_hyperflex_pipeline #(
			.DEVICE_FAMILY							(DEVICE_FAMILY),
			.DATA_WIDTH								(NUM_H2D_ST_CHANS_DERIVED),
			.DATA_OUTPUTS_REG_PIPELINE_DEPTH		(AGENT_CONTROL_PORT_PIPELINE)
			) h2d_st_q_pause_agent_control_pipeline_inst (
			.clk									(host_clk_internal),
			.data_in								(h2d_st_q_pause_agent_control_wire),
			.data_out_pipeline  					(h2d_st_q_pause_agent_control_pipeline)   
			);

			intel_ssgdma_hyperflex_pipeline #(
			.DEVICE_FAMILY							(DEVICE_FAMILY),
			.DATA_WIDTH								(NUM_H2D_ST_CHANS_DERIVED),
			.DATA_OUTPUTS_REG_PIPELINE_DEPTH		(AGENT_CONTROL_PORT_PIPELINE)
			) h2d_st_q_sw_reset_req_pipeline_inst (
			.clk									(host_clk_internal),
			.data_in								(h2d_st_q_sw_reset_req_wire),
			.data_out_pipeline  					(h2d_st_q_sw_reset_req_pipeline)   
			);
	end else begin: H2D_ST_CHANS_CTRL_PIPELINE_DIS
			assign h2d_st_q_pause_agent_control_pipeline	= '0;
			assign h2d_st_q_sw_reset_req_pipeline			= '0;
			assign h2d_st_q_en_pipeline						= '0;
			assign h2d_st_irq_en_pipeline					= '0;
		end	
	
	if (NUM_D2H_ST_CHANS_DERIVED > 0) begin: D2H_ST_CHANS_CTRL_PIPELINE_GEN	
			intel_ssgdma_hyperflex_pipeline #(
			.DEVICE_FAMILY							(DEVICE_FAMILY),
			.DATA_WIDTH								(NUM_D2H_ST_CHANS_DERIVED),
			.DATA_OUTPUTS_REG_PIPELINE_DEPTH		(AGENT_CONTROL_PORT_PIPELINE)
			) d2h_st_q_en_pipeline_inst (
			.clk									(host_clk_internal),
			.data_in								(d2h_st_q_en_wire),
			.data_out_pipeline  					(d2h_st_q_en_pipeline)   
			);

			intel_ssgdma_hyperflex_pipeline #(
			.DEVICE_FAMILY							(DEVICE_FAMILY),
			.DATA_WIDTH								(NUM_D2H_ST_CHANS_DERIVED),
			.DATA_OUTPUTS_REG_PIPELINE_DEPTH		(AGENT_CONTROL_PORT_PIPELINE)
			) d2h_st_irq_en_pipeline_inst (
			.clk									(host_clk_internal),
			.data_in								(d2h_st_irq_en_wire),
			.data_out_pipeline  					(d2h_st_irq_en_pipeline)   
			);

			intel_ssgdma_hyperflex_pipeline #(
			.DEVICE_FAMILY							(DEVICE_FAMILY),
			.DATA_WIDTH								(NUM_D2H_ST_CHANS_DERIVED),
			.DATA_OUTPUTS_REG_PIPELINE_DEPTH		(AGENT_CONTROL_PORT_PIPELINE)
			) d2h_st_q_pause_agent_control_pipeline_inst (
			.clk									(host_clk_internal),
			.data_in								(d2h_st_q_pause_agent_control_wire),
			.data_out_pipeline  					(d2h_st_q_pause_agent_control_pipeline)   
			);

			intel_ssgdma_hyperflex_pipeline #(
			.DEVICE_FAMILY							(DEVICE_FAMILY),
			.DATA_WIDTH								(NUM_D2H_ST_CHANS_DERIVED),
			.DATA_OUTPUTS_REG_PIPELINE_DEPTH		(AGENT_CONTROL_PORT_PIPELINE)
			) d2h_st_q_sw_reset_req_pipeline_inst (
			.clk									(host_clk_internal),
			.data_in								(d2h_st_q_sw_reset_req_wire),
			.data_out_pipeline  					(d2h_st_q_sw_reset_req_pipeline)   
			);
	end else begin: D2H_ST_CHANS_CTRL_PIPELINE_DIS
			assign d2h_st_q_pause_agent_control_pipeline	= '0;
			assign d2h_st_q_sw_reset_req_pipeline			= '0;
			assign d2h_st_q_en_pipeline						= '0;
			assign d2h_st_irq_en_pipeline					= '0;
		end		
endgenerate

logic [1-1:0]     															app_reset_status_n_delay_out;
logic [1-1:0]     															app_reset_status_n_out_int = '0;

always @(posedge host_clk_internal) begin
	if (~app_reset_status_n_internal) begin
		app_reset_status_n_out_int 		<= '0;
	end else begin	
			app_reset_status_n_out_int 	<= 1'b1;
		end
end 

intel_ssgdma_hyperflex_pipeline #(
.DEVICE_FAMILY																(DEVICE_FAMILY),
.DATA_WIDTH																	(1),
.DATA_OUTPUTS_REG_PIPELINE_DEPTH											(20)
) app_reset_status_n_pipeline_inst (
.clk																		(host_clk_internal),
// .data_in																	(app_reset_status_n_internal),
.data_in																	(app_reset_status_n_out_int),
.data_out_pipeline  														(app_reset_status_n_delay_out)   
);	

assign app_reset_status_n													= app_reset_status_n_delay_out;

logic [1-1:0]     															app_reset_status_n_pipeline_out;
logic [NUM_RESET_OUTPUT_DUPLICATE-1:0]     									app_reset_status_n_pipeline_out_dup	/* synthesis preserve_syn_only dont_merge*/;

intel_ssgdma_hyperflex_reset_controller_simple #(
.DEVICE_FAMILY 																(DEVICE_FAMILY),
.RESET_INPUTS_SYNCHRONIZER_EN 												(0),
.RESET_OUTPUTS_REG_PIPELINE_EN 												(1),
.RESET_OUTPUTS_REG_DUP_DEPTH 												(3)
) app_reset_status_n_sync_inst (
.clk 																		(host_clk_internal),
.reset_n_in 																(app_reset_status_n_internal),
.reset_n_sync_out 															(app_reset_status_n_pipeline_out)  
);


always_ff @(posedge host_clk) begin
	app_reset_status_n_pipeline_out_dup		<= {(NUM_RESET_OUTPUT_DUPLICATE){app_reset_status_n_pipeline_out}};
end

	// Interrupt interface
	assign irq = irq_bit | watchdog_timeout_error;

	intel_ssgdma_soc_and_dma_only_mode_wrapper #(
	.DEVICE_FAMILY      					(DEVICE_FAMILY),
	.DMA_MODE								(DMA_MODE),
	.MAX_PAYLOAD_SIZE						(MAX_PAYLOAD_SIZE),
	.MAX_READ_REQUEST_SIZE					(MAX_READ_REQUEST_SIZE),
	.ECC_EN									(ECC_EN),
	.AXI_ST_PORT_FREQ						(AXI_ST_PORT_FREQ),
	.UNALIGNED_ACCESS_EN					(UNALIGNED_ACCESS_EN),

	.HOST_INT_TYPE							(HOST_INT_TYPE	),
	.HOST_AWD    							(HOST_AWD    	),
	.HOST_IDWD    							(HOST_IDWD    	),
	.HOST_LWD    							(HOST_LWD    	),
	.HOST_DWD    							(HOST_DWD    	),

	.HOST_CSR_AWD    						(HOST_CSR_AWD  ),
	.HOST_CSR_DWD    						(HOST_CSR_DWD  ),

	.NUM_H2D_MM_PORTS						(NUM_H2D_MM_PORTS),
	.NUM_H2D_ST_PORTS						(NUM_H2D_ST_PORTS),
	.NUM_D2H_ST_PORTS						(NUM_D2H_ST_PORTS),

	.NUM_H2D_MM_CHANS						(NUM_H2D_MM_CHANS),
	.NUM_H2D_ST_CHANS						(NUM_H2D_ST_CHANS),
	.NUM_D2H_ST_CHANS						(NUM_D2H_ST_CHANS),

	.NUM_H2D_D2H_PORTS						(NUM_H2D_D2H_PORTS),

	.SS_ST_DWD    							(SS_ST_DWD),

	.TX_ARB_DWD    				    		(TX_ARB_DWD  ),
	.TX_ARB_IDWD    						(TX_ARB_IDWD ),
	.TX_ARB_UWD            		    		(TX_ARB_UWD  ),
	.TX_ARB_BWD         					(TX_ARB_BWD  ),
	.TX_ARB_BENWD        					(TX_ARB_BENWD),

	// .TX_ARB_UWD_INT							(TX_ARB_UWD_INT),
		
	.RX_ARB_DWD    				    		(RX_ARB_DWD  ),
	.RX_ARB_IDWD    						(RX_ARB_IDWD ),
	.RX_ARB_UWD            		    		(RX_ARB_UWD  ),
	.RX_ARB_BWD         					(RX_ARB_BWD  ),
	.RX_ARB_BENWD        					(RX_ARB_BENWD),

	.ARBITER_PACKET_FIFO_DATA_WIDTH			(DMA_ARBITER_PACKET_FIFO_DATA_WIDTH)

	) soc_and_dma_only_mode_wrapper_inst (

    .host_clk                              (host_clk         ),
    .host_aresetn                          (app_reset_status_n_pipeline_out_dup[PCIE_SOC_WRAPPER_RESET_INPUT_INDEX]),

    .axi_lite_clk                          (axi_lite_clk     ),
    .axi_lite_areset_n                     (csr_reset_n_sync),

    .watchdog_timer_en                     (watchdog_timer_en), // input
    .watchdog_timeout                      (watchdog_timeout), //input
    .host_watchdog_timeout_error           (host_watchdog_timeout_error), // output pulse

    //Host AXI-4 Manager
    .host_awvalid                          (host_awvalid),
    .host_awaddr                           (host_awaddr ),
    .host_awsize                           (host_awsize ),
    .host_awprot                           (host_awprot ),
    .host_awlen                            (host_awlen  ),
    .host_awburst                          (host_awburst),
    .host_awid                             (host_awid   ),
    .host_awcache                          (host_awcache),
    .host_awready                          (host_awready),

    .host_wvalid                           (host_wvalid ),
    .host_wdata                            (host_wdata  ),
    .host_wlast                            (host_wlast  ),
    .host_wstrb                            (host_wstrb  ),
    .host_wready                           (host_wready ),

    .host_bready                           (host_bready ),
    .host_bvalid                           (host_bvalid ),
    .host_bresp                            (host_bresp  ),
    .host_bid                              (host_bid    ),

    .host_arvalid                          (host_arvalid),
    .host_araddr                           (host_araddr ),
    .host_arsize                           (host_arsize ),
    .host_arprot                           (host_arprot ),
    .host_arlen                            (host_arlen  ),
    .host_arburst                          (host_arburst),
    .host_arid                             (host_arid   ),
    .host_arcache                          (host_arcache),
    .host_arready                          (host_arready),

    .host_rready                           (host_rready ),
    .host_rdata                            (host_rdata  ),
    .host_rvalid                           (host_rvalid ),
    .host_rlast                            (host_rlast  ),
    .host_rresp                            (host_rresp  ),
    .host_rid                              (host_rid    ),

    // Mem Rd/Wr AXI-ST Interface from DMA Arbiter to SoC Host
    .arb_st_source_tready                  (arb_st_source_tready), //output
    .arb_st_source_tvalid                  (arb_st_source_tvalid), //input
    .arb_st_source_tdata                   (arb_st_source_tdata ),
    .arb_st_source_tkeep                   (arb_st_source_tkeep ),
    .arb_st_source_tlast                   (arb_st_source_tlast ),
    .arb_st_source_tuser                   (arb_st_source_tuser ),
    .arb_st_source_tid                     (arb_st_source_tid   ),

    // Mem Rd/Wr Completion AXI-ST Interface from SoC Host to DMA Router
    .router_completer_tready               (router_completer_tready), //input
    .router_completer_tvalid               (router_completer_tvalid), //output
    .router_completer_tdata                (router_completer_tdata ),
    .router_completer_tkeep                (router_completer_tkeep ),
    .router_completer_tlast                (router_completer_tlast ),
    .router_completer_tuser                (router_completer_tuser ),
    .router_completer_tid                  (router_completer_tid   ),

    // Interrupt Controller
    .prefetch_irq_ready_o                  (prefetch_msix_ready),
    .prefetch_irq_valid_i                  (prefetch_msix_valid),
    .prefetch_irq_data_i                   (prefetch_msix_data ),

    .h2d_mm_q_desc_completion_valid        (h2d_mm_q_desc_completion_valid),//output
    .h2d_st_q_desc_completion_valid        (h2d_st_q_desc_completion_valid),//output
    .d2h_st_q_desc_completion_valid        (d2h_st_q_desc_completion_valid),//output

    .d2h_st_q_video_flushing_event_valid   (d2h_st_q_video_flushing_event_valid),//output

    .h2d_mm_agent_responder_added          (h2d_mm_agent_responder_added), //input
    .h2d_st_agent_responder_added          (h2d_st_agent_responder_added), //input
    .d2h_st_agent_responder_added          (d2h_st_agent_responder_added), //input

    .d2h_st_agent_flush_int                (d2h_st_agent_flush_int) //input
	);

	// PCIe mode related signals input to common region wrapper
	assign pcie_mps = MAX_PAYLOAD_SIZE_DERIVED_DEFAULT;
	assign pcie_mrrs = MAX_READ_REQUEST_SIZE_DERIVED_DEFAULT;

	assign pcie_pf_num = '0;
	assign pcie_dev_num = '0;
	assign pcie_bus_num = '0;
	assign pcie_bus_num_valid = '0;
	assign pcie_pf_id = '0;
	assign pcie_vf_id = '0;
	assign pcie_vf_in_slot_pf = '0;
	assign pcie_slot_id = '0;
	assign pcie_bus_master_en = '0;
	assign pcie_msix_mask = '0;
	assign pcie_msix_en = '0;
	assign pcie_mem_space_en = '0;
	assign pcie_exp_rom_enable = '0;
	assign pcie_tph_req_en = '0;
	assign pcie_ats_en = '0;
	assign pcie_msi_en = '0;
	assign pcie_msi_mask = '0;
	assign pcie_ext_tag_en = '0;
	assign pcie_tag_req_10bit_en = '0;
	assign pcie_ptm_en = '0;
	assign pcie_vf_en = '0;
	assign pcie_page_req_en = '0;

	assign arb_bas_fifo_tvalid						= '0; 
	assign arb_bas_fifo_tdata						= '0;
	assign arb_bas_fifo_tuser						= '0;
	assign arb_bas_fifo_tlast						= '0;
	assign arb_bas_fifo_tid							= '0;
	assign arb_bas_fifo_tkeep						= '0;

	assign arb_msix_fifo_tvalid						= '0; 
	assign arb_msix_fifo_tdata						= '0;
	assign arb_msix_fifo_tuser						= '0;
	assign arb_msix_fifo_tlast						= '0;
	assign arb_msix_fifo_tid						= '0;
	assign arb_msix_fifo_tkeep						= '0;

	assign msix_csr_addr_i  = '0;
	assign msix_csr_wrreq_i = '0;
	assign msix_csr_wdata_i = '0;
	assign msix_csr_rdreq_i = '0;

	assign router_msix_fifo_tready = '0;
	assign router_bas_fifo_tready  = '0;

    assign txcred_dmaarb_valid     = '0;
    assign txcred_dmaarb_p_head    = '0;
    assign txcred_dmaarb_p_data    = '0;
    assign txcred_dmaarb_np_head   = '0;
    assign txcred_dmaarb_np_data   = '0;

    assign bam_watchdog_timeout_error = 1'b0;

common_region_wrapper #(
.DEVICE_FAMILY															(DEVICE_FAMILY),
.DMA_MODE																(DMA_MODE),
.EXT_TAG_EN																(EXT_TAG_EN),
.EXT_10BITS_TAG_REQ_EN													(EXT_10BITS_TAG_REQ_EN),
.SRIOV_EN																(SRIOV_EN),
.ECC_EN																	(ECC_EN),
.MAX_READ_REQUEST_SIZE													(MAX_READ_REQUEST_SIZE),
.NUM_H2D_MM_PORTS														(NUM_H2D_MM_PORTS),
.NUM_H2D_ST_PORTS														(NUM_H2D_ST_PORTS),
.NUM_D2H_ST_PORTS														(NUM_D2H_ST_PORTS),
.NUM_H2D_MM_CHANS														(NUM_H2D_MM_CHANS),
.NUM_H2D_ST_CHANS														(NUM_H2D_ST_CHANS),
.NUM_D2H_ST_CHANS														(NUM_D2H_ST_CHANS),
.DBG_CSR_AWD															(DBG_CSR_AWD),
.HOST_CSR_AWD															(HOST_CSR_AWD),
.HOST_CSR_DWD															(HOST_CSR_DWD),
.MAX_PAYLOAD_SIZE														(MAX_PAYLOAD_SIZE),
.TX_ARB_MODE															(TX_ARB_MODE),
.SS_ST_DWD																(SS_ST_DWD),
.HOST_DWD																(HOST_DWD),
.SS_ST_BWD																(SS_ST_BWD),
.SS_ST_BENWD															(SS_ST_BENWD),
.TX_ARB_DWD																(TX_ARB_DWD),
.TX_ARB_IDWD															(TX_ARB_IDWD),
.TX_ARB_UWD																(TX_ARB_UWD),
.TX_ARB_BWD																(TX_ARB_BWD),
.TX_ARB_BENWD															(TX_ARB_BENWD),
.TX_ARB_IDWD_INT														(TX_ARB_IDWD_INT),
.TX_ARB_UWD_INT															(TX_ARB_UWD_INT),
.RX_ARB_DWD																(RX_ARB_DWD),
.RX_ARB_IDWD															(RX_ARB_IDWD),
.RX_ARB_UWD																(RX_ARB_UWD),
.RX_ARB_BWD																(RX_ARB_BWD),
.RX_ARB_BENWD															(RX_ARB_BENWD),
.RX_ARB_IDWD_INT														(RX_ARB_IDWD_INT),
.MSIX_DATA_WIDTH														(MSIX_DATA_WIDTH),
.MAX_PAYLOAD_SIZE_DERIVED_DEFAULT										(MAX_PAYLOAD_SIZE_DERIVED_DEFAULT),
.MAX_READ_REQUEST_SIZE_DERIVED_DEFAULT									(MAX_READ_REQUEST_SIZE_DERIVED_DEFAULT),
.NUM_TAG_SIZE_DERIVED_BITS												(NUM_TAG_SIZE_DERIVED_BITS),
.DMA_ARBITER_PACKET_FIFO_DATA_WIDTH										(DMA_ARBITER_PACKET_FIFO_DATA_WIDTH),
.DMA_ARBITER_PREFETCH_MEM_WRITE_PACKET_FIFO_DATA_WIDTH					(DMA_ARBITER_PREFETCH_MEM_WRITE_PACKET_FIFO_DATA_WIDTH),
.DMA_ARBITER_PREFETCH_MEM_READ_PACKET_FIFO_DATA_WIDTH					(DMA_ARBITER_PREFETCH_MEM_READ_PACKET_FIFO_DATA_WIDTH),
.DMA_ARBITER_MSIX_PACKET_FIFO_DATA_WIDTH								(DMA_ARBITER_MSIX_PACKET_FIFO_DATA_WIDTH),
.DMA_ARBITER_BAS_PACKET_FIFO_DATA_WIDTH									(DMA_ARBITER_BAS_PACKET_FIFO_DATA_WIDTH),
.DMA_ARBITER_D2H_ST_PACKET_FIFO_DATA_WIDTH								(DMA_ARBITER_D2H_ST_PACKET_FIFO_DATA_WIDTH),
.DMA_ARBITER_H2D_ST_PACKET_FIFO_DATA_WIDTH								(DMA_ARBITER_H2D_ST_PACKET_FIFO_DATA_WIDTH),
.DMA_ARBITER_H2D_MM_PACKET_FIFO_DATA_WIDTH								(DMA_ARBITER_H2D_MM_PACKET_FIFO_DATA_WIDTH),
.DMA_ROUTER_PACKET_FIFO_DATA_WIDTH										(DMA_ROUTER_PACKET_FIFO_DATA_WIDTH),
.DMA_ROUTER_PREFETCH_MEM_WRITE_PACKET_FIFO_DATA_WIDTH					(DMA_ROUTER_PREFETCH_MEM_WRITE_PACKET_FIFO_DATA_WIDTH),
.DMA_ROUTER_PREFETCH_MEM_READ_PACKET_FIFO_DATA_WIDTH					(DMA_ROUTER_PREFETCH_MEM_READ_PACKET_FIFO_DATA_WIDTH),
.DMA_ROUTER_MSIX_PACKET_FIFO_DATA_WIDTH									(DMA_ROUTER_MSIX_PACKET_FIFO_DATA_WIDTH),
.DMA_ROUTER_BAS_PACKET_FIFO_DATA_WIDTH									(DMA_ROUTER_BAS_PACKET_FIFO_DATA_WIDTH),
.DMA_ROUTER_D2H_ST_PACKET_FIFO_DATA_WIDTH								(DMA_ROUTER_D2H_ST_PACKET_FIFO_DATA_WIDTH),
.DMA_ROUTER_H2D_ST_PACKET_FIFO_DATA_WIDTH								(DMA_ROUTER_H2D_ST_PACKET_FIFO_DATA_WIDTH),
.DMA_ROUTER_H2D_MM_PACKET_FIFO_DATA_WIDTH								(DMA_ROUTER_H2D_MM_PACKET_FIFO_DATA_WIDTH),

.AXI_ST_PORT_FREQ														(AXI_ST_PORT_FREQ),
.HOST_AXI_PROT_PRIV_ACC													(HOST_AXI_PROT_PRIV_ACC),
.HOST_AXI_PROT_SEC_ACC													(HOST_AXI_PROT_SEC_ACC),
.HOST_AXI_PROT_DATA_ACC													(HOST_AXI_PROT_DATA_ACC),
.HOST_AXI_AWCACHE														(HOST_AXI_AWCACHE),
.HOST_AXI_ARCACHE														(HOST_AXI_ARCACHE),
.HOST_AXI_AWBAR															(HOST_AXI_AWBAR),
.HOST_AXI_ARBAR															(HOST_AXI_ARBAR),
.HOST_AXI_AWDOMAIN														(HOST_AXI_AWDOMAIN),
.HOST_AXI_ARDOMAIN														(HOST_AXI_ARDOMAIN),
.HOST_AXI_AWSNOOP														(HOST_AXI_AWSNOOP),
.HOST_AXI_ARSNOOP														(HOST_AXI_ARSNOOP),
.UNALIGNED_ACCESS_EN_PARAM												(UNALIGNED_ACCESS_EN_PARAM	),
.NUM_H2D_MM_PORTS_PARAM													(NUM_H2D_MM_PORTS_PARAM		),
.NUM_H2D_ST_PORTS_PARAM													(NUM_H2D_ST_PORTS_PARAM		),
.NUM_D2H_ST_PORTS_PARAM													(NUM_D2H_ST_PORTS_PARAM		),
.NUM_BAR_PORTS_PARAM													(NUM_BAR_PORTS_PARAM		),
.DMA_MODE_PARAM															(DMA_MODE_PARAM				),
.H2D_MM_QCSR_NUM_CHAN_PER_DEVICE_PORT_PARAM								(H2D_MM_QCSR_NUM_CHAN_PER_DEVICE_PORT_PARAM),
.H2D_ST_QCSR_NUM_CHAN_PER_DEVICE_PORT_PARAM								(H2D_ST_QCSR_NUM_CHAN_PER_DEVICE_PORT_PARAM),
.H2D_ST_QCSR_PORT_DATA_TYPE_PARAM										(H2D_ST_QCSR_PORT_DATA_TYPE_PARAM),
.H2D_ST_QCSR_PORT_INT_TYPE_PARAM										(H2D_ST_QCSR_PORT_INT_TYPE_PARAM),
.H2D_ST_QCSR_PORT_PKT_MODE_PARAM										(H2D_ST_QCSR_PORT_PKT_MODE_PARAM),
.H2D_ST_QCSR_PTP_PORT_EN_PARAM											(H2D_ST_QCSR_PTP_PORT_EN_PARAM),
.D2H_ST_QCSR_NUM_CHAN_PER_DEVICE_PORT_PARAM								(D2H_ST_QCSR_NUM_CHAN_PER_DEVICE_PORT_PARAM),
.D2H_ST_QCSR_PORT_INIT_FLUSH_EN_PARAM									(D2H_ST_QCSR_PORT_INIT_FLUSH_EN_PARAM),
.D2H_ST_QCSR_PORT_RUNTIME_FLUSH_EN_PARAM								(D2H_ST_QCSR_PORT_RUNTIME_FLUSH_EN_PARAM),
.D2H_ST_QCSR_PORT_DATA_TYPE_PARAM										(D2H_ST_QCSR_PORT_DATA_TYPE_PARAM),
.D2H_ST_QCSR_PORT_INT_TYPE_PARAM										(D2H_ST_QCSR_PORT_INT_TYPE_PARAM),
.D2H_ST_QCSR_PORT_PKT_MODE_PARAM										(D2H_ST_QCSR_PORT_PKT_MODE_PARAM),
.D2H_ST_QCSR_PTP_PORT_EN_PARAM											(D2H_ST_QCSR_PTP_PORT_EN_PARAM)
) common_dma_wrapper_inst (
.csr_clk																(axi_lite_clk),
.host_clk																(host_clk_internal),
.csr_reset_n															(axi_lite_areset_n),
.host_reset_status_n													(host_reset_status_n),
		
.csr_reset_n_sync														(csr_reset_n_sync),
.app_reset_status_n_sync												(app_reset_status_n_internal),

.host_lite_csr_awvalid													(host_lite_csr_awvalid),
.host_lite_csr_awaddr													(host_lite_csr_awaddr),
.host_lite_csr_awready													(host_lite_csr_awready),
.host_lite_csr_wvalid													(host_lite_csr_wvalid),
.host_lite_csr_wdata													(host_lite_csr_wdata),
.host_lite_csr_wstrb													(host_lite_csr_wstrb),
.host_lite_csr_wready													(host_lite_csr_wready),
	
.host_lite_csr_bready													(host_lite_csr_bready),
.host_lite_csr_bvalid													(host_lite_csr_bvalid),
.host_lite_csr_bresp													(host_lite_csr_bresp),

.host_lite_csr_arvalid													(host_lite_csr_arvalid),
.host_lite_csr_araddr													(host_lite_csr_araddr),
.host_lite_csr_arready													(host_lite_csr_arready),

.host_lite_csr_rready													(host_lite_csr_rready),
.host_lite_csr_rvalid													(host_lite_csr_rvalid),
.host_lite_csr_rdata													(host_lite_csr_rdata),
.host_lite_csr_rresp													(host_lite_csr_rresp),

.pcie_pf_num															(pcie_pf_num),
.pcie_dev_num															(pcie_dev_num),
.pcie_bus_num															(pcie_bus_num),
.pcie_bus_num_valid														(pcie_bus_num_valid),

.pcie_pf_id																(pcie_pf_id),
.pcie_vf_id																(pcie_vf_id),
.pcie_vf_in_slot_pf														(pcie_vf_in_slot_pf),
.pcie_slot_id															(pcie_slot_id),
.pcie_bus_master_en														(pcie_bus_master_en),
.pcie_msix_mask															(pcie_msix_mask),
.pcie_msix_en															(pcie_msix_en),
.pcie_mem_space_en														(pcie_mem_space_en),

.pcie_exp_rom_enable													(pcie_exp_rom_enable),
.pcie_tph_req_en														(pcie_tph_req_en),
.pcie_ats_en															(pcie_ats_en),
.pcie_msi_en															(pcie_msi_en),
.pcie_msi_mask															(pcie_msi_mask),
.pcie_ext_tag_en														(pcie_ext_tag_en),
.pcie_tag_req_10bit_en													(pcie_tag_req_10bit_en),
.pcie_ptm_en															(pcie_ptm_en),
.pcie_mps																(pcie_mps),
.pcie_mrrs																(pcie_mrrs),
.pcie_vf_en																(pcie_vf_en),
.pcie_page_req_en														(pcie_page_req_en),

.host_pf_id																(host_pf_id),
.host_vf_id																(host_vf_id),
.host_vf_in_slot_pf														(host_vf_in_slot_pf),
.host_slot_id															(host_slot_id),
.host_bus_master_en														(host_bus_master_en),
.host_msix_mask															(host_msix_mask),
.host_msix_en															(host_msix_en),
.host_mem_space_en														(host_mem_space_en),

.host_exp_rom_enable													(host_exp_rom_enable),
.host_tph_req_en														(host_tph_req_en),
.host_ats_en															(host_ats_en),
.host_msi_en															(host_msi_en),
.host_msi_mask															(host_msi_mask),
.host_ext_tag_en														(host_ext_tag_en),
.host_tag_req_10bit_en													(host_tag_req_10bit_en),
.host_ptm_en															(host_ptm_en),
.host_mps																(host_mps),
.host_mrrs																(host_mrrs),
.host_vf_en																(host_vf_en),
.host_page_req_en														(host_page_req_en),

.host_pf_num															(host_pf_num),
.host_dev_num															(host_dev_num),
.host_bus_num															(host_bus_num),
.host_bus_num_valid														(host_bus_num_valid),

.router_completer_tdata													(router_completer_tdata),
.router_completer_tvalid												(router_completer_tvalid),
.router_completer_tid													(router_completer_tid),
.router_completer_tkeep													(router_completer_tkeep),
.router_completer_tlast													(router_completer_tlast),
.router_completer_tuser													(router_completer_tuser),
.router_completer_tready												(router_completer_tready),

.router_msix_fifo_tvalid												(router_msix_fifo_tvalid),
.router_msix_fifo_tready												(router_msix_fifo_tready),
.router_msix_fifo_tdata													(router_msix_fifo_tdata),
.router_msix_fifo_tuser													(router_msix_fifo_tuser),
.router_msix_fifo_tlast													(router_msix_fifo_tlast),
.router_msix_fifo_tid													(router_msix_fifo_tid),
.router_msix_fifo_tkeep													(router_msix_fifo_tkeep),

.router_bas_fifo_tvalid													(router_bas_fifo_tvalid),
.router_bas_fifo_tready													(router_bas_fifo_tready),
.router_bas_fifo_tdata													(router_bas_fifo_tdata),
.router_bas_fifo_tuser													(router_bas_fifo_tuser),
.router_bas_fifo_tlast													(router_bas_fifo_tlast),
.router_bas_fifo_tid													(router_bas_fifo_tid),
.router_bas_fifo_tkeep													(router_bas_fifo_tkeep),

.irq																	(irq_bit), //1-bit output for SoC mode only

.watchdog_timer_en														(watchdog_timer_en			), // output
.watchdog_timeout														(watchdog_timeout			), // output
.watchdog_timeout_error													(watchdog_timeout_error		), // output
.bam_watchdog_timeout_error												(bam_watchdog_timeout_error	), // input pulse from BAM (PCIe mode)
.host_watchdog_timeout_error											(host_watchdog_timeout_error), // input pulse from Host (SoC and DMA Only modes)

.h2d_mm_prefetch_irq_en													(h2d_mm_prefetch_irq_en_wire),
.h2d_mm_q_en															(h2d_mm_q_en_wire),
.h2d_mm_irq_en															(h2d_mm_irq_en_wire),
.h2d_mm_wb_en															(h2d_mm_wb_en_wire),
.h2d_mm_q_pause_agent_control											(h2d_mm_q_pause_agent_control_wire),
.h2d_mm_q_sw_reset_req													(h2d_mm_q_sw_reset_req_wire),

.h2d_st_prefetch_irq_en													(h2d_st_prefetch_irq_en_wire),
.h2d_st_q_en															(h2d_st_q_en_wire),
.h2d_st_irq_en															(h2d_st_irq_en_wire),
.h2d_st_wb_en															(h2d_st_wb_en_wire),
.h2d_st_q_pause_agent_control											(h2d_st_q_pause_agent_control_wire),
.h2d_st_q_sw_reset_req													(h2d_st_q_sw_reset_req_wire),

.d2h_st_prefetch_irq_en													(d2h_st_prefetch_irq_en_wire),
.d2h_st_q_en															(d2h_st_q_en_wire),
.d2h_st_irq_en															(d2h_st_irq_en_wire),
.d2h_st_wb_en															(d2h_st_wb_en_wire),
.d2h_st_q_pause_agent_control											(d2h_st_q_pause_agent_control_wire),
.d2h_st_q_sw_reset_req													(d2h_st_q_sw_reset_req_wire),

.h2d_mm_q_descr_buffer_full												(h2d_mm_q_descr_buffer_full),
.h2d_mm_q_descr_buffer_empty											(h2d_mm_q_descr_buffer_empty),
.h2d_mm_q_resp_buffer_full												(h2d_mm_q_resp_buffer_full),
.h2d_mm_q_resp_buffer_empty												(h2d_mm_q_resp_buffer_empty),

.h2d_st_q_descr_buffer_full												(h2d_st_q_descr_buffer_full),
.h2d_st_q_descr_buffer_empty											(h2d_st_q_descr_buffer_empty),
.h2d_st_q_resp_buffer_full												(h2d_st_q_resp_buffer_full),
.h2d_st_q_resp_buffer_empty												(h2d_st_q_resp_buffer_empty),

.d2h_st_q_descr_buffer_full												(d2h_st_q_descr_buffer_full),
.d2h_st_q_descr_buffer_empty											(d2h_st_q_descr_buffer_empty),
.d2h_st_q_resp_buffer_full												(d2h_st_q_resp_buffer_full),
.d2h_st_q_resp_buffer_empty												(d2h_st_q_resp_buffer_empty),

.h2d_mm_q_desc_completion_valid											(h2d_mm_q_desc_completion_valid),//input
.h2d_st_q_desc_completion_valid											(h2d_st_q_desc_completion_valid),//input
.d2h_st_q_desc_completion_valid											(d2h_st_q_desc_completion_valid),//input

.d2h_st_q_video_flushing_event_valid									(d2h_st_q_video_flushing_event_valid),//input

`ifdef DIRECTED_TB_CSR_STIMULUS_EN
.h2d_mm_csr_addr_i														(tb_h2d_mm_csr_addr_i),
.h2d_mm_csr_wrreq_i														(tb_h2d_mm_csr_wrreq_i),
.h2d_mm_csr_wdata_i														(tb_h2d_mm_csr_wdata_i),
.h2d_mm_csr_rdreq_i														(tb_h2d_mm_csr_rdreq_i),
.h2d_mm_csr_rdata_o														(tb_h2d_mm_csr_rdata_o),
.h2d_mm_csr_rdvalid_o													(tb_h2d_mm_csr_rdvalid_o),
.h2d_mm_csr_req_ack_o													(tb_h2d_mm_csr_req_ack_o),

.h2d_st_csr_addr_i														(tb_h2d_st_csr_addr_i),
.h2d_st_csr_wrreq_i														(tb_h2d_st_csr_wrreq_i),
.h2d_st_csr_wdata_i														(tb_h2d_st_csr_wdata_i),
.h2d_st_csr_rdreq_i														(tb_h2d_st_csr_rdreq_i),
.h2d_st_csr_rdata_o														(tb_h2d_st_csr_rdata_o),
.h2d_st_csr_rdvalid_o													(tb_h2d_st_csr_rdvalid_o),
.h2d_st_csr_req_ack_o													(tb_h2d_st_csr_req_ack_o),

.d2h_st_csr_addr_i														(tb_d2h_st_csr_addr_i),
.d2h_st_csr_wrreq_i														(tb_d2h_st_csr_wrreq_i),
.d2h_st_csr_wdata_i														(tb_d2h_st_csr_wdata_i),
.d2h_st_csr_rdreq_i														(tb_d2h_st_csr_rdreq_i),
.d2h_st_csr_rdata_o														(tb_d2h_st_csr_rdata_o),
.d2h_st_csr_rdvalid_o													(tb_d2h_st_csr_rdvalid_o),
.d2h_st_csr_req_ack_o													(tb_d2h_st_csr_req_ack_o),

.msix_csr_addr_i														(tb_msix_csr_addr_i),
.msix_csr_wrreq_i														(tb_msix_csr_wrreq_i),
.msix_csr_wdata_i														(tb_msix_csr_wdata_i),
.msix_csr_rdreq_i														(tb_msix_csr_rdreq_i),
.msix_csr_rdata_o														(tb_msix_csr_rdata_o),
.msix_csr_rdvalid_o														(tb_msix_csr_rdvalid_o),
.msix_csr_req_ack_o														(tb_msix_csr_req_ack_o),
`else	
.h2d_mm_csr_addr_i														(h2d_mm_csr_addr_i),
.h2d_mm_csr_wrreq_i														(h2d_mm_csr_wrreq_i),
.h2d_mm_csr_wdata_i														(h2d_mm_csr_wdata_i),
.h2d_mm_csr_rdreq_i														(h2d_mm_csr_rdreq_i),
.h2d_mm_csr_rdata_o														(h2d_mm_csr_rdata_o),
.h2d_mm_csr_rdvalid_o													(h2d_mm_csr_rdvalid_o),
.h2d_mm_csr_req_ack_o													(h2d_mm_csr_req_ack_o),

.h2d_st_csr_addr_i														(h2d_st_csr_addr_i),
.h2d_st_csr_wrreq_i														(h2d_st_csr_wrreq_i),
.h2d_st_csr_wdata_i														(h2d_st_csr_wdata_i),
.h2d_st_csr_rdreq_i														(h2d_st_csr_rdreq_i),
.h2d_st_csr_rdata_o														(h2d_st_csr_rdata_o),
.h2d_st_csr_rdvalid_o													(h2d_st_csr_rdvalid_o),
.h2d_st_csr_req_ack_o													(h2d_st_csr_req_ack_o),

.d2h_st_csr_addr_i														(d2h_st_csr_addr_i),
.d2h_st_csr_wrreq_i														(d2h_st_csr_wrreq_i),
.d2h_st_csr_wdata_i														(d2h_st_csr_wdata_i),
.d2h_st_csr_rdreq_i														(d2h_st_csr_rdreq_i),
.d2h_st_csr_rdata_o														(d2h_st_csr_rdata_o),
.d2h_st_csr_rdvalid_o													(d2h_st_csr_rdvalid_o),
.d2h_st_csr_req_ack_o													(d2h_st_csr_req_ack_o),

.msix_csr_addr_i														(msix_csr_addr_i),
.msix_csr_wrreq_i														(msix_csr_wrreq_i),
.msix_csr_wdata_i														(msix_csr_wdata_i),
.msix_csr_rdreq_i														(msix_csr_rdreq_i),
.msix_csr_rdata_o														(msix_csr_rdata_o),
.msix_csr_rdvalid_o														(msix_csr_rdvalid_o),
.msix_csr_req_ack_o														(msix_csr_req_ack_o),
`endif // DIRECTED_TB_CSR_STIMULUS_EN

`ifdef DIRECTED_TB_ARB_STIMULUS_EN
.arb_msix_fifo_tvalid													(tb_arb_msix_fifo_tvalid),
.arb_msix_fifo_tready													(tb_arb_msix_fifo_tready),
.arb_msix_fifo_tdata													(tb_arb_msix_fifo_tdata),
.arb_msix_fifo_tuser													(tb_arb_msix_fifo_tuser),
.arb_msix_fifo_tlast													(tb_arb_msix_fifo_tlast),
.arb_msix_fifo_tid														(tb_arb_msix_fifo_tid),
.arb_msix_fifo_tkeep													(tb_arb_msix_fifo_tkeep),

.arb_bas_fifo_tvalid													(tb_arb_bas_fifo_tvalid),
.arb_bas_fifo_tready													(tb_arb_bas_fifo_tready),
.arb_bas_fifo_tdata														(tb_arb_bas_fifo_tdata),
.arb_bas_fifo_tuser														(tb_arb_bas_fifo_tuser),
.arb_bas_fifo_tlast														(tb_arb_bas_fifo_tlast),
.arb_bas_fifo_tid														(tb_arb_bas_fifo_tid),
.arb_bas_fifo_tkeep														(tb_arb_bas_fifo_tkeep),

.arb_h2d_mm_fifo_tvalid													(tb_arb_h2d_mm_fifo_tvalid),
.arb_h2d_mm_fifo_tready													(tb_arb_h2d_mm_fifo_tready),
.arb_h2d_mm_fifo_tdata													(tb_arb_h2d_mm_fifo_tdata),
.arb_h2d_mm_fifo_tuser													(tb_arb_h2d_mm_fifo_tuser),
.arb_h2d_mm_fifo_tlast													(tb_arb_h2d_mm_fifo_tlast),
.arb_h2d_mm_fifo_tid													(tb_arb_h2d_mm_fifo_tid),
.arb_h2d_mm_fifo_tkeep													(tb_arb_h2d_mm_fifo_tkeep),

.arb_h2d_st_fifo_tvalid													(tb_arb_h2d_st_fifo_tvalid),
.arb_h2d_st_fifo_tready													(tb_arb_h2d_st_fifo_tready),
.arb_h2d_st_fifo_tdata													(tb_arb_h2d_st_fifo_tdata),
.arb_h2d_st_fifo_tuser													(tb_arb_h2d_st_fifo_tuser),
.arb_h2d_st_fifo_tlast													(tb_arb_h2d_st_fifo_tlast),
.arb_h2d_st_fifo_tid													(tb_arb_h2d_st_fifo_tid),
.arb_h2d_st_fifo_tkeep													(tb_arb_h2d_st_fifo_tkeep),

.arb_d2h_st_fifo_tvalid													(tb_arb_d2h_st_fifo_tvalid),
.arb_d2h_st_fifo_tready													(tb_arb_d2h_st_fifo_tready),
.arb_d2h_st_fifo_tdata													(tb_arb_d2h_st_fifo_tdata),
.arb_d2h_st_fifo_tuser													(tb_arb_d2h_st_fifo_tuser),
.arb_d2h_st_fifo_tlast													(tb_arb_d2h_st_fifo_tlast),
.arb_d2h_st_fifo_tid													(tb_arb_d2h_st_fifo_tid),
.arb_d2h_st_fifo_tkeep													(tb_arb_d2h_st_fifo_tkeep),
`else	
.arb_msix_fifo_tvalid													(arb_msix_fifo_tvalid),
.arb_msix_fifo_tready													(arb_msix_fifo_tready),
.arb_msix_fifo_tdata													(arb_msix_fifo_tdata),
.arb_msix_fifo_tuser													(arb_msix_fifo_tuser),
.arb_msix_fifo_tlast													(arb_msix_fifo_tlast),
.arb_msix_fifo_tid														(arb_msix_fifo_tid),
.arb_msix_fifo_tkeep													(arb_msix_fifo_tkeep),

.arb_bas_fifo_tvalid													(arb_bas_fifo_tvalid),
.arb_bas_fifo_tready													(arb_bas_fifo_tready),
.arb_bas_fifo_tdata														(arb_bas_fifo_tdata),
.arb_bas_fifo_tuser														(arb_bas_fifo_tuser),
.arb_bas_fifo_tlast														(arb_bas_fifo_tlast),
.arb_bas_fifo_tid														(arb_bas_fifo_tid),
.arb_bas_fifo_tkeep														(arb_bas_fifo_tkeep),

.arb_h2d_mm_fifo_tvalid													(arb_h2d_mm_fifo_tvalid),
.arb_h2d_mm_fifo_tready													(arb_h2d_mm_fifo_tready),
.arb_h2d_mm_fifo_tdata													(arb_h2d_mm_fifo_tdata),
.arb_h2d_mm_fifo_tuser													(arb_h2d_mm_fifo_tuser),
.arb_h2d_mm_fifo_tlast													(arb_h2d_mm_fifo_tlast),
.arb_h2d_mm_fifo_tid													(arb_h2d_mm_fifo_tid),
.arb_h2d_mm_fifo_tkeep													(arb_h2d_mm_fifo_tkeep),

.arb_h2d_st_fifo_tvalid													(arb_h2d_st_fifo_tvalid),
.arb_h2d_st_fifo_tready													(arb_h2d_st_fifo_tready),
.arb_h2d_st_fifo_tdata													(arb_h2d_st_fifo_tdata),
.arb_h2d_st_fifo_tuser													(arb_h2d_st_fifo_tuser),
.arb_h2d_st_fifo_tlast													(arb_h2d_st_fifo_tlast),
.arb_h2d_st_fifo_tid													(arb_h2d_st_fifo_tid),
.arb_h2d_st_fifo_tkeep													(arb_h2d_st_fifo_tkeep),

.arb_d2h_st_fifo_tvalid													(arb_d2h_st_fifo_tvalid),
.arb_d2h_st_fifo_tready													(arb_d2h_st_fifo_tready),
.arb_d2h_st_fifo_tdata													(arb_d2h_st_fifo_tdata),
.arb_d2h_st_fifo_tuser													(arb_d2h_st_fifo_tuser),
.arb_d2h_st_fifo_tlast													(arb_d2h_st_fifo_tlast),
.arb_d2h_st_fifo_tid													(arb_d2h_st_fifo_tid),
.arb_d2h_st_fifo_tkeep													(arb_d2h_st_fifo_tkeep),
`endif // DIRECTED_TB_ARB_STIMULUS_EN

`ifdef DIRECTED_TB_ARB_STIMULUS_EN
.arb_st_source_tvalid													(tb_arb_st_source_tvalid),
.arb_st_source_tready													('1),
.arb_st_source_tdata													(tb_arb_st_source_tdata),
.arb_st_source_tuser													(tb_arb_st_source_tuser),
.arb_st_source_tlast													(tb_arb_st_source_tlast),
.arb_st_source_tid														(tb_arb_st_source_tid),
.arb_st_source_tkeep													(tb_arb_st_source_tkeep),
`else
.arb_st_source_tvalid													(arb_st_source_tvalid),
.arb_st_source_tready													(arb_st_source_tready),
.arb_st_source_tdata													(arb_st_source_tdata),
.arb_st_source_tuser													(arb_st_source_tuser),
.arb_st_source_tlast													(arb_st_source_tlast),
.arb_st_source_tid														(arb_st_source_tid),
.arb_st_source_tkeep													(arb_st_source_tkeep),
`endif // DIRECTED_TB_ARB_STIMULUS_EN

.router_h2d_mm_fifo_tvalid												(router_h2d_mm_fifo_tvalid),
.router_h2d_mm_fifo_tready												(router_h2d_mm_fifo_tready),
.router_h2d_mm_fifo_tdata												(router_h2d_mm_fifo_tdata),
.router_h2d_mm_fifo_tuser												(router_h2d_mm_fifo_tuser),
.router_h2d_mm_fifo_tlast												(router_h2d_mm_fifo_tlast),
.router_h2d_mm_fifo_tid													(router_h2d_mm_fifo_tid),
.router_h2d_mm_fifo_tkeep												(router_h2d_mm_fifo_tkeep),
  
.router_h2d_st_fifo_tvalid												(router_h2d_st_fifo_tvalid),
.router_h2d_st_fifo_tready												(router_h2d_st_fifo_tready),
.router_h2d_st_fifo_tdata												(router_h2d_st_fifo_tdata),
.router_h2d_st_fifo_tuser												(router_h2d_st_fifo_tuser),
.router_h2d_st_fifo_tlast												(router_h2d_st_fifo_tlast),
.router_h2d_st_fifo_tid													(router_h2d_st_fifo_tid),
.router_h2d_st_fifo_tkeep												(router_h2d_st_fifo_tkeep),
  
.router_d2h_st_fifo_tvalid												(router_d2h_st_fifo_tvalid),
.router_d2h_st_fifo_tready												(router_d2h_st_fifo_tready),
.router_d2h_st_fifo_tdata												(router_d2h_st_fifo_tdata),
.router_d2h_st_fifo_tuser												(router_d2h_st_fifo_tuser),
.router_d2h_st_fifo_tlast												(router_d2h_st_fifo_tlast),
.router_d2h_st_fifo_tid													(router_d2h_st_fifo_tid),
.router_d2h_st_fifo_tkeep												(router_d2h_st_fifo_tkeep),
 
`ifdef DIRECTED_TB_CSR_STIMULUS_EN
.prefetch_csr_addr_i													(tb_prefetch_csr_addr_i),
.prefetch_csr_wrreq_i													(tb_prefetch_csr_wrreq_i),
.prefetch_csr_wdata_i													(tb_prefetch_csr_wdata_i),
.prefetch_csr_rdreq_i													(tb_prefetch_csr_rdreq_i),
.prefetch_csr_rdata_o													(tb_prefetch_csr_rdata_o),
.prefetch_csr_rdvalid_o													(tb_prefetch_csr_rdvalid_o),
.prefetch_csr_req_ack_o													(tb_prefetch_csr_req_ack_o),
`endif // DIRECTED_TB_CSR_STIMULUS_EN

`ifdef DIRECTED_TB_ARB_STIMULUS_EN
.arb_prefetch_fifo_mem_write_tvalid										(tb_arb_prefetch_fifo_mem_write_tvalid),
.arb_prefetch_fifo_mem_write_tready										(tb_arb_prefetch_fifo_mem_write_tready),
.arb_prefetch_fifo_mem_write_tdata										(tb_arb_prefetch_fifo_mem_write_tdata),
.arb_prefetch_fifo_mem_write_tuser										(tb_arb_prefetch_fifo_mem_write_tuser),
.arb_prefetch_fifo_mem_write_tlast										(tb_arb_prefetch_fifo_mem_write_tlast),
.arb_prefetch_fifo_mem_write_tid										(tb_arb_prefetch_fifo_mem_write_tid),
.arb_prefetch_fifo_mem_write_tkeep										(tb_arb_prefetch_fifo_mem_write_tkeep),

.arb_prefetch_fifo_mem_read_tvalid										(tb_arb_prefetch_fifo_mem_read_tvalid),
.arb_prefetch_fifo_mem_read_tready										(tb_arb_prefetch_fifo_mem_read_tready),
.arb_prefetch_fifo_mem_read_tdata										(tb_arb_prefetch_fifo_mem_read_tdata),
.arb_prefetch_fifo_mem_read_tuser										(tb_arb_prefetch_fifo_mem_read_tuser),
.arb_prefetch_fifo_mem_read_tlast										(tb_arb_prefetch_fifo_mem_read_tlast),
.arb_prefetch_fifo_mem_read_tid											(tb_arb_prefetch_fifo_mem_read_tid),
.arb_prefetch_fifo_mem_read_tkeep										(tb_arb_prefetch_fifo_mem_read_tkeep),
`endif // DIRECTED_TB_ARB_STIMULUS_EN

`ifndef PREFETCHER_INSTANCE_EN
.router_prefetch_fifo_mem_write_tdata									(router_prefetch_fifo_mem_write_tdata),
.router_prefetch_fifo_mem_write_tvalid									(router_prefetch_fifo_mem_write_tvalid),
.router_prefetch_fifo_mem_write_tid										(router_prefetch_fifo_mem_write_tid),
.router_prefetch_fifo_mem_write_tkeep									(router_prefetch_fifo_mem_write_tkeep),
.router_prefetch_fifo_mem_write_tlast									(router_prefetch_fifo_mem_write_tlast),
.router_prefetch_fifo_mem_write_tuser									(router_prefetch_fifo_mem_write_tuser),
.router_prefetch_fifo_mem_write_tready									(router_prefetch_fifo_mem_write_tready),

.router_prefetch_fifo_mem_read_tdata									(router_prefetch_fifo_mem_read_tdata),
.router_prefetch_fifo_mem_read_tvalid									(router_prefetch_fifo_mem_read_tvalid),
.router_prefetch_fifo_mem_read_tid										(router_prefetch_fifo_mem_read_tid),
.router_prefetch_fifo_mem_read_tkeep									(router_prefetch_fifo_mem_read_tkeep),
.router_prefetch_fifo_mem_read_tlast									(router_prefetch_fifo_mem_read_tlast),
.router_prefetch_fifo_mem_read_tuser									(router_prefetch_fifo_mem_read_tuser),
.router_prefetch_fifo_mem_read_tready									(router_prefetch_fifo_mem_read_tready),
`endif // PREFETCHER_INSTANCE_EN

.h2d_mm_desc_axi_st_source_tready										(h2d_mm_desc_axi_st_source_tready),

.h2d_st_desc_axi_st_source_tready										(h2d_st_desc_axi_st_source_tready),

.d2h_st_desc_axi_st_source_tready										(d2h_st_desc_axi_st_source_tready),

.h2d_mm_agent_descriptor_taken											(h2d_mm_agent_descriptor_taken),
.h2d_st_agent_descriptor_taken											(h2d_st_agent_descriptor_taken),
.d2h_st_agent_descriptor_taken											(d2h_st_agent_descriptor_taken),

.h2d_mm_resp_axi_st_sink_tvalid											(h2d_mm_resp_axi_st_sink_tvalid),
.h2d_mm_resp_axi_st_sink_tdata											(h2d_mm_resp_axi_st_sink_tdata),
.h2d_mm_resp_axi_st_sink_tlast											(h2d_mm_resp_axi_st_sink_tlast),

.h2d_st_resp_axi_st_sink_tvalid											(h2d_st_resp_axi_st_sink_tvalid),
.h2d_st_resp_axi_st_sink_tdata											(h2d_st_resp_axi_st_sink_tdata),
.h2d_st_resp_axi_st_sink_tlast											(h2d_st_resp_axi_st_sink_tlast),

.d2h_st_resp_axi_st_sink_tvalid											(d2h_st_resp_axi_st_sink_tvalid),
.d2h_st_resp_axi_st_sink_tdata											(d2h_st_resp_axi_st_sink_tdata),
.d2h_st_resp_axi_st_sink_tlast											(d2h_st_resp_axi_st_sink_tlast),

.h2d_mm_agent_responder_added											(h2d_mm_agent_responder_added),
.h2d_st_agent_responder_added											(h2d_st_agent_responder_added),
.d2h_st_agent_responder_added											(d2h_st_agent_responder_added),

.d2h_st_agent_flush_int													(d2h_st_agent_flush_int),
.d2h_st_agent_flush_ack													(d2h_st_agent_flush_ack),

.d2h_st_byteack_valid													(d2h_st_byteack_valid),
.d2h_st_byteack															(d2h_st_byteack),

// `ifdef PREFETCHER_INSTANCE_EN
.h2d_mm_desc_axi_st_source_tvalid										(h2d_mm_desc_axi_st_source_tvalid),
.h2d_mm_desc_axi_st_source_tdata										(h2d_mm_desc_axi_st_source_tdata),
.h2d_mm_desc_axi_st_source_tlast										(h2d_mm_desc_axi_st_source_tlast),

.h2d_st_desc_axi_st_source_tvalid										(h2d_st_desc_axi_st_source_tvalid),
.h2d_st_desc_axi_st_source_tdata										(h2d_st_desc_axi_st_source_tdata),
.h2d_st_desc_axi_st_source_tlast										(h2d_st_desc_axi_st_source_tlast),

.d2h_st_desc_axi_st_source_tvalid										(d2h_st_desc_axi_st_source_tvalid),
.d2h_st_desc_axi_st_source_tdata										(d2h_st_desc_axi_st_source_tdata),
.d2h_st_desc_axi_st_source_tlast										(d2h_st_desc_axi_st_source_tlast),

.h2d_mm_resp_axi_st_sink_tready											(h2d_mm_resp_axi_st_sink_tready),
.h2d_st_resp_axi_st_sink_tready											(h2d_st_resp_axi_st_sink_tready),
.d2h_st_resp_axi_st_sink_tready											(d2h_st_resp_axi_st_sink_tready),

.prefetch_msix_valid													(prefetch_msix_valid),
.prefetch_msix_data														(prefetch_msix_data),
.prefetch_msix_ready													(prefetch_msix_ready),
// `endif // PREFETCHER_INSTANCE_EN

.txcred_dmaarb_valid													(txcred_dmaarb_valid),
.txcred_dmaarb_p_head													(txcred_dmaarb_p_head),
.txcred_dmaarb_p_data													(txcred_dmaarb_p_data),
.txcred_dmaarb_np_head													(txcred_dmaarb_np_head),
.txcred_dmaarb_np_data													(txcred_dmaarb_np_data)
);

device_agent_wrapper # (
.DEVICE_FAMILY																				(DEVICE_FAMILY),
.UNALIGNED_ACCESS_EN																		(UNALIGNED_ACCESS_EN),
.ECC_EN																						(ECC_EN),

.SS_ST_DWD																					(SS_ST_DWD),

.HOST_DWD																					(HOST_DWD),

.NUM_H2D_MM_PORTS																			(NUM_H2D_MM_PORTS),
.NUM_H2D_ST_PORTS																			(NUM_H2D_ST_PORTS),
.NUM_D2H_ST_PORTS																			(NUM_D2H_ST_PORTS),
.NUM_H2D_MM_CHANS																			(NUM_H2D_MM_CHANS),
.NUM_H2D_ST_CHANS																			(NUM_H2D_ST_CHANS),
.NUM_D2H_ST_CHANS																			(NUM_D2H_ST_CHANS),
.NUM_H2D_MM_CHANS_DERIVED																	(NUM_H2D_MM_CHANS_DERIVED),
.NUM_H2D_ST_CHANS_DERIVED																	(NUM_H2D_ST_CHANS_DERIVED),
.NUM_D2H_ST_CHANS_DERIVED																	(NUM_D2H_ST_CHANS_DERIVED),
.NUM_H2D_D2H_PORTS																			(NUM_H2D_D2H_PORTS),
.NUM_H2D_D2H_CHANS																			(NUM_H2D_D2H_CHANS),
.NUM_H2D_D2H_PORTS_DERIVED																	(NUM_H2D_D2H_PORTS_DERIVED),
.NUM_H2D_D2H_CHANS_DERIVED																	(NUM_H2D_D2H_CHANS_DERIVED),
.HOST_CSR_AWD																				(HOST_CSR_AWD),
.HOST_CSR_DWD																				(HOST_CSR_DWD),

.H2D_MM0_AWD																				(H2D_MM0_AWD					),
.H2D_MM0_LWD																				(H2D_MM0_LWD					),
.H2D_MM0_IDWD																			(H2D_MM0_IDWD				),
.H2D_MM0_DWD																				(H2D_MM0_DWD					),
.H2D_MM0_FIFO_DEPTH																		(H2D_MM0_FIFO_DEPTH			),
.NUM_CHAN_PER_H2D_MM_PORT0																(NUM_CHAN_PER_H2D_MM_PORT0	),



.H2D_D2H_DD_WD																				(H2D_D2H_DD_WD),

.TX_ARB_DWD																					(TX_ARB_DWD),
.TX_ARB_IDWD																				(TX_ARB_IDWD),
.TX_ARB_UWD																					(TX_ARB_UWD),
.TX_ARB_BWD																					(TX_ARB_BWD),

.RX_ARB_DWD																					(RX_ARB_DWD),
.RX_ARB_IDWD																				(RX_ARB_IDWD),
.RX_ARB_UWD																					(RX_ARB_UWD),
.RX_ARB_BWD																					(RX_ARB_BWD),

.TX_ARB_IDWD_INT																			(TX_ARB_IDWD_INT),
.RX_ARB_IDWD_INT																			(RX_ARB_IDWD_INT),

.SRIOV_EN																					(SRIOV_EN),
.MAX_PAYLOAD_SIZE																			(MAX_PAYLOAD_SIZE),
.MAX_READ_REQUEST_SIZE																		(MAX_READ_REQUEST_SIZE),
.MAX_PAYLOAD_SIZE_DERIVED_DEFAULT															(MAX_PAYLOAD_SIZE_DERIVED_DEFAULT),
.MAX_READ_REQUEST_SIZE_DERIVED_DEFAULT														(MAX_READ_REQUEST_SIZE_DERIVED_DEFAULT),
.NUM_TAG_SIZE_DERIVED_BITS																	(NUM_TAG_SIZE_DERIVED_BITS),

.DMA_ARBITER_D2H_ST_PACKET_FIFO_DATA_WIDTH													(DMA_ARBITER_D2H_ST_PACKET_FIFO_DATA_WIDTH),
.DMA_ARBITER_H2D_ST_PACKET_FIFO_DATA_WIDTH													(DMA_ARBITER_H2D_ST_PACKET_FIFO_DATA_WIDTH),
.DMA_ARBITER_H2D_MM_PACKET_FIFO_DATA_WIDTH													(DMA_ARBITER_H2D_MM_PACKET_FIFO_DATA_WIDTH),

.DMA_ROUTER_D2H_ST_PACKET_FIFO_DATA_WIDTH													(DMA_ROUTER_D2H_ST_PACKET_FIFO_DATA_WIDTH),
.DMA_ROUTER_H2D_ST_PACKET_FIFO_DATA_WIDTH													(DMA_ROUTER_H2D_ST_PACKET_FIFO_DATA_WIDTH),
.DMA_ROUTER_H2D_MM_PACKET_FIFO_DATA_WIDTH													(DMA_ROUTER_H2D_MM_PACKET_FIFO_DATA_WIDTH)
) device_agent_inst (

.host_reset_status_n																		(app_reset_status_n_pipeline_out_dup[DEVICE_AGENT_WRAPPER_RESET_INPUT_INDEX]),
.host_clk																					(host_clk_internal),

.h2d0_mm_clk                                                                             (h2d0_mm_clk),
.h2d0_mm_resetn                                                                          (h2d0_mm_resetn),

.h2d0_awvalid                                                                            (h2d0_awvalid),
.h2d0_awaddr                                                                             (h2d0_awaddr ),
.h2d0_awsize                                                                             (h2d0_awsize ),
.h2d0_awprot                                                                             (h2d0_awprot ),
.h2d0_awlen                                                                              (h2d0_awlen  ),
.h2d0_awburst                                                                            (h2d0_awburst),
.h2d0_awid                                                                               (h2d0_awid   ),
.h2d0_awcache                                                                            (h2d0_awcache),
.h2d0_awready                                                                            (h2d0_awready),

.h2d0_wvalid                                                                             (h2d0_wvalid ),
.h2d0_wdata                                                                              (h2d0_wdata  ),
.h2d0_wlast                                                                              (h2d0_wlast  ),
.h2d0_wstrb                                                                              (h2d0_wstrb  ),
.h2d0_wready                                                                             (h2d0_wready ),

.h2d0_bready                                                                             (h2d0_bready ),
.h2d0_bvalid                                                                             (h2d0_bvalid ),
.h2d0_bresp                                                                              (h2d0_bresp  ),
.h2d0_bid                                                                                (h2d0_bid    ),

.h2d0_arvalid                                                                            (h2d0_arvalid),
.h2d0_araddr                                                                             (h2d0_araddr ),
.h2d0_arsize                                                                             (h2d0_arsize ),
.h2d0_arprot                                                                             (h2d0_arprot ),
.h2d0_arlen                                                                              (h2d0_arlen  ),
.h2d0_arburst                                                                            (h2d0_arburst),
.h2d0_arid                                                                               (h2d0_arid   ),
.h2d0_arcache                                                                            (h2d0_arcache),
.h2d0_arready                                                                            (h2d0_arready),

.h2d0_rready                                                                             (h2d0_rready ),
.h2d0_rdata                                                                              (h2d0_rdata  ),
.h2d0_rvalid                                                                             (h2d0_rvalid ),
.h2d0_rlast                                                                              (h2d0_rlast  ),
.h2d0_rresp                                                                              (h2d0_rresp  ),
.h2d0_rid                                                                                (h2d0_rid    ),



//TODO: add H2D MM, Descriptor Write & Response interfaces later
`ifndef DIRECTED_TB_ARB_STIMULUS_EN
.arb_h2d_mm_fifo_tvalid																		(arb_h2d_mm_fifo_tvalid),
.arb_h2d_mm_fifo_tready																		(arb_h2d_mm_fifo_tready),
.arb_h2d_mm_fifo_tdata																		(arb_h2d_mm_fifo_tdata),
.arb_h2d_mm_fifo_tuser																		(arb_h2d_mm_fifo_tuser),
.arb_h2d_mm_fifo_tlast																		(arb_h2d_mm_fifo_tlast),
.arb_h2d_mm_fifo_tid																		(arb_h2d_mm_fifo_tid),
.arb_h2d_mm_fifo_tkeep																		(arb_h2d_mm_fifo_tkeep),

.arb_h2d_st_fifo_tvalid																		(arb_h2d_st_fifo_tvalid),
.arb_h2d_st_fifo_tready																		(arb_h2d_st_fifo_tready),
.arb_h2d_st_fifo_tdata																		(arb_h2d_st_fifo_tdata),
.arb_h2d_st_fifo_tuser																		(arb_h2d_st_fifo_tuser),
.arb_h2d_st_fifo_tlast																		(arb_h2d_st_fifo_tlast),
.arb_h2d_st_fifo_tid																		(arb_h2d_st_fifo_tid),
.arb_h2d_st_fifo_tkeep																		(arb_h2d_st_fifo_tkeep),

.arb_d2h_st_fifo_tvalid																		(arb_d2h_st_fifo_tvalid),
.arb_d2h_st_fifo_tready																		(arb_d2h_st_fifo_tready),
.arb_d2h_st_fifo_tdata																		(arb_d2h_st_fifo_tdata),
.arb_d2h_st_fifo_tuser																		(arb_d2h_st_fifo_tuser),
.arb_d2h_st_fifo_tlast																		(arb_d2h_st_fifo_tlast),
.arb_d2h_st_fifo_tid																		(arb_d2h_st_fifo_tid),
.arb_d2h_st_fifo_tkeep																		(arb_d2h_st_fifo_tkeep),
`else // 
.arb_h2d_mm_fifo_tready																		('0),
.arb_h2d_st_fifo_tready																		('0),
.arb_d2h_st_fifo_tready																		('0),
`endif // DIRECTED_TB_ARB_STIMULUS_EN

`ifndef DIRECTED_TB_CSR_STIMULUS_EN
.h2d_mm_csr_addr																			(h2d_mm_csr_addr_i),
.h2d_mm_csr_wdata																			(h2d_mm_csr_wdata_i),
.h2d_mm_csr_rdata																			(h2d_mm_csr_rdata_o),
.h2d_mm_csr_wrreq																			(h2d_mm_csr_wrreq_i),
.h2d_mm_csr_rdreq																			(h2d_mm_csr_rdreq_i),
.h2d_mm_csr_rdvalid																			(h2d_mm_csr_rdvalid_o),
.h2d_mm_csr_req_ack																			(h2d_mm_csr_req_ack_o),

.h2d_st_csr_addr																			(h2d_st_csr_addr_i),
.h2d_st_csr_wdata																			(h2d_st_csr_wdata_i),
.h2d_st_csr_rdata																			(h2d_st_csr_rdata_o),
.h2d_st_csr_wrreq																			(h2d_st_csr_wrreq_i),
.h2d_st_csr_rdreq																			(h2d_st_csr_rdreq_i),
.h2d_st_csr_rdvalid																			(h2d_st_csr_rdvalid_o),
.h2d_st_csr_req_ack																			(h2d_st_csr_req_ack_o),

.d2h_st_csr_addr																			(d2h_st_csr_addr_i),
.d2h_st_csr_wdata																			(d2h_st_csr_wdata_i),
.d2h_st_csr_rdata																			(d2h_st_csr_rdata_o),
.d2h_st_csr_wrreq																			(d2h_st_csr_wrreq_i),
.d2h_st_csr_rdreq																			(d2h_st_csr_rdreq_i),
.d2h_st_csr_rdvalid																			(d2h_st_csr_rdvalid_o),
.d2h_st_csr_req_ack																			(d2h_st_csr_req_ack_o),
`else // 
.h2d_mm_csr_rdata																			('0),
.h2d_mm_csr_rdvalid																			('0),
.h2d_mm_csr_req_ack																			('0),

.h2d_st_csr_rdata																			('0),
.h2d_st_csr_rdvalid																			('0),
.h2d_st_csr_req_ack																			('0),

.d2h_st_csr_rdata																			('0),
.d2h_st_csr_rdvalid																			('0),
.d2h_st_csr_req_ack																			('0),
`endif // DIRECTED_TB_CSR_STIMULUS_EN

.router_h2d_mm_fifo_tvalid																	(router_h2d_mm_fifo_tvalid),
.router_h2d_mm_fifo_tready																	(router_h2d_mm_fifo_tready),
.router_h2d_mm_fifo_tdata																	(router_h2d_mm_fifo_tdata),
.router_h2d_mm_fifo_tuser																	(router_h2d_mm_fifo_tuser),
.router_h2d_mm_fifo_tlast																	(router_h2d_mm_fifo_tlast),
.router_h2d_mm_fifo_tid																		(router_h2d_mm_fifo_tid),
.router_h2d_mm_fifo_tkeep																	(router_h2d_mm_fifo_tkeep),
  
.router_h2d_st_fifo_tvalid																	(router_h2d_st_fifo_tvalid),
.router_h2d_st_fifo_tready																	(router_h2d_st_fifo_tready),
.router_h2d_st_fifo_tdata																	(router_h2d_st_fifo_tdata),
.router_h2d_st_fifo_tuser																	(router_h2d_st_fifo_tuser),
.router_h2d_st_fifo_tlast																	(router_h2d_st_fifo_tlast),
.router_h2d_st_fifo_tid																		(router_h2d_st_fifo_tid),
.router_h2d_st_fifo_tkeep																	(router_h2d_st_fifo_tkeep),
  
.router_d2h_st_fifo_tvalid																	(router_d2h_st_fifo_tvalid),
.router_d2h_st_fifo_tready																	(router_d2h_st_fifo_tready),
.router_d2h_st_fifo_tdata																	(router_d2h_st_fifo_tdata),
.router_d2h_st_fifo_tuser																	(router_d2h_st_fifo_tuser),
.router_d2h_st_fifo_tlast																	(router_d2h_st_fifo_tlast),
.router_d2h_st_fifo_tid																		(router_d2h_st_fifo_tid),
.router_d2h_st_fifo_tkeep																	(router_d2h_st_fifo_tkeep),

.h2d_mm_desc_axi_st_source_tvalid															(h2d_mm_desc_axi_st_source_tvalid),
.h2d_mm_desc_axi_st_source_tready															(h2d_mm_desc_axi_st_source_tready),
.h2d_mm_desc_axi_st_source_tdata															(h2d_mm_desc_axi_st_source_tdata),
.h2d_mm_desc_axi_st_source_tlast															(h2d_mm_desc_axi_st_source_tlast),

.h2d_st_desc_axi_st_source_tvalid															(h2d_st_desc_axi_st_source_tvalid),
.h2d_st_desc_axi_st_source_tready															(h2d_st_desc_axi_st_source_tready),
.h2d_st_desc_axi_st_source_tdata															(h2d_st_desc_axi_st_source_tdata),
.h2d_st_desc_axi_st_source_tlast															(h2d_st_desc_axi_st_source_tlast),

.d2h_st_desc_axi_st_source_tvalid															(d2h_st_desc_axi_st_source_tvalid),
.d2h_st_desc_axi_st_source_tready															(d2h_st_desc_axi_st_source_tready),
.d2h_st_desc_axi_st_source_tdata															(d2h_st_desc_axi_st_source_tdata),
.d2h_st_desc_axi_st_source_tlast															(d2h_st_desc_axi_st_source_tlast),

.h2d_mm_agent_descriptor_taken																(h2d_mm_agent_descriptor_taken),
.h2d_st_agent_descriptor_taken																(h2d_st_agent_descriptor_taken),
.d2h_st_agent_descriptor_taken																(d2h_st_agent_descriptor_taken),

.h2d_mm_agent_responder_added																(h2d_mm_agent_responder_added),
.h2d_st_agent_responder_added																(h2d_st_agent_responder_added),
.d2h_st_agent_responder_added																(d2h_st_agent_responder_added),

.d2h_st_agent_flush_int																		(d2h_st_agent_flush_int),
.d2h_st_agent_flush_ack																		(d2h_st_agent_flush_ack),

.d2h_st_byteack_valid																		(d2h_st_byteack_valid),
.d2h_st_byteack																				(d2h_st_byteack),

.h2d_mm_resp_axi_st_sink_tvalid																(h2d_mm_resp_axi_st_sink_tvalid),
.h2d_mm_resp_axi_st_sink_tready																(h2d_mm_resp_axi_st_sink_tready),
.h2d_mm_resp_axi_st_sink_tdata																(h2d_mm_resp_axi_st_sink_tdata),
.h2d_mm_resp_axi_st_sink_tlast																(h2d_mm_resp_axi_st_sink_tlast),

.h2d_st_resp_axi_st_sink_tvalid																(h2d_st_resp_axi_st_sink_tvalid),
.h2d_st_resp_axi_st_sink_tready																(h2d_st_resp_axi_st_sink_tready),
.h2d_st_resp_axi_st_sink_tdata																(h2d_st_resp_axi_st_sink_tdata),
.h2d_st_resp_axi_st_sink_tlast																(h2d_st_resp_axi_st_sink_tlast),

.d2h_st_resp_axi_st_sink_tvalid																(d2h_st_resp_axi_st_sink_tvalid),
.d2h_st_resp_axi_st_sink_tready																(d2h_st_resp_axi_st_sink_tready),
.d2h_st_resp_axi_st_sink_tdata																(d2h_st_resp_axi_st_sink_tdata),
.d2h_st_resp_axi_st_sink_tlast																(d2h_st_resp_axi_st_sink_tlast),

.h2d_mm_prefetch_irq_en																		('0), // Not used by Device Agent
.h2d_mm_wb_en																				('0), // Not used by Device Agent
.h2d_mm_q_en																				(h2d_mm_q_en_pipeline),
.h2d_mm_irq_en																				(h2d_mm_irq_en_pipeline),
.h2d_mm_q_pause_agent_control																(h2d_mm_q_pause_agent_control_pipeline),
.h2d_mm_q_sw_reset_req																		(h2d_mm_q_sw_reset_req_pipeline),

.h2d_st_prefetch_irq_en																		('0), // Not used by Device Agent
.h2d_st_wb_en																				('0), // Not used by Device Agent
.h2d_st_q_en																				(h2d_st_q_en_pipeline),
.h2d_st_irq_en																				(h2d_st_irq_en_pipeline),
.h2d_st_q_pause_agent_control																(h2d_st_q_pause_agent_control_pipeline),
.h2d_st_q_sw_reset_req																		(h2d_st_q_sw_reset_req_pipeline),

.d2h_st_prefetch_irq_en																		('0), // Not used by Device Agent
.d2h_st_wb_en																				('0), // Not used by Device Agent
.d2h_st_q_en																				(d2h_st_q_en_pipeline),
.d2h_st_irq_en																				(d2h_st_irq_en_pipeline),
.d2h_st_q_pause_agent_control																(d2h_st_q_pause_agent_control_pipeline),
.d2h_st_q_sw_reset_req																		(d2h_st_q_sw_reset_req_pipeline),

.h2d_mm_q_descr_buffer_full																	(h2d_mm_q_descr_buffer_full),
.h2d_mm_q_descr_buffer_empty																(h2d_mm_q_descr_buffer_empty),
.h2d_mm_q_resp_buffer_full																	(h2d_mm_q_resp_buffer_full),
.h2d_mm_q_resp_buffer_empty																	(h2d_mm_q_resp_buffer_empty),

.h2d_st_q_descr_buffer_full																	(h2d_st_q_descr_buffer_full),
.h2d_st_q_descr_buffer_empty																(h2d_st_q_descr_buffer_empty),
.h2d_st_q_resp_buffer_full																	(h2d_st_q_resp_buffer_full),
.h2d_st_q_resp_buffer_empty																	(h2d_st_q_resp_buffer_empty),

.d2h_st_q_descr_buffer_full																	(d2h_st_q_descr_buffer_full),
.d2h_st_q_descr_buffer_empty																(d2h_st_q_descr_buffer_empty),
.d2h_st_q_resp_buffer_full																	(d2h_st_q_resp_buffer_full),
.d2h_st_q_resp_buffer_empty																	(d2h_st_q_resp_buffer_empty),

// DMA Only mode
// .h2d_mm_descrwr_axi_st_source_tvalid														(h2d_mm_descrwr_axi_st_source_tvalid),
// .h2d_mm_descrwr_axi_st_source_tready														(h2d_mm_descrwr_axi_st_source_tready),
// .h2d_mm_descrwr_axi_st_source_tdata															(h2d_mm_descrwr_axi_st_source_tdata),
// .h2d_mm_descrwr_axi_st_source_tlast															(h2d_mm_descrwr_axi_st_source_tlast),

// .h2d_mm_descrresp_axi_st_sink_tvalid														(h2d_mm_descrresp_axi_st_sink_tvalid),
// .h2d_mm_descrresp_axi_st_sink_tdata															(h2d_mm_descrresp_axi_st_sink_tdata),
// .h2d_mm_descrresp_axi_st_sink_tlast															(h2d_mm_descrresp_axi_st_sink_tlast),

// .h2d_st_descrwr_axi_st_source_tvalid														(h2d_st_descrwr_axi_st_source_tvalid),
// .h2d_st_descrwr_axi_st_source_tready														(h2d_st_descrwr_axi_st_source_tready),
// .h2d_st_descrwr_axi_st_source_tdata															(h2d_st_descrwr_axi_st_source_tdata),
// .h2d_st_descrwr_axi_st_source_tlast															(h2d_st_descrwr_axi_st_source_tlast),

// .h2d_st_descrresp_axi_st_sink_tvalid														(h2d_st_descrresp_axi_st_sink_tvalid),
// .h2d_st_descrresp_axi_st_sink_tdata															(h2d_st_descrresp_axi_st_sink_tdata),
// .h2d_st_descrresp_axi_st_sink_tlast															(h2d_st_descrresp_axi_st_sink_tlast),

// .d2h_st_descrwr_axi_st_source_tvalid														(d2h_st_descrwr_axi_st_source_tvalid),
// .d2h_st_descrwr_axi_st_source_tready														(d2h_st_descrwr_axi_st_source_tready),
// .d2h_st_descrwr_axi_st_source_tdata															(d2h_st_descrwr_axi_st_source_tdata),
// .d2h_st_descrwr_axi_st_source_tlast															(d2h_st_descrwr_axi_st_source_tlast),

// .d2h_st_descrresp_axi_st_sink_tvalid														(d2h_st_descrresp_axi_st_sink_tvalid),
// .d2h_st_descrresp_axi_st_sink_tdata															(d2h_st_descrresp_axi_st_sink_tdata),
// .d2h_st_descrresp_axi_st_sink_tlast															(d2h_st_descrresp_axi_st_sink_tlast),

.host_pf_id																					(host_pf_id),
.host_vf_id																					(host_vf_id),
.host_vf_in_slot_pf																			(host_vf_in_slot_pf),
.host_slot_id																				(host_slot_id),
.host_bus_master_en																			(host_bus_master_en),
.host_msix_mask																				(host_msix_mask),
.host_msix_en																				(host_msix_en),
.host_mem_space_en																			(host_mem_space_en),

.host_exp_rom_enable																		(host_exp_rom_enable),
.host_tph_req_en																			(host_tph_req_en),
.host_ats_en																				(host_ats_en),
.host_msi_en																				(host_msi_en),
.host_msi_mask																				(host_msi_mask),
.host_ext_tag_en																			(host_ext_tag_en),
.host_tag_req_10bit_en																		(host_tag_req_10bit_en),
.host_ptm_en																				(host_ptm_en),
.host_mps																					(host_mps),
.host_mrrs																					(host_mrrs),
.host_vf_en																					(host_vf_en),
.host_page_req_en																			(host_page_req_en)
);

endmodule

