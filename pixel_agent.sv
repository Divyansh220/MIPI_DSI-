class pixel_agent extends uvm_agent;
  `uvm_component_utils(pixel_agent)
 
  pixel_cfg  pcfg;
  pixel_mon  pmon;
  pixel_drv  pdrv;
  pixel_seqr pseqr;
  
  function new(string name="pixel_agent",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    if(!uvm_config_db#(pixel_cfg)::get(this,"","pixel_cfg",pcfg))
    `uvm_fatal("pixel_cfg","not getting config in pixel_agent")
    super.build_phase(phase);
    
    pmon=pixel_mon::type_id::create("pmon",this);
    if(pcfg.is_active==UVM_ACTIVE);
    	begin
          pdrv = pixel_drv::type_id::create("pdrv",this);
          pseqr=pixel_seqr::type_id::create("pseqr",this);
        end
  endfunction
  
  function void connect_phase(uvm_phase phase);
    if(pcfg.is_active==UVM_ACTIVE)
      begin
        pdrv.seq_item_port.connect(pseqr.seq_item_export);
      end
  endfunction
endclass
  