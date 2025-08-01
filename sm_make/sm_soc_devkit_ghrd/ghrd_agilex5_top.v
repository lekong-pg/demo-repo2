//****************************************************************************
//
// SPDX-License-Identifier: MIT-0
// Copyright(c) 2019-2021 Intel Corporation.
//
//****************************************************************************
// This is a generated system top level RTL file. 



module ghrd_agilex5_top (
//Additional refclk_bti to preserve Etile XCVR
// Clock and Reset
input    wire          fpga_clk_100,

//HPS
// HPS EMIF
output   wire          emif_hps_emif_mem_0_mem_ck_t,
output   wire          emif_hps_emif_mem_0_mem_ck_c,
output   wire [16:0]   emif_hps_emif_mem_0_mem_a,
output   wire          emif_hps_emif_mem_0_mem_act_n,
output   wire [1:0]    emif_hps_emif_mem_0_mem_ba,
output   wire [1:0]    emif_hps_emif_mem_0_mem_bg,
output   wire          emif_hps_emif_mem_0_mem_cke,
output   wire          emif_hps_emif_mem_0_mem_cs_n,
output   wire          emif_hps_emif_mem_0_mem_odt,
output   wire          emif_hps_emif_mem_0_mem_reset_n,
output   wire          emif_hps_emif_mem_0_mem_par,
input    wire          emif_hps_emif_mem_0_mem_alert_n,
input    wire          emif_hps_emif_oct_0_oct_rzqin,
input    wire          emif_hps_emif_ref_clk_0_clk,
inout    wire [3:0]    emif_hps_emif_mem_0_mem_dqs_t,
inout    wire [3:0]    emif_hps_emif_mem_0_mem_dqs_c,
inout    wire [31:0]   emif_hps_emif_mem_0_mem_dq,
input    wire          hps_jtag_tck,
input    wire          hps_jtag_tms,
output   wire          hps_jtag_tdo,
input    wire          hps_jtag_tdi,
output   wire          hps_sdmmc_CCLK, 
inout    wire          hps_sdmmc_CMD,          
inout    wire          hps_sdmmc_D0,          
inout    wire          hps_sdmmc_D1,          
inout    wire          hps_sdmmc_D2,        
inout    wire          hps_sdmmc_D3,        
input    wire          hps_sdmmc_WPROT,

inout    wire          hps_usb1_DATA0,         
inout    wire          hps_usb1_DATA1,      
inout    wire          hps_usb1_DATA2,        
inout    wire          hps_usb1_DATA3,       
inout    wire          hps_usb1_DATA4,        
inout    wire          hps_usb1_DATA5,      
inout    wire          hps_usb1_DATA6,      
inout    wire          hps_usb1_DATA7,         
input    wire          hps_usb1_CLK,         
output   wire          hps_usb1_STP,       
input    wire          hps_usb1_DIR,        
input    wire          hps_usb1_NXT, 

input    wire          usb31_io_vbus_det,                  
input    wire          usb31_io_flt_bar,                   
output   wire [1:0]    usb31_io_usb_ctrl,
input    wire          usb31_io_usb31_id,                  
input    wire          usb31_phy_refclk_p_clk,             
//input    wire          usb31_phy_refclk_p_clk(n),             
input    wire          usb31_phy_rx_serial_n_i_rx_serial_n,
input    wire          usb31_phy_rx_serial_p_i_rx_serial_p,
output   wire          usb31_phy_tx_serial_n_o_tx_serial_n,
output   wire          usb31_phy_tx_serial_p_o_tx_serial_p,
output   wire          hps_emac2_TX_CLK,       
input    wire          hps_emac2_RX_CLK,      
output   wire          hps_emac2_TX_CTL,
input    wire          hps_emac2_RX_CTL,      
output   wire          hps_emac2_TXD0,       
output   wire          hps_emac2_TXD1,
input    wire          hps_emac2_RXD0,     
input    wire          hps_emac2_RXD1, 
output   wire          hps_emac2_PPS,    
input    wire          hps_emac2_PPS_TRIG,
output   wire          hps_emac2_TXD2,        
output   wire          hps_emac2_TXD3,
input    wire          hps_emac2_RXD2,        
input    wire          hps_emac2_RXD3,
inout    wire          hps_emac2_MDIO,         
output   wire          hps_emac2_MDC,
input    wire          hps_uart0_RX,       
output   wire          hps_uart0_TX, 
inout    wire          hps_i3c1_SDA,        
inout    wire          hps_i3c1_SCL, 
inout    wire          hps_gpio0_io0,
inout    wire          hps_gpio0_io1,
inout    wire          hps_gpio0_io11,
inout    wire          hps_gpio1_io3,
input    wire          hps_osc_clk,
input    wire          fpga_reset_n
);

wire                   system_clk_100;
wire                   system_clk_100_internal;
wire                   ninit_done;
wire                   fpga_reset_n_debounced_wire;
reg                    fpga_reset_n_debounced;
wire                   system_reset_n;
//wire                 h2f_reset;

assign                 system_reset_n = fpga_reset_n_debounced
& ~ninit_done;

//assign               system_reset_n = fpga_reset_n_debounced & ~h2f_reset & ~ninit_done;

assign                 system_clk_100   = fpga_clk_100;

assign                 system_clk_100_internal  = system_clk_100;




// Todo no longer needed
//wire [31:0]            f2h_irq1_irq;
wire                   o_pma_cpu_clk;

// Todo no longer needed
//assign                 f2h_irq1_irq    = {32'b0};

// Qsys Top module
qsys_top soc_inst (
.clk_100_clk                               (system_clk_100_internal),
.ninit_done_ninit_done                     (ninit_done),

.emif_hps_emif_mem_0_mem_ck_t              (emif_hps_emif_mem_0_mem_ck_t),
.emif_hps_emif_mem_0_mem_ck_c              (emif_hps_emif_mem_0_mem_ck_c),
.emif_hps_emif_mem_0_mem_a                 (emif_hps_emif_mem_0_mem_a),
.emif_hps_emif_mem_0_mem_act_n             (emif_hps_emif_mem_0_mem_act_n),
.emif_hps_emif_mem_0_mem_ba                (emif_hps_emif_mem_0_mem_ba),
.emif_hps_emif_mem_0_mem_bg                (emif_hps_emif_mem_0_mem_bg),
.emif_hps_emif_mem_0_mem_cke               (emif_hps_emif_mem_0_mem_cke),
.emif_hps_emif_mem_0_mem_cs_n              (emif_hps_emif_mem_0_mem_cs_n),
.emif_hps_emif_mem_0_mem_odt               (emif_hps_emif_mem_0_mem_odt),
.emif_hps_emif_mem_0_mem_reset_n           (emif_hps_emif_mem_0_mem_reset_n),
.emif_hps_emif_mem_0_mem_par               (emif_hps_emif_mem_0_mem_par),
.emif_hps_emif_mem_0_mem_alert_n           (emif_hps_emif_mem_0_mem_alert_n),
.emif_hps_emif_mem_0_mem_dqs_t             (emif_hps_emif_mem_0_mem_dqs_t),
.emif_hps_emif_mem_0_mem_dqs_c             (emif_hps_emif_mem_0_mem_dqs_c),
.emif_hps_emif_mem_0_mem_dq                (emif_hps_emif_mem_0_mem_dq),
.emif_hps_emif_oct_0_oct_rzqin             (emif_hps_emif_oct_0_oct_rzqin),
.emif_hps_emif_ref_clk_0_clk               (emif_hps_emif_ref_clk_0_clk),
.hps_io_jtag_tck                           (hps_jtag_tck),                
.hps_io_jtag_tms                           (hps_jtag_tms),                
.hps_io_jtag_tdo                           (hps_jtag_tdo),                 
.hps_io_jtag_tdi                           (hps_jtag_tdi),    
.hps_io_emac2_tx_clk                       (hps_emac2_TX_CLK),      
.hps_io_emac2_rx_clk                       (hps_emac2_RX_CLK),  
.hps_io_emac2_tx_ctl                       (hps_emac2_TX_CTL),     
.hps_io_emac2_rx_ctl                       (hps_emac2_RX_CTL),  
.hps_io_emac2_txd0                         (hps_emac2_TXD0),        
.hps_io_emac2_txd1                         (hps_emac2_TXD1),  
.hps_io_emac2_rxd0                         (hps_emac2_RXD0),   
.hps_io_emac2_rxd1                         (hps_emac2_RXD1),     
.hps_io_emac2_pps                          (hps_emac2_PPS),      
.hps_io_emac2_pps_trig                     (hps_emac2_PPS_TRIG), 
.hps_io_emac2_txd2                         (hps_emac2_TXD2),      
.hps_io_emac2_txd3                         (hps_emac2_TXD3),  
.hps_io_emac2_rxd2                         (hps_emac2_RXD2),     
.hps_io_emac2_rxd3                         (hps_emac2_RXD3),   
.hps_io_mdio2_mdio                         (hps_emac2_MDIO),  
.hps_io_mdio2_mdc                          (hps_emac2_MDC),  
.hps_io_sdmmc_cclk                         (hps_sdmmc_CCLK),   
.hps_io_sdmmc_cmd                          (hps_sdmmc_CMD), 
.hps_io_sdmmc_data0                        (hps_sdmmc_D0),          
.hps_io_sdmmc_data1                        (hps_sdmmc_D1),          
.hps_io_sdmmc_data2                        (hps_sdmmc_D2),         
.hps_io_sdmmc_data3                        (hps_sdmmc_D3),        
.hps_io_sdmmc_wprot                        (hps_sdmmc_WPROT),
.hps_io_i3c1_sda                           (hps_i3c1_SDA),     
.hps_io_i3c1_scl                           (hps_i3c1_SCL),
.hps_io_uart0_rx                           (hps_uart0_RX),          
.hps_io_uart0_tx                           (hps_uart0_TX), 
.o_pma_cu_clk_clk                          (o_pma_cpu_clk),
.hps_io_usb1_clk                           (hps_usb1_CLK), 
.hps_io_usb1_stp                           (hps_usb1_STP), 
.hps_io_usb1_dir                           (hps_usb1_DIR),
// Todo clarify for NXT or NXR
.hps_io_usb1_nxt                           (hps_usb1_NXT),
.hps_io_usb1_data0                         (hps_usb1_DATA0),
.hps_io_usb1_data1                         (hps_usb1_DATA1), 
.hps_io_usb1_data2                         (hps_usb1_DATA2), 
.hps_io_usb1_data3                         (hps_usb1_DATA3), 
.hps_io_usb1_data4                         (hps_usb1_DATA4), 
.hps_io_usb1_data5                         (hps_usb1_DATA5),
.hps_io_usb1_data6                         (hps_usb1_DATA6), 
.hps_io_usb1_data7                         (hps_usb1_DATA7),
.usb31_io_vbus_det                         (usb31_io_vbus_det), 
.usb31_io_flt_bar                          (usb31_io_flt_bar),                   
.usb31_io_usb_ctrl                         (usb31_io_usb_ctrl),
.usb31_io_usb31_id                         (usb31_io_usb31_id),                  
.usb31_phy_refclk_p_clk                    (usb31_phy_refclk_p_clk),             
//.usb31_phy_refclk_n_clk                    (usb31_phy_refclk_p_clk(n)),             
.usb31_phy_rx_serial_n_i_rx_serial_n       (usb31_phy_rx_serial_n_i_rx_serial_n),
.usb31_phy_rx_serial_p_i_rx_serial_p       (usb31_phy_rx_serial_p_i_rx_serial_p),
.usb31_phy_tx_serial_n_o_tx_serial_n       (usb31_phy_tx_serial_n_o_tx_serial_n),
.usb31_phy_tx_serial_p_o_tx_serial_p       (usb31_phy_tx_serial_p_o_tx_serial_p),
.usb31_phy_pma_cpu_clk_clk                 (o_pma_cpu_clk),
.hps_io_gpio0                          (hps_gpio0_io0),
.hps_io_gpio1                          (hps_gpio0_io1),
.hps_io_gpio11                          (hps_gpio0_io11),
.hps_io_gpio27                          (hps_gpio1_io3),
// Todo nolonger export to top 
//.f2h_irq1_irq                              (f2h_irq1_irq),
.hps_io_hps_osc_clk                        (hps_osc_clk),

//.h2f_reset_reset                           (h2f_reset),

.reset_reset_n                             (system_reset_n)
); 

// debounce fpga_reset_n
debounce fpga_reset_n_debounce_inst (
.clk                                       (system_clk_100_internal),
.reset_n                                   (~ninit_done),
.data_in                                   (fpga_reset_n),
.data_out                                  (fpga_reset_n_debounced_wire)
);
defparam fpga_reset_n_debounce_inst.WIDTH = 1;
defparam fpga_reset_n_debounce_inst.POLARITY = "LOW";
defparam fpga_reset_n_debounce_inst.TIMEOUT = 10000;               // at 100Mhz this is a debounce time of 1ms
defparam fpga_reset_n_debounce_inst.TIMEOUT_WIDTH = 32;            // ceil(log2(TIMEOUT))

always @ (posedge system_clk_100_internal or posedge ninit_done)
begin
    if (ninit_done == 1'b1)
        fpga_reset_n_debounced <= 1'b0;
    else
        fpga_reset_n_debounced <= fpga_reset_n_debounced_wire;  
end



endmodule


