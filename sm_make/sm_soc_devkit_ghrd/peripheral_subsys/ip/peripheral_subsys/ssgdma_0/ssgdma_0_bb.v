module ssgdma_0 (
		input  wire         axi_lite_clk,          //       axi_lite_clk.clk
		input  wire         axi_lite_areset_n,     //  axi_lite_areset_n.reset_n
		input  wire         host_clk,              //           host_clk.clk
		input  wire         host_aresetn,          //       host_aresetn.reset_n
		output wire         app_reset_status_n,    // app_reset_status_n.reset_n
		input  wire         host_awready,          //               host.awready
		output wire         host_awvalid,          //                   .awvalid
		output wire [63:0]  host_awaddr,           //                   .awaddr
		output wire [7:0]   host_awlen,            //                   .awlen
		output wire [1:0]   host_awburst,          //                   .awburst
		output wire [2:0]   host_awsize,           //                   .awsize
		output wire [2:0]   host_awprot,           //                   .awprot
		output wire [4:0]   host_awid,             //                   .awid
		output wire [3:0]   host_awcache,          //                   .awcache
		input  wire         host_wready,           //                   .wready
		output wire         host_wvalid,           //                   .wvalid
		output wire [255:0] host_wdata,            //                   .wdata
		output wire [31:0]  host_wstrb,            //                   .wstrb
		output wire         host_wlast,            //                   .wlast
		output wire         host_bready,           //                   .bready
		input  wire         host_bvalid,           //                   .bvalid
		input  wire [1:0]   host_bresp,            //                   .bresp
		input  wire [4:0]   host_bid,              //                   .bid
		input  wire         host_arready,          //                   .arready
		output wire         host_arvalid,          //                   .arvalid
		output wire [63:0]  host_araddr,           //                   .araddr
		output wire [7:0]   host_arlen,            //                   .arlen
		output wire [1:0]   host_arburst,          //                   .arburst
		output wire [2:0]   host_arsize,           //                   .arsize
		output wire [2:0]   host_arprot,           //                   .arprot
		output wire [4:0]   host_arid,             //                   .arid
		output wire [3:0]   host_arcache,          //                   .arcache
		output wire         host_rready,           //                   .rready
		input  wire         host_rvalid,           //                   .rvalid
		input  wire [255:0] host_rdata,            //                   .rdata
		input  wire         host_rlast,            //                   .rlast
		input  wire [1:0]   host_rresp,            //                   .rresp
		input  wire [4:0]   host_rid,              //                   .rid
		output wire         host_lite_csr_awready, //           host_csr.awready
		input  wire         host_lite_csr_awvalid, //                   .awvalid
		input  wire [21:0]  host_lite_csr_awaddr,  //                   .awaddr
		input  wire [2:0]   host_lite_csr_awprot,  //                   .awprot
		output wire         host_lite_csr_wready,  //                   .wready
		input  wire         host_lite_csr_wvalid,  //                   .wvalid
		input  wire [31:0]  host_lite_csr_wdata,   //                   .wdata
		input  wire [3:0]   host_lite_csr_wstrb,   //                   .wstrb
		input  wire         host_lite_csr_bready,  //                   .bready
		output wire         host_lite_csr_bvalid,  //                   .bvalid
		output wire [1:0]   host_lite_csr_bresp,   //                   .bresp
		output wire         host_lite_csr_arready, //                   .arready
		input  wire         host_lite_csr_arvalid, //                   .arvalid
		input  wire [21:0]  host_lite_csr_araddr,  //                   .araddr
		input  wire [2:0]   host_lite_csr_arprot,  //                   .arprot
		input  wire         host_lite_csr_rready,  //                   .rready
		output wire         host_lite_csr_rvalid,  //                   .rvalid
		output wire [31:0]  host_lite_csr_rdata,   //                   .rdata
		output wire [1:0]   host_lite_csr_rresp,   //                   .rresp
		output wire         irq,                   //          interrupt.irq
		input  wire         h2d0_mm_clk,           //        h2d0_mm_clk.clk
		input  wire         h2d0_mm_resetn,        //     h2d0_mm_resetn.reset_n
		output wire         h2d0_awvalid,          //               h2d0.awvalid
		input  wire         h2d0_awready,          //                   .awready
		output wire [63:0]  h2d0_awaddr,           //                   .awaddr
		output wire [7:0]   h2d0_awlen,            //                   .awlen
		output wire [1:0]   h2d0_awburst,          //                   .awburst
		output wire [2:0]   h2d0_awsize,           //                   .awsize
		output wire [2:0]   h2d0_awprot,           //                   .awprot
		output wire [7:0]   h2d0_awid,             //                   .awid
		output wire [3:0]   h2d0_awcache,          //                   .awcache
		output wire         h2d0_wvalid,           //                   .wvalid
		output wire         h2d0_wlast,            //                   .wlast
		input  wire         h2d0_wready,           //                   .wready
		output wire [63:0]  h2d0_wdata,            //                   .wdata
		output wire [7:0]   h2d0_wstrb,            //                   .wstrb
		input  wire         h2d0_bvalid,           //                   .bvalid
		output wire         h2d0_bready,           //                   .bready
		input  wire [1:0]   h2d0_bresp,            //                   .bresp
		input  wire [7:0]   h2d0_bid,              //                   .bid
		output wire         h2d0_arvalid,          //                   .arvalid
		input  wire         h2d0_arready,          //                   .arready
		output wire [63:0]  h2d0_araddr,           //                   .araddr
		output wire [7:0]   h2d0_arlen,            //                   .arlen
		output wire [1:0]   h2d0_arburst,          //                   .arburst
		output wire [2:0]   h2d0_arsize,           //                   .arsize
		output wire [2:0]   h2d0_arprot,           //                   .arprot
		output wire [7:0]   h2d0_arid,             //                   .arid
		output wire [3:0]   h2d0_arcache,          //                   .arcache
		input  wire         h2d0_rvalid,           //                   .rvalid
		input  wire         h2d0_rlast,            //                   .rlast
		output wire         h2d0_rready,           //                   .rready
		input  wire [63:0]  h2d0_rdata,            //                   .rdata
		input  wire [1:0]   h2d0_rresp,            //                   .rresp
		input  wire [7:0]   h2d0_rid               //                   .rid
	);
endmodule

