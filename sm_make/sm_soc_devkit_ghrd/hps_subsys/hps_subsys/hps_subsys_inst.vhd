	component hps_subsys is
		port (
			h2f_reset_reset_n                      : out   std_logic;                                         -- reset_n
			hps2fpga_clk_clk                       : in    std_logic                      := 'X';             -- clk
			hps2fpga_rst_reset_n                   : in    std_logic                      := 'X';             -- reset_n
			hps2fpga_awid                          : out   std_logic_vector(3 downto 0);                      -- awid
			hps2fpga_awaddr                        : out   std_logic_vector(37 downto 0);                     -- awaddr
			hps2fpga_awlen                         : out   std_logic_vector(7 downto 0);                      -- awlen
			hps2fpga_awsize                        : out   std_logic_vector(2 downto 0);                      -- awsize
			hps2fpga_awburst                       : out   std_logic_vector(1 downto 0);                      -- awburst
			hps2fpga_awlock                        : out   std_logic;                                         -- awlock
			hps2fpga_awcache                       : out   std_logic_vector(3 downto 0);                      -- awcache
			hps2fpga_awprot                        : out   std_logic_vector(2 downto 0);                      -- awprot
			hps2fpga_awvalid                       : out   std_logic;                                         -- awvalid
			hps2fpga_awready                       : in    std_logic                      := 'X';             -- awready
			hps2fpga_wdata                         : out   std_logic_vector(127 downto 0);                    -- wdata
			hps2fpga_wstrb                         : out   std_logic_vector(15 downto 0);                     -- wstrb
			hps2fpga_wlast                         : out   std_logic;                                         -- wlast
			hps2fpga_wvalid                        : out   std_logic;                                         -- wvalid
			hps2fpga_wready                        : in    std_logic                      := 'X';             -- wready
			hps2fpga_bid                           : in    std_logic_vector(3 downto 0)   := (others => 'X'); -- bid
			hps2fpga_bresp                         : in    std_logic_vector(1 downto 0)   := (others => 'X'); -- bresp
			hps2fpga_bvalid                        : in    std_logic                      := 'X';             -- bvalid
			hps2fpga_bready                        : out   std_logic;                                         -- bready
			hps2fpga_arid                          : out   std_logic_vector(3 downto 0);                      -- arid
			hps2fpga_araddr                        : out   std_logic_vector(37 downto 0);                     -- araddr
			hps2fpga_arlen                         : out   std_logic_vector(7 downto 0);                      -- arlen
			hps2fpga_arsize                        : out   std_logic_vector(2 downto 0);                      -- arsize
			hps2fpga_arburst                       : out   std_logic_vector(1 downto 0);                      -- arburst
			hps2fpga_arlock                        : out   std_logic;                                         -- arlock
			hps2fpga_arcache                       : out   std_logic_vector(3 downto 0);                      -- arcache
			hps2fpga_arprot                        : out   std_logic_vector(2 downto 0);                      -- arprot
			hps2fpga_arvalid                       : out   std_logic;                                         -- arvalid
			hps2fpga_arready                       : in    std_logic                      := 'X';             -- arready
			hps2fpga_rid                           : in    std_logic_vector(3 downto 0)   := (others => 'X'); -- rid
			hps2fpga_rdata                         : in    std_logic_vector(127 downto 0) := (others => 'X'); -- rdata
			hps2fpga_rresp                         : in    std_logic_vector(1 downto 0)   := (others => 'X'); -- rresp
			hps2fpga_rlast                         : in    std_logic                      := 'X';             -- rlast
			hps2fpga_rvalid                        : in    std_logic                      := 'X';             -- rvalid
			hps2fpga_rready                        : out   std_logic;                                         -- rready
			lwhps2fpga_clk_clk                     : in    std_logic                      := 'X';             -- clk
			lwhps2fpga_rst_reset_n                 : in    std_logic                      := 'X';             -- reset_n
			lwhps2fpga_awid                        : out   std_logic_vector(3 downto 0);                      -- awid
			lwhps2fpga_awaddr                      : out   std_logic_vector(28 downto 0);                     -- awaddr
			lwhps2fpga_awlen                       : out   std_logic_vector(7 downto 0);                      -- awlen
			lwhps2fpga_awsize                      : out   std_logic_vector(2 downto 0);                      -- awsize
			lwhps2fpga_awburst                     : out   std_logic_vector(1 downto 0);                      -- awburst
			lwhps2fpga_awlock                      : out   std_logic;                                         -- awlock
			lwhps2fpga_awcache                     : out   std_logic_vector(3 downto 0);                      -- awcache
			lwhps2fpga_awprot                      : out   std_logic_vector(2 downto 0);                      -- awprot
			lwhps2fpga_awvalid                     : out   std_logic;                                         -- awvalid
			lwhps2fpga_awready                     : in    std_logic                      := 'X';             -- awready
			lwhps2fpga_wdata                       : out   std_logic_vector(31 downto 0);                     -- wdata
			lwhps2fpga_wstrb                       : out   std_logic_vector(3 downto 0);                      -- wstrb
			lwhps2fpga_wlast                       : out   std_logic;                                         -- wlast
			lwhps2fpga_wvalid                      : out   std_logic;                                         -- wvalid
			lwhps2fpga_wready                      : in    std_logic                      := 'X';             -- wready
			lwhps2fpga_bid                         : in    std_logic_vector(3 downto 0)   := (others => 'X'); -- bid
			lwhps2fpga_bresp                       : in    std_logic_vector(1 downto 0)   := (others => 'X'); -- bresp
			lwhps2fpga_bvalid                      : in    std_logic                      := 'X';             -- bvalid
			lwhps2fpga_bready                      : out   std_logic;                                         -- bready
			lwhps2fpga_arid                        : out   std_logic_vector(3 downto 0);                      -- arid
			lwhps2fpga_araddr                      : out   std_logic_vector(28 downto 0);                     -- araddr
			lwhps2fpga_arlen                       : out   std_logic_vector(7 downto 0);                      -- arlen
			lwhps2fpga_arsize                      : out   std_logic_vector(2 downto 0);                      -- arsize
			lwhps2fpga_arburst                     : out   std_logic_vector(1 downto 0);                      -- arburst
			lwhps2fpga_arlock                      : out   std_logic;                                         -- arlock
			lwhps2fpga_arcache                     : out   std_logic_vector(3 downto 0);                      -- arcache
			lwhps2fpga_arprot                      : out   std_logic_vector(2 downto 0);                      -- arprot
			lwhps2fpga_arvalid                     : out   std_logic;                                         -- arvalid
			lwhps2fpga_arready                     : in    std_logic                      := 'X';             -- arready
			lwhps2fpga_rid                         : in    std_logic_vector(3 downto 0)   := (others => 'X'); -- rid
			lwhps2fpga_rdata                       : in    std_logic_vector(31 downto 0)  := (others => 'X'); -- rdata
			lwhps2fpga_rresp                       : in    std_logic_vector(1 downto 0)   := (others => 'X'); -- rresp
			lwhps2fpga_rlast                       : in    std_logic                      := 'X';             -- rlast
			lwhps2fpga_rvalid                      : in    std_logic                      := 'X';             -- rvalid
			lwhps2fpga_rready                      : out   std_logic;                                         -- rready
			hps_io_hps_osc_clk                     : in    std_logic                      := 'X';             -- hps_osc_clk
			hps_io_sdmmc_data0                     : inout std_logic                      := 'X';             -- sdmmc_data0
			hps_io_sdmmc_data1                     : inout std_logic                      := 'X';             -- sdmmc_data1
			hps_io_sdmmc_cclk                      : out   std_logic;                                         -- sdmmc_cclk
			hps_io_sdmmc_wprot                     : in    std_logic                      := 'X';             -- sdmmc_wprot
			hps_io_sdmmc_data2                     : inout std_logic                      := 'X';             -- sdmmc_data2
			hps_io_sdmmc_data3                     : inout std_logic                      := 'X';             -- sdmmc_data3
			hps_io_sdmmc_cmd                       : inout std_logic                      := 'X';             -- sdmmc_cmd
			hps_io_usb1_clk                        : in    std_logic                      := 'X';             -- usb1_clk
			hps_io_usb1_stp                        : out   std_logic;                                         -- usb1_stp
			hps_io_usb1_dir                        : in    std_logic                      := 'X';             -- usb1_dir
			hps_io_usb1_data0                      : inout std_logic                      := 'X';             -- usb1_data0
			hps_io_usb1_data1                      : inout std_logic                      := 'X';             -- usb1_data1
			hps_io_usb1_nxt                        : in    std_logic                      := 'X';             -- usb1_nxt
			hps_io_usb1_data2                      : inout std_logic                      := 'X';             -- usb1_data2
			hps_io_usb1_data3                      : inout std_logic                      := 'X';             -- usb1_data3
			hps_io_usb1_data4                      : inout std_logic                      := 'X';             -- usb1_data4
			hps_io_usb1_data5                      : inout std_logic                      := 'X';             -- usb1_data5
			hps_io_usb1_data6                      : inout std_logic                      := 'X';             -- usb1_data6
			hps_io_usb1_data7                      : inout std_logic                      := 'X';             -- usb1_data7
			hps_io_emac2_tx_clk                    : out   std_logic;                                         -- emac2_tx_clk
			hps_io_emac2_tx_ctl                    : out   std_logic;                                         -- emac2_tx_ctl
			hps_io_emac2_rx_clk                    : in    std_logic                      := 'X';             -- emac2_rx_clk
			hps_io_emac2_rx_ctl                    : in    std_logic                      := 'X';             -- emac2_rx_ctl
			hps_io_emac2_txd0                      : out   std_logic;                                         -- emac2_txd0
			hps_io_emac2_txd1                      : out   std_logic;                                         -- emac2_txd1
			hps_io_emac2_rxd0                      : in    std_logic                      := 'X';             -- emac2_rxd0
			hps_io_emac2_rxd1                      : in    std_logic                      := 'X';             -- emac2_rxd1
			hps_io_emac2_txd2                      : out   std_logic;                                         -- emac2_txd2
			hps_io_emac2_txd3                      : out   std_logic;                                         -- emac2_txd3
			hps_io_emac2_rxd2                      : in    std_logic                      := 'X';             -- emac2_rxd2
			hps_io_emac2_rxd3                      : in    std_logic                      := 'X';             -- emac2_rxd3
			hps_io_emac2_pps                       : out   std_logic;                                         -- emac2_pps
			hps_io_emac2_pps_trig                  : in    std_logic                      := 'X';             -- emac2_pps_trig
			hps_io_mdio2_mdio                      : inout std_logic                      := 'X';             -- mdio2_mdio
			hps_io_mdio2_mdc                       : out   std_logic;                                         -- mdio2_mdc
			hps_io_uart0_tx                        : out   std_logic;                                         -- uart0_tx
			hps_io_uart0_rx                        : in    std_logic                      := 'X';             -- uart0_rx
			hps_io_i3c1_sda                        : inout std_logic                      := 'X';             -- i3c1_sda
			hps_io_i3c1_scl                        : inout std_logic                      := 'X';             -- i3c1_scl
			hps_io_jtag_tck                        : in    std_logic                      := 'X';             -- jtag_tck
			hps_io_jtag_tms                        : in    std_logic                      := 'X';             -- jtag_tms
			hps_io_jtag_tdo                        : out   std_logic;                                         -- jtag_tdo
			hps_io_jtag_tdi                        : in    std_logic                      := 'X';             -- jtag_tdi
			hps_io_gpio0                           : inout std_logic                      := 'X';             -- gpio0
			hps_io_gpio1                           : inout std_logic                      := 'X';             -- gpio1
			hps_io_gpio11                          : inout std_logic                      := 'X';             -- gpio11
			hps_io_gpio27                          : inout std_logic                      := 'X';             -- gpio27
			usb31_io_vbus_det                      : in    std_logic                      := 'X';             -- vbus_det
			usb31_io_flt_bar                       : in    std_logic                      := 'X';             -- flt_bar
			usb31_io_usb_ctrl                      : out   std_logic_vector(1 downto 0);                      -- usb_ctrl
			usb31_io_usb31_id                      : in    std_logic                      := 'X';             -- usb31_id
			f2h_irq_in_irq                         : in    std_logic_vector(62 downto 0)  := (others => 'X'); -- irq
			usb31_phy_pma_cpu_clk_clk              : in    std_logic                      := 'X';             -- clk
			usb31_phy_refclk_p_clk                 : in    std_logic                      := 'X';             -- clk
			usb31_phy_refclk_n_clk                 : in    std_logic                      := 'X';             -- clk
			usb31_phy_rx_serial_n_i_rx_serial_n    : in    std_logic                      := 'X';             -- i_rx_serial_n
			usb31_phy_rx_serial_p_i_rx_serial_p    : in    std_logic                      := 'X';             -- i_rx_serial_p
			usb31_phy_tx_serial_n_o_tx_serial_n    : out   std_logic;                                         -- o_tx_serial_n
			usb31_phy_tx_serial_p_o_tx_serial_p    : out   std_logic;                                         -- o_tx_serial_p
			usb31_phy_reconfig_rst_reset           : in    std_logic                      := 'X';             -- reset
			usb31_phy_reconfig_clk_clk             : in    std_logic                      := 'X';             -- clk
			usb31_phy_reconfig_slave_address       : in    std_logic_vector(20 downto 0)  := (others => 'X'); -- address
			usb31_phy_reconfig_slave_byteenable    : in    std_logic_vector(3 downto 0)   := (others => 'X'); -- byteenable
			usb31_phy_reconfig_slave_readdatavalid : out   std_logic;                                         -- readdatavalid
			usb31_phy_reconfig_slave_read          : in    std_logic                      := 'X';             -- read
			usb31_phy_reconfig_slave_write         : in    std_logic                      := 'X';             -- write
			usb31_phy_reconfig_slave_readdata      : out   std_logic_vector(31 downto 0);                     -- readdata
			usb31_phy_reconfig_slave_writedata     : in    std_logic_vector(31 downto 0)  := (others => 'X'); -- writedata
			usb31_phy_reconfig_slave_waitrequest   : out   std_logic;                                         -- waitrequest
			f2sdram_clk_clk                        : in    std_logic                      := 'X';             -- clk
			f2sdram_rst_reset_n                    : in    std_logic                      := 'X';             -- reset_n
			f2sdram_araddr                         : in    std_logic_vector(31 downto 0)  := (others => 'X'); -- araddr
			f2sdram_arburst                        : in    std_logic_vector(1 downto 0)   := (others => 'X'); -- arburst
			f2sdram_arcache                        : in    std_logic_vector(3 downto 0)   := (others => 'X'); -- arcache
			f2sdram_arid                           : in    std_logic_vector(4 downto 0)   := (others => 'X'); -- arid
			f2sdram_arlen                          : in    std_logic_vector(7 downto 0)   := (others => 'X'); -- arlen
			f2sdram_arlock                         : in    std_logic                      := 'X';             -- arlock
			f2sdram_arprot                         : in    std_logic_vector(2 downto 0)   := (others => 'X'); -- arprot
			f2sdram_arqos                          : in    std_logic_vector(3 downto 0)   := (others => 'X'); -- arqos
			f2sdram_arready                        : out   std_logic;                                         -- arready
			f2sdram_arsize                         : in    std_logic_vector(2 downto 0)   := (others => 'X'); -- arsize
			f2sdram_arvalid                        : in    std_logic                      := 'X';             -- arvalid
			f2sdram_awaddr                         : in    std_logic_vector(31 downto 0)  := (others => 'X'); -- awaddr
			f2sdram_awburst                        : in    std_logic_vector(1 downto 0)   := (others => 'X'); -- awburst
			f2sdram_awcache                        : in    std_logic_vector(3 downto 0)   := (others => 'X'); -- awcache
			f2sdram_awid                           : in    std_logic_vector(4 downto 0)   := (others => 'X'); -- awid
			f2sdram_awlen                          : in    std_logic_vector(7 downto 0)   := (others => 'X'); -- awlen
			f2sdram_awlock                         : in    std_logic                      := 'X';             -- awlock
			f2sdram_awprot                         : in    std_logic_vector(2 downto 0)   := (others => 'X'); -- awprot
			f2sdram_awqos                          : in    std_logic_vector(3 downto 0)   := (others => 'X'); -- awqos
			f2sdram_awready                        : out   std_logic;                                         -- awready
			f2sdram_awsize                         : in    std_logic_vector(2 downto 0)   := (others => 'X'); -- awsize
			f2sdram_awvalid                        : in    std_logic                      := 'X';             -- awvalid
			f2sdram_bid                            : out   std_logic_vector(4 downto 0);                      -- bid
			f2sdram_bready                         : in    std_logic                      := 'X';             -- bready
			f2sdram_bresp                          : out   std_logic_vector(1 downto 0);                      -- bresp
			f2sdram_bvalid                         : out   std_logic;                                         -- bvalid
			f2sdram_rdata                          : out   std_logic_vector(255 downto 0);                    -- rdata
			f2sdram_rid                            : out   std_logic_vector(4 downto 0);                      -- rid
			f2sdram_rlast                          : out   std_logic;                                         -- rlast
			f2sdram_rready                         : in    std_logic                      := 'X';             -- rready
			f2sdram_rresp                          : out   std_logic_vector(1 downto 0);                      -- rresp
			f2sdram_rvalid                         : out   std_logic;                                         -- rvalid
			f2sdram_wdata                          : in    std_logic_vector(255 downto 0) := (others => 'X'); -- wdata
			f2sdram_wlast                          : in    std_logic                      := 'X';             -- wlast
			f2sdram_wready                         : out   std_logic;                                         -- wready
			f2sdram_wstrb                          : in    std_logic_vector(31 downto 0)  := (others => 'X'); -- wstrb
			f2sdram_wvalid                         : in    std_logic                      := 'X';             -- wvalid
			f2sdram_aruser                         : in    std_logic_vector(7 downto 0)   := (others => 'X'); -- aruser
			f2sdram_awuser                         : in    std_logic_vector(7 downto 0)   := (others => 'X'); -- awuser
			f2sdram_wuser                          : in    std_logic_vector(7 downto 0)   := (others => 'X'); -- wuser
			f2sdram_buser                          : out   std_logic_vector(7 downto 0);                      -- buser
			f2sdram_arregion                       : in    std_logic_vector(3 downto 0)   := (others => 'X'); -- arregion
			f2sdram_ruser                          : out   std_logic_vector(7 downto 0);                      -- ruser
			f2sdram_awregion                       : in    std_logic_vector(3 downto 0)   := (others => 'X'); -- awregion
			fpga2hps_clk_clk                       : in    std_logic                      := 'X';             -- clk
			fpga2hps_rst_reset_n                   : in    std_logic                      := 'X';             -- reset_n
			fpga2hps_awid                          : in    std_logic_vector(4 downto 0)   := (others => 'X'); -- awid
			fpga2hps_awaddr                        : in    std_logic_vector(31 downto 0)  := (others => 'X'); -- awaddr
			fpga2hps_awlen                         : in    std_logic_vector(7 downto 0)   := (others => 'X'); -- awlen
			fpga2hps_awsize                        : in    std_logic_vector(2 downto 0)   := (others => 'X'); -- awsize
			fpga2hps_arsize                        : in    std_logic_vector(2 downto 0)   := (others => 'X'); -- arsize
			fpga2hps_awburst                       : in    std_logic_vector(1 downto 0)   := (others => 'X'); -- awburst
			fpga2hps_awlock                        : in    std_logic                      := 'X';             -- awlock
			fpga2hps_awcache                       : in    std_logic_vector(3 downto 0)   := (others => 'X'); -- awcache
			fpga2hps_awprot                        : in    std_logic_vector(2 downto 0)   := (others => 'X'); -- awprot
			fpga2hps_awqos                         : in    std_logic_vector(3 downto 0)   := (others => 'X'); -- awqos
			fpga2hps_awvalid                       : in    std_logic                      := 'X';             -- awvalid
			fpga2hps_awready                       : out   std_logic;                                         -- awready
			fpga2hps_wdata                         : in    std_logic_vector(255 downto 0) := (others => 'X'); -- wdata
			fpga2hps_wstrb                         : in    std_logic_vector(31 downto 0)  := (others => 'X'); -- wstrb
			fpga2hps_wlast                         : in    std_logic                      := 'X';             -- wlast
			fpga2hps_wvalid                        : in    std_logic                      := 'X';             -- wvalid
			fpga2hps_wready                        : out   std_logic;                                         -- wready
			fpga2hps_bid                           : out   std_logic_vector(4 downto 0);                      -- bid
			fpga2hps_bresp                         : out   std_logic_vector(1 downto 0);                      -- bresp
			fpga2hps_bvalid                        : out   std_logic;                                         -- bvalid
			fpga2hps_bready                        : in    std_logic                      := 'X';             -- bready
			fpga2hps_arid                          : in    std_logic_vector(4 downto 0)   := (others => 'X'); -- arid
			fpga2hps_araddr                        : in    std_logic_vector(31 downto 0)  := (others => 'X'); -- araddr
			fpga2hps_arlen                         : in    std_logic_vector(7 downto 0)   := (others => 'X'); -- arlen
			fpga2hps_arburst                       : in    std_logic_vector(1 downto 0)   := (others => 'X'); -- arburst
			fpga2hps_arlock                        : in    std_logic                      := 'X';             -- arlock
			fpga2hps_arcache                       : in    std_logic_vector(3 downto 0)   := (others => 'X'); -- arcache
			fpga2hps_arprot                        : in    std_logic_vector(2 downto 0)   := (others => 'X'); -- arprot
			fpga2hps_arqos                         : in    std_logic_vector(3 downto 0)   := (others => 'X'); -- arqos
			fpga2hps_arvalid                       : in    std_logic                      := 'X';             -- arvalid
			fpga2hps_arready                       : out   std_logic;                                         -- arready
			fpga2hps_rid                           : out   std_logic_vector(4 downto 0);                      -- rid
			fpga2hps_rdata                         : out   std_logic_vector(255 downto 0);                    -- rdata
			fpga2hps_rresp                         : out   std_logic_vector(1 downto 0);                      -- rresp
			fpga2hps_rlast                         : out   std_logic;                                         -- rlast
			fpga2hps_rvalid                        : out   std_logic;                                         -- rvalid
			fpga2hps_rready                        : in    std_logic                      := 'X';             -- rready
			fpga2hps_aruser                        : in    std_logic_vector(7 downto 0)   := (others => 'X'); -- aruser
			fpga2hps_awuser                        : in    std_logic_vector(7 downto 0)   := (others => 'X'); -- awuser
			fpga2hps_arregion                      : in    std_logic_vector(3 downto 0)   := (others => 'X'); -- arregion
			fpga2hps_awregion                      : in    std_logic_vector(3 downto 0)   := (others => 'X'); -- awregion
			fpga2hps_wuser                         : in    std_logic_vector(7 downto 0)   := (others => 'X'); -- wuser
			fpga2hps_buser                         : out   std_logic_vector(7 downto 0);                      -- buser
			fpga2hps_ruser                         : out   std_logic_vector(7 downto 0);                      -- ruser
			emif_hps_emif_mem_0_mem_ck_t           : out   std_logic;                                         -- mem_ck_t
			emif_hps_emif_mem_0_mem_ck_c           : out   std_logic;                                         -- mem_ck_c
			emif_hps_emif_mem_0_mem_cke            : out   std_logic;                                         -- mem_cke
			emif_hps_emif_mem_0_mem_odt            : out   std_logic;                                         -- mem_odt
			emif_hps_emif_mem_0_mem_cs_n           : out   std_logic;                                         -- mem_cs_n
			emif_hps_emif_mem_0_mem_a              : out   std_logic_vector(16 downto 0);                     -- mem_a
			emif_hps_emif_mem_0_mem_ba             : out   std_logic_vector(1 downto 0);                      -- mem_ba
			emif_hps_emif_mem_0_mem_bg             : out   std_logic;                                         -- mem_bg
			emif_hps_emif_mem_0_mem_act_n          : out   std_logic;                                         -- mem_act_n
			emif_hps_emif_mem_0_mem_par            : out   std_logic;                                         -- mem_par
			emif_hps_emif_mem_0_mem_alert_n        : in    std_logic                      := 'X';             -- mem_alert_n
			emif_hps_emif_mem_0_mem_reset_n        : out   std_logic;                                         -- mem_reset_n
			emif_hps_emif_mem_0_mem_dq             : inout std_logic_vector(31 downto 0)  := (others => 'X'); -- mem_dq
			emif_hps_emif_mem_0_mem_dqs_t          : inout std_logic_vector(3 downto 0)   := (others => 'X'); -- mem_dqs_t
			emif_hps_emif_mem_0_mem_dqs_c          : inout std_logic_vector(3 downto 0)   := (others => 'X'); -- mem_dqs_c
			emif_hps_emif_oct_0_oct_rzqin          : in    std_logic                      := 'X';             -- oct_rzqin
			emif_hps_emif_ref_clk_0_clk            : in    std_logic                      := 'X';             -- clk
			o_pma_cu_clk_clk                       : out   std_logic_vector(0 downto 0)                       -- clk
		);
	end component hps_subsys;

	u0 : component hps_subsys
		port map (
			h2f_reset_reset_n                      => CONNECTED_TO_h2f_reset_reset_n,                      --                h2f_reset.reset_n
			hps2fpga_clk_clk                       => CONNECTED_TO_hps2fpga_clk_clk,                       --             hps2fpga_clk.clk
			hps2fpga_rst_reset_n                   => CONNECTED_TO_hps2fpga_rst_reset_n,                   --             hps2fpga_rst.reset_n
			hps2fpga_awid                          => CONNECTED_TO_hps2fpga_awid,                          --                 hps2fpga.awid
			hps2fpga_awaddr                        => CONNECTED_TO_hps2fpga_awaddr,                        --                         .awaddr
			hps2fpga_awlen                         => CONNECTED_TO_hps2fpga_awlen,                         --                         .awlen
			hps2fpga_awsize                        => CONNECTED_TO_hps2fpga_awsize,                        --                         .awsize
			hps2fpga_awburst                       => CONNECTED_TO_hps2fpga_awburst,                       --                         .awburst
			hps2fpga_awlock                        => CONNECTED_TO_hps2fpga_awlock,                        --                         .awlock
			hps2fpga_awcache                       => CONNECTED_TO_hps2fpga_awcache,                       --                         .awcache
			hps2fpga_awprot                        => CONNECTED_TO_hps2fpga_awprot,                        --                         .awprot
			hps2fpga_awvalid                       => CONNECTED_TO_hps2fpga_awvalid,                       --                         .awvalid
			hps2fpga_awready                       => CONNECTED_TO_hps2fpga_awready,                       --                         .awready
			hps2fpga_wdata                         => CONNECTED_TO_hps2fpga_wdata,                         --                         .wdata
			hps2fpga_wstrb                         => CONNECTED_TO_hps2fpga_wstrb,                         --                         .wstrb
			hps2fpga_wlast                         => CONNECTED_TO_hps2fpga_wlast,                         --                         .wlast
			hps2fpga_wvalid                        => CONNECTED_TO_hps2fpga_wvalid,                        --                         .wvalid
			hps2fpga_wready                        => CONNECTED_TO_hps2fpga_wready,                        --                         .wready
			hps2fpga_bid                           => CONNECTED_TO_hps2fpga_bid,                           --                         .bid
			hps2fpga_bresp                         => CONNECTED_TO_hps2fpga_bresp,                         --                         .bresp
			hps2fpga_bvalid                        => CONNECTED_TO_hps2fpga_bvalid,                        --                         .bvalid
			hps2fpga_bready                        => CONNECTED_TO_hps2fpga_bready,                        --                         .bready
			hps2fpga_arid                          => CONNECTED_TO_hps2fpga_arid,                          --                         .arid
			hps2fpga_araddr                        => CONNECTED_TO_hps2fpga_araddr,                        --                         .araddr
			hps2fpga_arlen                         => CONNECTED_TO_hps2fpga_arlen,                         --                         .arlen
			hps2fpga_arsize                        => CONNECTED_TO_hps2fpga_arsize,                        --                         .arsize
			hps2fpga_arburst                       => CONNECTED_TO_hps2fpga_arburst,                       --                         .arburst
			hps2fpga_arlock                        => CONNECTED_TO_hps2fpga_arlock,                        --                         .arlock
			hps2fpga_arcache                       => CONNECTED_TO_hps2fpga_arcache,                       --                         .arcache
			hps2fpga_arprot                        => CONNECTED_TO_hps2fpga_arprot,                        --                         .arprot
			hps2fpga_arvalid                       => CONNECTED_TO_hps2fpga_arvalid,                       --                         .arvalid
			hps2fpga_arready                       => CONNECTED_TO_hps2fpga_arready,                       --                         .arready
			hps2fpga_rid                           => CONNECTED_TO_hps2fpga_rid,                           --                         .rid
			hps2fpga_rdata                         => CONNECTED_TO_hps2fpga_rdata,                         --                         .rdata
			hps2fpga_rresp                         => CONNECTED_TO_hps2fpga_rresp,                         --                         .rresp
			hps2fpga_rlast                         => CONNECTED_TO_hps2fpga_rlast,                         --                         .rlast
			hps2fpga_rvalid                        => CONNECTED_TO_hps2fpga_rvalid,                        --                         .rvalid
			hps2fpga_rready                        => CONNECTED_TO_hps2fpga_rready,                        --                         .rready
			lwhps2fpga_clk_clk                     => CONNECTED_TO_lwhps2fpga_clk_clk,                     --           lwhps2fpga_clk.clk
			lwhps2fpga_rst_reset_n                 => CONNECTED_TO_lwhps2fpga_rst_reset_n,                 --           lwhps2fpga_rst.reset_n
			lwhps2fpga_awid                        => CONNECTED_TO_lwhps2fpga_awid,                        --               lwhps2fpga.awid
			lwhps2fpga_awaddr                      => CONNECTED_TO_lwhps2fpga_awaddr,                      --                         .awaddr
			lwhps2fpga_awlen                       => CONNECTED_TO_lwhps2fpga_awlen,                       --                         .awlen
			lwhps2fpga_awsize                      => CONNECTED_TO_lwhps2fpga_awsize,                      --                         .awsize
			lwhps2fpga_awburst                     => CONNECTED_TO_lwhps2fpga_awburst,                     --                         .awburst
			lwhps2fpga_awlock                      => CONNECTED_TO_lwhps2fpga_awlock,                      --                         .awlock
			lwhps2fpga_awcache                     => CONNECTED_TO_lwhps2fpga_awcache,                     --                         .awcache
			lwhps2fpga_awprot                      => CONNECTED_TO_lwhps2fpga_awprot,                      --                         .awprot
			lwhps2fpga_awvalid                     => CONNECTED_TO_lwhps2fpga_awvalid,                     --                         .awvalid
			lwhps2fpga_awready                     => CONNECTED_TO_lwhps2fpga_awready,                     --                         .awready
			lwhps2fpga_wdata                       => CONNECTED_TO_lwhps2fpga_wdata,                       --                         .wdata
			lwhps2fpga_wstrb                       => CONNECTED_TO_lwhps2fpga_wstrb,                       --                         .wstrb
			lwhps2fpga_wlast                       => CONNECTED_TO_lwhps2fpga_wlast,                       --                         .wlast
			lwhps2fpga_wvalid                      => CONNECTED_TO_lwhps2fpga_wvalid,                      --                         .wvalid
			lwhps2fpga_wready                      => CONNECTED_TO_lwhps2fpga_wready,                      --                         .wready
			lwhps2fpga_bid                         => CONNECTED_TO_lwhps2fpga_bid,                         --                         .bid
			lwhps2fpga_bresp                       => CONNECTED_TO_lwhps2fpga_bresp,                       --                         .bresp
			lwhps2fpga_bvalid                      => CONNECTED_TO_lwhps2fpga_bvalid,                      --                         .bvalid
			lwhps2fpga_bready                      => CONNECTED_TO_lwhps2fpga_bready,                      --                         .bready
			lwhps2fpga_arid                        => CONNECTED_TO_lwhps2fpga_arid,                        --                         .arid
			lwhps2fpga_araddr                      => CONNECTED_TO_lwhps2fpga_araddr,                      --                         .araddr
			lwhps2fpga_arlen                       => CONNECTED_TO_lwhps2fpga_arlen,                       --                         .arlen
			lwhps2fpga_arsize                      => CONNECTED_TO_lwhps2fpga_arsize,                      --                         .arsize
			lwhps2fpga_arburst                     => CONNECTED_TO_lwhps2fpga_arburst,                     --                         .arburst
			lwhps2fpga_arlock                      => CONNECTED_TO_lwhps2fpga_arlock,                      --                         .arlock
			lwhps2fpga_arcache                     => CONNECTED_TO_lwhps2fpga_arcache,                     --                         .arcache
			lwhps2fpga_arprot                      => CONNECTED_TO_lwhps2fpga_arprot,                      --                         .arprot
			lwhps2fpga_arvalid                     => CONNECTED_TO_lwhps2fpga_arvalid,                     --                         .arvalid
			lwhps2fpga_arready                     => CONNECTED_TO_lwhps2fpga_arready,                     --                         .arready
			lwhps2fpga_rid                         => CONNECTED_TO_lwhps2fpga_rid,                         --                         .rid
			lwhps2fpga_rdata                       => CONNECTED_TO_lwhps2fpga_rdata,                       --                         .rdata
			lwhps2fpga_rresp                       => CONNECTED_TO_lwhps2fpga_rresp,                       --                         .rresp
			lwhps2fpga_rlast                       => CONNECTED_TO_lwhps2fpga_rlast,                       --                         .rlast
			lwhps2fpga_rvalid                      => CONNECTED_TO_lwhps2fpga_rvalid,                      --                         .rvalid
			lwhps2fpga_rready                      => CONNECTED_TO_lwhps2fpga_rready,                      --                         .rready
			hps_io_hps_osc_clk                     => CONNECTED_TO_hps_io_hps_osc_clk,                     --                   hps_io.hps_osc_clk
			hps_io_sdmmc_data0                     => CONNECTED_TO_hps_io_sdmmc_data0,                     --                         .sdmmc_data0
			hps_io_sdmmc_data1                     => CONNECTED_TO_hps_io_sdmmc_data1,                     --                         .sdmmc_data1
			hps_io_sdmmc_cclk                      => CONNECTED_TO_hps_io_sdmmc_cclk,                      --                         .sdmmc_cclk
			hps_io_sdmmc_wprot                     => CONNECTED_TO_hps_io_sdmmc_wprot,                     --                         .sdmmc_wprot
			hps_io_sdmmc_data2                     => CONNECTED_TO_hps_io_sdmmc_data2,                     --                         .sdmmc_data2
			hps_io_sdmmc_data3                     => CONNECTED_TO_hps_io_sdmmc_data3,                     --                         .sdmmc_data3
			hps_io_sdmmc_cmd                       => CONNECTED_TO_hps_io_sdmmc_cmd,                       --                         .sdmmc_cmd
			hps_io_usb1_clk                        => CONNECTED_TO_hps_io_usb1_clk,                        --                         .usb1_clk
			hps_io_usb1_stp                        => CONNECTED_TO_hps_io_usb1_stp,                        --                         .usb1_stp
			hps_io_usb1_dir                        => CONNECTED_TO_hps_io_usb1_dir,                        --                         .usb1_dir
			hps_io_usb1_data0                      => CONNECTED_TO_hps_io_usb1_data0,                      --                         .usb1_data0
			hps_io_usb1_data1                      => CONNECTED_TO_hps_io_usb1_data1,                      --                         .usb1_data1
			hps_io_usb1_nxt                        => CONNECTED_TO_hps_io_usb1_nxt,                        --                         .usb1_nxt
			hps_io_usb1_data2                      => CONNECTED_TO_hps_io_usb1_data2,                      --                         .usb1_data2
			hps_io_usb1_data3                      => CONNECTED_TO_hps_io_usb1_data3,                      --                         .usb1_data3
			hps_io_usb1_data4                      => CONNECTED_TO_hps_io_usb1_data4,                      --                         .usb1_data4
			hps_io_usb1_data5                      => CONNECTED_TO_hps_io_usb1_data5,                      --                         .usb1_data5
			hps_io_usb1_data6                      => CONNECTED_TO_hps_io_usb1_data6,                      --                         .usb1_data6
			hps_io_usb1_data7                      => CONNECTED_TO_hps_io_usb1_data7,                      --                         .usb1_data7
			hps_io_emac2_tx_clk                    => CONNECTED_TO_hps_io_emac2_tx_clk,                    --                         .emac2_tx_clk
			hps_io_emac2_tx_ctl                    => CONNECTED_TO_hps_io_emac2_tx_ctl,                    --                         .emac2_tx_ctl
			hps_io_emac2_rx_clk                    => CONNECTED_TO_hps_io_emac2_rx_clk,                    --                         .emac2_rx_clk
			hps_io_emac2_rx_ctl                    => CONNECTED_TO_hps_io_emac2_rx_ctl,                    --                         .emac2_rx_ctl
			hps_io_emac2_txd0                      => CONNECTED_TO_hps_io_emac2_txd0,                      --                         .emac2_txd0
			hps_io_emac2_txd1                      => CONNECTED_TO_hps_io_emac2_txd1,                      --                         .emac2_txd1
			hps_io_emac2_rxd0                      => CONNECTED_TO_hps_io_emac2_rxd0,                      --                         .emac2_rxd0
			hps_io_emac2_rxd1                      => CONNECTED_TO_hps_io_emac2_rxd1,                      --                         .emac2_rxd1
			hps_io_emac2_txd2                      => CONNECTED_TO_hps_io_emac2_txd2,                      --                         .emac2_txd2
			hps_io_emac2_txd3                      => CONNECTED_TO_hps_io_emac2_txd3,                      --                         .emac2_txd3
			hps_io_emac2_rxd2                      => CONNECTED_TO_hps_io_emac2_rxd2,                      --                         .emac2_rxd2
			hps_io_emac2_rxd3                      => CONNECTED_TO_hps_io_emac2_rxd3,                      --                         .emac2_rxd3
			hps_io_emac2_pps                       => CONNECTED_TO_hps_io_emac2_pps,                       --                         .emac2_pps
			hps_io_emac2_pps_trig                  => CONNECTED_TO_hps_io_emac2_pps_trig,                  --                         .emac2_pps_trig
			hps_io_mdio2_mdio                      => CONNECTED_TO_hps_io_mdio2_mdio,                      --                         .mdio2_mdio
			hps_io_mdio2_mdc                       => CONNECTED_TO_hps_io_mdio2_mdc,                       --                         .mdio2_mdc
			hps_io_uart0_tx                        => CONNECTED_TO_hps_io_uart0_tx,                        --                         .uart0_tx
			hps_io_uart0_rx                        => CONNECTED_TO_hps_io_uart0_rx,                        --                         .uart0_rx
			hps_io_i3c1_sda                        => CONNECTED_TO_hps_io_i3c1_sda,                        --                         .i3c1_sda
			hps_io_i3c1_scl                        => CONNECTED_TO_hps_io_i3c1_scl,                        --                         .i3c1_scl
			hps_io_jtag_tck                        => CONNECTED_TO_hps_io_jtag_tck,                        --                         .jtag_tck
			hps_io_jtag_tms                        => CONNECTED_TO_hps_io_jtag_tms,                        --                         .jtag_tms
			hps_io_jtag_tdo                        => CONNECTED_TO_hps_io_jtag_tdo,                        --                         .jtag_tdo
			hps_io_jtag_tdi                        => CONNECTED_TO_hps_io_jtag_tdi,                        --                         .jtag_tdi
			hps_io_gpio0                           => CONNECTED_TO_hps_io_gpio0,                           --                         .gpio0
			hps_io_gpio1                           => CONNECTED_TO_hps_io_gpio1,                           --                         .gpio1
			hps_io_gpio11                          => CONNECTED_TO_hps_io_gpio11,                          --                         .gpio11
			hps_io_gpio27                          => CONNECTED_TO_hps_io_gpio27,                          --                         .gpio27
			usb31_io_vbus_det                      => CONNECTED_TO_usb31_io_vbus_det,                      --                 usb31_io.vbus_det
			usb31_io_flt_bar                       => CONNECTED_TO_usb31_io_flt_bar,                       --                         .flt_bar
			usb31_io_usb_ctrl                      => CONNECTED_TO_usb31_io_usb_ctrl,                      --                         .usb_ctrl
			usb31_io_usb31_id                      => CONNECTED_TO_usb31_io_usb31_id,                      --                         .usb31_id
			f2h_irq_in_irq                         => CONNECTED_TO_f2h_irq_in_irq,                         --               f2h_irq_in.irq
			usb31_phy_pma_cpu_clk_clk              => CONNECTED_TO_usb31_phy_pma_cpu_clk_clk,              --    usb31_phy_pma_cpu_clk.clk
			usb31_phy_refclk_p_clk                 => CONNECTED_TO_usb31_phy_refclk_p_clk,                 --       usb31_phy_refclk_p.clk
			usb31_phy_refclk_n_clk                 => CONNECTED_TO_usb31_phy_refclk_n_clk,                 --       usb31_phy_refclk_n.clk
			usb31_phy_rx_serial_n_i_rx_serial_n    => CONNECTED_TO_usb31_phy_rx_serial_n_i_rx_serial_n,    --    usb31_phy_rx_serial_n.i_rx_serial_n
			usb31_phy_rx_serial_p_i_rx_serial_p    => CONNECTED_TO_usb31_phy_rx_serial_p_i_rx_serial_p,    --    usb31_phy_rx_serial_p.i_rx_serial_p
			usb31_phy_tx_serial_n_o_tx_serial_n    => CONNECTED_TO_usb31_phy_tx_serial_n_o_tx_serial_n,    --    usb31_phy_tx_serial_n.o_tx_serial_n
			usb31_phy_tx_serial_p_o_tx_serial_p    => CONNECTED_TO_usb31_phy_tx_serial_p_o_tx_serial_p,    --    usb31_phy_tx_serial_p.o_tx_serial_p
			usb31_phy_reconfig_rst_reset           => CONNECTED_TO_usb31_phy_reconfig_rst_reset,           --   usb31_phy_reconfig_rst.reset
			usb31_phy_reconfig_clk_clk             => CONNECTED_TO_usb31_phy_reconfig_clk_clk,             --   usb31_phy_reconfig_clk.clk
			usb31_phy_reconfig_slave_address       => CONNECTED_TO_usb31_phy_reconfig_slave_address,       -- usb31_phy_reconfig_slave.address
			usb31_phy_reconfig_slave_byteenable    => CONNECTED_TO_usb31_phy_reconfig_slave_byteenable,    --                         .byteenable
			usb31_phy_reconfig_slave_readdatavalid => CONNECTED_TO_usb31_phy_reconfig_slave_readdatavalid, --                         .readdatavalid
			usb31_phy_reconfig_slave_read          => CONNECTED_TO_usb31_phy_reconfig_slave_read,          --                         .read
			usb31_phy_reconfig_slave_write         => CONNECTED_TO_usb31_phy_reconfig_slave_write,         --                         .write
			usb31_phy_reconfig_slave_readdata      => CONNECTED_TO_usb31_phy_reconfig_slave_readdata,      --                         .readdata
			usb31_phy_reconfig_slave_writedata     => CONNECTED_TO_usb31_phy_reconfig_slave_writedata,     --                         .writedata
			usb31_phy_reconfig_slave_waitrequest   => CONNECTED_TO_usb31_phy_reconfig_slave_waitrequest,   --                         .waitrequest
			f2sdram_clk_clk                        => CONNECTED_TO_f2sdram_clk_clk,                        --              f2sdram_clk.clk
			f2sdram_rst_reset_n                    => CONNECTED_TO_f2sdram_rst_reset_n,                    --              f2sdram_rst.reset_n
			f2sdram_araddr                         => CONNECTED_TO_f2sdram_araddr,                         --                  f2sdram.araddr
			f2sdram_arburst                        => CONNECTED_TO_f2sdram_arburst,                        --                         .arburst
			f2sdram_arcache                        => CONNECTED_TO_f2sdram_arcache,                        --                         .arcache
			f2sdram_arid                           => CONNECTED_TO_f2sdram_arid,                           --                         .arid
			f2sdram_arlen                          => CONNECTED_TO_f2sdram_arlen,                          --                         .arlen
			f2sdram_arlock                         => CONNECTED_TO_f2sdram_arlock,                         --                         .arlock
			f2sdram_arprot                         => CONNECTED_TO_f2sdram_arprot,                         --                         .arprot
			f2sdram_arqos                          => CONNECTED_TO_f2sdram_arqos,                          --                         .arqos
			f2sdram_arready                        => CONNECTED_TO_f2sdram_arready,                        --                         .arready
			f2sdram_arsize                         => CONNECTED_TO_f2sdram_arsize,                         --                         .arsize
			f2sdram_arvalid                        => CONNECTED_TO_f2sdram_arvalid,                        --                         .arvalid
			f2sdram_awaddr                         => CONNECTED_TO_f2sdram_awaddr,                         --                         .awaddr
			f2sdram_awburst                        => CONNECTED_TO_f2sdram_awburst,                        --                         .awburst
			f2sdram_awcache                        => CONNECTED_TO_f2sdram_awcache,                        --                         .awcache
			f2sdram_awid                           => CONNECTED_TO_f2sdram_awid,                           --                         .awid
			f2sdram_awlen                          => CONNECTED_TO_f2sdram_awlen,                          --                         .awlen
			f2sdram_awlock                         => CONNECTED_TO_f2sdram_awlock,                         --                         .awlock
			f2sdram_awprot                         => CONNECTED_TO_f2sdram_awprot,                         --                         .awprot
			f2sdram_awqos                          => CONNECTED_TO_f2sdram_awqos,                          --                         .awqos
			f2sdram_awready                        => CONNECTED_TO_f2sdram_awready,                        --                         .awready
			f2sdram_awsize                         => CONNECTED_TO_f2sdram_awsize,                         --                         .awsize
			f2sdram_awvalid                        => CONNECTED_TO_f2sdram_awvalid,                        --                         .awvalid
			f2sdram_bid                            => CONNECTED_TO_f2sdram_bid,                            --                         .bid
			f2sdram_bready                         => CONNECTED_TO_f2sdram_bready,                         --                         .bready
			f2sdram_bresp                          => CONNECTED_TO_f2sdram_bresp,                          --                         .bresp
			f2sdram_bvalid                         => CONNECTED_TO_f2sdram_bvalid,                         --                         .bvalid
			f2sdram_rdata                          => CONNECTED_TO_f2sdram_rdata,                          --                         .rdata
			f2sdram_rid                            => CONNECTED_TO_f2sdram_rid,                            --                         .rid
			f2sdram_rlast                          => CONNECTED_TO_f2sdram_rlast,                          --                         .rlast
			f2sdram_rready                         => CONNECTED_TO_f2sdram_rready,                         --                         .rready
			f2sdram_rresp                          => CONNECTED_TO_f2sdram_rresp,                          --                         .rresp
			f2sdram_rvalid                         => CONNECTED_TO_f2sdram_rvalid,                         --                         .rvalid
			f2sdram_wdata                          => CONNECTED_TO_f2sdram_wdata,                          --                         .wdata
			f2sdram_wlast                          => CONNECTED_TO_f2sdram_wlast,                          --                         .wlast
			f2sdram_wready                         => CONNECTED_TO_f2sdram_wready,                         --                         .wready
			f2sdram_wstrb                          => CONNECTED_TO_f2sdram_wstrb,                          --                         .wstrb
			f2sdram_wvalid                         => CONNECTED_TO_f2sdram_wvalid,                         --                         .wvalid
			f2sdram_aruser                         => CONNECTED_TO_f2sdram_aruser,                         --                         .aruser
			f2sdram_awuser                         => CONNECTED_TO_f2sdram_awuser,                         --                         .awuser
			f2sdram_wuser                          => CONNECTED_TO_f2sdram_wuser,                          --                         .wuser
			f2sdram_buser                          => CONNECTED_TO_f2sdram_buser,                          --                         .buser
			f2sdram_arregion                       => CONNECTED_TO_f2sdram_arregion,                       --                         .arregion
			f2sdram_ruser                          => CONNECTED_TO_f2sdram_ruser,                          --                         .ruser
			f2sdram_awregion                       => CONNECTED_TO_f2sdram_awregion,                       --                         .awregion
			fpga2hps_clk_clk                       => CONNECTED_TO_fpga2hps_clk_clk,                       --             fpga2hps_clk.clk
			fpga2hps_rst_reset_n                   => CONNECTED_TO_fpga2hps_rst_reset_n,                   --             fpga2hps_rst.reset_n
			fpga2hps_awid                          => CONNECTED_TO_fpga2hps_awid,                          --                 fpga2hps.awid
			fpga2hps_awaddr                        => CONNECTED_TO_fpga2hps_awaddr,                        --                         .awaddr
			fpga2hps_awlen                         => CONNECTED_TO_fpga2hps_awlen,                         --                         .awlen
			fpga2hps_awsize                        => CONNECTED_TO_fpga2hps_awsize,                        --                         .awsize
			fpga2hps_arsize                        => CONNECTED_TO_fpga2hps_arsize,                        --                         .arsize
			fpga2hps_awburst                       => CONNECTED_TO_fpga2hps_awburst,                       --                         .awburst
			fpga2hps_awlock                        => CONNECTED_TO_fpga2hps_awlock,                        --                         .awlock
			fpga2hps_awcache                       => CONNECTED_TO_fpga2hps_awcache,                       --                         .awcache
			fpga2hps_awprot                        => CONNECTED_TO_fpga2hps_awprot,                        --                         .awprot
			fpga2hps_awqos                         => CONNECTED_TO_fpga2hps_awqos,                         --                         .awqos
			fpga2hps_awvalid                       => CONNECTED_TO_fpga2hps_awvalid,                       --                         .awvalid
			fpga2hps_awready                       => CONNECTED_TO_fpga2hps_awready,                       --                         .awready
			fpga2hps_wdata                         => CONNECTED_TO_fpga2hps_wdata,                         --                         .wdata
			fpga2hps_wstrb                         => CONNECTED_TO_fpga2hps_wstrb,                         --                         .wstrb
			fpga2hps_wlast                         => CONNECTED_TO_fpga2hps_wlast,                         --                         .wlast
			fpga2hps_wvalid                        => CONNECTED_TO_fpga2hps_wvalid,                        --                         .wvalid
			fpga2hps_wready                        => CONNECTED_TO_fpga2hps_wready,                        --                         .wready
			fpga2hps_bid                           => CONNECTED_TO_fpga2hps_bid,                           --                         .bid
			fpga2hps_bresp                         => CONNECTED_TO_fpga2hps_bresp,                         --                         .bresp
			fpga2hps_bvalid                        => CONNECTED_TO_fpga2hps_bvalid,                        --                         .bvalid
			fpga2hps_bready                        => CONNECTED_TO_fpga2hps_bready,                        --                         .bready
			fpga2hps_arid                          => CONNECTED_TO_fpga2hps_arid,                          --                         .arid
			fpga2hps_araddr                        => CONNECTED_TO_fpga2hps_araddr,                        --                         .araddr
			fpga2hps_arlen                         => CONNECTED_TO_fpga2hps_arlen,                         --                         .arlen
			fpga2hps_arburst                       => CONNECTED_TO_fpga2hps_arburst,                       --                         .arburst
			fpga2hps_arlock                        => CONNECTED_TO_fpga2hps_arlock,                        --                         .arlock
			fpga2hps_arcache                       => CONNECTED_TO_fpga2hps_arcache,                       --                         .arcache
			fpga2hps_arprot                        => CONNECTED_TO_fpga2hps_arprot,                        --                         .arprot
			fpga2hps_arqos                         => CONNECTED_TO_fpga2hps_arqos,                         --                         .arqos
			fpga2hps_arvalid                       => CONNECTED_TO_fpga2hps_arvalid,                       --                         .arvalid
			fpga2hps_arready                       => CONNECTED_TO_fpga2hps_arready,                       --                         .arready
			fpga2hps_rid                           => CONNECTED_TO_fpga2hps_rid,                           --                         .rid
			fpga2hps_rdata                         => CONNECTED_TO_fpga2hps_rdata,                         --                         .rdata
			fpga2hps_rresp                         => CONNECTED_TO_fpga2hps_rresp,                         --                         .rresp
			fpga2hps_rlast                         => CONNECTED_TO_fpga2hps_rlast,                         --                         .rlast
			fpga2hps_rvalid                        => CONNECTED_TO_fpga2hps_rvalid,                        --                         .rvalid
			fpga2hps_rready                        => CONNECTED_TO_fpga2hps_rready,                        --                         .rready
			fpga2hps_aruser                        => CONNECTED_TO_fpga2hps_aruser,                        --                         .aruser
			fpga2hps_awuser                        => CONNECTED_TO_fpga2hps_awuser,                        --                         .awuser
			fpga2hps_arregion                      => CONNECTED_TO_fpga2hps_arregion,                      --                         .arregion
			fpga2hps_awregion                      => CONNECTED_TO_fpga2hps_awregion,                      --                         .awregion
			fpga2hps_wuser                         => CONNECTED_TO_fpga2hps_wuser,                         --                         .wuser
			fpga2hps_buser                         => CONNECTED_TO_fpga2hps_buser,                         --                         .buser
			fpga2hps_ruser                         => CONNECTED_TO_fpga2hps_ruser,                         --                         .ruser
			emif_hps_emif_mem_0_mem_ck_t           => CONNECTED_TO_emif_hps_emif_mem_0_mem_ck_t,           --      emif_hps_emif_mem_0.mem_ck_t
			emif_hps_emif_mem_0_mem_ck_c           => CONNECTED_TO_emif_hps_emif_mem_0_mem_ck_c,           --                         .mem_ck_c
			emif_hps_emif_mem_0_mem_cke            => CONNECTED_TO_emif_hps_emif_mem_0_mem_cke,            --                         .mem_cke
			emif_hps_emif_mem_0_mem_odt            => CONNECTED_TO_emif_hps_emif_mem_0_mem_odt,            --                         .mem_odt
			emif_hps_emif_mem_0_mem_cs_n           => CONNECTED_TO_emif_hps_emif_mem_0_mem_cs_n,           --                         .mem_cs_n
			emif_hps_emif_mem_0_mem_a              => CONNECTED_TO_emif_hps_emif_mem_0_mem_a,              --                         .mem_a
			emif_hps_emif_mem_0_mem_ba             => CONNECTED_TO_emif_hps_emif_mem_0_mem_ba,             --                         .mem_ba
			emif_hps_emif_mem_0_mem_bg             => CONNECTED_TO_emif_hps_emif_mem_0_mem_bg,             --                         .mem_bg
			emif_hps_emif_mem_0_mem_act_n          => CONNECTED_TO_emif_hps_emif_mem_0_mem_act_n,          --                         .mem_act_n
			emif_hps_emif_mem_0_mem_par            => CONNECTED_TO_emif_hps_emif_mem_0_mem_par,            --                         .mem_par
			emif_hps_emif_mem_0_mem_alert_n        => CONNECTED_TO_emif_hps_emif_mem_0_mem_alert_n,        --                         .mem_alert_n
			emif_hps_emif_mem_0_mem_reset_n        => CONNECTED_TO_emif_hps_emif_mem_0_mem_reset_n,        --                         .mem_reset_n
			emif_hps_emif_mem_0_mem_dq             => CONNECTED_TO_emif_hps_emif_mem_0_mem_dq,             --                         .mem_dq
			emif_hps_emif_mem_0_mem_dqs_t          => CONNECTED_TO_emif_hps_emif_mem_0_mem_dqs_t,          --                         .mem_dqs_t
			emif_hps_emif_mem_0_mem_dqs_c          => CONNECTED_TO_emif_hps_emif_mem_0_mem_dqs_c,          --                         .mem_dqs_c
			emif_hps_emif_oct_0_oct_rzqin          => CONNECTED_TO_emif_hps_emif_oct_0_oct_rzqin,          --      emif_hps_emif_oct_0.oct_rzqin
			emif_hps_emif_ref_clk_0_clk            => CONNECTED_TO_emif_hps_emif_ref_clk_0_clk,            --  emif_hps_emif_ref_clk_0.clk
			o_pma_cu_clk_clk                       => CONNECTED_TO_o_pma_cu_clk_clk                        --             o_pma_cu_clk.clk
		);

