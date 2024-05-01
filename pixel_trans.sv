class pixel_trans extends uvm_sequence_item;
  `uvm_object_utils(pixel_trans)
  
  rand bit [23:0]pixel_data[];
  rand bit data_valid;
  rand bit hsync;
  rand bit vsync;
  rand bit [1:0] hfp;
  rand bit [1:0] hbp;
  rand int number_of_lines;
  rand int number_of_frames;
  
  static int a;
  
  function void post_randomize();
    a=pixel_data.size;
  endfunction
  
  function new(string name="pixel_trans");
    super.new(name);
  endfunction
  
  //---------------- DO PRINT ------------------//

	function void do_print(uvm_printer printer); 
		
		super.do_print(printer);
      
      foreach(pixel_data[i])
		
      printer.print_field($sformatf("pixel_data[%0d]",i)  , this.pixel_data[i] ,24, UVM_HEX);
      printer.print_field("number_of_lines" , this.number_of_lines , 32 , UVM_DEC);
      printer.print_field("number_of_frames", this.number_of_frames , 32 , UVM_DEC);
		
	
	endfunction

  
endclass
