class dsi_test extends uvm_test;
  `uvm_component_utils(dsi_test)
  
  dsi_env_cfg ecfg;
  ahb_config ahb_cfg;
  pixel_cfg pcfg;
  ppi_cfg ppi_cfgh;
  dsi_env envh;
  
  function new(string name="dsi_test",uvm_component parent);
    super.new(name,parent);
    ahb_cfg  = new("ahb_cfg");
    pcfg     = new("pcfg");
    ppi_cfgh = new("ppi_cfgh");
    ecfg     = new("ecfg");
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual ahb_if)::get(this,"","ahb_if",ahb_cfg.vif))
      `uvm_fatal("ahb_if","not getting config");
    ahb_cfg.is_active= UVM_ACTIVE;
    ecfg.ahb_cfg = ahb_cfg;
    
    if(!uvm_config_db#(virtual pixel_if)::get(this,"","pixel_if",pcfg.vif))
      `uvm_fatal("pixel_if","not getting config");
    pcfg.is_active= UVM_ACTIVE;
    ecfg.pcfg = pcfg;
    
    if(!uvm_config_db#(virtual ppi_if)::get(this,"","ppi_if",ppi_cfgh.vif))
      `uvm_fatal("ppi_if","not getting config");
    ppi_cfgh.is_active= UVM_PASSIVE;
    ecfg.ppi_cfgh = ppi_cfgh;
    
    uvm_config_db#(dsi_env_cfg)::set(this,"*","dsi_env_cfg",ecfg);
    envh = dsi_env::type_id::create("envh",this);
  endfunction
 
  function void end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology();
  endfunction
endclass

class test1 extends dsi_test;
  `uvm_component_utils(test1)
  
  vseq1 vseq1h;
  vseq2 vseq2h; 
  
  function new(string name ="test1",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    vseq1h =vseq1::type_id::create("vseq1h");
     vseq2h = vseq2::type_id::create("vseq2h");
    endfunction
  
 task run_phase(uvm_phase phase);
    phase.raise_objection(this);
   vseq1h.start(envh.vseqrh);
    vseq2h.start(envh.vseqrh);
   #100;
    phase.drop_objection(this);
  endtask
endclass
  
/*  class test2 extends dsi_test;
    `uvm_component_utils(test2)
    
    vseq2 vseq2h;
    
    function new(string name="test2",uvm_component parent);
      super.new(name,parent);
      endfunction
    
    function void build_phase(uvm_phase phase);
      super.build_phase (phase);
      vseq2h = vseq2::type_id::create("vseq2h");
    endfunction
    
    task run_phase (uvm_phase phase);
      phase.raise_objection(this);
      vseq2h.start(envh.vseqrh);
      phase.drop_objection(this);
    endtask      
endclass*/
    