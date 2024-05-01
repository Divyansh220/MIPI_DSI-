class ppi_agent extends uvm_agent;
  `uvm_component_utils(ppi_agent)
   
  ppi_cfg ppi_cfgh;
  ppi_mon ppi_monh;
  
  function new(string name="ppi_agent",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    if(!uvm_config_db#(ppi_cfg)::get(this,"","ppi_cfg",ppi_cfgh))
      `uvm_fatal("ppi_cfg","not getting config in ppi_agent")
      super.build_phase(phase);
    ppi_monh=ppi_mon::type_id::create("ppi_monh",this);
  endfunction
  
endclass