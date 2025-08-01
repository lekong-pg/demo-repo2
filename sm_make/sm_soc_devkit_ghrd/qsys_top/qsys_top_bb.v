module qsys_top (
		input  wire        clk_100_clk,                         //                 clk_100.clk
		input  wire        reset_reset_n,                       //                   reset.reset_n
		output wire        ninit_done_ninit_done,               //              ninit_done.ninit_done
		input  wire        hps_io_hps_osc_clk,                  //                  hps_io.hps_osc_clk
		inout  wire        hps_io_sdmmc_data0,                  //                        .sdmmc_data0
		inout  wire        hps_io_sdmmc_data1,                  //                        .sdmmc_data1
		output wire        hps_io_sdmmc_cclk,                   //                        .sdmmc_cclk
		input  wire        hps_io_sdmmc_wprot,                  //                        .sdmmc_wprot
		inout  wire        hps_io_sdmmc_data2,                  //                        .sdmmc_data2
		inout  wire        hps_io_sdmmc_data3,                  //                        .sdmmc_data3
		inout  wire        hps_io_sdmmc_cmd,                    //                        .sdmmc_cmd
		input  wire        hps_io_usb1_clk,                     //                        .usb1_clk
		output wire        hps_io_usb1_stp,                     //                        .usb1_stp
		input  wire        hps_io_usb1_dir,                     //                        .usb1_dir
		inout  wire        hps_io_usb1_data0,                   //                        .usb1_data0
		inout  wire        hps_io_usb1_data1,                   //                        .usb1_data1
		input  wire        hps_io_usb1_nxt,                     //                        .usb1_nxt
		inout  wire        hps_io_usb1_data2,                   //                        .usb1_data2
		inout  wire        hps_io_usb1_data3,                   //                        .usb1_data3
		inout  wire        hps_io_usb1_data4,                   //                        .usb1_data4
		inout  wire        hps_io_usb1_data5,                   //                        .usb1_data5
		inout  wire        hps_io_usb1_data6,                   //                        .usb1_data6
		inout  wire        hps_io_usb1_data7,                   //                        .usb1_data7
		output wire        hps_io_emac2_tx_clk,                 //                        .emac2_tx_clk
		output wire        hps_io_emac2_tx_ctl,                 //                        .emac2_tx_ctl
		input  wire        hps_io_emac2_rx_clk,                 //                        .emac2_rx_clk
		input  wire        hps_io_emac2_rx_ctl,                 //                        .emac2_rx_ctl
		output wire        hps_io_emac2_txd0,                   //                        .emac2_txd0
		output wire        hps_io_emac2_txd1,                   //                        .emac2_txd1
		input  wire        hps_io_emac2_rxd0,                   //                        .emac2_rxd0
		input  wire        hps_io_emac2_rxd1,                   //                        .emac2_rxd1
		output wire        hps_io_emac2_txd2,                   //                        .emac2_txd2
		output wire        hps_io_emac2_txd3,                   //                        .emac2_txd3
		input  wire        hps_io_emac2_rxd2,                   //                        .emac2_rxd2
		input  wire        hps_io_emac2_rxd3,                   //                        .emac2_rxd3
		output wire        hps_io_emac2_pps,                    //                        .emac2_pps
		input  wire        hps_io_emac2_pps_trig,               //                        .emac2_pps_trig
		inout  wire        hps_io_mdio2_mdio,                   //                        .mdio2_mdio
		output wire        hps_io_mdio2_mdc,                    //                        .mdio2_mdc
		output wire        hps_io_uart0_tx,                     //                        .uart0_tx
		input  wire        hps_io_uart0_rx,                     //                        .uart0_rx
		inout  wire        hps_io_i3c1_sda,                     //                        .i3c1_sda
		inout  wire        hps_io_i3c1_scl,                     //                        .i3c1_scl
		input  wire        hps_io_jtag_tck,                     //                        .jtag_tck
		input  wire        hps_io_jtag_tms,                     //                        .jtag_tms
		output wire        hps_io_jtag_tdo,                     //                        .jtag_tdo
		input  wire        hps_io_jtag_tdi,                     //                        .jtag_tdi
		inout  wire        hps_io_gpio0,                        //                        .gpio0
		inout  wire        hps_io_gpio1,                        //                        .gpio1
		inout  wire        hps_io_gpio11,                       //                        .gpio11
		inout  wire        hps_io_gpio27,                       //                        .gpio27
		input  wire        usb31_io_vbus_det,                   //                usb31_io.vbus_det
		input  wire        usb31_io_flt_bar,                    //                        .flt_bar
		output wire [1:0]  usb31_io_usb_ctrl,                   //                        .usb_ctrl
		input  wire        usb31_io_usb31_id,                   //                        .usb31_id
		input  wire        usb31_phy_pma_cpu_clk_clk,           //   usb31_phy_pma_cpu_clk.clk
		input  wire        usb31_phy_refclk_p_clk,              //      usb31_phy_refclk_p.clk
		input  wire        usb31_phy_refclk_n_clk,              //      usb31_phy_refclk_n.clk
		input  wire        usb31_phy_rx_serial_n_i_rx_serial_n, //   usb31_phy_rx_serial_n.i_rx_serial_n
		input  wire        usb31_phy_rx_serial_p_i_rx_serial_p, //   usb31_phy_rx_serial_p.i_rx_serial_p
		output wire        usb31_phy_tx_serial_n_o_tx_serial_n, //   usb31_phy_tx_serial_n.o_tx_serial_n
		output wire        usb31_phy_tx_serial_p_o_tx_serial_p, //   usb31_phy_tx_serial_p.o_tx_serial_p
		output wire        emif_hps_emif_mem_0_mem_ck_t,        //     emif_hps_emif_mem_0.mem_ck_t
		output wire        emif_hps_emif_mem_0_mem_ck_c,        //                        .mem_ck_c
		output wire        emif_hps_emif_mem_0_mem_cke,         //                        .mem_cke
		output wire        emif_hps_emif_mem_0_mem_odt,         //                        .mem_odt
		output wire        emif_hps_emif_mem_0_mem_cs_n,        //                        .mem_cs_n
		output wire [16:0] emif_hps_emif_mem_0_mem_a,           //                        .mem_a
		output wire [1:0]  emif_hps_emif_mem_0_mem_ba,          //                        .mem_ba
		output wire        emif_hps_emif_mem_0_mem_bg,          //                        .mem_bg
		output wire        emif_hps_emif_mem_0_mem_act_n,       //                        .mem_act_n
		output wire        emif_hps_emif_mem_0_mem_par,         //                        .mem_par
		input  wire        emif_hps_emif_mem_0_mem_alert_n,     //                        .mem_alert_n
		output wire        emif_hps_emif_mem_0_mem_reset_n,     //                        .mem_reset_n
		inout  wire [31:0] emif_hps_emif_mem_0_mem_dq,          //                        .mem_dq
		inout  wire [3:0]  emif_hps_emif_mem_0_mem_dqs_t,       //                        .mem_dqs_t
		inout  wire [3:0]  emif_hps_emif_mem_0_mem_dqs_c,       //                        .mem_dqs_c
		input  wire        emif_hps_emif_oct_0_oct_rzqin,       //     emif_hps_emif_oct_0.oct_rzqin
		input  wire        emif_hps_emif_ref_clk_0_clk,         // emif_hps_emif_ref_clk_0.clk
		output wire [0:0]  o_pma_cu_clk_clk                     //            o_pma_cu_clk.clk
	);
endmodule

