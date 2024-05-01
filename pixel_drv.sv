class pixel_drv extends uvm_driver#(pixel_trans);
  `uvm_component_utils(pixel_drv)
  
  pixel_cfg pcfg;
  virtual pixel_if pif;
  pixel_trans pxtn2;
  
  function new(string name="pixel_drv",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(pixel_cfg)::get(this,"","pixel_cfg",pcfg))
    `uvm_fatal("PIXEL_CFG","not getting config from uvm_driver");
        endfunction
  
  function void connect_phase(uvm_phase phase);
    pif = pcfg.vif;
  endfunction
  
  task run_phase (uvm_phase phase);
    forever
      begin
        seq_item_port.get_next_item(req);
        send_dut(req);
        seq_item_port.item_done();
      end
  endtask
  
  task send_dut(pixel_trans pxtn);
    @(pif.pixel_drv_cb);
    
    repeat(pxtn.number_of_frames)
          begin
           pif.pixel_drv_cb.vsync<=1;
            @(pif.pixel_drv_cb);
           pif.pixel_drv_cb.vsync<=0; 
     
            repeat(pxtn.number_of_lines)
              begin
                @(pif.pixel_drv_cb);
            	pif.pixel_drv_cb.hsync<=1;
           		@(pif.pixel_drv_cb);
           		pif.pixel_drv_cb.hsync<=0;
                repeat(pxtn.hbp)
                  @(pif.pixel_drv_cb);

              	pif.pixel_drv_cb.data_valid<=1;
                pxtn2 = new("pxtn2");
                assert(pxtn2.randomize() with {pxtn2.pixel_data.size == pxtn.pixel_data.size;});
                for(int i=0;i<pxtn2.pixel_data.size;i++)
              	begin
                	pif.pixel_drv_cb.pixel_data<=pxtn2.pixel_data[i];
                	@(pif.pixel_drv_cb);
              	end
                pif.pixel_drv_cb.data_valid<=0; 
                repeat(pxtn.hfp)
                  @(pif.pixel_drv_cb);
                repeat(10)
             @(pif.pixel_drv_cb);
              end
           
          end
    
    `uvm_info("PIXEL_DRIVER",$sformatf("data from pixel driver \n %s",pxtn.sprint()),UVM_LOW)  ;
  endtask
                  
endclass