class pixel_seqr extends uvm_sequencer#(pixel_trans);
  `uvm_component_utils(pixel_seqr)
  
  pixel_cfg pcfg;
  
  function new(string name="pixel_seqr",uvm_component parent);
    super.new(name,parent);
  endfunction
endclass
