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

`default_nettype wire

// synopsys translate_on

`define DEV_AGENT_DEBUG				0

// `include "./ssgdma_macro.sv" // For internal debugging, comment away subsequent define lines and enable this one instead

`define DEVICE_AGENT_INSTANCE_EN	1
`define PREFETCHER_INSTANCE_EN		1
`define COMPLETER_INSTANCE_EN		1
`define BAM_INSTANCE_EN				1
`define TX_SCHEDULER_INSTANCE_EN	1
// `define CS_INSTANCE_EN				1
// `define BAS_INSTANCE_EN				1

import ssgdma_pkg::*;
import ssgdma_csr_reg_pkg::*;

module device_agent_wrapper #(
parameter DEVICE_FAMILY      																= "Agilex 7",
parameter DMA_MODE																			= "DMA PCIe mode", // "DMA PCIe mode", "DMA SoC mode", "DMA only mode" 
parameter SS_ST_DWD            																= 512,
parameter SS_ST_UWD            																= 2,
parameter SS_ST_BWD            																= 8,
parameter SS_ST_BENWD           															= SS_ST_DWD/SS_ST_BWD,	

parameter HOST_AWD    																		= 64,	// 
parameter HOST_IDWD    																		= 1,	// 
parameter HOST_LWD    																		= 8,
parameter HOST_DWD    																		= 512,	// 

parameter SRIOV_EN																			= 0, // 0 or 1
parameter UNALIGNED_ACCESS_EN																= 0, // 0 or 1
parameter ECC_EN																			= 0, // 0 or 1

parameter MULTI_FUNCTIONS_EN																= 0, // 0 or 1
parameter NUM_PF																			= 1, // 1 or 2
parameter NUM_VF_PER_PF0																	= 0, // TBD, not used for now
parameter NUM_TAG_SIZE_DERIVED_BITS															= 8, 
parameter [2:0] MAX_PAYLOAD_SIZE_DERIVED_DEFAULT            								= 2,
parameter [2:0] MAX_READ_REQUEST_SIZE_DERIVED_DEFAULT         								= 5,

parameter MAX_READ_REQUEST_SIZE     														= 256,
parameter MAX_PAYLOAD_SIZE																	= 512, // "128 bytes", "256 bytes", "512 bytes", "1024 bytes", "2048 bytes", "4096 bytes"
parameter ADDR_64BITS_EN																	= 0, // 0 or 1
parameter FLR_EN																			= 0,  	// 0 or 1

parameter H2D_MM0_AWD    																= 64,	// 1 to 64
parameter H2D_MM0_LWD    																= 8,
parameter H2D_MM0_IDWD    																= 1,	// 1 to 18
parameter H2D_MM0_DWD    																= 64,	// 8, 16, 32, 64, 128, 256, 512, 1024
parameter H2D_MM0_FIFO_DEPTH 															= 6144,	// 64, 128, 256, 512, 1024, 2048, 4096
parameter NUM_CHAN_PER_H2D_MM_PORT0														= 1,	// 1 to 32, not used for now


parameter NUM_H2D_MM_PORTS																	= 0, // 0 to 16
parameter NUM_H2D_ST_PORTS																	= 1, // 0 to 16
parameter NUM_D2H_ST_PORTS																	= 1, // 0 to 16

// TODO: the NUM_*_CHANS values are identical NUM_*_PORTS for intial support now
parameter NUM_H2D_MM_CHANS																	= 1, // 1 to 512 (up to 32 H2D MM ports, TBD)
parameter NUM_H2D_ST_CHANS																	= 1, // 1 to 512 (up to 32 H2D ST ports, TBD)
parameter NUM_D2H_ST_CHANS																	= 1, // 1 to 512 (up to 32 D2H ST ports, TBD) 

parameter HOST_CSR_AWD    																	= 22,
parameter HOST_CSR_DWD    																	= 32,
parameter HOST_CSR_BWD    																	= 8,
parameter HOST_CSR_BENWD           															= HOST_CSR_DWD/HOST_CSR_BWD,

parameter NUM_H2D_MM_CHANS_PER_PORT															= 1, //1 for PoC, TBD max number of channels per port. 
parameter NUM_H2D_ST_CHANS_PER_PORT															= 1, //1 for PoC, TBD max number of channels per port 
parameter NUM_D2H_ST_CHANS_PER_PORT															= 1, //1 for PoC, TBD max number of channels per port 

parameter NUM_H2D_MM_CHANS_DERIVED															= ((SRIOV_EN == 1) ? (NUM_H2D_MM_CHANS*NUM_H2D_MM_PORTS) : NUM_H2D_MM_PORTS), // 
parameter NUM_H2D_ST_CHANS_DERIVED															= ((SRIOV_EN == 1) ? (NUM_H2D_ST_CHANS*NUM_H2D_ST_PORTS) : NUM_H2D_ST_PORTS), // 
parameter NUM_D2H_ST_CHANS_DERIVED															= ((SRIOV_EN == 1) ? (NUM_D2H_ST_CHANS*NUM_D2H_ST_PORTS) : NUM_D2H_ST_PORTS), // 
	
parameter NUM_H2D_MM_PORTS_DERIVED															= NUM_H2D_MM_PORTS, // 
parameter NUM_H2D_ST_PORTS_DERIVED															= NUM_H2D_ST_PORTS, // 
parameter NUM_D2H_ST_PORTS_DERIVED															= NUM_D2H_ST_PORTS, // 
	
parameter NUM_H2D_D2H_PORTS																	= (NUM_H2D_MM_PORTS == 0 && NUM_H2D_ST_PORTS == 0 && NUM_D2H_ST_PORTS == 0) ? 	0 :
																							  (NUM_H2D_MM_PORTS == 0 && NUM_H2D_ST_PORTS == 0 && NUM_D2H_ST_PORTS > 0) 	? 	NUM_D2H_ST_PORTS :
																							  (NUM_H2D_MM_PORTS == 0 && NUM_H2D_ST_PORTS > 0  && NUM_D2H_ST_PORTS == 0) ? 	NUM_H2D_ST_PORTS :
																							  (NUM_H2D_MM_PORTS == 0 && NUM_H2D_ST_PORTS > 0  && NUM_D2H_ST_PORTS > 0) 	? 	(NUM_H2D_ST_PORTS+NUM_D2H_ST_PORTS):
																							  (NUM_H2D_MM_PORTS > 0  && NUM_H2D_ST_PORTS == 0 && NUM_D2H_ST_PORTS == 0) ? 	NUM_H2D_MM_PORTS :
																							  (NUM_H2D_MM_PORTS > 0  && NUM_H2D_ST_PORTS == 0 && NUM_D2H_ST_PORTS > 0) 	? 	(NUM_H2D_MM_PORTS+NUM_D2H_ST_PORTS):
																							  (NUM_H2D_MM_PORTS > 0  && NUM_H2D_ST_PORTS > 0  && NUM_D2H_ST_PORTS == 0) ? 	(NUM_H2D_MM_PORTS+NUM_H2D_ST_PORTS):
																							  (NUM_H2D_MM_PORTS > 0  && NUM_H2D_ST_PORTS > 0  && NUM_D2H_ST_PORTS > 0) 	? 	(NUM_H2D_MM_PORTS+NUM_H2D_ST_PORTS+NUM_D2H_ST_PORTS):
																							  (NUM_H2D_MM_PORTS+NUM_H2D_ST_PORTS+NUM_D2H_ST_PORTS), //
																							  
parameter NUM_H2D_D2H_CHANS																	= (NUM_H2D_MM_PORTS == 0 && NUM_H2D_ST_PORTS == 0 && NUM_D2H_ST_PORTS == 0) ? 	0 :
																							  (NUM_H2D_MM_PORTS == 0 && NUM_H2D_ST_PORTS == 0 && NUM_D2H_ST_PORTS > 0) 	? 	NUM_D2H_ST_CHANS :
																							  (NUM_H2D_MM_PORTS == 0 && NUM_H2D_ST_PORTS > 0  && NUM_D2H_ST_PORTS == 0)	? 	NUM_H2D_ST_CHANS :
																							  (NUM_H2D_MM_PORTS == 0 && NUM_H2D_ST_PORTS > 0  && NUM_D2H_ST_PORTS > 0) 	? 	(NUM_H2D_ST_CHANS+NUM_D2H_ST_CHANS):
																							  (NUM_H2D_MM_PORTS > 0  && NUM_H2D_ST_PORTS == 0 && NUM_D2H_ST_PORTS == 0)	? 	NUM_H2D_MM_CHANS :
																							  (NUM_H2D_MM_PORTS > 0  && NUM_H2D_ST_PORTS == 0 && NUM_D2H_ST_PORTS > 0) 	? 	(NUM_H2D_MM_CHANS+NUM_D2H_ST_CHANS):
																							  (NUM_H2D_MM_PORTS > 0  && NUM_H2D_ST_PORTS > 0  && NUM_D2H_ST_PORTS == 0)	? 	(NUM_H2D_MM_CHANS+NUM_H2D_ST_CHANS):
																							  (NUM_H2D_MM_PORTS > 0  && NUM_H2D_ST_PORTS > 0  && NUM_D2H_ST_PORTS > 0) 	? 	(NUM_H2D_MM_CHANS+NUM_H2D_ST_CHANS+NUM_D2H_ST_CHANS):
																							  (NUM_H2D_MM_CHANS+NUM_H2D_ST_CHANS+NUM_D2H_ST_CHANS), //

parameter NUM_H2D_D2H_PORTS_DERIVED															= NUM_H2D_D2H_PORTS, //
parameter NUM_H2D_D2H_CHANS_DERIVED															= (SRIOV_EN == 1) ? NUM_H2D_D2H_CHANS : NUM_H2D_D2H_PORTS, //

parameter H2D_D2H_DD_WD                                 									= 32, // 32, 128, 256
parameter AGENT_DESCRIPTOR_FIFO_DEPTH														= 32, // number of descriptors to store
parameter AGENT_DESCRIPTOR_DATA_WIDTH														= H2D_D2H_DD_WD, //
parameter AGENT_RESPONDER_DATA_WIDTH														= H2D_D2H_DD_WD, //
parameter MSIX_DATA_WIDTH																	= 16, 
	
parameter TX_ARB_DWD    																	= (DMA_MODE == "DMA PCIe mode") ? SS_ST_DWD : HOST_DWD,
parameter TX_ARB_IDWD    																	= 15,	// 4 to 15
parameter TX_ARB_UWD            															= 116,	// 116 - To/From DMA Arbiter, 84 - To/From DMA Router
parameter TX_ARB_BWD         											 					= 8,	// 
parameter TX_ARB_BENWD        																= (TX_ARB_DWD/TX_ARB_BWD),	

parameter RX_ARB_DWD    																	= (DMA_MODE == "DMA PCIe mode") ? SS_ST_DWD : HOST_DWD,
parameter RX_ARB_IDWD    																	= 15,	// 4 to 15
parameter RX_ARB_UWD            															= 86,	// 116 - To/From DMA Arbiter, 84 - To/From DMA Router
parameter RX_ARB_BWD         											 					= 8,	// 
parameter RX_ARB_BENWD        																= (RX_ARB_DWD/RX_ARB_BWD),	

parameter TX_ARB_IDWD_INT                            										= 10,
parameter RX_ARB_IDWD_INT                            										= 10,
											
parameter DMA_ARBITER_D2H_ST_PACKET_FIFO_DATA_WIDTH											= TX_ARB_DWD,
parameter DMA_ARBITER_H2D_ST_PACKET_FIFO_DATA_WIDTH											= 8, // 
parameter DMA_ARBITER_H2D_MM_PACKET_FIFO_DATA_WIDTH											= TX_ARB_DWD,

parameter DMA_ROUTER_D2H_ST_PACKET_FIFO_DATA_WIDTH											= 8,
parameter DMA_ROUTER_H2D_ST_PACKET_FIFO_DATA_WIDTH											= RX_ARB_DWD, // 
parameter DMA_ROUTER_H2D_MM_PACKET_FIFO_DATA_WIDTH											= RX_ARB_DWD
) (

// PCIe Hard IP Reset Signal
input  logic [1-1:0]  																			host_reset_status_n,	// PCIe mode: coming from ss_reset_status_n, SoC and DMA Only modes: host_aresetn
input  logic [1-1:0]  																			host_clk,				// PCIe mode: coming from ss_axi_st_clk, SoC and DMA Only modes: host_clk
// Clocks and Resets for Device Ports
input  logic [1-1:0]  																			h2d0_mm_clk,
input  logic [1-1:0]  																			h2d0_mm_resetn,	// Not used, just for platform designer compatibilty purpose
// Device Port Interfaces
// Host to Device AXI-4 Manager Interface (h2d_mm0) - Port 0
output logic [1-1:0]  																			h2d0_awvalid,
output logic [H2D_MM0_AWD-1:0]  																h2d0_awaddr,
output logic [3-1:0]  																			h2d0_awsize,
output logic [3-1:0]  																			h2d0_awprot,
output logic [H2D_MM0_LWD-1:0]  																h2d0_awlen,
output logic [2-1:0]  																			h2d0_awburst,
output logic [H2D_MM0_IDWD-1:0]																h2d0_awid,
output logic [4-1:0]  																			h2d0_awcache,
input  logic [1-1:0]  																			h2d0_awready,

output logic [1-1:0]  																			h2d0_wvalid,
output logic [H2D_MM0_DWD-1:0]  																h2d0_wdata,
output logic [1-1:0]  																			h2d0_wlast,
output logic [(H2D_MM0_DWD/8)-1:0]  															h2d0_wstrb,
input  logic [1-1:0]  																			h2d0_wready,

output logic [1-1:0]  																			h2d0_bready,
input  logic [1-1:0]  																			h2d0_bvalid,
input  logic [2-1:0]  																			h2d0_bresp,
input  logic [H2D_MM0_IDWD-1:0]  															h2d0_bid,

output logic [1-1:0]  																			h2d0_arvalid,
output logic [H2D_MM0_AWD-1:0]  																h2d0_araddr,
output logic [3-1:0]  																			h2d0_arsize,
output logic [3-1:0]  																			h2d0_arprot,
output logic [H2D_MM0_LWD-1:0]  																h2d0_arlen,
output logic [2-1:0]  																			h2d0_arburst,
output logic [H2D_MM0_IDWD-1:0]  															h2d0_arid,
output logic [4-1:0]  																			h2d0_arcache,
input  logic [1-1:0]  																			h2d0_arready,

output logic [1-1:0]  																			h2d0_rready,
input  logic [H2D_MM0_DWD-1:0]  																h2d0_rdata,
input  logic [1-1:0]  																			h2d0_rvalid,
input  logic [1-1:0]  																			h2d0_rlast,
input  logic [2-1:0]  																			h2d0_rresp,
input  logic [H2D_MM0_IDWD-1:0]  															h2d0_rid,

output logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0]															arb_h2d_mm_fifo_tvalid,
input  logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0]															arb_h2d_mm_fifo_tready,
output logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0][DMA_ARBITER_H2D_MM_PACKET_FIFO_DATA_WIDTH-1:0]			arb_h2d_mm_fifo_tdata,
output logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0][TX_ARB_UWD-1:0]											arb_h2d_mm_fifo_tuser,
output logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0]															arb_h2d_mm_fifo_tlast,
output logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0][TX_ARB_IDWD_INT-1:0]									arb_h2d_mm_fifo_tid,
output logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0][DMA_ARBITER_H2D_MM_PACKET_FIFO_DATA_WIDTH/8-1:0]		arb_h2d_mm_fifo_tkeep,
  
output logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0]															arb_h2d_st_fifo_tvalid,
input  logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0]															arb_h2d_st_fifo_tready,
output logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0][DMA_ARBITER_H2D_ST_PACKET_FIFO_DATA_WIDTH-1:0]			arb_h2d_st_fifo_tdata,
output logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0][TX_ARB_UWD-1:0]											arb_h2d_st_fifo_tuser,
output logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0]															arb_h2d_st_fifo_tlast,
output logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0][TX_ARB_IDWD_INT-1:0]									arb_h2d_st_fifo_tid,
output logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0][DMA_ARBITER_H2D_ST_PACKET_FIFO_DATA_WIDTH/8-1:0]		arb_h2d_st_fifo_tkeep,
  
output logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0]															arb_d2h_st_fifo_tvalid,
input  logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0]															arb_d2h_st_fifo_tready,
output logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0][DMA_ARBITER_D2H_ST_PACKET_FIFO_DATA_WIDTH-1:0]			arb_d2h_st_fifo_tdata,
output logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0][TX_ARB_UWD-1:0]											arb_d2h_st_fifo_tuser,
output logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0]															arb_d2h_st_fifo_tlast,
output logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0][TX_ARB_IDWD_INT-1:0]									arb_d2h_st_fifo_tid,
output logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0][DMA_ARBITER_D2H_ST_PACKET_FIFO_DATA_WIDTH/8-1:0]		arb_d2h_st_fifo_tkeep,

// To access responder table & updates status registers from QCSR 
output logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0][HOST_CSR_AWD-1:0]										h2d_mm_csr_addr,
output logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0][HOST_CSR_DWD-1:0]										h2d_mm_csr_wdata,
input  logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0][HOST_CSR_DWD-1:0]										h2d_mm_csr_rdata,
output logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0]  														h2d_mm_csr_wrreq,
output logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0]        													h2d_mm_csr_rdreq,
input  logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0]  														h2d_mm_csr_rdvalid,
input  logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0]  														h2d_mm_csr_req_ack,
	
// To access responder table & updates status registers from QCSR 
output logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0][HOST_CSR_AWD-1:0]										h2d_st_csr_addr,
output logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0][HOST_CSR_DWD-1:0]										h2d_st_csr_wdata,
input  logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0][HOST_CSR_DWD-1:0]										h2d_st_csr_rdata,
output logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0]        													h2d_st_csr_rdreq,
output logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0]  														h2d_st_csr_wrreq,
input  logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0]  														h2d_st_csr_req_ack,
input  logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0]  														h2d_st_csr_rdvalid,

// To access responder table & updates status registers from QCSR 
output logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0][HOST_CSR_AWD-1:0]										d2h_st_csr_addr,
output logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0][HOST_CSR_DWD-1:0]   									d2h_st_csr_wdata,
input  logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0][HOST_CSR_DWD-1:0]   									d2h_st_csr_rdata,
output logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0]  														d2h_st_csr_wrreq,
output logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0]        													d2h_st_csr_rdreq,
input  logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0]  														d2h_st_csr_rdvalid,
input  logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0]  														d2h_st_csr_req_ack,

input  logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0]															router_h2d_mm_fifo_tvalid,
output logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0]															router_h2d_mm_fifo_tready,
input  logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0][DMA_ROUTER_H2D_MM_PACKET_FIFO_DATA_WIDTH-1:0]			router_h2d_mm_fifo_tdata,
input  logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0][RX_ARB_UWD-1:0]											router_h2d_mm_fifo_tuser,
input  logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0]															router_h2d_mm_fifo_tlast,
input  logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0][RX_ARB_IDWD_INT-1:0]									router_h2d_mm_fifo_tid,
input  logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0][DMA_ROUTER_H2D_MM_PACKET_FIFO_DATA_WIDTH/8-1:0]			router_h2d_mm_fifo_tkeep,
  
input  logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0]															router_h2d_st_fifo_tvalid,
output logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0]															router_h2d_st_fifo_tready,
input  logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0][DMA_ROUTER_H2D_ST_PACKET_FIFO_DATA_WIDTH-1:0]			router_h2d_st_fifo_tdata,
input  logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0][RX_ARB_UWD-1:0]											router_h2d_st_fifo_tuser,
input  logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0]															router_h2d_st_fifo_tlast,
input  logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0][RX_ARB_IDWD_INT-1:0]									router_h2d_st_fifo_tid,
input  logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0][DMA_ROUTER_H2D_ST_PACKET_FIFO_DATA_WIDTH/8-1:0]			router_h2d_st_fifo_tkeep,
  
input  logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0]															router_d2h_st_fifo_tvalid,
output logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0]															router_d2h_st_fifo_tready,
input  logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0][DMA_ROUTER_D2H_ST_PACKET_FIFO_DATA_WIDTH-1:0]			router_d2h_st_fifo_tdata,
input  logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0][RX_ARB_UWD-1:0]											router_d2h_st_fifo_tuser,
input  logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0]															router_d2h_st_fifo_tlast,
input  logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0][RX_ARB_IDWD_INT-1:0]									router_d2h_st_fifo_tid,
input  logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0][DMA_ROUTER_D2H_ST_PACKET_FIFO_DATA_WIDTH/8-1:0]			router_d2h_st_fifo_tkeep,

// Synchronized to ss_axi_st_clk
input logic [5-1:0]  																										host_pf_id,
input logic [12-1:0]  																										host_vf_id,
input logic [1-1:0]  																										host_vf_in_slot_pf,
input logic [5-1:0]  																										host_slot_id,
input logic [1-1:0]  																										host_bus_master_en,
input logic [1-1:0]  																										host_msix_mask,
input logic [1-1:0]  																										host_msix_en,
input logic [1-1:0]  																										host_mem_space_en,
input logic [1-1:0]  																										host_exp_rom_enable,
input logic [1-1:0]  																										host_tph_req_en,
input logic [1-1:0]  																										host_ats_en,
input logic [1-1:0]  																										host_msi_en,
input logic [1-1:0]  																										host_msi_mask,
input logic [1-1:0]  																										host_ext_tag_en,
input logic [1-1:0]  																										host_tag_req_10bit_en,
input logic [1-1:0]  																										host_ptm_en,
input logic [3-1:0]  																										host_mps,
input logic [3-1:0]  																										host_mrrs,
input logic [1-1:0]  																										host_vf_en,
input logic [1-1:0]  																										host_page_req_en,

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

input  logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0] 														h2d_mm_desc_axi_st_source_tvalid, //width = 1 per device port
output logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0] 														h2d_mm_desc_axi_st_source_tready, //width = 1 per device port
input  logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0][AGENT_DESCRIPTOR_DATA_WIDTH-1:0]						h2d_mm_desc_axi_st_source_tdata,  //width = 32 or 256 per device port //TO_ASK: how do we differentiate each agent's data widht?
input  logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0]															h2d_mm_desc_axi_st_source_tlast,  //width = 1 per device port

input  logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0] 														h2d_st_desc_axi_st_source_tvalid, //width = 1 per device port
output logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0] 														h2d_st_desc_axi_st_source_tready, //width = 1 per device port
input  logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0][AGENT_DESCRIPTOR_DATA_WIDTH-1:0]						h2d_st_desc_axi_st_source_tdata,  //width = 32 or 256 per device port //TO_ASK: how do we differentiate each agent's data widht?
input  logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0]															h2d_st_desc_axi_st_source_tlast,  //width = 1 per device port

input  logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0] 														d2h_st_desc_axi_st_source_tvalid, //width = 1 per device port
output logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0] 														d2h_st_desc_axi_st_source_tready, //width = 1 per device port
input  logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0][AGENT_DESCRIPTOR_DATA_WIDTH-1:0]						d2h_st_desc_axi_st_source_tdata,  //width = 32 or 256 per device port //TO_ASK: how do we differentiate each agent's data widht?
input  logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0]															d2h_st_desc_axi_st_source_tlast,  //width = 1 per device port

output logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0]															h2d_mm_agent_descriptor_taken, //Agent sends a pulse when a descriptor is taken from the agent's descriptor FIFO (a descriptor is 32 bytes)
output logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0]															h2d_st_agent_descriptor_taken, //Agent sends a pulse when a descriptor is taken from the agent's descriptor FIFO (a descriptor is 32 bytes)
output logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0]															d2h_st_agent_descriptor_taken, //Agent sends a pulse when a descriptor is taken from the agent's descriptor FIFO (a descriptor is 32 bytes)

output logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0] 														h2d_mm_resp_axi_st_sink_tvalid, //width = 1 per device port
input  logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0] 														h2d_mm_resp_axi_st_sink_tready, //width = 1 per device port
output logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0][AGENT_RESPONDER_DATA_WIDTH-1:0]							h2d_mm_resp_axi_st_sink_tdata,  //width = 32 or 256 per device port //TO_ASK: how do we differentiate each agent's data widht?
output logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0]															h2d_mm_resp_axi_st_sink_tlast,  //width = 1 per device port

output logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0] 														h2d_st_resp_axi_st_sink_tvalid, //width = 1 per device port
input  logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0] 														h2d_st_resp_axi_st_sink_tready, //width = 1 per device port
output logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0][AGENT_RESPONDER_DATA_WIDTH-1:0]							h2d_st_resp_axi_st_sink_tdata,  //width = 32 or 256 per device port //TO_ASK: how do we differentiate each agent's data widht?
output logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0]															h2d_st_resp_axi_st_sink_tlast,  //width = 1 per device port

output logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0] 														d2h_st_resp_axi_st_sink_tvalid, //width = 1 per device port
input  logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0] 														d2h_st_resp_axi_st_sink_tready, //width = 1 per device port
output logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0][AGENT_RESPONDER_DATA_WIDTH-1:0]							d2h_st_resp_axi_st_sink_tdata,  //width = 32 or 256 per device port //TO_ASK: how do we differentiate each agent's data widht?
output logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0]															d2h_st_resp_axi_st_sink_tlast,  //width = 1 per device port

output logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0]															h2d_mm_agent_responder_added, //Agent sends a pulse when a responder is filled into the agent's responder FIFO (a responder is 32 bytes)
output logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0]															h2d_st_agent_responder_added, //Agent sends a pulse when a responder is filled into the agent's responder FIFO (a responder is 32 bytes)
output logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0]															d2h_st_agent_responder_added, //Agent sends a pulse when a responder is filled into the agent's responder FIFO (a responder is 32 bytes)

output logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0]															d2h_st_agent_flush_int, //Agent asserts this signal when it requires prefetcher to send a flush MSI-X interrupt to the host. It will be cleared once prefetcher sends the ACK.
input  logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0]															d2h_st_agent_flush_ack, //Agent sends a single clock pulse to acknowledge the flush interrupt from agent. 

output logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0]															h2d_mm_q_descr_buffer_full,
output logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0]															h2d_mm_q_descr_buffer_empty,
output logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0]															h2d_mm_q_resp_buffer_full,
output logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0]															h2d_mm_q_resp_buffer_empty,

output logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0]															h2d_st_q_descr_buffer_full,
output logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0]															h2d_st_q_descr_buffer_empty,
output logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0]															h2d_st_q_resp_buffer_full,
output logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0]															h2d_st_q_resp_buffer_empty,

output logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0]															d2h_st_q_descr_buffer_full,
output logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0]															d2h_st_q_descr_buffer_empty,
output logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0]															d2h_st_q_resp_buffer_full,
output logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0]															d2h_st_q_resp_buffer_empty,

input  logic [((NUM_D2H_ST_CHANS_DERIVED==0) ? 0 : (NUM_D2H_ST_CHANS_DERIVED-1)):0]											d2h_st_byteack_valid,
input  logic [((NUM_D2H_ST_CHANS_DERIVED==0) ? 0 : (NUM_D2H_ST_CHANS_DERIVED-1)):0][HOST_CSR_DWD-1:0]						d2h_st_byteack,

input  logic [((NUM_H2D_MM_CHANS_DERIVED==0) ? 0 : (NUM_H2D_MM_CHANS_DERIVED-1)):0]  										h2d_mm_q_en,  					// to Prefetcher Engine & Agent
input  logic [((NUM_H2D_MM_CHANS_DERIVED==0) ? 0 : (NUM_H2D_MM_CHANS_DERIVED-1)):0]  										h2d_mm_prefetch_irq_en, 		// to Prefetcher Engine only
input  logic [((NUM_H2D_MM_CHANS_DERIVED==0) ? 0 : (NUM_H2D_MM_CHANS_DERIVED-1)):0]  										h2d_mm_wb_en, 					// to Prefetcher Engine only
input  logic [((NUM_H2D_MM_CHANS_DERIVED==0) ? 0 : (NUM_H2D_MM_CHANS_DERIVED-1)):0]  										h2d_mm_irq_en, 					// to Prefetcher Engine only
input  logic [((NUM_H2D_MM_CHANS_DERIVED==0) ? 0 : (NUM_H2D_MM_CHANS_DERIVED-1)):0]  										h2d_mm_q_pause_agent_control, 	// to Agent only
input  logic [((NUM_H2D_MM_CHANS_DERIVED==0) ? 0 : (NUM_H2D_MM_CHANS_DERIVED-1)):0]  										h2d_mm_q_sw_reset_req, 			// to Agent only

input  logic [((NUM_H2D_ST_CHANS_DERIVED==0) ? 0 : (NUM_H2D_ST_CHANS_DERIVED-1)):0]  										h2d_st_prefetch_irq_en,
input  logic [((NUM_H2D_ST_CHANS_DERIVED==0) ? 0 : (NUM_H2D_ST_CHANS_DERIVED-1)):0]  										h2d_st_q_en,
input  logic [((NUM_H2D_ST_CHANS_DERIVED==0) ? 0 : (NUM_H2D_ST_CHANS_DERIVED-1)):0]  										h2d_st_irq_en,
input  logic [((NUM_H2D_ST_CHANS_DERIVED==0) ? 0 : (NUM_H2D_ST_CHANS_DERIVED-1)):0]  										h2d_st_wb_en,
input  logic [((NUM_H2D_ST_CHANS_DERIVED==0) ? 0 : (NUM_H2D_ST_CHANS_DERIVED-1)):0]  										h2d_st_q_pause_agent_control,
input  logic [((NUM_H2D_ST_CHANS_DERIVED==0) ? 0 : (NUM_H2D_ST_CHANS_DERIVED-1)):0]  										h2d_st_q_sw_reset_req,

input  logic [((NUM_D2H_ST_CHANS_DERIVED==0) ? 0 : (NUM_D2H_ST_CHANS_DERIVED-1)):0]  										d2h_st_prefetch_irq_en,
input  logic [((NUM_D2H_ST_CHANS_DERIVED==0) ? 0 : (NUM_D2H_ST_CHANS_DERIVED-1)):0]  										d2h_st_q_en,
input  logic [((NUM_D2H_ST_CHANS_DERIVED==0) ? 0 : (NUM_D2H_ST_CHANS_DERIVED-1)):0]  										d2h_st_irq_en,
input  logic [((NUM_D2H_ST_CHANS_DERIVED==0) ? 0 : (NUM_D2H_ST_CHANS_DERIVED-1)):0]  										d2h_st_wb_en,
input  logic [((NUM_D2H_ST_CHANS_DERIVED==0) ? 0 : (NUM_D2H_ST_CHANS_DERIVED-1)):0]  										d2h_st_q_pause_agent_control,
input  logic [((NUM_D2H_ST_CHANS_DERIVED==0) ? 0 : (NUM_D2H_ST_CHANS_DERIVED-1)):0]  										d2h_st_q_sw_reset_req
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
);

logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0]  																h2d_mm_clk;
logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0]  																h2d_mm_resetn;	// Not used, just for platform designer compatibilty purpose

logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0]  																h2d_st_clk;
logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0]  																h2d_st_resetn;	// Not used, just for platform designer compatibilty purpose

logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0]  																d2h_st_clk;
logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1))	:0]  															d2h_st_resetn;	// Not used, just for platform designer compatibilty purpose

assign d2h_st_clk 		= '0;
assign d2h_st_resetn  	= '0;

assign h2d_st_clk 		= '0;
assign h2d_st_resetn  	= '0;

assign h2d_mm_clk 		= h2d0_mm_clk;
assign h2d_mm_resetn  	= h2d0_mm_resetn;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0][H2D_D2H_QCSR_ADDR_WIDTH-1:0]									h2d_mm_agent_csr_addr;
logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0][H2D_D2H_QCSR_ADDR_WIDTH-1:0]									h2d_st_agent_csr_addr;
logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0][H2D_D2H_QCSR_ADDR_WIDTH-1:0]									d2h_st_agent_csr_addr;

logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0][(10-H2D_D2H_QCSR_ADDR_WIDTH)-1:0]								h2d_mm_agent_csr_addr_reserved;
logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0][(10-H2D_D2H_QCSR_ADDR_WIDTH)-1:0]								h2d_st_agent_csr_addr_reserved;
logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0][(10-H2D_D2H_QCSR_ADDR_WIDTH)-1:0]								d2h_st_agent_csr_addr_reserved;

logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0][H2D_D2H_PORT_TYPE_WIDTH-1:0]									h2d_mm_agent_type;
logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0][H2D_D2H_PORT_TYPE_WIDTH-1:0]									h2d_st_agent_type;
logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0][H2D_D2H_PORT_TYPE_WIDTH-1:0]									d2h_st_agent_type;

logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0][H2D_D2H_PORT_ID_WIDTH-1:0]										h2d_mm_agent_port_id;
logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0][H2D_D2H_PORT_ID_WIDTH-1:0]										h2d_st_agent_port_id;
logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0][H2D_D2H_PORT_ID_WIDTH-1:0]										d2h_st_agent_port_id;

logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0][H2D_D2H_CHAN_ID_WIDTH-1:0]										h2d_mm_agent_chan_id;
logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0][H2D_D2H_CHAN_ID_WIDTH-1:0]										h2d_st_agent_chan_id;
logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0][H2D_D2H_CHAN_ID_WIDTH-1:0]										d2h_st_agent_chan_id;

logic [((NUM_H2D_MM_PORTS==0) ? 0 : (NUM_H2D_MM_PORTS-1)):0]																h2d_mm_agent_resp_table_id;
logic [((NUM_H2D_ST_PORTS==0) ? 0 : (NUM_H2D_ST_PORTS-1)):0]																h2d_st_agent_resp_table_id;
logic [((NUM_D2H_ST_PORTS==0) ? 0 : (NUM_D2H_ST_PORTS-1)):0]																d2h_st_agent_resp_table_id;
	
logic [2-1:0]																												h2d_d2h_csr_sel;

assign h2d_d2h_csr_sel		 					= 2'd2;

localparam NUM_RESET_OUTPUT_DUPLICATE									= NUM_H2D_D2H_PORTS; // one dedicated register bit for each device port

logic [1-1:0]     														host_reset_status_n_pipeline_out;
logic [NUM_RESET_OUTPUT_DUPLICATE-1:0]     								host_reset_status_n_pipeline_out_dup	/* synthesis preserve_syn_only dont_merge*/;

intel_ssgdma_hyperflex_reset_controller_simple #(
.DEVICE_FAMILY 															(DEVICE_FAMILY),
.RESET_INPUTS_SYNCHRONIZER_EN 											(0),
.RESET_OUTPUTS_REG_PIPELINE_EN 											(1),
.RESET_OUTPUTS_REG_DUP_DEPTH 											(3)
) host_reset_status_n_pipeline_inst (
.clk 																	(host_clk),
.reset_n_in 															(host_reset_status_n),
.reset_n_sync_out 														(host_reset_status_n_pipeline_out)  
);

always_ff @(posedge host_clk) begin
	host_reset_status_n_pipeline_out_dup								<= {(NUM_RESET_OUTPUT_DUPLICATE){host_reset_status_n_pipeline_out}};
end
	
	assign d2h_st_agent_type					= '0;
	assign d2h_st_agent_port_id 				= '0;
	assign d2h_st_agent_chan_id 				= '0;
	assign d2h_st_agent_resp_table_id			= '0;
	assign d2h_st_agent_csr_addr_reserved		= '0;
	assign d2h_st_csr_addr 						= '0;

	assign h2d_st_agent_type					= '0;
	assign h2d_st_agent_port_id 				= '0;
	assign h2d_st_agent_chan_id 				= '0;
	assign h2d_st_agent_resp_table_id			= '0;
	assign h2d_st_agent_csr_addr_reserved		= '0;
	assign h2d_st_csr_addr 						= '0;

for (genvar i = 0; i < NUM_H2D_MM_PORTS; i++) begin: H2D_MM_CSR_MAPPING_LOOP
	assign h2d_mm_agent_type[i] 				= 2'd2;
	assign h2d_mm_agent_port_id[i] 				= i;
	assign h2d_mm_agent_chan_id[i] 				= '0;
	assign h2d_mm_agent_resp_table_id[i]		= '0;
	assign h2d_mm_agent_csr_addr_reserved[i]	= {10-H2D_D2H_QCSR_ADDR_WIDTH{1'b0}};	
	assign h2d_mm_csr_addr[i] 					= {h2d_d2h_csr_sel,h2d_mm_agent_type[i],h2d_mm_agent_chan_id[i],h2d_mm_agent_port_id[i],h2d_mm_agent_resp_table_id[i],h2d_mm_agent_csr_addr_reserved[i],h2d_mm_agent_csr_addr[i]};
end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

`ifdef DEV_AGENT_DEBUG
	// if (`DEV_AGENT_DEBUG==1)
	logic [8:0] h2d_desc_tlast_count;			/* synthesis noprune*/ //
	logic [8:0] h2d_resp_tlast_count;			/* synthesis noprune*/ //

	logic [8:0] d2h_desc_tlast_count;			/* synthesis noprune*/ //
	logic [8:0] d2h_resp_tlast_count;			/* synthesis noprune*/ //
	
	always_ff @(posedge host_clk) begin
		if (~host_reset_status_n_pipeline_out_dup[0]) begin
			h2d_desc_tlast_count	<= '0;
			h2d_resp_tlast_count	<= '0;
			d2h_desc_tlast_count	<= '0;
			d2h_resp_tlast_count	<= '0;
		end else begin	
				if (h2d_st_desc_axi_st_source_tvalid & h2d_st_desc_axi_st_source_tready & h2d_st_desc_axi_st_source_tlast) begin
					h2d_desc_tlast_count  <= h2d_desc_tlast_count + 1'b1;
				end
				
				if (h2d_st_resp_axi_st_sink_tvalid & h2d_st_resp_axi_st_sink_tready & h2d_st_resp_axi_st_sink_tlast) begin
					h2d_resp_tlast_count  <= h2d_resp_tlast_count + 1'b1;
				end
				
				if (d2h_st_desc_axi_st_source_tvalid & d2h_st_desc_axi_st_source_tready & d2h_st_desc_axi_st_source_tlast) begin
					d2h_desc_tlast_count  <= d2h_desc_tlast_count + 1'b1;
				end
				
				if (d2h_st_resp_axi_st_sink_tvalid & d2h_st_resp_axi_st_sink_tready & d2h_st_resp_axi_st_sink_tlast) begin
					d2h_resp_tlast_count  <= d2h_resp_tlast_count + 1'b1;
				end			
			end
	end
`endif

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


assign d2h_st_agent_flush_int 			= '0;
// assign d2h0_st_tready 				= '0;

assign d2h_st_csr_wdata 				= '0;
assign d2h_st_csr_wrreq 				= '0;
assign d2h_st_csr_rdreq 				= '0;

assign d2h_st_agent_descriptor_taken	= '0;
assign d2h_st_agent_responder_added		= '0;

assign d2h_st_desc_axi_st_source_tready	= '0;

assign d2h_st_resp_axi_st_sink_tvalid	= '0;
assign d2h_st_resp_axi_st_sink_tdata	= '0;
assign d2h_st_resp_axi_st_sink_tlast	= '0;

assign arb_d2h_st_fifo_tvalid 			= '0;
assign arb_d2h_st_fifo_tdata 			= '0;
assign arb_d2h_st_fifo_tuser 			= '0;
assign arb_d2h_st_fifo_tlast 			= '0;
assign arb_d2h_st_fifo_tid 				= '0;
assign arb_d2h_st_fifo_tkeep 			= '0;

assign router_d2h_st_fifo_tready 		= '0;

assign d2h_st_q_descr_buffer_full 		= '0;
assign d2h_st_q_descr_buffer_empty 		= '0;
assign d2h_st_q_resp_buffer_full 		= '0;
assign d2h_st_q_resp_buffer_empty 		= '0;


assign h2d_st_csr_wdata 				= '0;
assign h2d_st_csr_wrreq 				= '0;
assign h2d_st_csr_rdreq 				= '0;

assign h2d_st_agent_descriptor_taken	= '0;
assign h2d_st_agent_responder_added		= '0;

assign h2d_st_desc_axi_st_source_tready	= '0;

assign h2d_st_resp_axi_st_sink_tvalid	= '0;
assign h2d_st_resp_axi_st_sink_tdata	= '0;
assign h2d_st_resp_axi_st_sink_tlast	= '0;

assign arb_h2d_st_fifo_tvalid 			= '0;
assign arb_h2d_st_fifo_tdata 			= '0;
assign arb_h2d_st_fifo_tuser 			= '0;
assign arb_h2d_st_fifo_tlast 			= '0;
assign arb_h2d_st_fifo_tid 				= '0;
assign arb_h2d_st_fifo_tkeep 			= '0;

assign router_h2d_st_fifo_tready 		= '0;

assign h2d_st_q_descr_buffer_full 		= '0;
assign h2d_st_q_descr_buffer_empty 		= '0;
assign h2d_st_q_resp_buffer_full 		= '0;
assign h2d_st_q_resp_buffer_empty 		= '0;


intel_ssgdma_host_agent_top # (
.P_FAMILY								(DEVICE_FAMILY),
.AGENT_TYPE								("MM"),
.NUM_CHAN_PER_PORT						(NUM_CHAN_PER_H2D_MM_PORT0),
.UNALIGNED_ACCESS_EN					(UNALIGNED_ACCESS_EN),

.AGENT_DESCRIPTOR_FIFO_DEPTH			(AGENT_DESCRIPTOR_FIFO_DEPTH),
.H2D_FIFO_DEPTH							(H2D_MM0_FIFO_DEPTH),
.D2H_FIFO_DEPTH							(H2D_MM0_FIFO_DEPTH),
.HOST_CSR_AWD							(H2D_D2H_QCSR_ADDR_WIDTH), // up to actual defined Device Port QCSR only, exclusive of Responder Table as that would be required by Prefetcher access only
.HOST_CSR_DWD							(HOST_CSR_DWD),

.H2D_MM_AWD								(H2D_MM0_AWD),
.H2D_MM_LWD								(H2D_MM0_LWD),
.H2D_MM_DWD								(H2D_MM0_DWD),
.H2D_MM_IDWD							(H2D_MM0_IDWD),
 
.DD_WD									(H2D_D2H_DD_WD),

.TX_ARB_DWD								(TX_ARB_DWD),
.TX_ARB_UWD								(TX_ARB_UWD),
.TX_ARB_IDWD							(TX_ARB_IDWD_INT),

.RX_ARB_DWD								(RX_ARB_DWD),
.RX_ARB_UWD								(RX_ARB_UWD),
.RX_ARB_IDWD							(RX_ARB_IDWD_INT)
) h2d_mm_agent0_inst (

.core_clk								(host_clk),
.port_clk								(h2d_mm_clk[0]),

.hrd_core_rstn							(host_reset_status_n_pipeline_out_dup[0]),

.agent_q_en								(h2d_mm_q_en[0]),
.agent_prefetch_irq_en					(h2d_mm_prefetch_irq_en[0]),
.agent_wb_en							(h2d_mm_wb_en[0]),
.agent_irq_en							(h2d_mm_irq_en[0]),
.agent_q_pause_agent_control			(h2d_mm_q_pause_agent_control[0]),
.agent_q_sw_reset_req					(h2d_mm_q_sw_reset_req[0]),

.d2h_byteack_valid						('0),
.d2h_byteack							('0),

.host_mps								(host_mps),
.host_mrrs								(host_mrrs),

.agent_csr_addr							(h2d_mm_agent_csr_addr[0]),
.agent_csr_wdata						(h2d_mm_csr_wdata[0]),
.agent_csr_rdata						(h2d_mm_csr_rdata[0]),
.agent_csr_wrreq						(h2d_mm_csr_wrreq[0]),
.agent_csr_rdreq						(h2d_mm_csr_rdreq[0]),
.agent_csr_rdvalid						(h2d_mm_csr_rdvalid[0]),
.agent_csr_req_ack						(h2d_mm_csr_req_ack[0]),

.agent_descriptor_taken					(h2d_mm_agent_descriptor_taken[0]),
.agent_response_added					(h2d_mm_agent_responder_added[0]),
.d2h_flush_ack							('0),

.q_descr_buffer_full					(h2d_mm_q_descr_buffer_full[0]),
.q_descr_buffer_empty					(h2d_mm_q_descr_buffer_empty[0]),
.q_resp_buffer_full						(h2d_mm_q_resp_buffer_full[0]),
.q_resp_buffer_empty					(h2d_mm_q_resp_buffer_empty[0]),

.h2d_mm_awvalid							(h2d0_awvalid), // 
.h2d_mm_awready							(h2d0_awready), // 
.h2d_mm_awaddr							(h2d0_awaddr), // 
.h2d_mm_awlen							(h2d0_awlen), // 
.h2d_mm_awburst							(h2d0_awburst), // 
.h2d_mm_awsize							(h2d0_awsize), // 
.h2d_mm_awprot							(h2d0_awprot), // 
.h2d_mm_awid							(h2d0_awid), // 
.h2d_mm_awcache							(h2d0_awcache), // 
  
.h2d_mm_wvalid							(h2d0_wvalid), // 
.h2d_mm_wlast							(h2d0_wlast), // 
.h2d_mm_wready							(h2d0_wready), // 
.h2d_mm_wdata							(h2d0_wdata), // 
.h2d_mm_wstrb							(h2d0_wstrb), // 
.h2d_mm_bvalid							(h2d0_bvalid), // 
.h2d_mm_bready							(h2d0_bready), // 
.h2d_mm_bresp							(h2d0_bresp), // 
.h2d_mm_bid								(h2d0_bid), // 
  
.h2d_mm_arvalid							(h2d0_arvalid), // 
.h2d_mm_arready							(h2d0_arready), // 
.h2d_mm_araddr							(h2d0_araddr), // 
.h2d_mm_arlen							(h2d0_arlen), // 
.h2d_mm_arburst							(h2d0_arburst), // 
.h2d_mm_arsize							(h2d0_arsize), // 
.h2d_mm_arprot							(h2d0_arprot), // 
.h2d_mm_arid							(h2d0_arid), // 
.h2d_mm_arcache							(h2d0_arcache), // 
  
.h2d_mm_rvalid							(h2d0_rvalid), // 
.h2d_mm_rlast							(h2d0_rlast), // 
.h2d_mm_rready							(h2d0_rready), // 
.h2d_mm_rdata							(h2d0_rdata), // 
.h2d_mm_rresp							(h2d0_rresp), // 
.h2d_mm_rid								(h2d0_rid), // 

.h2d_st_tready							('0), // 

.d2h_st_tvalid							('0), // 
.d2h_st_tdata							('0), // 
.d2h_st_tid								('0), // 
.d2h_st_tkeep							('0), // 
.d2h_st_tlast							('0), // 
.d2h_st_tuser							('0), // 

.ptp_st_tvalid							('0), // 
.ptp_st_tdata							('0), // 
.ptp_st_tid								('0), // 

.dd_st_sink_tvalid						(h2d_mm_desc_axi_st_source_tvalid[0]), // 
.dd_st_sink_tready						(h2d_mm_desc_axi_st_source_tready[0]), // 
.dd_st_sink_tdata						(h2d_mm_desc_axi_st_source_tdata[0]), // 
.dd_st_sink_tlast						(h2d_mm_desc_axi_st_source_tlast[0]), // 

.dr_st_source_tvalid					(h2d_mm_resp_axi_st_sink_tvalid[0]), // 
.dr_st_source_tready					(h2d_mm_resp_axi_st_sink_tready[0]), // 
.dr_st_source_tdata						(h2d_mm_resp_axi_st_sink_tdata[0]), // 
.dr_st_source_tlast						(h2d_mm_resp_axi_st_sink_tlast[0]), // 

.arb_st_source_tvalid					(arb_h2d_mm_fifo_tvalid[0]), // 
.arb_st_source_tready					(arb_h2d_mm_fifo_tready[0]), // 
.arb_st_source_tdata					(arb_h2d_mm_fifo_tdata[0]), // 
.arb_st_source_tuser					(arb_h2d_mm_fifo_tuser[0]), // 
.arb_st_source_tlast					(arb_h2d_mm_fifo_tlast[0]), // 
.arb_st_source_tid						(arb_h2d_mm_fifo_tid[0]), // 
.arb_st_source_tkeep					(arb_h2d_mm_fifo_tkeep[0]), // 

.arb_st_sink_tvalid						(router_h2d_mm_fifo_tvalid[0]), // 
.arb_st_sink_tready						(router_h2d_mm_fifo_tready[0]), // 
.arb_st_sink_tdata						(router_h2d_mm_fifo_tdata[0]), // 
.arb_st_sink_tuser						(router_h2d_mm_fifo_tuser[0]), // 
.arb_st_sink_tlast						(router_h2d_mm_fifo_tlast[0]), // 
.arb_st_sink_tid						(router_h2d_mm_fifo_tid[0]), // 
.arb_st_sink_tkeep						(router_h2d_mm_fifo_tkeep[0]) // 
);

endmodule

