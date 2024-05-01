class dsi_vsequence extends uvm_sequence#(uvm_sequence_item);
  `uvm_object_utils(dsi_vsequence);
  
  dsi_vseqr vseqrh;
  ahb_seqr ahb_seqrh;
  pixel_seqr pixel_seqrh;
  
  function new(string name ="dsi_vsequence");
    super.new(name);
  endfunction
  
  task body();
    $cast(vseqrh,m_sequencer);
    ahb_seqrh =vseqrh.ahb_seqrh;
    pixel_seqrh= vseqrh.pixel_seqrh;
  endtask
  
endclass
//ahb_sequence
class vseq1 extends dsi_vsequence;
  `uvm_object_utils(vseq1)
  
  ahb_seq1 ahb_seq1h;
 
  
  function new(string name ="vseq1");
    super.new(name);
  endfunction
  
  task body();
    super.body();
    ahb_seq1h = ahb_seq1::type_id::create("ahb_seq1h");
    ahb_seq1h.start(ahb_seqrh);
  endtask
endclass
  //pixel_sequence

  class vseq2 extends dsi_vsequence;
    `uvm_object_utils(vseq2)
    
    pixel_seq1 pixel_seq1h;
    function new(string name ="vseq2");
      super.new(name);
    endfunction
    
    task body();
      super.body();
      pixel_seq1h =pixel_seq1::type_id::create("pixel_seq1h");
      pixel_seq1h.start(pixel_seqrh);
    endtask
      
  endclass