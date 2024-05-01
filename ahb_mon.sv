class ahb_mon extends uvm_monitor;
  `uvm_component_utils(ahb_mon)
  
  ahb_config ahb_cfg;
  
  
  function new(string name="ahb_mon",uvm_component parent);
    super.new(name,parent);
  endfunction
  
 /* function void build_phase(uvm_phase phase)
    super.build_phase(phase);
    if(!uvm_config_db#(ahb_cfg)::get(this,"","ahb_mon",monh));
    `uvm_fatal("not getting config form ahb config ")
  endfunction*/
  
  function void connect_phase(uvm_phase phase);
  endfunction
endclass