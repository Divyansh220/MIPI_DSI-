class ahb_sequence extends uvm_sequence#(ahb_trans);
  `uvm_object_utils(ahb_sequence)
  
  function new(string name ="ahb_sequence");
    super.new(name);
  endfunction
  
endclass

class ahb_seq1 extends ahb_sequence;
  `uvm_object_utils(ahb_seq1)
  
  function new(string name="ahb_seq1");
    super.new(name);
  endfunction
  task body();
    req =ahb_trans::type_id::create("req");
    
    start_item(req);
    assert(req.randomize() with {hwrite==1; hsize==3'b010; hburst ==3'b000; htrans ==2'b10; haddr==32'h4000_0000; hwdata==32'h0000_0000;})//payload_register
      finish_item(req);
    
     start_item(req);
    assert(req.randomize()with {hwrite==1;hsize==3'b010;hburst ==3'b000;htrans ==2'b10;haddr==32'h4000_0020;hwdata==32'h0000_0001;})
      finish_item(req);//cmd_register for long packet
    
     start_item(req);
    assert(req.randomize()with {hwrite==1;hsize==3'b010;hburst ==3'b000;htrans ==2'b10;haddr==32'h4000_0024;hwdata==32'h0000_03c0;})
      finish_item(req);//dsi_lng for word count QQVGA
    
     start_item(req);
    assert(req.randomize()with {hwrite==1;hsize==3'b010;hburst ==3'b000;htrans ==2'b10;haddr==32'h4000_0028;hwdata==32'h0000_0003;})
      finish_item(req);//ctrl0_reg for number of lanes by giving hwdata as 03
    
     start_item(req);
    assert(req.randomize()with {hwrite==1;hsize==3'b010;hburst ==3'b000;htrans ==2'b10;haddr==32'h4000_002c;hwdata==32'h0000_0003;})
      finish_item(req);//ctrl_1 reg
    
     start_item(req);
    assert(req.randomize()with {hwrite==1;hsize==3'b010;hburst ==3'b000;htrans ==2'b10;haddr==32'h4000_0030;hwdata==32'h0000_0004;})
      finish_item(req);//ctrl_2 reg
    
       start_item(req);
    assert(req.randomize()with {hwrite==1;hsize==3'b010;hburst ==3'b000;htrans ==2'b10;haddr==32'h4000_0034;hwdata==32'h0000_0005;})
      finish_item(req);//ctrl_3 reg 
    
    start_item(req);
    assert(req.randomize()with {hwrite==1;hsize==3'b010;hburst ==3'b000;htrans ==2'b10;haddr==32'h4000_0038;hwdata==32'h0000_0006;})
      finish_item(req);//ctrl_4 reg
    
    start_item(req);
    assert(req.randomize()with {hwrite==1;hsize==3'b010;hburst ==3'b000;htrans ==2'b10;haddr==32'h4000_0038;hwdata==32'h0003_0000;})
      finish_item(req);//ctrl_5 reg for video_enb & 18 bit loose packet
    
  endtask
endclass
    
    
    
    