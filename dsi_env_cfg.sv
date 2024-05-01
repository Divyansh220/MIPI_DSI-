class dsi_env_cfg extends uvm_object;
  `uvm_object_utils(dsi_env_cfg)
  
  bit has_scoreboard =1;
  bit has_ahb_agent =1;
  bit has_pixel_agent =1;
  bit has_ppi_agent =1;
  bit has_vseqr=1;
  
  ahb_config ahb_cfg;
  pixel_cfg pcfg;
  ppi_cfg ppi_cfgh;
  
  function new(string name="dsi_env_cfg");
    super.new(name);
  endfunction
  
endclass