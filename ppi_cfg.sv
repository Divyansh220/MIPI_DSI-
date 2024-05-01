class ppi_cfg extends uvm_object;
  `uvm_object_utils(ppi_cfg)
  uvm_active_passive_enum is_active;
  virtual ppi_if vif;
  
  function new(string name= "ppi_cfg");
    super.new(name);
  endfunction
  
endclass