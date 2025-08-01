module peripheral_subsys (
		input  wire [3:0]   button_pio_external_connection_export, // button_pio_external_connection.export
		output wire         button_pio_irq_irq,                    //                 button_pio_irq.irq
		input  wire [3:0]   dipsw_pio_external_connection_export,  //  dipsw_pio_external_connection.export
		output wire         dipsw_pio_irq_irq,                     //                  dipsw_pio_irq.irq
		input  wire [2:0]   led_pio_external_connection_in_port,   //    led_pio_external_connection.in_port
		output wire [2:0]   led_pio_external_connection_out_port,  //                               .out_port
		output wire         pb_cpu_0_s0_waitrequest,               //                    pb_cpu_0_s0.waitrequest
		output wire [31:0]  pb_cpu_0_s0_readdata,                  //                               .readdata
		output wire         pb_cpu_0_s0_readdatavalid,             //                               .readdatavalid
		input  wire [0:0]   pb_cpu_0_s0_burstcount,                //                               .burstcount
		input  wire [31:0]  pb_cpu_0_s0_writedata,                 //                               .writedata
		input  wire [22:0]  pb_cpu_0_s0_address,                   //                               .address
		input  wire         pb_cpu_0_s0_write,                     //                               .write
		input  wire         pb_cpu_0_s0_read,                      //                               .read
		input  wire [3:0]   pb_cpu_0_s0_byteenable,                //                               .byteenable
		input  wire         pb_cpu_0_s0_debugaccess,               //                               .debugaccess
		input  wire         clk_clk,                               //                            clk.clk
		input  wire         reset_reset_n,                         //                          reset.reset_n
		input  wire         ssgdma_host_clk_clk,                   //                ssgdma_host_clk.clk
		input  wire         ssgdma_host_aresetn_reset_n,           //            ssgdma_host_aresetn.reset_n
		input  wire         ssgdma_host_awready,                   //                    ssgdma_host.awready
		output wire         ssgdma_host_awvalid,                   //                               .awvalid
		output wire [63:0]  ssgdma_host_awaddr,                    //                               .awaddr
		output wire [7:0]   ssgdma_host_awlen,                     //                               .awlen
		output wire [1:0]   ssgdma_host_awburst,                   //                               .awburst
		output wire [2:0]   ssgdma_host_awsize,                    //                               .awsize
		output wire [2:0]   ssgdma_host_awprot,                    //                               .awprot
		output wire [4:0]   ssgdma_host_awid,                      //                               .awid
		output wire [3:0]   ssgdma_host_awcache,                   //                               .awcache
		input  wire         ssgdma_host_wready,                    //                               .wready
		output wire         ssgdma_host_wvalid,                    //                               .wvalid
		output wire [255:0] ssgdma_host_wdata,                     //                               .wdata
		output wire [31:0]  ssgdma_host_wstrb,                     //                               .wstrb
		output wire         ssgdma_host_wlast,                     //                               .wlast
		output wire         ssgdma_host_bready,                    //                               .bready
		input  wire         ssgdma_host_bvalid,                    //                               .bvalid
		input  wire [1:0]   ssgdma_host_bresp,                     //                               .bresp
		input  wire [4:0]   ssgdma_host_bid,                       //                               .bid
		input  wire         ssgdma_host_arready,                   //                               .arready
		output wire         ssgdma_host_arvalid,                   //                               .arvalid
		output wire [63:0]  ssgdma_host_araddr,                    //                               .araddr
		output wire [7:0]   ssgdma_host_arlen,                     //                               .arlen
		output wire [1:0]   ssgdma_host_arburst,                   //                               .arburst
		output wire [2:0]   ssgdma_host_arsize,                    //                               .arsize
		output wire [2:0]   ssgdma_host_arprot,                    //                               .arprot
		output wire [4:0]   ssgdma_host_arid,                      //                               .arid
		output wire [3:0]   ssgdma_host_arcache,                   //                               .arcache
		output wire         ssgdma_host_rready,                    //                               .rready
		input  wire         ssgdma_host_rvalid,                    //                               .rvalid
		input  wire [255:0] ssgdma_host_rdata,                     //                               .rdata
		input  wire         ssgdma_host_rlast,                     //                               .rlast
		input  wire [1:0]   ssgdma_host_rresp,                     //                               .rresp
		input  wire [4:0]   ssgdma_host_rid,                       //                               .rid
		output wire         ssgdma_interrupt_irq,                  //               ssgdma_interrupt.irq
		input  wire         ssgdma_h2d0_mm_clk_clk,                //             ssgdma_h2d0_mm_clk.clk
		input  wire         ssgdma_h2d0_mm_resetn_reset_n,         //          ssgdma_h2d0_mm_resetn.reset_n
		output wire         ssgdma_h2d0_awvalid,                   //                    ssgdma_h2d0.awvalid
		input  wire         ssgdma_h2d0_awready,                   //                               .awready
		output wire [63:0]  ssgdma_h2d0_awaddr,                    //                               .awaddr
		output wire [7:0]   ssgdma_h2d0_awlen,                     //                               .awlen
		output wire [1:0]   ssgdma_h2d0_awburst,                   //                               .awburst
		output wire [2:0]   ssgdma_h2d0_awsize,                    //                               .awsize
		output wire [2:0]   ssgdma_h2d0_awprot,                    //                               .awprot
		output wire [7:0]   ssgdma_h2d0_awid,                      //                               .awid
		output wire [3:0]   ssgdma_h2d0_awcache,                   //                               .awcache
		output wire         ssgdma_h2d0_wvalid,                    //                               .wvalid
		output wire         ssgdma_h2d0_wlast,                     //                               .wlast
		input  wire         ssgdma_h2d0_wready,                    //                               .wready
		output wire [63:0]  ssgdma_h2d0_wdata,                     //                               .wdata
		output wire [7:0]   ssgdma_h2d0_wstrb,                     //                               .wstrb
		input  wire         ssgdma_h2d0_bvalid,                    //                               .bvalid
		output wire         ssgdma_h2d0_bready,                    //                               .bready
		input  wire [1:0]   ssgdma_h2d0_bresp,                     //                               .bresp
		input  wire [7:0]   ssgdma_h2d0_bid,                       //                               .bid
		output wire         ssgdma_h2d0_arvalid,                   //                               .arvalid
		input  wire         ssgdma_h2d0_arready,                   //                               .arready
		output wire [63:0]  ssgdma_h2d0_araddr,                    //                               .araddr
		output wire [7:0]   ssgdma_h2d0_arlen,                     //                               .arlen
		output wire [1:0]   ssgdma_h2d0_arburst,                   //                               .arburst
		output wire [2:0]   ssgdma_h2d0_arsize,                    //                               .arsize
		output wire [2:0]   ssgdma_h2d0_arprot,                    //                               .arprot
		output wire [7:0]   ssgdma_h2d0_arid,                      //                               .arid
		output wire [3:0]   ssgdma_h2d0_arcache,                   //                               .arcache
		input  wire         ssgdma_h2d0_rvalid,                    //                               .rvalid
		input  wire         ssgdma_h2d0_rlast,                     //                               .rlast
		output wire         ssgdma_h2d0_rready,                    //                               .rready
		input  wire [63:0]  ssgdma_h2d0_rdata,                     //                               .rdata
		input  wire [1:0]   ssgdma_h2d0_rresp,                     //                               .rresp
		input  wire [7:0]   ssgdma_h2d0_rid                        //                               .rid
	);
endmodule

