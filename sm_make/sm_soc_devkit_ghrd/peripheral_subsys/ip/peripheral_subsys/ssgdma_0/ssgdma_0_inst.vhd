	component ssgdma_0 is
		port (
			axi_lite_clk          : in  std_logic                      := 'X';             -- clk
			axi_lite_areset_n     : in  std_logic                      := 'X';             -- reset_n
			host_clk              : in  std_logic                      := 'X';             -- clk
			host_aresetn          : in  std_logic                      := 'X';             -- reset_n
			app_reset_status_n    : out std_logic;                                         -- reset_n
			host_awready          : in  std_logic                      := 'X';             -- awready
			host_awvalid          : out std_logic;                                         -- awvalid
			host_awaddr           : out std_logic_vector(63 downto 0);                     -- awaddr
			host_awlen            : out std_logic_vector(7 downto 0);                      -- awlen
			host_awburst          : out std_logic_vector(1 downto 0);                      -- awburst
			host_awsize           : out std_logic_vector(2 downto 0);                      -- awsize
			host_awprot           : out std_logic_vector(2 downto 0);                      -- awprot
			host_awid             : out std_logic_vector(4 downto 0);                      -- awid
			host_awcache          : out std_logic_vector(3 downto 0);                      -- awcache
			host_wready           : in  std_logic                      := 'X';             -- wready
			host_wvalid           : out std_logic;                                         -- wvalid
			host_wdata            : out std_logic_vector(255 downto 0);                    -- wdata
			host_wstrb            : out std_logic_vector(31 downto 0);                     -- wstrb
			host_wlast            : out std_logic;                                         -- wlast
			host_bready           : out std_logic;                                         -- bready
			host_bvalid           : in  std_logic                      := 'X';             -- bvalid
			host_bresp            : in  std_logic_vector(1 downto 0)   := (others => 'X'); -- bresp
			host_bid              : in  std_logic_vector(4 downto 0)   := (others => 'X'); -- bid
			host_arready          : in  std_logic                      := 'X';             -- arready
			host_arvalid          : out std_logic;                                         -- arvalid
			host_araddr           : out std_logic_vector(63 downto 0);                     -- araddr
			host_arlen            : out std_logic_vector(7 downto 0);                      -- arlen
			host_arburst          : out std_logic_vector(1 downto 0);                      -- arburst
			host_arsize           : out std_logic_vector(2 downto 0);                      -- arsize
			host_arprot           : out std_logic_vector(2 downto 0);                      -- arprot
			host_arid             : out std_logic_vector(4 downto 0);                      -- arid
			host_arcache          : out std_logic_vector(3 downto 0);                      -- arcache
			host_rready           : out std_logic;                                         -- rready
			host_rvalid           : in  std_logic                      := 'X';             -- rvalid
			host_rdata            : in  std_logic_vector(255 downto 0) := (others => 'X'); -- rdata
			host_rlast            : in  std_logic                      := 'X';             -- rlast
			host_rresp            : in  std_logic_vector(1 downto 0)   := (others => 'X'); -- rresp
			host_rid              : in  std_logic_vector(4 downto 0)   := (others => 'X'); -- rid
			host_lite_csr_awready : out std_logic;                                         -- awready
			host_lite_csr_awvalid : in  std_logic                      := 'X';             -- awvalid
			host_lite_csr_awaddr  : in  std_logic_vector(21 downto 0)  := (others => 'X'); -- awaddr
			host_lite_csr_awprot  : in  std_logic_vector(2 downto 0)   := (others => 'X'); -- awprot
			host_lite_csr_wready  : out std_logic;                                         -- wready
			host_lite_csr_wvalid  : in  std_logic                      := 'X';             -- wvalid
			host_lite_csr_wdata   : in  std_logic_vector(31 downto 0)  := (others => 'X'); -- wdata
			host_lite_csr_wstrb   : in  std_logic_vector(3 downto 0)   := (others => 'X'); -- wstrb
			host_lite_csr_bready  : in  std_logic                      := 'X';             -- bready
			host_lite_csr_bvalid  : out std_logic;                                         -- bvalid
			host_lite_csr_bresp   : out std_logic_vector(1 downto 0);                      -- bresp
			host_lite_csr_arready : out std_logic;                                         -- arready
			host_lite_csr_arvalid : in  std_logic                      := 'X';             -- arvalid
			host_lite_csr_araddr  : in  std_logic_vector(21 downto 0)  := (others => 'X'); -- araddr
			host_lite_csr_arprot  : in  std_logic_vector(2 downto 0)   := (others => 'X'); -- arprot
			host_lite_csr_rready  : in  std_logic                      := 'X';             -- rready
			host_lite_csr_rvalid  : out std_logic;                                         -- rvalid
			host_lite_csr_rdata   : out std_logic_vector(31 downto 0);                     -- rdata
			host_lite_csr_rresp   : out std_logic_vector(1 downto 0);                      -- rresp
			irq                   : out std_logic;                                         -- irq
			h2d0_mm_clk           : in  std_logic                      := 'X';             -- clk
			h2d0_mm_resetn        : in  std_logic                      := 'X';             -- reset_n
			h2d0_awvalid          : out std_logic;                                         -- awvalid
			h2d0_awready          : in  std_logic                      := 'X';             -- awready
			h2d0_awaddr           : out std_logic_vector(63 downto 0);                     -- awaddr
			h2d0_awlen            : out std_logic_vector(7 downto 0);                      -- awlen
			h2d0_awburst          : out std_logic_vector(1 downto 0);                      -- awburst
			h2d0_awsize           : out std_logic_vector(2 downto 0);                      -- awsize
			h2d0_awprot           : out std_logic_vector(2 downto 0);                      -- awprot
			h2d0_awid             : out std_logic_vector(7 downto 0);                      -- awid
			h2d0_awcache          : out std_logic_vector(3 downto 0);                      -- awcache
			h2d0_wvalid           : out std_logic;                                         -- wvalid
			h2d0_wlast            : out std_logic;                                         -- wlast
			h2d0_wready           : in  std_logic                      := 'X';             -- wready
			h2d0_wdata            : out std_logic_vector(63 downto 0);                     -- wdata
			h2d0_wstrb            : out std_logic_vector(7 downto 0);                      -- wstrb
			h2d0_bvalid           : in  std_logic                      := 'X';             -- bvalid
			h2d0_bready           : out std_logic;                                         -- bready
			h2d0_bresp            : in  std_logic_vector(1 downto 0)   := (others => 'X'); -- bresp
			h2d0_bid              : in  std_logic_vector(7 downto 0)   := (others => 'X'); -- bid
			h2d0_arvalid          : out std_logic;                                         -- arvalid
			h2d0_arready          : in  std_logic                      := 'X';             -- arready
			h2d0_araddr           : out std_logic_vector(63 downto 0);                     -- araddr
			h2d0_arlen            : out std_logic_vector(7 downto 0);                      -- arlen
			h2d0_arburst          : out std_logic_vector(1 downto 0);                      -- arburst
			h2d0_arsize           : out std_logic_vector(2 downto 0);                      -- arsize
			h2d0_arprot           : out std_logic_vector(2 downto 0);                      -- arprot
			h2d0_arid             : out std_logic_vector(7 downto 0);                      -- arid
			h2d0_arcache          : out std_logic_vector(3 downto 0);                      -- arcache
			h2d0_rvalid           : in  std_logic                      := 'X';             -- rvalid
			h2d0_rlast            : in  std_logic                      := 'X';             -- rlast
			h2d0_rready           : out std_logic;                                         -- rready
			h2d0_rdata            : in  std_logic_vector(63 downto 0)  := (others => 'X'); -- rdata
			h2d0_rresp            : in  std_logic_vector(1 downto 0)   := (others => 'X'); -- rresp
			h2d0_rid              : in  std_logic_vector(7 downto 0)   := (others => 'X')  -- rid
		);
	end component ssgdma_0;

	u0 : component ssgdma_0
		port map (
			axi_lite_clk          => CONNECTED_TO_axi_lite_clk,          --       axi_lite_clk.clk
			axi_lite_areset_n     => CONNECTED_TO_axi_lite_areset_n,     --  axi_lite_areset_n.reset_n
			host_clk              => CONNECTED_TO_host_clk,              --           host_clk.clk
			host_aresetn          => CONNECTED_TO_host_aresetn,          --       host_aresetn.reset_n
			app_reset_status_n    => CONNECTED_TO_app_reset_status_n,    -- app_reset_status_n.reset_n
			host_awready          => CONNECTED_TO_host_awready,          --               host.awready
			host_awvalid          => CONNECTED_TO_host_awvalid,          --                   .awvalid
			host_awaddr           => CONNECTED_TO_host_awaddr,           --                   .awaddr
			host_awlen            => CONNECTED_TO_host_awlen,            --                   .awlen
			host_awburst          => CONNECTED_TO_host_awburst,          --                   .awburst
			host_awsize           => CONNECTED_TO_host_awsize,           --                   .awsize
			host_awprot           => CONNECTED_TO_host_awprot,           --                   .awprot
			host_awid             => CONNECTED_TO_host_awid,             --                   .awid
			host_awcache          => CONNECTED_TO_host_awcache,          --                   .awcache
			host_wready           => CONNECTED_TO_host_wready,           --                   .wready
			host_wvalid           => CONNECTED_TO_host_wvalid,           --                   .wvalid
			host_wdata            => CONNECTED_TO_host_wdata,            --                   .wdata
			host_wstrb            => CONNECTED_TO_host_wstrb,            --                   .wstrb
			host_wlast            => CONNECTED_TO_host_wlast,            --                   .wlast
			host_bready           => CONNECTED_TO_host_bready,           --                   .bready
			host_bvalid           => CONNECTED_TO_host_bvalid,           --                   .bvalid
			host_bresp            => CONNECTED_TO_host_bresp,            --                   .bresp
			host_bid              => CONNECTED_TO_host_bid,              --                   .bid
			host_arready          => CONNECTED_TO_host_arready,          --                   .arready
			host_arvalid          => CONNECTED_TO_host_arvalid,          --                   .arvalid
			host_araddr           => CONNECTED_TO_host_araddr,           --                   .araddr
			host_arlen            => CONNECTED_TO_host_arlen,            --                   .arlen
			host_arburst          => CONNECTED_TO_host_arburst,          --                   .arburst
			host_arsize           => CONNECTED_TO_host_arsize,           --                   .arsize
			host_arprot           => CONNECTED_TO_host_arprot,           --                   .arprot
			host_arid             => CONNECTED_TO_host_arid,             --                   .arid
			host_arcache          => CONNECTED_TO_host_arcache,          --                   .arcache
			host_rready           => CONNECTED_TO_host_rready,           --                   .rready
			host_rvalid           => CONNECTED_TO_host_rvalid,           --                   .rvalid
			host_rdata            => CONNECTED_TO_host_rdata,            --                   .rdata
			host_rlast            => CONNECTED_TO_host_rlast,            --                   .rlast
			host_rresp            => CONNECTED_TO_host_rresp,            --                   .rresp
			host_rid              => CONNECTED_TO_host_rid,              --                   .rid
			host_lite_csr_awready => CONNECTED_TO_host_lite_csr_awready, --           host_csr.awready
			host_lite_csr_awvalid => CONNECTED_TO_host_lite_csr_awvalid, --                   .awvalid
			host_lite_csr_awaddr  => CONNECTED_TO_host_lite_csr_awaddr,  --                   .awaddr
			host_lite_csr_awprot  => CONNECTED_TO_host_lite_csr_awprot,  --                   .awprot
			host_lite_csr_wready  => CONNECTED_TO_host_lite_csr_wready,  --                   .wready
			host_lite_csr_wvalid  => CONNECTED_TO_host_lite_csr_wvalid,  --                   .wvalid
			host_lite_csr_wdata   => CONNECTED_TO_host_lite_csr_wdata,   --                   .wdata
			host_lite_csr_wstrb   => CONNECTED_TO_host_lite_csr_wstrb,   --                   .wstrb
			host_lite_csr_bready  => CONNECTED_TO_host_lite_csr_bready,  --                   .bready
			host_lite_csr_bvalid  => CONNECTED_TO_host_lite_csr_bvalid,  --                   .bvalid
			host_lite_csr_bresp   => CONNECTED_TO_host_lite_csr_bresp,   --                   .bresp
			host_lite_csr_arready => CONNECTED_TO_host_lite_csr_arready, --                   .arready
			host_lite_csr_arvalid => CONNECTED_TO_host_lite_csr_arvalid, --                   .arvalid
			host_lite_csr_araddr  => CONNECTED_TO_host_lite_csr_araddr,  --                   .araddr
			host_lite_csr_arprot  => CONNECTED_TO_host_lite_csr_arprot,  --                   .arprot
			host_lite_csr_rready  => CONNECTED_TO_host_lite_csr_rready,  --                   .rready
			host_lite_csr_rvalid  => CONNECTED_TO_host_lite_csr_rvalid,  --                   .rvalid
			host_lite_csr_rdata   => CONNECTED_TO_host_lite_csr_rdata,   --                   .rdata
			host_lite_csr_rresp   => CONNECTED_TO_host_lite_csr_rresp,   --                   .rresp
			irq                   => CONNECTED_TO_irq,                   --          interrupt.irq
			h2d0_mm_clk           => CONNECTED_TO_h2d0_mm_clk,           --        h2d0_mm_clk.clk
			h2d0_mm_resetn        => CONNECTED_TO_h2d0_mm_resetn,        --     h2d0_mm_resetn.reset_n
			h2d0_awvalid          => CONNECTED_TO_h2d0_awvalid,          --               h2d0.awvalid
			h2d0_awready          => CONNECTED_TO_h2d0_awready,          --                   .awready
			h2d0_awaddr           => CONNECTED_TO_h2d0_awaddr,           --                   .awaddr
			h2d0_awlen            => CONNECTED_TO_h2d0_awlen,            --                   .awlen
			h2d0_awburst          => CONNECTED_TO_h2d0_awburst,          --                   .awburst
			h2d0_awsize           => CONNECTED_TO_h2d0_awsize,           --                   .awsize
			h2d0_awprot           => CONNECTED_TO_h2d0_awprot,           --                   .awprot
			h2d0_awid             => CONNECTED_TO_h2d0_awid,             --                   .awid
			h2d0_awcache          => CONNECTED_TO_h2d0_awcache,          --                   .awcache
			h2d0_wvalid           => CONNECTED_TO_h2d0_wvalid,           --                   .wvalid
			h2d0_wlast            => CONNECTED_TO_h2d0_wlast,            --                   .wlast
			h2d0_wready           => CONNECTED_TO_h2d0_wready,           --                   .wready
			h2d0_wdata            => CONNECTED_TO_h2d0_wdata,            --                   .wdata
			h2d0_wstrb            => CONNECTED_TO_h2d0_wstrb,            --                   .wstrb
			h2d0_bvalid           => CONNECTED_TO_h2d0_bvalid,           --                   .bvalid
			h2d0_bready           => CONNECTED_TO_h2d0_bready,           --                   .bready
			h2d0_bresp            => CONNECTED_TO_h2d0_bresp,            --                   .bresp
			h2d0_bid              => CONNECTED_TO_h2d0_bid,              --                   .bid
			h2d0_arvalid          => CONNECTED_TO_h2d0_arvalid,          --                   .arvalid
			h2d0_arready          => CONNECTED_TO_h2d0_arready,          --                   .arready
			h2d0_araddr           => CONNECTED_TO_h2d0_araddr,           --                   .araddr
			h2d0_arlen            => CONNECTED_TO_h2d0_arlen,            --                   .arlen
			h2d0_arburst          => CONNECTED_TO_h2d0_arburst,          --                   .arburst
			h2d0_arsize           => CONNECTED_TO_h2d0_arsize,           --                   .arsize
			h2d0_arprot           => CONNECTED_TO_h2d0_arprot,           --                   .arprot
			h2d0_arid             => CONNECTED_TO_h2d0_arid,             --                   .arid
			h2d0_arcache          => CONNECTED_TO_h2d0_arcache,          --                   .arcache
			h2d0_rvalid           => CONNECTED_TO_h2d0_rvalid,           --                   .rvalid
			h2d0_rlast            => CONNECTED_TO_h2d0_rlast,            --                   .rlast
			h2d0_rready           => CONNECTED_TO_h2d0_rready,           --                   .rready
			h2d0_rdata            => CONNECTED_TO_h2d0_rdata,            --                   .rdata
			h2d0_rresp            => CONNECTED_TO_h2d0_rresp,            --                   .rresp
			h2d0_rid              => CONNECTED_TO_h2d0_rid               --                   .rid
		);

