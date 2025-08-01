	component qsys_top is
		port (
			clk_100_clk                         : in    std_logic                     := 'X';             -- clk
			reset_reset_n                       : in    std_logic                     := 'X';             -- reset_n
			ninit_done_ninit_done               : out   std_logic;                                        -- ninit_done
			hps_io_hps_osc_clk                  : in    std_logic                     := 'X';             -- hps_osc_clk
			hps_io_sdmmc_data0                  : inout std_logic                     := 'X';             -- sdmmc_data0
			hps_io_sdmmc_data1                  : inout std_logic                     := 'X';             -- sdmmc_data1
			hps_io_sdmmc_cclk                   : out   std_logic;                                        -- sdmmc_cclk
			hps_io_sdmmc_wprot                  : in    std_logic                     := 'X';             -- sdmmc_wprot
			hps_io_sdmmc_data2                  : inout std_logic                     := 'X';             -- sdmmc_data2
			hps_io_sdmmc_data3                  : inout std_logic                     := 'X';             -- sdmmc_data3
			hps_io_sdmmc_cmd                    : inout std_logic                     := 'X';             -- sdmmc_cmd
			hps_io_usb1_clk                     : in    std_logic                     := 'X';             -- usb1_clk
			hps_io_usb1_stp                     : out   std_logic;                                        -- usb1_stp
			hps_io_usb1_dir                     : in    std_logic                     := 'X';             -- usb1_dir
			hps_io_usb1_data0                   : inout std_logic                     := 'X';             -- usb1_data0
			hps_io_usb1_data1                   : inout std_logic                     := 'X';             -- usb1_data1
			hps_io_usb1_nxt                     : in    std_logic                     := 'X';             -- usb1_nxt
			hps_io_usb1_data2                   : inout std_logic                     := 'X';             -- usb1_data2
			hps_io_usb1_data3                   : inout std_logic                     := 'X';             -- usb1_data3
			hps_io_usb1_data4                   : inout std_logic                     := 'X';             -- usb1_data4
			hps_io_usb1_data5                   : inout std_logic                     := 'X';             -- usb1_data5
			hps_io_usb1_data6                   : inout std_logic                     := 'X';             -- usb1_data6
			hps_io_usb1_data7                   : inout std_logic                     := 'X';             -- usb1_data7
			hps_io_emac2_tx_clk                 : out   std_logic;                                        -- emac2_tx_clk
			hps_io_emac2_tx_ctl                 : out   std_logic;                                        -- emac2_tx_ctl
			hps_io_emac2_rx_clk                 : in    std_logic                     := 'X';             -- emac2_rx_clk
			hps_io_emac2_rx_ctl                 : in    std_logic                     := 'X';             -- emac2_rx_ctl
			hps_io_emac2_txd0                   : out   std_logic;                                        -- emac2_txd0
			hps_io_emac2_txd1                   : out   std_logic;                                        -- emac2_txd1
			hps_io_emac2_rxd0                   : in    std_logic                     := 'X';             -- emac2_rxd0
			hps_io_emac2_rxd1                   : in    std_logic                     := 'X';             -- emac2_rxd1
			hps_io_emac2_txd2                   : out   std_logic;                                        -- emac2_txd2
			hps_io_emac2_txd3                   : out   std_logic;                                        -- emac2_txd3
			hps_io_emac2_rxd2                   : in    std_logic                     := 'X';             -- emac2_rxd2
			hps_io_emac2_rxd3                   : in    std_logic                     := 'X';             -- emac2_rxd3
			hps_io_emac2_pps                    : out   std_logic;                                        -- emac2_pps
			hps_io_emac2_pps_trig               : in    std_logic                     := 'X';             -- emac2_pps_trig
			hps_io_mdio2_mdio                   : inout std_logic                     := 'X';             -- mdio2_mdio
			hps_io_mdio2_mdc                    : out   std_logic;                                        -- mdio2_mdc
			hps_io_uart0_tx                     : out   std_logic;                                        -- uart0_tx
			hps_io_uart0_rx                     : in    std_logic                     := 'X';             -- uart0_rx
			hps_io_i3c1_sda                     : inout std_logic                     := 'X';             -- i3c1_sda
			hps_io_i3c1_scl                     : inout std_logic                     := 'X';             -- i3c1_scl
			hps_io_jtag_tck                     : in    std_logic                     := 'X';             -- jtag_tck
			hps_io_jtag_tms                     : in    std_logic                     := 'X';             -- jtag_tms
			hps_io_jtag_tdo                     : out   std_logic;                                        -- jtag_tdo
			hps_io_jtag_tdi                     : in    std_logic                     := 'X';             -- jtag_tdi
			hps_io_gpio0                        : inout std_logic                     := 'X';             -- gpio0
			hps_io_gpio1                        : inout std_logic                     := 'X';             -- gpio1
			hps_io_gpio11                       : inout std_logic                     := 'X';             -- gpio11
			hps_io_gpio27                       : inout std_logic                     := 'X';             -- gpio27
			usb31_io_vbus_det                   : in    std_logic                     := 'X';             -- vbus_det
			usb31_io_flt_bar                    : in    std_logic                     := 'X';             -- flt_bar
			usb31_io_usb_ctrl                   : out   std_logic_vector(1 downto 0);                     -- usb_ctrl
			usb31_io_usb31_id                   : in    std_logic                     := 'X';             -- usb31_id
			usb31_phy_pma_cpu_clk_clk           : in    std_logic                     := 'X';             -- clk
			usb31_phy_refclk_p_clk              : in    std_logic                     := 'X';             -- clk
			usb31_phy_refclk_n_clk              : in    std_logic                     := 'X';             -- clk
			usb31_phy_rx_serial_n_i_rx_serial_n : in    std_logic                     := 'X';             -- i_rx_serial_n
			usb31_phy_rx_serial_p_i_rx_serial_p : in    std_logic                     := 'X';             -- i_rx_serial_p
			usb31_phy_tx_serial_n_o_tx_serial_n : out   std_logic;                                        -- o_tx_serial_n
			usb31_phy_tx_serial_p_o_tx_serial_p : out   std_logic;                                        -- o_tx_serial_p
			emif_hps_emif_mem_0_mem_ck_t        : out   std_logic;                                        -- mem_ck_t
			emif_hps_emif_mem_0_mem_ck_c        : out   std_logic;                                        -- mem_ck_c
			emif_hps_emif_mem_0_mem_cke         : out   std_logic;                                        -- mem_cke
			emif_hps_emif_mem_0_mem_odt         : out   std_logic;                                        -- mem_odt
			emif_hps_emif_mem_0_mem_cs_n        : out   std_logic;                                        -- mem_cs_n
			emif_hps_emif_mem_0_mem_a           : out   std_logic_vector(16 downto 0);                    -- mem_a
			emif_hps_emif_mem_0_mem_ba          : out   std_logic_vector(1 downto 0);                     -- mem_ba
			emif_hps_emif_mem_0_mem_bg          : out   std_logic;                                        -- mem_bg
			emif_hps_emif_mem_0_mem_act_n       : out   std_logic;                                        -- mem_act_n
			emif_hps_emif_mem_0_mem_par         : out   std_logic;                                        -- mem_par
			emif_hps_emif_mem_0_mem_alert_n     : in    std_logic                     := 'X';             -- mem_alert_n
			emif_hps_emif_mem_0_mem_reset_n     : out   std_logic;                                        -- mem_reset_n
			emif_hps_emif_mem_0_mem_dq          : inout std_logic_vector(31 downto 0) := (others => 'X'); -- mem_dq
			emif_hps_emif_mem_0_mem_dqs_t       : inout std_logic_vector(3 downto 0)  := (others => 'X'); -- mem_dqs_t
			emif_hps_emif_mem_0_mem_dqs_c       : inout std_logic_vector(3 downto 0)  := (others => 'X'); -- mem_dqs_c
			emif_hps_emif_oct_0_oct_rzqin       : in    std_logic                     := 'X';             -- oct_rzqin
			emif_hps_emif_ref_clk_0_clk         : in    std_logic                     := 'X';             -- clk
			o_pma_cu_clk_clk                    : out   std_logic_vector(0 downto 0)                      -- clk
		);
	end component qsys_top;

	u0 : component qsys_top
		port map (
			clk_100_clk                         => CONNECTED_TO_clk_100_clk,                         --                 clk_100.clk
			reset_reset_n                       => CONNECTED_TO_reset_reset_n,                       --                   reset.reset_n
			ninit_done_ninit_done               => CONNECTED_TO_ninit_done_ninit_done,               --              ninit_done.ninit_done
			hps_io_hps_osc_clk                  => CONNECTED_TO_hps_io_hps_osc_clk,                  --                  hps_io.hps_osc_clk
			hps_io_sdmmc_data0                  => CONNECTED_TO_hps_io_sdmmc_data0,                  --                        .sdmmc_data0
			hps_io_sdmmc_data1                  => CONNECTED_TO_hps_io_sdmmc_data1,                  --                        .sdmmc_data1
			hps_io_sdmmc_cclk                   => CONNECTED_TO_hps_io_sdmmc_cclk,                   --                        .sdmmc_cclk
			hps_io_sdmmc_wprot                  => CONNECTED_TO_hps_io_sdmmc_wprot,                  --                        .sdmmc_wprot
			hps_io_sdmmc_data2                  => CONNECTED_TO_hps_io_sdmmc_data2,                  --                        .sdmmc_data2
			hps_io_sdmmc_data3                  => CONNECTED_TO_hps_io_sdmmc_data3,                  --                        .sdmmc_data3
			hps_io_sdmmc_cmd                    => CONNECTED_TO_hps_io_sdmmc_cmd,                    --                        .sdmmc_cmd
			hps_io_usb1_clk                     => CONNECTED_TO_hps_io_usb1_clk,                     --                        .usb1_clk
			hps_io_usb1_stp                     => CONNECTED_TO_hps_io_usb1_stp,                     --                        .usb1_stp
			hps_io_usb1_dir                     => CONNECTED_TO_hps_io_usb1_dir,                     --                        .usb1_dir
			hps_io_usb1_data0                   => CONNECTED_TO_hps_io_usb1_data0,                   --                        .usb1_data0
			hps_io_usb1_data1                   => CONNECTED_TO_hps_io_usb1_data1,                   --                        .usb1_data1
			hps_io_usb1_nxt                     => CONNECTED_TO_hps_io_usb1_nxt,                     --                        .usb1_nxt
			hps_io_usb1_data2                   => CONNECTED_TO_hps_io_usb1_data2,                   --                        .usb1_data2
			hps_io_usb1_data3                   => CONNECTED_TO_hps_io_usb1_data3,                   --                        .usb1_data3
			hps_io_usb1_data4                   => CONNECTED_TO_hps_io_usb1_data4,                   --                        .usb1_data4
			hps_io_usb1_data5                   => CONNECTED_TO_hps_io_usb1_data5,                   --                        .usb1_data5
			hps_io_usb1_data6                   => CONNECTED_TO_hps_io_usb1_data6,                   --                        .usb1_data6
			hps_io_usb1_data7                   => CONNECTED_TO_hps_io_usb1_data7,                   --                        .usb1_data7
			hps_io_emac2_tx_clk                 => CONNECTED_TO_hps_io_emac2_tx_clk,                 --                        .emac2_tx_clk
			hps_io_emac2_tx_ctl                 => CONNECTED_TO_hps_io_emac2_tx_ctl,                 --                        .emac2_tx_ctl
			hps_io_emac2_rx_clk                 => CONNECTED_TO_hps_io_emac2_rx_clk,                 --                        .emac2_rx_clk
			hps_io_emac2_rx_ctl                 => CONNECTED_TO_hps_io_emac2_rx_ctl,                 --                        .emac2_rx_ctl
			hps_io_emac2_txd0                   => CONNECTED_TO_hps_io_emac2_txd0,                   --                        .emac2_txd0
			hps_io_emac2_txd1                   => CONNECTED_TO_hps_io_emac2_txd1,                   --                        .emac2_txd1
			hps_io_emac2_rxd0                   => CONNECTED_TO_hps_io_emac2_rxd0,                   --                        .emac2_rxd0
			hps_io_emac2_rxd1                   => CONNECTED_TO_hps_io_emac2_rxd1,                   --                        .emac2_rxd1
			hps_io_emac2_txd2                   => CONNECTED_TO_hps_io_emac2_txd2,                   --                        .emac2_txd2
			hps_io_emac2_txd3                   => CONNECTED_TO_hps_io_emac2_txd3,                   --                        .emac2_txd3
			hps_io_emac2_rxd2                   => CONNECTED_TO_hps_io_emac2_rxd2,                   --                        .emac2_rxd2
			hps_io_emac2_rxd3                   => CONNECTED_TO_hps_io_emac2_rxd3,                   --                        .emac2_rxd3
			hps_io_emac2_pps                    => CONNECTED_TO_hps_io_emac2_pps,                    --                        .emac2_pps
			hps_io_emac2_pps_trig               => CONNECTED_TO_hps_io_emac2_pps_trig,               --                        .emac2_pps_trig
			hps_io_mdio2_mdio                   => CONNECTED_TO_hps_io_mdio2_mdio,                   --                        .mdio2_mdio
			hps_io_mdio2_mdc                    => CONNECTED_TO_hps_io_mdio2_mdc,                    --                        .mdio2_mdc
			hps_io_uart0_tx                     => CONNECTED_TO_hps_io_uart0_tx,                     --                        .uart0_tx
			hps_io_uart0_rx                     => CONNECTED_TO_hps_io_uart0_rx,                     --                        .uart0_rx
			hps_io_i3c1_sda                     => CONNECTED_TO_hps_io_i3c1_sda,                     --                        .i3c1_sda
			hps_io_i3c1_scl                     => CONNECTED_TO_hps_io_i3c1_scl,                     --                        .i3c1_scl
			hps_io_jtag_tck                     => CONNECTED_TO_hps_io_jtag_tck,                     --                        .jtag_tck
			hps_io_jtag_tms                     => CONNECTED_TO_hps_io_jtag_tms,                     --                        .jtag_tms
			hps_io_jtag_tdo                     => CONNECTED_TO_hps_io_jtag_tdo,                     --                        .jtag_tdo
			hps_io_jtag_tdi                     => CONNECTED_TO_hps_io_jtag_tdi,                     --                        .jtag_tdi
			hps_io_gpio0                        => CONNECTED_TO_hps_io_gpio0,                        --                        .gpio0
			hps_io_gpio1                        => CONNECTED_TO_hps_io_gpio1,                        --                        .gpio1
			hps_io_gpio11                       => CONNECTED_TO_hps_io_gpio11,                       --                        .gpio11
			hps_io_gpio27                       => CONNECTED_TO_hps_io_gpio27,                       --                        .gpio27
			usb31_io_vbus_det                   => CONNECTED_TO_usb31_io_vbus_det,                   --                usb31_io.vbus_det
			usb31_io_flt_bar                    => CONNECTED_TO_usb31_io_flt_bar,                    --                        .flt_bar
			usb31_io_usb_ctrl                   => CONNECTED_TO_usb31_io_usb_ctrl,                   --                        .usb_ctrl
			usb31_io_usb31_id                   => CONNECTED_TO_usb31_io_usb31_id,                   --                        .usb31_id
			usb31_phy_pma_cpu_clk_clk           => CONNECTED_TO_usb31_phy_pma_cpu_clk_clk,           --   usb31_phy_pma_cpu_clk.clk
			usb31_phy_refclk_p_clk              => CONNECTED_TO_usb31_phy_refclk_p_clk,              --      usb31_phy_refclk_p.clk
			usb31_phy_refclk_n_clk              => CONNECTED_TO_usb31_phy_refclk_n_clk,              --      usb31_phy_refclk_n.clk
			usb31_phy_rx_serial_n_i_rx_serial_n => CONNECTED_TO_usb31_phy_rx_serial_n_i_rx_serial_n, --   usb31_phy_rx_serial_n.i_rx_serial_n
			usb31_phy_rx_serial_p_i_rx_serial_p => CONNECTED_TO_usb31_phy_rx_serial_p_i_rx_serial_p, --   usb31_phy_rx_serial_p.i_rx_serial_p
			usb31_phy_tx_serial_n_o_tx_serial_n => CONNECTED_TO_usb31_phy_tx_serial_n_o_tx_serial_n, --   usb31_phy_tx_serial_n.o_tx_serial_n
			usb31_phy_tx_serial_p_o_tx_serial_p => CONNECTED_TO_usb31_phy_tx_serial_p_o_tx_serial_p, --   usb31_phy_tx_serial_p.o_tx_serial_p
			emif_hps_emif_mem_0_mem_ck_t        => CONNECTED_TO_emif_hps_emif_mem_0_mem_ck_t,        --     emif_hps_emif_mem_0.mem_ck_t
			emif_hps_emif_mem_0_mem_ck_c        => CONNECTED_TO_emif_hps_emif_mem_0_mem_ck_c,        --                        .mem_ck_c
			emif_hps_emif_mem_0_mem_cke         => CONNECTED_TO_emif_hps_emif_mem_0_mem_cke,         --                        .mem_cke
			emif_hps_emif_mem_0_mem_odt         => CONNECTED_TO_emif_hps_emif_mem_0_mem_odt,         --                        .mem_odt
			emif_hps_emif_mem_0_mem_cs_n        => CONNECTED_TO_emif_hps_emif_mem_0_mem_cs_n,        --                        .mem_cs_n
			emif_hps_emif_mem_0_mem_a           => CONNECTED_TO_emif_hps_emif_mem_0_mem_a,           --                        .mem_a
			emif_hps_emif_mem_0_mem_ba          => CONNECTED_TO_emif_hps_emif_mem_0_mem_ba,          --                        .mem_ba
			emif_hps_emif_mem_0_mem_bg          => CONNECTED_TO_emif_hps_emif_mem_0_mem_bg,          --                        .mem_bg
			emif_hps_emif_mem_0_mem_act_n       => CONNECTED_TO_emif_hps_emif_mem_0_mem_act_n,       --                        .mem_act_n
			emif_hps_emif_mem_0_mem_par         => CONNECTED_TO_emif_hps_emif_mem_0_mem_par,         --                        .mem_par
			emif_hps_emif_mem_0_mem_alert_n     => CONNECTED_TO_emif_hps_emif_mem_0_mem_alert_n,     --                        .mem_alert_n
			emif_hps_emif_mem_0_mem_reset_n     => CONNECTED_TO_emif_hps_emif_mem_0_mem_reset_n,     --                        .mem_reset_n
			emif_hps_emif_mem_0_mem_dq          => CONNECTED_TO_emif_hps_emif_mem_0_mem_dq,          --                        .mem_dq
			emif_hps_emif_mem_0_mem_dqs_t       => CONNECTED_TO_emif_hps_emif_mem_0_mem_dqs_t,       --                        .mem_dqs_t
			emif_hps_emif_mem_0_mem_dqs_c       => CONNECTED_TO_emif_hps_emif_mem_0_mem_dqs_c,       --                        .mem_dqs_c
			emif_hps_emif_oct_0_oct_rzqin       => CONNECTED_TO_emif_hps_emif_oct_0_oct_rzqin,       --     emif_hps_emif_oct_0.oct_rzqin
			emif_hps_emif_ref_clk_0_clk         => CONNECTED_TO_emif_hps_emif_ref_clk_0_clk,         -- emif_hps_emif_ref_clk_0.clk
			o_pma_cu_clk_clk                    => CONNECTED_TO_o_pma_cu_clk_clk                     --            o_pma_cu_clk.clk
		);

