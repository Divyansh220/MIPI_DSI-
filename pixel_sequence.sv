class pixel_sequence extends uvm_sequence#(pixel_trans);
  `uvm_object_utils(pixel_sequence)
  
  function new (string name="pixel_sequence");
    super.new(name);
    endfunction
  
endclass

class pixel_seq1 extends pixel_sequence;
  `uvm_object_utils(pixel_seq1)
  
  function new (string name="pixel_seq1");
    super.new(name);
  endfunction
  
  task body();
    req =pixel_trans::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {number_of_frames==2; number_of_lines==5; pixel_data.size==160; hfp != 0; hbp != 0;})
      finish_item(req);
  endtask
     
endclass
      