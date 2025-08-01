	component gts_inst is
		port (
			o_pma_cu_clk : out std_logic_vector(0 downto 0)   -- clk
		);
	end component gts_inst;

	u0 : component gts_inst
		port map (
			o_pma_cu_clk => CONNECTED_TO_o_pma_cu_clk  -- o_pma_cu_clk.clk
		);

