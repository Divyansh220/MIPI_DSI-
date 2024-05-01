class ahb_agent extends uvm_agent;
  `uvm_component_utils(ahb_agent)
  
  ahb_config ahb_cfg;
  ahb_drv drvh;
  ahb_mon monh;
  ahb_seqr seqrh;
  
  function new(string name = "ahb_agent", uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    if(!uvm_config_db #(ahb_config)::get(this,"","ahb_config",ahb_cfg))
       `uvm_fatal("ahb_cfg","not getting config ");
      super.build_phase(phase);
      
      monh=ahb_mon::type_id::create("monh", this);
    if(ahb_cfg.is_active)
        begin
          drvh=ahb_drv::type_id::create("drvh",this);
          seqrh=ahb_seqr::type_id::create("seqrh",this);
        end
   
  endfunction
     
      function void connect_phase(uvm_phase phase);
        if(ahb_cfg.is_active)
          drvh.seq_item_port.connect(seqrh.seq_item_export);
      endfunction
     
endclass
      
      
      
      