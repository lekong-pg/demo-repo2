	component peripheral_subsys is
		port (
			button_pio_external_connection_export : in  std_logic_vector(3 downto 0)   := (others => 'X'); -- export
			button_pio_irq_irq                    : out std_logic;                                         -- irq
			dipsw_pio_external_connection_export  : in  std_logic_vector(3 downto 0)   := (others => 'X'); -- export
			dipsw_pio_irq_irq                     : out std_logic;                                         -- irq
			led_pio_external_connection_in_port   : in  std_logic_vector(2 downto 0)   := (others => 'X'); -- in_port
			led_pio_external_connection_out_port  : out std_logic_vector(2 downto 0);                      -- out_port
			pb_cpu_0_s0_waitrequest               : out std_logic;                                         -- waitrequest
			pb_cpu_0_s0_readdata                  : out std_logic_vector(31 downto 0);                     -- readdata
			pb_cpu_0_s0_readdatavalid             : out std_logic;                                         -- readdatavalid
			pb_cpu_0_s0_burstcount                : in  std_logic_vector(0 downto 0)   := (others => 'X'); -- burstcount
			pb_cpu_0_s0_writedata                 : in  std_logic_vector(31 downto 0)  := (others => 'X'); -- writedata
			pb_cpu_0_s0_address                   : in  std_logic_vector(22 downto 0)  := (others => 'X'); -- address
			pb_cpu_0_s0_write                     : in  std_logic                      := 'X';             -- write
			pb_cpu_0_s0_read                      : in  std_logic                      := 'X';             -- read
			pb_cpu_0_s0_byteenable                : in  std_logic_vector(3 downto 0)   := (others => 'X'); -- byteenable
			pb_cpu_0_s0_debugaccess               : in  std_logic                      := 'X';             -- debugaccess
			clk_clk                               : in  std_logic                      := 'X';             -- clk
			reset_reset_n                         : in  std_logic                      := 'X';             -- reset_n
			ssgdma_host_clk_clk                   : in  std_logic                      := 'X';             -- clk
			ssgdma_host_aresetn_reset_n           : in  std_logic                      := 'X';             -- reset_n
			ssgdma_host_awready                   : in  std_logic                      := 'X';             -- awready
			ssgdma_host_awvalid                   : out std_logic;                                         -- awvalid
			ssgdma_host_awaddr                    : out std_logic_vector(63 downto 0);                     -- awaddr
			ssgdma_host_awlen                     : out std_logic_vector(7 downto 0);                      -- awlen
			ssgdma_host_awburst                   : out std_logic_vector(1 downto 0);                      -- awburst
			ssgdma_host_awsize                    : out std_logic_vector(2 downto 0);                      -- awsize
			ssgdma_host_awprot                    : out std_logic_vector(2 downto 0);                      -- awprot
			ssgdma_host_awid                      : out std_logic_vector(4 downto 0);                      -- awid
			ssgdma_host_awcache                   : out std_logic_vector(3 downto 0);                      -- awcache
			ssgdma_host_wready                    : in  std_logic                      := 'X';             -- wready
			ssgdma_host_wvalid                    : out std_logic;                                         -- wvalid
			ssgdma_host_wdata                     : out std_logic_vector(255 downto 0);                    -- wdata
			ssgdma_host_wstrb                     : out std_logic_vector(31 downto 0);                     -- wstrb
			ssgdma_host_wlast                     : out std_logic;                                         -- wlast
			ssgdma_host_bready                    : out std_logic;                                         -- bready
			ssgdma_host_bvalid                    : in  std_logic                      := 'X';             -- bvalid
			ssgdma_host_bresp                     : in  std_logic_vector(1 downto 0)   := (others => 'X'); -- bresp
			ssgdma_host_bid                       : in  std_logic_vector(4 downto 0)   := (others => 'X'); -- bid
			ssgdma_host_arready                   : in  std_logic                      := 'X';             -- arready
			ssgdma_host_arvalid                   : out std_logic;                                         -- arvalid
			ssgdma_host_araddr                    : out std_logic_vector(63 downto 0);                     -- araddr
			ssgdma_host_arlen                     : out std_logic_vector(7 downto 0);                      -- arlen
			ssgdma_host_arburst                   : out std_logic_vector(1 downto 0);                      -- arburst
			ssgdma_host_arsize                    : out std_logic_vector(2 downto 0);                      -- arsize
			ssgdma_host_arprot                    : out std_logic_vector(2 downto 0);                      -- arprot
			ssgdma_host_arid                      : out std_logic_vector(4 downto 0);                      -- arid
			ssgdma_host_arcache                   : out std_logic_vector(3 downto 0);                      -- arcache
			ssgdma_host_rready                    : out std_logic;                                         -- rready
			ssgdma_host_rvalid                    : in  std_logic                      := 'X';             -- rvalid
			ssgdma_host_rdata                     : in  std_logic_vector(255 downto 0) := (others => 'X'); -- rdata
			ssgdma_host_rlast                     : in  std_logic                      := 'X';             -- rlast
			ssgdma_host_rresp                     : in  std_logic_vector(1 downto 0)   := (others => 'X'); -- rresp
			ssgdma_host_rid                       : in  std_logic_vector(4 downto 0)   := (others => 'X'); -- rid
			ssgdma_interrupt_irq                  : out std_logic;                                         -- irq
			ssgdma_h2d0_mm_clk_clk                : in  std_logic                      := 'X';             -- clk
			ssgdma_h2d0_mm_resetn_reset_n         : in  std_logic                      := 'X';             -- reset_n
			ssgdma_h2d0_awvalid                   : out std_logic;                                         -- awvalid
			ssgdma_h2d0_awready                   : in  std_logic                      := 'X';             -- awready
			ssgdma_h2d0_awaddr                    : out std_logic_vector(63 downto 0);                     -- awaddr
			ssgdma_h2d0_awlen                     : out std_logic_vector(7 downto 0);                      -- awlen
			ssgdma_h2d0_awburst                   : out std_logic_vector(1 downto 0);                      -- awburst
			ssgdma_h2d0_awsize                    : out std_logic_vector(2 downto 0);                      -- awsize
			ssgdma_h2d0_awprot                    : out std_logic_vector(2 downto 0);                      -- awprot
			ssgdma_h2d0_awid                      : out std_logic_vector(7 downto 0);                      -- awid
			ssgdma_h2d0_awcache                   : out std_logic_vector(3 downto 0);                      -- awcache
			ssgdma_h2d0_wvalid                    : out std_logic;                                         -- wvalid
			ssgdma_h2d0_wlast                     : out std_logic;                                         -- wlast
			ssgdma_h2d0_wready                    : in  std_logic                      := 'X';             -- wready
			ssgdma_h2d0_wdata                     : out std_logic_vector(63 downto 0);                     -- wdata
			ssgdma_h2d0_wstrb                     : out std_logic_vector(7 downto 0);                      -- wstrb
			ssgdma_h2d0_bvalid                    : in  std_logic                      := 'X';             -- bvalid
			ssgdma_h2d0_bready                    : out std_logic;                                         -- bready
			ssgdma_h2d0_bresp                     : in  std_logic_vector(1 downto 0)   := (others => 'X'); -- bresp
			ssgdma_h2d0_bid                       : in  std_logic_vector(7 downto 0)   := (others => 'X'); -- bid
			ssgdma_h2d0_arvalid                   : out std_logic;                                         -- arvalid
			ssgdma_h2d0_arready                   : in  std_logic                      := 'X';             -- arready
			ssgdma_h2d0_araddr                    : out std_logic_vector(63 downto 0);                     -- araddr
			ssgdma_h2d0_arlen                     : out std_logic_vector(7 downto 0);                      -- arlen
			ssgdma_h2d0_arburst                   : out std_logic_vector(1 downto 0);                      -- arburst
			ssgdma_h2d0_arsize                    : out std_logic_vector(2 downto 0);                      -- arsize
			ssgdma_h2d0_arprot                    : out std_logic_vector(2 downto 0);                      -- arprot
			ssgdma_h2d0_arid                      : out std_logic_vector(7 downto 0);                      -- arid
			ssgdma_h2d0_arcache                   : out std_logic_vector(3 downto 0);                      -- arcache
			ssgdma_h2d0_rvalid                    : in  std_logic                      := 'X';             -- rvalid
			ssgdma_h2d0_rlast                     : in  std_logic                      := 'X';             -- rlast
			ssgdma_h2d0_rready                    : out std_logic;                                         -- rready
			ssgdma_h2d0_rdata                     : in  std_logic_vector(63 downto 0)  := (others => 'X'); -- rdata
			ssgdma_h2d0_rresp                     : in  std_logic_vector(1 downto 0)   := (others => 'X'); -- rresp
			ssgdma_h2d0_rid                       : in  std_logic_vector(7 downto 0)   := (others => 'X')  -- rid
		);
	end component peripheral_subsys;

	u0 : component peripheral_subsys
		port map (
			button_pio_external_connection_export => CONNECTED_TO_button_pio_external_connection_export, -- button_pio_external_connection.export
			button_pio_irq_irq                    => CONNECTED_TO_button_pio_irq_irq,                    --                 button_pio_irq.irq
			dipsw_pio_external_connection_export  => CONNECTED_TO_dipsw_pio_external_connection_export,  --  dipsw_pio_external_connection.export
			dipsw_pio_irq_irq                     => CONNECTED_TO_dipsw_pio_irq_irq,                     --                  dipsw_pio_irq.irq
			led_pio_external_connection_in_port   => CONNECTED_TO_led_pio_external_connection_in_port,   --    led_pio_external_connection.in_port
			led_pio_external_connection_out_port  => CONNECTED_TO_led_pio_external_connection_out_port,  --                               .out_port
			pb_cpu_0_s0_waitrequest               => CONNECTED_TO_pb_cpu_0_s0_waitrequest,               --                    pb_cpu_0_s0.waitrequest
			pb_cpu_0_s0_readdata                  => CONNECTED_TO_pb_cpu_0_s0_readdata,                  --                               .readdata
			pb_cpu_0_s0_readdatavalid             => CONNECTED_TO_pb_cpu_0_s0_readdatavalid,             --                               .readdatavalid
			pb_cpu_0_s0_burstcount                => CONNECTED_TO_pb_cpu_0_s0_burstcount,                --                               .burstcount
			pb_cpu_0_s0_writedata                 => CONNECTED_TO_pb_cpu_0_s0_writedata,                 --                               .writedata
			pb_cpu_0_s0_address                   => CONNECTED_TO_pb_cpu_0_s0_address,                   --                               .address
			pb_cpu_0_s0_write                     => CONNECTED_TO_pb_cpu_0_s0_write,                     --                               .write
			pb_cpu_0_s0_read                      => CONNECTED_TO_pb_cpu_0_s0_read,                      --                               .read
			pb_cpu_0_s0_byteenable                => CONNECTED_TO_pb_cpu_0_s0_byteenable,                --                               .byteenable
			pb_cpu_0_s0_debugaccess               => CONNECTED_TO_pb_cpu_0_s0_debugaccess,               --                               .debugaccess
			clk_clk                               => CONNECTED_TO_clk_clk,                               --                            clk.clk
			reset_reset_n                         => CONNECTED_TO_reset_reset_n,                         --                          reset.reset_n
			ssgdma_host_clk_clk                   => CONNECTED_TO_ssgdma_host_clk_clk,                   --                ssgdma_host_clk.clk
			ssgdma_host_aresetn_reset_n           => CONNECTED_TO_ssgdma_host_aresetn_reset_n,           --            ssgdma_host_aresetn.reset_n
			ssgdma_host_awready                   => CONNECTED_TO_ssgdma_host_awready,                   --                    ssgdma_host.awready
			ssgdma_host_awvalid                   => CONNECTED_TO_ssgdma_host_awvalid,                   --                               .awvalid
			ssgdma_host_awaddr                    => CONNECTED_TO_ssgdma_host_awaddr,                    --                               .awaddr
			ssgdma_host_awlen                     => CONNECTED_TO_ssgdma_host_awlen,                     --                               .awlen
			ssgdma_host_awburst                   => CONNECTED_TO_ssgdma_host_awburst,                   --                               .awburst
			ssgdma_host_awsize                    => CONNECTED_TO_ssgdma_host_awsize,                    --                               .awsize
			ssgdma_host_awprot                    => CONNECTED_TO_ssgdma_host_awprot,                    --                               .awprot
			ssgdma_host_awid                      => CONNECTED_TO_ssgdma_host_awid,                      --                               .awid
			ssgdma_host_awcache                   => CONNECTED_TO_ssgdma_host_awcache,                   --                               .awcache
			ssgdma_host_wready                    => CONNECTED_TO_ssgdma_host_wready,                    --                               .wready
			ssgdma_host_wvalid                    => CONNECTED_TO_ssgdma_host_wvalid,                    --                               .wvalid
			ssgdma_host_wdata                     => CONNECTED_TO_ssgdma_host_wdata,                     --                               .wdata
			ssgdma_host_wstrb                     => CONNECTED_TO_ssgdma_host_wstrb,                     --                               .wstrb
			ssgdma_host_wlast                     => CONNECTED_TO_ssgdma_host_wlast,                     --                               .wlast
			ssgdma_host_bready                    => CONNECTED_TO_ssgdma_host_bready,                    --                               .bready
			ssgdma_host_bvalid                    => CONNECTED_TO_ssgdma_host_bvalid,                    --                               .bvalid
			ssgdma_host_bresp                     => CONNECTED_TO_ssgdma_host_bresp,                     --                               .bresp
			ssgdma_host_bid                       => CONNECTED_TO_ssgdma_host_bid,                       --                               .bid
			ssgdma_host_arready                   => CONNECTED_TO_ssgdma_host_arready,                   --                               .arready
			ssgdma_host_arvalid                   => CONNECTED_TO_ssgdma_host_arvalid,                   --                               .arvalid
			ssgdma_host_araddr                    => CONNECTED_TO_ssgdma_host_araddr,                    --                               .araddr
			ssgdma_host_arlen                     => CONNECTED_TO_ssgdma_host_arlen,                     --                               .arlen
			ssgdma_host_arburst                   => CONNECTED_TO_ssgdma_host_arburst,                   --                               .arburst
			ssgdma_host_arsize                    => CONNECTED_TO_ssgdma_host_arsize,                    --                               .arsize
			ssgdma_host_arprot                    => CONNECTED_TO_ssgdma_host_arprot,                    --                               .arprot
			ssgdma_host_arid                      => CONNECTED_TO_ssgdma_host_arid,                      --                               .arid
			ssgdma_host_arcache                   => CONNECTED_TO_ssgdma_host_arcache,                   --                               .arcache
			ssgdma_host_rready                    => CONNECTED_TO_ssgdma_host_rready,                    --                               .rready
			ssgdma_host_rvalid                    => CONNECTED_TO_ssgdma_host_rvalid,                    --                               .rvalid
			ssgdma_host_rdata                     => CONNECTED_TO_ssgdma_host_rdata,                     --                               .rdata
			ssgdma_host_rlast                     => CONNECTED_TO_ssgdma_host_rlast,                     --                               .rlast
			ssgdma_host_rresp                     => CONNECTED_TO_ssgdma_host_rresp,                     --                               .rresp
			ssgdma_host_rid                       => CONNECTED_TO_ssgdma_host_rid,                       --                               .rid
			ssgdma_interrupt_irq                  => CONNECTED_TO_ssgdma_interrupt_irq,                  --               ssgdma_interrupt.irq
			ssgdma_h2d0_mm_clk_clk                => CONNECTED_TO_ssgdma_h2d0_mm_clk_clk,                --             ssgdma_h2d0_mm_clk.clk
			ssgdma_h2d0_mm_resetn_reset_n         => CONNECTED_TO_ssgdma_h2d0_mm_resetn_reset_n,         --          ssgdma_h2d0_mm_resetn.reset_n
			ssgdma_h2d0_awvalid                   => CONNECTED_TO_ssgdma_h2d0_awvalid,                   --                    ssgdma_h2d0.awvalid
			ssgdma_h2d0_awready                   => CONNECTED_TO_ssgdma_h2d0_awready,                   --                               .awready
			ssgdma_h2d0_awaddr                    => CONNECTED_TO_ssgdma_h2d0_awaddr,                    --                               .awaddr
			ssgdma_h2d0_awlen                     => CONNECTED_TO_ssgdma_h2d0_awlen,                     --                               .awlen
			ssgdma_h2d0_awburst                   => CONNECTED_TO_ssgdma_h2d0_awburst,                   --                               .awburst
			ssgdma_h2d0_awsize                    => CONNECTED_TO_ssgdma_h2d0_awsize,                    --                               .awsize
			ssgdma_h2d0_awprot                    => CONNECTED_TO_ssgdma_h2d0_awprot,                    --                               .awprot
			ssgdma_h2d0_awid                      => CONNECTED_TO_ssgdma_h2d0_awid,                      --                               .awid
			ssgdma_h2d0_awcache                   => CONNECTED_TO_ssgdma_h2d0_awcache,                   --                               .awcache
			ssgdma_h2d0_wvalid                    => CONNECTED_TO_ssgdma_h2d0_wvalid,                    --                               .wvalid
			ssgdma_h2d0_wlast                     => CONNECTED_TO_ssgdma_h2d0_wlast,                     --                               .wlast
			ssgdma_h2d0_wready                    => CONNECTED_TO_ssgdma_h2d0_wready,                    --                               .wready
			ssgdma_h2d0_wdata                     => CONNECTED_TO_ssgdma_h2d0_wdata,                     --                               .wdata
			ssgdma_h2d0_wstrb                     => CONNECTED_TO_ssgdma_h2d0_wstrb,                     --                               .wstrb
			ssgdma_h2d0_bvalid                    => CONNECTED_TO_ssgdma_h2d0_bvalid,                    --                               .bvalid
			ssgdma_h2d0_bready                    => CONNECTED_TO_ssgdma_h2d0_bready,                    --                               .bready
			ssgdma_h2d0_bresp                     => CONNECTED_TO_ssgdma_h2d0_bresp,                     --                               .bresp
			ssgdma_h2d0_bid                       => CONNECTED_TO_ssgdma_h2d0_bid,                       --                               .bid
			ssgdma_h2d0_arvalid                   => CONNECTED_TO_ssgdma_h2d0_arvalid,                   --                               .arvalid
			ssgdma_h2d0_arready                   => CONNECTED_TO_ssgdma_h2d0_arready,                   --                               .arready
			ssgdma_h2d0_araddr                    => CONNECTED_TO_ssgdma_h2d0_araddr,                    --                               .araddr
			ssgdma_h2d0_arlen                     => CONNECTED_TO_ssgdma_h2d0_arlen,                     --                               .arlen
			ssgdma_h2d0_arburst                   => CONNECTED_TO_ssgdma_h2d0_arburst,                   --                               .arburst
			ssgdma_h2d0_arsize                    => CONNECTED_TO_ssgdma_h2d0_arsize,                    --                               .arsize
			ssgdma_h2d0_arprot                    => CONNECTED_TO_ssgdma_h2d0_arprot,                    --                               .arprot
			ssgdma_h2d0_arid                      => CONNECTED_TO_ssgdma_h2d0_arid,                      --                               .arid
			ssgdma_h2d0_arcache                   => CONNECTED_TO_ssgdma_h2d0_arcache,                   --                               .arcache
			ssgdma_h2d0_rvalid                    => CONNECTED_TO_ssgdma_h2d0_rvalid,                    --                               .rvalid
			ssgdma_h2d0_rlast                     => CONNECTED_TO_ssgdma_h2d0_rlast,                     --                               .rlast
			ssgdma_h2d0_rready                    => CONNECTED_TO_ssgdma_h2d0_rready,                    --                               .rready
			ssgdma_h2d0_rdata                     => CONNECTED_TO_ssgdma_h2d0_rdata,                     --                               .rdata
			ssgdma_h2d0_rresp                     => CONNECTED_TO_ssgdma_h2d0_rresp,                     --                               .rresp
			ssgdma_h2d0_rid                       => CONNECTED_TO_ssgdma_h2d0_rid                        --                               .rid
		);

