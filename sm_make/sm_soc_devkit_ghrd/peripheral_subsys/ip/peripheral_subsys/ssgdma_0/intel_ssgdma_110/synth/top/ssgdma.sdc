# (C) 2001-2023 Intel Corporation. All rights reserved.
# Your use of Intel Corporation's design tools, logic functions and other 
# software and tools, and its AMPP partner logic functions, and any output 
# files from any of the foregoing (including device programming or simulation 
# files), and any associated documentation or information are expressly subject 
# to the terms and conditions of the Intel Program License Subscription 
# Agreement, Intel FPGA IP License Agreement, or other applicable 
# license agreement, including, without limitation, that your use is for the 
# sole purpose of programming logic devices manufactured by Intel and sold by 
# Intel or its authorized distributors.  Please refer to the applicable 
# agreement for further details.



# User should set top level SDC constraint by referencing to the SSGDMA IP's SDC constraint

# No SDC constraint is generated in Example Design, please refer to SDC constraint file of Example Design.

proc ssgdma_ip_sdc {} {

set_time_format -unit ns -decimal_places 3

#create_clock -name {altera_reserved_tck} [get_ports { altera_reserved_tck }] -period 16MHz

create_clock -name axi_lite_clk -period 100MHz [get_ports {axi_lite_clk}]

create_clock -name host_clk -period 100MHz [get_ports {host_clk}]

create_clock -name h2d0_mm_clk -period 300MHz [get_ports {h2d0_mm_clk}]



# Automatically calculate clock uncertainty to jitter and other effects.
derive_clock_uncertainty

#set ALT_RSV_CLK     [get_clocks altera_reserved_tck]


set AXI_LITE_CLK	[get_clocks axi_lite_clk]

set SS_AXI_ST_CLK	[get_clocks host_clk]

set H2D0_MM_CLK	[get_clocks h2d0_mm_clk]



set_input_delay -clock $AXI_LITE_CLK -add_delay 1 [get_ports {axi_lite_areset_n}]

set_input_delay -clock $SS_AXI_ST_CLK -add_delay 1 [get_ports {host_aresetn}]

set_input_delay -clock $H2D0_MM_CLK -add_delay 1 [get_ports {h2d0_mm_resetn}]



# declare_clock       ALTERA_INSERTED_INTOSC_FOR_TRS|divided_osc_clk
# set OSC_CLK	        [get_clocks ALTERA_INSERTED_INTOSC_FOR_TRS|divided_osc_clk]

# Clock groups
#if { [string equal quartus_fit $::TimeQuestInfo(nameofexecutable)] } { set_max_delay -to [get_ports { altera_reserved_tdo } ] 0 }
#set_clock_groups -asynchronous -group {altera_reserved_tck}

# From Timequest cookbook
#set_clock_groups -exclusive -group [get_clocks altera_reserved_tck]
#
#set_input_delay -add_delay -clock altera_reserved_tck -clock_fall 3 [get_ports altera_reserved_tdi]
#set_input_delay -add_delay -clock altera_reserved_tck -clock_fall 3 [get_ports altera_reserved_tms]
#set_output_delay -add_delay -clock altera_reserved_tck 3 [get_ports altera_reserved_tdo]

set_clock_groups -asynchronous -group $AXI_LITE_CLK -group $SS_AXI_ST_CLK

set_clock_groups -asynchronous -group $H2D0_MM_CLK -group $AXI_LITE_CLK
set_clock_groups -asynchronous -group $H2D0_MM_CLK -group $SS_AXI_ST_CLK


}








