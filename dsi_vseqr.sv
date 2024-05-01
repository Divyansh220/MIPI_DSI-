class dsi_vseqr extends uvm_sequencer#(uvm_sequence_item);
  `uvm_component_utils(dsi_vseqr)
  
  ahb_seqr ahb_seqrh;
  pixel_seqr pixel_seqrh;
  
  function new(string name="dsi_vseqr",uvm_component parent);
    super.new(name,parent);
  endfunction
  
endclass