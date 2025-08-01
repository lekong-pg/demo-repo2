if {[get_collection_size [get_nodes -nowarn sundancemesa_hps_inst~l4_main_clk]  ] > 0} { 
	 create_clock -name l4_main_clk_src -period 2.5 [get_nodes -nowarn sundancemesa_hps_inst~l4_main_clk] 
	 create_generated_clock -divide_by 1 -name l4_main_clk [get_registers sundancemesa_hps_inst~l4_main_clk.reg] -master_clock [get_clocks l4_main_clk_src] -source [get_nodes sundancemesa_hps_inst~l4_main_clk] 
} 
if {[get_collection_size [get_nodes -nowarn sundancemesa_hps_inst~l4_mp_clk]  ] > 0} { 
	 create_clock -name l4_mp_clk_src -period 5.0 [get_nodes -nowarn sundancemesa_hps_inst~l4_mp_clk] 
	 create_generated_clock -divide_by 1 -name l4_mp_clk [get_registers sundancemesa_hps_inst~l4_mp_clk.reg] -master_clock [get_clocks l4_mp_clk_src] -source [get_nodes sundancemesa_hps_inst~l4_mp_clk] 
} 
if {[get_collection_size [get_pins -nowarn -compatibility_mode  sundancemesa_hps_inst|f2s*irq*]  ] > 0} { 
 	 set_false_path -through [get_pins -nowarn -compatibility_mode  sundancemesa_hps_inst|f2s*irq*] -to [get_registers *clk*.reg]  
} 
if {[get_collection_size [get_pins -nowarn -compatibility_mode  sundancemesa_hps_inst|s2f*irq*]  ] > 0} { 
 	 set_false_path -through [get_pins -nowarn -compatibility_mode  sundancemesa_hps_inst|s2f*irq*] -from [get_registers *clk*.reg]  
} 
if {[get_collection_size [get_nodes -nowarn sundancemesa_hps_inst~pll_main_c2]  ] > 0} { 
	 create_clock -name pll_main_c2_clk_src -period 2.0 [get_nodes -nowarn sundancemesa_hps_inst~pll_main_c2] 
	 create_generated_clock -divide_by 1 -name pll_main_c2 [get_registers sundancemesa_hps_inst~pll_main_c2.reg] -master_clock [get_clocks pll_main_c2_clk_src] -source [get_nodes sundancemesa_hps_inst~pll_main_c2] 
} 
