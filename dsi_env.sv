class dsi_env extends uvm_env;
  `uvm_component_utils(dsi_env)
  
  dsi_env_cfg ecfg;
  dsi_scoreboard sb;
  dsi_vseqr vseqrh;
  pixel_agent pixel_agenth;
  ppi_agent ppi_agenth;
  ahb_agent ahb_agenth;
  
  function new(string name="dsi_env",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    if(!uvm_config_db#(dsi_env_cfg)::get(this,"","dsi_env_cfg",ecfg))
      `uvm_fatal("dsi_env_cfg","not getting from env_cfg")
      if(ecfg.has_ahb_agent)
        begin
          uvm_config_db#(ahb_config)::set(this,"*","ahb_config",ecfg.ahb_cfg);
        //  `uvm_fatal("env_cfg","setting the env_cfg")
          ahb_agenth= ahb_agent::type_id::create("ahb_agenth",this);
        end
    if(ecfg.has_pixel_agent)
      begin
        uvm_config_db#(pixel_cfg)::set(this,"*","pixel_cfg",ecfg.pcfg);
       // `uvm_fatal("pixel_cfg","not getting pixel_config")
        pixel_agenth=pixel_agent::type_id::create("pixel_agenth",this);
      end
    if(ecfg.has_ppi_agent)
      begin
        uvm_config_db#(ppi_cfg)::set(this,"*","ppi_cfg",ecfg.ppi_cfgh);
      //  `uvm_fatal("ppi_cfg","not getting ppi_config")
        ppi_agenth=ppi_agent::type_id::create("ppi_agenth",this);
      end
    if(ecfg.has_vseqr)
      vseqrh =dsi_vseqr::type_id::create("vseqrh",this);
    if(ecfg.has_scoreboard)
      sb=dsi_scoreboard::type_id::create("sb",this);
      super.build_phase(phase);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    if(ecfg.has_vseqr)
      begin
     if(ecfg.has_ahb_agent)
          vseqrh.ahb_seqrh=ahb_agenth.seqrh;
      if(ecfg.has_pixel_agent)
          vseqrh.pixel_seqrh=pixel_agenth.pseqr;
      end
    if(ecfg.has_scoreboard)
          begin
            pixel_agenth.pmon.pixel_mport.connect(sb.pixel_fifo.analysis_export);
            ppi_agenth.ppi_monh.ppi_mport.connect(sb.ppi_fifo.analysis_export);
          end
  endfunction
endclass
