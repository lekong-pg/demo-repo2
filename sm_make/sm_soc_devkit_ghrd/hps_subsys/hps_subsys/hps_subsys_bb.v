module hps_subsys (
		output wire         h2f_reset_reset_n,                      //                h2f_reset.reset_n
		input  wire         hps2fpga_clk_clk,                       //             hps2fpga_clk.clk
		input  wire         hps2fpga_rst_reset_n,                   //             hps2fpga_rst.reset_n
		output wire [3:0]   hps2fpga_awid,                          //                 hps2fpga.awid
		output wire [37:0]  hps2fpga_awaddr,                        //                         .awaddr
		output wire [7:0]   hps2fpga_awlen,                         //                         .awlen
		output wire [2:0]   hps2fpga_awsize,                        //                         .awsize
		output wire [1:0]   hps2fpga_awburst,                       //                         .awburst
		output wire         hps2fpga_awlock,                        //                         .awlock
		output wire [3:0]   hps2fpga_awcache,                       //                         .awcache
		output wire [2:0]   hps2fpga_awprot,                        //                         .awprot
		output wire         hps2fpga_awvalid,                       //                         .awvalid
		input  wire         hps2fpga_awready,                       //                         .awready
		output wire [127:0] hps2fpga_wdata,                         //                         .wdata
		output wire [15:0]  hps2fpga_wstrb,                         //                         .wstrb
		output wire         hps2fpga_wlast,                         //                         .wlast
		output wire         hps2fpga_wvalid,                        //                         .wvalid
		input  wire         hps2fpga_wready,                        //                         .wready
		input  wire [3:0]   hps2fpga_bid,                           //                         .bid
		input  wire [1:0]   hps2fpga_bresp,                         //                         .bresp
		input  wire         hps2fpga_bvalid,                        //                         .bvalid
		output wire         hps2fpga_bready,                        //                         .bready
		output wire [3:0]   hps2fpga_arid,                          //                         .arid
		output wire [37:0]  hps2fpga_araddr,                        //                         .araddr
		output wire [7:0]   hps2fpga_arlen,                         //                         .arlen
		output wire [2:0]   hps2fpga_arsize,                        //                         .arsize
		output wire [1:0]   hps2fpga_arburst,                       //                         .arburst
		output wire         hps2fpga_arlock,                        //                         .arlock
		output wire [3:0]   hps2fpga_arcache,                       //                         .arcache
		output wire [2:0]   hps2fpga_arprot,                        //                         .arprot
		output wire         hps2fpga_arvalid,                       //                         .arvalid
		input  wire         hps2fpga_arready,                       //                         .arready
		input  wire [3:0]   hps2fpga_rid,                           //                         .rid
		input  wire [127:0] hps2fpga_rdata,                         //                         .rdata
		input  wire [1:0]   hps2fpga_rresp,                         //                         .rresp
		input  wire         hps2fpga_rlast,                         //                         .rlast
		input  wire         hps2fpga_rvalid,                        //                         .rvalid
		output wire         hps2fpga_rready,                        //                         .rready
		input  wire         lwhps2fpga_clk_clk,                     //           lwhps2fpga_clk.clk
		input  wire         lwhps2fpga_rst_reset_n,                 //           lwhps2fpga_rst.reset_n
		output wire [3:0]   lwhps2fpga_awid,                        //               lwhps2fpga.awid
		output wire [28:0]  lwhps2fpga_awaddr,                      //                         .awaddr
		output wire [7:0]   lwhps2fpga_awlen,                       //                         .awlen
		output wire [2:0]   lwhps2fpga_awsize,                      //                         .awsize
		output wire [1:0]   lwhps2fpga_awburst,                     //                         .awburst
		output wire         lwhps2fpga_awlock,                      //                         .awlock
		output wire [3:0]   lwhps2fpga_awcache,                     //                         .awcache
		output wire [2:0]   lwhps2fpga_awprot,                      //                         .awprot
		output wire         lwhps2fpga_awvalid,                     //                         .awvalid
		input  wire         lwhps2fpga_awready,                     //                         .awready
		output wire [31:0]  lwhps2fpga_wdata,                       //                         .wdata
		output wire [3:0]   lwhps2fpga_wstrb,                       //                         .wstrb
		output wire         lwhps2fpga_wlast,                       //                         .wlast
		output wire         lwhps2fpga_wvalid,                      //                         .wvalid
		input  wire         lwhps2fpga_wready,                      //                         .wready
		input  wire [3:0]   lwhps2fpga_bid,                         //                         .bid
		input  wire [1:0]   lwhps2fpga_bresp,                       //                         .bresp
		input  wire         lwhps2fpga_bvalid,                      //                         .bvalid
		output wire         lwhps2fpga_bready,                      //                         .bready
		output wire [3:0]   lwhps2fpga_arid,                        //                         .arid
		output wire [28:0]  lwhps2fpga_araddr,                      //                         .araddr
		output wire [7:0]   lwhps2fpga_arlen,                       //                         .arlen
		output wire [2:0]   lwhps2fpga_arsize,                      //                         .arsize
		output wire [1:0]   lwhps2fpga_arburst,                     //                         .arburst
		output wire         lwhps2fpga_arlock,                      //                         .arlock
		output wire [3:0]   lwhps2fpga_arcache,                     //                         .arcache
		output wire [2:0]   lwhps2fpga_arprot,                      //                         .arprot
		output wire         lwhps2fpga_arvalid,                     //                         .arvalid
		input  wire         lwhps2fpga_arready,                     //                         .arready
		input  wire [3:0]   lwhps2fpga_rid,                         //                         .rid
		input  wire [31:0]  lwhps2fpga_rdata,                       //                         .rdata
		input  wire [1:0]   lwhps2fpga_rresp,                       //                         .rresp
		input  wire         lwhps2fpga_rlast,                       //                         .rlast
		input  wire         lwhps2fpga_rvalid,                      //                         .rvalid
		output wire         lwhps2fpga_rready,                      //                         .rready
		input  wire         hps_io_hps_osc_clk,                     //                   hps_io.hps_osc_clk
		inout  wire         hps_io_sdmmc_data0,                     //                         .sdmmc_data0
		inout  wire         hps_io_sdmmc_data1,                     //                         .sdmmc_data1
		output wire         hps_io_sdmmc_cclk,                      //                         .sdmmc_cclk
		input  wire         hps_io_sdmmc_wprot,                     //                         .sdmmc_wprot
		inout  wire         hps_io_sdmmc_data2,                     //                         .sdmmc_data2
		inout  wire         hps_io_sdmmc_data3,                     //                         .sdmmc_data3
		inout  wire         hps_io_sdmmc_cmd,                       //                         .sdmmc_cmd
		input  wire         hps_io_usb1_clk,                        //                         .usb1_clk
		output wire         hps_io_usb1_stp,                        //                         .usb1_stp
		input  wire         hps_io_usb1_dir,                        //                         .usb1_dir
		inout  wire         hps_io_usb1_data0,                      //                         .usb1_data0
		inout  wire         hps_io_usb1_data1,                      //                         .usb1_data1
		input  wire         hps_io_usb1_nxt,                        //                         .usb1_nxt
		inout  wire         hps_io_usb1_data2,                      //                         .usb1_data2
		inout  wire         hps_io_usb1_data3,                      //                         .usb1_data3
		inout  wire         hps_io_usb1_data4,                      //                         .usb1_data4
		inout  wire         hps_io_usb1_data5,                      //                         .usb1_data5
		inout  wire         hps_io_usb1_data6,                      //                         .usb1_data6
		inout  wire         hps_io_usb1_data7,                      //                         .usb1_data7
		output wire         hps_io_emac2_tx_clk,                    //                         .emac2_tx_clk
		output wire         hps_io_emac2_tx_ctl,                    //                         .emac2_tx_ctl
		input  wire         hps_io_emac2_rx_clk,                    //                         .emac2_rx_clk
		input  wire         hps_io_emac2_rx_ctl,                    //                         .emac2_rx_ctl
		output wire         hps_io_emac2_txd0,                      //                         .emac2_txd0
		output wire         hps_io_emac2_txd1,                      //                         .emac2_txd1
		input  wire         hps_io_emac2_rxd0,                      //                         .emac2_rxd0
		input  wire         hps_io_emac2_rxd1,                      //                         .emac2_rxd1
		output wire         hps_io_emac2_txd2,                      //                         .emac2_txd2
		output wire         hps_io_emac2_txd3,                      //                         .emac2_txd3
		input  wire         hps_io_emac2_rxd2,                      //                         .emac2_rxd2
		input  wire         hps_io_emac2_rxd3,                      //                         .emac2_rxd3
		output wire         hps_io_emac2_pps,                       //                         .emac2_pps
		input  wire         hps_io_emac2_pps_trig,                  //                         .emac2_pps_trig
		inout  wire         hps_io_mdio2_mdio,                      //                         .mdio2_mdio
		output wire         hps_io_mdio2_mdc,                       //                         .mdio2_mdc
		output wire         hps_io_uart0_tx,                        //                         .uart0_tx
		input  wire         hps_io_uart0_rx,                        //                         .uart0_rx
		inout  wire         hps_io_i3c1_sda,                        //                         .i3c1_sda
		inout  wire         hps_io_i3c1_scl,                        //                         .i3c1_scl
		input  wire         hps_io_jtag_tck,                        //                         .jtag_tck
		input  wire         hps_io_jtag_tms,                        //                         .jtag_tms
		output wire         hps_io_jtag_tdo,                        //                         .jtag_tdo
		input  wire         hps_io_jtag_tdi,                        //                         .jtag_tdi
		inout  wire         hps_io_gpio0,                           //                         .gpio0
		inout  wire         hps_io_gpio1,                           //                         .gpio1
		inout  wire         hps_io_gpio11,                          //                         .gpio11
		inout  wire         hps_io_gpio27,                          //                         .gpio27
		input  wire         usb31_io_vbus_det,                      //                 usb31_io.vbus_det
		input  wire         usb31_io_flt_bar,                       //                         .flt_bar
		output wire [1:0]   usb31_io_usb_ctrl,                      //                         .usb_ctrl
		input  wire         usb31_io_usb31_id,                      //                         .usb31_id
		input  wire [62:0]  f2h_irq_in_irq,                         //               f2h_irq_in.irq
		input  wire         usb31_phy_pma_cpu_clk_clk,              //    usb31_phy_pma_cpu_clk.clk
		input  wire         usb31_phy_refclk_p_clk,                 //       usb31_phy_refclk_p.clk
		input  wire         usb31_phy_refclk_n_clk,                 //       usb31_phy_refclk_n.clk
		input  wire         usb31_phy_rx_serial_n_i_rx_serial_n,    //    usb31_phy_rx_serial_n.i_rx_serial_n
		input  wire         usb31_phy_rx_serial_p_i_rx_serial_p,    //    usb31_phy_rx_serial_p.i_rx_serial_p
		output wire         usb31_phy_tx_serial_n_o_tx_serial_n,    //    usb31_phy_tx_serial_n.o_tx_serial_n
		output wire         usb31_phy_tx_serial_p_o_tx_serial_p,    //    usb31_phy_tx_serial_p.o_tx_serial_p
		input  wire         usb31_phy_reconfig_rst_reset,           //   usb31_phy_reconfig_rst.reset
		input  wire         usb31_phy_reconfig_clk_clk,             //   usb31_phy_reconfig_clk.clk
		input  wire [20:0]  usb31_phy_reconfig_slave_address,       // usb31_phy_reconfig_slave.address
		input  wire [3:0]   usb31_phy_reconfig_slave_byteenable,    //                         .byteenable
		output wire         usb31_phy_reconfig_slave_readdatavalid, //                         .readdatavalid
		input  wire         usb31_phy_reconfig_slave_read,          //                         .read
		input  wire         usb31_phy_reconfig_slave_write,         //                         .write
		output wire [31:0]  usb31_phy_reconfig_slave_readdata,      //                         .readdata
		input  wire [31:0]  usb31_phy_reconfig_slave_writedata,     //                         .writedata
		output wire         usb31_phy_reconfig_slave_waitrequest,   //                         .waitrequest
		input  wire         f2sdram_clk_clk,                        //              f2sdram_clk.clk
		input  wire         f2sdram_rst_reset_n,                    //              f2sdram_rst.reset_n
		input  wire [31:0]  f2sdram_araddr,                         //                  f2sdram.araddr
		input  wire [1:0]   f2sdram_arburst,                        //                         .arburst
		input  wire [3:0]   f2sdram_arcache,                        //                         .arcache
		input  wire [4:0]   f2sdram_arid,                           //                         .arid
		input  wire [7:0]   f2sdram_arlen,                          //                         .arlen
		input  wire         f2sdram_arlock,                         //                         .arlock
		input  wire [2:0]   f2sdram_arprot,                         //                         .arprot
		input  wire [3:0]   f2sdram_arqos,                          //                         .arqos
		output wire         f2sdram_arready,                        //                         .arready
		input  wire [2:0]   f2sdram_arsize,                         //                         .arsize
		input  wire         f2sdram_arvalid,                        //                         .arvalid
		input  wire [31:0]  f2sdram_awaddr,                         //                         .awaddr
		input  wire [1:0]   f2sdram_awburst,                        //                         .awburst
		input  wire [3:0]   f2sdram_awcache,                        //                         .awcache
		input  wire [4:0]   f2sdram_awid,                           //                         .awid
		input  wire [7:0]   f2sdram_awlen,                          //                         .awlen
		input  wire         f2sdram_awlock,                         //                         .awlock
		input  wire [2:0]   f2sdram_awprot,                         //                         .awprot
		input  wire [3:0]   f2sdram_awqos,                          //                         .awqos
		output wire         f2sdram_awready,                        //                         .awready
		input  wire [2:0]   f2sdram_awsize,                         //                         .awsize
		input  wire         f2sdram_awvalid,                        //                         .awvalid
		output wire [4:0]   f2sdram_bid,                            //                         .bid
		input  wire         f2sdram_bready,                         //                         .bready
		output wire [1:0]   f2sdram_bresp,                          //                         .bresp
		output wire         f2sdram_bvalid,                         //                         .bvalid
		output wire [255:0] f2sdram_rdata,                          //                         .rdata
		output wire [4:0]   f2sdram_rid,                            //                         .rid
		output wire         f2sdram_rlast,                          //                         .rlast
		input  wire         f2sdram_rready,                         //                         .rready
		output wire [1:0]   f2sdram_rresp,                          //                         .rresp
		output wire         f2sdram_rvalid,                         //                         .rvalid
		input  wire [255:0] f2sdram_wdata,                          //                         .wdata
		input  wire         f2sdram_wlast,                          //                         .wlast
		output wire         f2sdram_wready,                         //                         .wready
		input  wire [31:0]  f2sdram_wstrb,                          //                         .wstrb
		input  wire         f2sdram_wvalid,                         //                         .wvalid
		input  wire [7:0]   f2sdram_aruser,                         //                         .aruser
		input  wire [7:0]   f2sdram_awuser,                         //                         .awuser
		input  wire [7:0]   f2sdram_wuser,                          //                         .wuser
		output wire [7:0]   f2sdram_buser,                          //                         .buser
		input  wire [3:0]   f2sdram_arregion,                       //                         .arregion
		output wire [7:0]   f2sdram_ruser,                          //                         .ruser
		input  wire [3:0]   f2sdram_awregion,                       //                         .awregion
		input  wire         fpga2hps_clk_clk,                       //             fpga2hps_clk.clk
		input  wire         fpga2hps_rst_reset_n,                   //             fpga2hps_rst.reset_n
		input  wire [4:0]   fpga2hps_awid,                          //                 fpga2hps.awid
		input  wire [31:0]  fpga2hps_awaddr,                        //                         .awaddr
		input  wire [7:0]   fpga2hps_awlen,                         //                         .awlen
		input  wire [2:0]   fpga2hps_awsize,                        //                         .awsize
		input  wire [2:0]   fpga2hps_arsize,                        //                         .arsize
		input  wire [1:0]   fpga2hps_awburst,                       //                         .awburst
		input  wire         fpga2hps_awlock,                        //                         .awlock
		input  wire [3:0]   fpga2hps_awcache,                       //                         .awcache
		input  wire [2:0]   fpga2hps_awprot,                        //                         .awprot
		input  wire [3:0]   fpga2hps_awqos,                         //                         .awqos
		input  wire         fpga2hps_awvalid,                       //                         .awvalid
		output wire         fpga2hps_awready,                       //                         .awready
		input  wire [255:0] fpga2hps_wdata,                         //                         .wdata
		input  wire [31:0]  fpga2hps_wstrb,                         //                         .wstrb
		input  wire         fpga2hps_wlast,                         //                         .wlast
		input  wire         fpga2hps_wvalid,                        //                         .wvalid
		output wire         fpga2hps_wready,                        //                         .wready
		output wire [4:0]   fpga2hps_bid,                           //                         .bid
		output wire [1:0]   fpga2hps_bresp,                         //                         .bresp
		output wire         fpga2hps_bvalid,                        //                         .bvalid
		input  wire         fpga2hps_bready,                        //                         .bready
		input  wire [4:0]   fpga2hps_arid,                          //                         .arid
		input  wire [31:0]  fpga2hps_araddr,                        //                         .araddr
		input  wire [7:0]   fpga2hps_arlen,                         //                         .arlen
		input  wire [1:0]   fpga2hps_arburst,                       //                         .arburst
		input  wire         fpga2hps_arlock,                        //                         .arlock
		input  wire [3:0]   fpga2hps_arcache,                       //                         .arcache
		input  wire [2:0]   fpga2hps_arprot,                        //                         .arprot
		input  wire [3:0]   fpga2hps_arqos,                         //                         .arqos
		input  wire         fpga2hps_arvalid,                       //                         .arvalid
		output wire         fpga2hps_arready,                       //                         .arready
		output wire [4:0]   fpga2hps_rid,                           //                         .rid
		output wire [255:0] fpga2hps_rdata,                         //                         .rdata
		output wire [1:0]   fpga2hps_rresp,                         //                         .rresp
		output wire         fpga2hps_rlast,                         //                         .rlast
		output wire         fpga2hps_rvalid,                        //                         .rvalid
		input  wire         fpga2hps_rready,                        //                         .rready
		input  wire [7:0]   fpga2hps_aruser,                        //                         .aruser
		input  wire [7:0]   fpga2hps_awuser,                        //                         .awuser
		input  wire [3:0]   fpga2hps_arregion,                      //                         .arregion
		input  wire [3:0]   fpga2hps_awregion,                      //                         .awregion
		input  wire [7:0]   fpga2hps_wuser,                         //                         .wuser
		output wire [7:0]   fpga2hps_buser,                         //                         .buser
		output wire [7:0]   fpga2hps_ruser,                         //                         .ruser
		output wire         emif_hps_emif_mem_0_mem_ck_t,           //      emif_hps_emif_mem_0.mem_ck_t
		output wire         emif_hps_emif_mem_0_mem_ck_c,           //                         .mem_ck_c
		output wire         emif_hps_emif_mem_0_mem_cke,            //                         .mem_cke
		output wire         emif_hps_emif_mem_0_mem_odt,            //                         .mem_odt
		output wire         emif_hps_emif_mem_0_mem_cs_n,           //                         .mem_cs_n
		output wire [16:0]  emif_hps_emif_mem_0_mem_a,              //                         .mem_a
		output wire [1:0]   emif_hps_emif_mem_0_mem_ba,             //                         .mem_ba
		output wire         emif_hps_emif_mem_0_mem_bg,             //                         .mem_bg
		output wire         emif_hps_emif_mem_0_mem_act_n,          //                         .mem_act_n
		output wire         emif_hps_emif_mem_0_mem_par,            //                         .mem_par
		input  wire         emif_hps_emif_mem_0_mem_alert_n,        //                         .mem_alert_n
		output wire         emif_hps_emif_mem_0_mem_reset_n,        //                         .mem_reset_n
		inout  wire [31:0]  emif_hps_emif_mem_0_mem_dq,             //                         .mem_dq
		inout  wire [3:0]   emif_hps_emif_mem_0_mem_dqs_t,          //                         .mem_dqs_t
		inout  wire [3:0]   emif_hps_emif_mem_0_mem_dqs_c,          //                         .mem_dqs_c
		input  wire         emif_hps_emif_oct_0_oct_rzqin,          //      emif_hps_emif_oct_0.oct_rzqin
		input  wire         emif_hps_emif_ref_clk_0_clk,            //  emif_hps_emif_ref_clk_0.clk
		output wire [0:0]   o_pma_cu_clk_clk                        //             o_pma_cu_clk.clk
	);
endmodule

