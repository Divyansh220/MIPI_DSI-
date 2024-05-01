// Code your testbench here
// or browse Examples
module top;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  `include "ahb_if.sv"
  `include "pixel_if.sv"
  `include "ppi_if.sv"
  
  
  `include "ahb_config.sv"
  `include "pixel_cfg.sv"
  `include "ppi_cfg.sv"
  `include "dsi_env_cfg.sv"
  
  `include "ahb_trans.sv"
  `include "ahb_drv.sv"
  `include "ahb_mon.sv"
   `include "ahb_sequence.sv"
  `include "ahb_seqr.sv"
  `include "ahb_agent.sv"
  
  `include "pixel_trans.sv"
  `include "pixel_drv.sv"
  `include "pixel_mon.sv"
  `include "pixel_seqr.sv"
  `include "pixel_sequence.sv"
  `include "pixel_agent.sv"
  
  `include "ppi_trans.sv"
  `include "ppi_mon.sv"
  `include "ppi_agent.sv"

  `include "dsi_vseqr.sv"
  `include "dsi_vsequence.sv"
  `include "dsi_scoreboard.sv"
  `include "dsi_env.sv"
  `include "dsi_test.sv"
  
  bit clk,dsi_clock;
  bit reset;
  always #10 clk =~clk;
  
  initial
    begin
      #15 reset = 1;
    end
   
  ahb_if aif(clk);
  pixel_if pif(clk);
  ppi_if ppi_if0(dsi_clock);
  
  dsi#(160,120) DUT(
    .haddr(aif.haddr),
    .hwrite(aif.hwrite), 
    .hsize(aif.hsize),   
    .hburst(aif.hburst),
    .htrans(aif.htrans),
    .hwdata(aif.hwdata),
    .hprot(aif.hprot),
    .hresp(aif.hresp),
    .hready(aif.hready), 
           
    .pixel_data(pif.pixel_data),
    .data_valid(pif.data_valid),
    .hsync(pif.hsync),
    .vsync(pif.vsync),
    .pclk(clk),
    
    .dsi_clk(dsi_clock),
    .dsi_rst(reset),
    .ppi_data_lane0(ppi_if0.ppi_lane0),
    .ppi_data_lane1(ppi_if0.ppi_lane1),
    .ppi_data_lane2(ppi_if0.ppi_lane2),
    .ppi_data_lane3(ppi_if0.ppi_lane3),
    .ppi_lane0_en(ppi_if0.ppi_lane0_en),
    .ppi_lane1_en(ppi_if0.ppi_lane1_en),
    .ppi_lane2_en(ppi_if0.ppi_lane2_en),
    .ppi_lane3_en(ppi_if0.ppi_lane3_en));
  
  initial
    begin
      $dumpfile("dump.vcd"); $dumpvars;
      uvm_config_db#(virtual ahb_if)::set(null,"*","ahb_if",aif);
      uvm_config_db#(virtual pixel_if)::set(null,"*","pixel_if",pif);
      uvm_config_db#(virtual ppi_if)::set(null,"*","ppi_if",ppi_if0);
      
      run_test("test1");
    end
  
  
endmodule