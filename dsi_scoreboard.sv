class dsi_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(dsi_scoreboard)
  
 pixel_trans pxtn;
  ppi_trans ppi_xtn;
  //ppi_mon ppi_monh;
  
  
   
  uvm_tlm_analysis_fifo#(pixel_trans)pixel_fifo;
  uvm_tlm_analysis_fifo#(ppi_trans)ppi_fifo;
  
  covergroup pixel_cg;
    h: coverpoint hsync;
    v: coverpoint vsync;
    dv: coverpoint data_valid;
  endgroup
  
  covergroup pixel_data_cg with function sample(bit [23:0]a);
    pd: coverpoint a{
      bins low= {[24'h0: 24']} }
  endgroup
  
  function new(string name="dsi_scoreboard",uvm_component parent);
    super.new(name,parent);
    pixel_fifo =new("pixel_fifo",this);
    ppi_fifo =new("ppi_fifo",this);
  endfunction 
  
  task run_phase (uvm_phase phase);
    forever
      begin
        pixel_fifo.get(pxtn);
        $display("receiving data in scoreboard from pixel %s",pxtn.sprint());
        ppi_fifo.get(ppi_xtn);
        $display("receiving data in scoreboard from ppi %s",ppi_xtn.sprint());
       compare();
       end
    endtask
    
    task compare();
      begin
        if(pxtn.pixel_data==ppi_xtn.data)
          `uvm_info("scoreboard","data_matched",UVM_MEDIUM)
    else
           `uvm_info("scoreboard","data_mismatched",UVM_MEDIUM)
      end
    
  endtask
      
endclass