class ahb_trans extends uvm_sequence_item;
  `uvm_object_utils(ahb_trans);
  
  rand bit [31:0]haddr;
  rand bit hwrite; 
  rand bit [2:0]hsize;   
  rand bit [2:0]hburst;
  rand bit [1:0]htrans;
  rand bit [31:0]hwdata;
           	
  
  
  function new(string name="ahb_trans");
    super.new(name);
  endfunction
  
  //---------------- DO PRINT ------------------//

	function void do_print(uvm_printer printer); 
		
		super.do_print(printer);
		
      printer.print_field("haddr"  	 , this.haddr     	  , 32 , UVM_HEX);
      printer.print_field("hwdata" 	 , this.hwdata    	  , 32 , UVM_HEX);
      printer.print_field("hsize"  	 , this.hsize     	  , 3  , UVM_HEX);
      printer.print_field("htrans" 	 , this.htrans    	  , 2  , UVM_HEX);
      printer.print_field("hburst" 	 , this.hburst    	  , 3  , UVM_HEX);
      printer.print_field("hwrite" 	 , this.hwrite    	  , 1  , UVM_HEX);
      printer.print_field("hburst"  , this.hburst         , 5  , UVM_HEX);
	
	endfunction

  
endclass