class pixel_cfg extends uvm_object;
  `uvm_object_utils(pixel_cfg)
  
  uvm_active_passive_enum is_active;
  virtual pixel_if vif;
  
  function new(string name="pixel_cfg");
    super.new(name);
  endfunction
  
endclass
  