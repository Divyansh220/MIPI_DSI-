class ahb_drv extends uvm_driver#(ahb_trans);
  `uvm_component_utils(ahb_drv)
  
  ahb_config ahb_cfg;
  virtual ahb_if vif;
  
    function new(string name="ahb_drv",uvm_component parent);
    super.new(name,parent);
    endfunction
  
    function void build_phase(uvm_phase phase);
    super.build_phase(phase);
      if(!uvm_config_db#(ahb_config)::get(this,"","ahb_config",ahb_cfg))
        `uvm_fatal("ahb_config","not getting config from ahb config")
      endfunction
      
     function void connect_phase(uvm_phase phase);
      vif=ahb_cfg.vif;
    endfunction
  
  task run_phase(uvm_phase phase);
    
    while(vif.ahb_drv_cb.hready!==1)
		@(vif.ahb_drv_cb);

	forever
		begin
			seq_item_port.get_next_item(req);
			drive(req);
			seq_item_port.item_done();
		end

	endtask

  task drive(ahb_trans xtn);
		
		`uvm_info("AHB_DRIVER",$sformatf("data from ahb driver \n %s",req.sprint()),UVM_LOW)
		
		vif.ahb_drv_cb.haddr <= xtn.haddr;
		vif.ahb_drv_cb.htrans <= xtn.htrans;
		vif.ahb_drv_cb.hsize <= xtn.hsize;
		vif.ahb_drv_cb.hwrite <= xtn.hwrite;
		@(vif.ahb_drv_cb);

    while(vif.ahb_drv_cb.hready!==1)
		@(vif.ahb_drv_cb);

		vif.ahb_drv_cb.hwdata <= xtn.hwdata;
		
  endtask
endclass