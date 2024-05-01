class ppi_trans extends uvm_sequence_item;
  `uvm_object_utils_begin(ppi_trans)
  `uvm_field_int(wc,UVM_ALL_ON)
  `uvm_field_int(ecc,UVM_ALL_ON)
  `uvm_field_int(crc,UVM_ALL_ON)
  `uvm_field_array_int(payload,UVM_ALL_ON)
  `uvm_field_array_int(data,UVM_ALL_ON)
  `uvm_object_utils_end// no need to write print or compare method , activating all methods 
  
  bit [15:0]wc;
  bit [7:0]ecc;
  bit [7:0]payload[];
  bit [15:0]crc;
  bit [23:0]data[];
  
  
  
  function new(string name="ppi_trans");
    super.new(name);
  endfunction
  
endclass
