class pixel_mon extends uvm_monitor;
  `uvm_component_utils(pixel_mon)
  
  virtual pixel_if pif;
  pixel_cfg pcfg;
  uvm_analysis_port#(pixel_trans) pixel_mport;
  pixel_trans pxtn;
  
  function new(string name="pixel_mon",uvm_component parent);
    super.new(name,parent);
    pixel_mport=new("pixel_mport",this);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(pixel_cfg)::get(this,"","pixel_cfg",pcfg))
    `uvm_fatal("PIXEL_CFG","not getting config from uvm_driver");
        endfunction
  function void connect_phase(uvm_phase phase);
    pif = pcfg.vif;
  endfunction
  
  task run_phase(uvm_phase phase);
   forever
      begin
        collect_data();
      end
  endtask
  
  task collect_data();
    pxtn =pixel_trans::type_id::create("pxtn");
    @(pif.pixel_mon_cb);
    wait(pif.pixel_mon_cb.data_valid);
    pxtn.pixel_data = new[pxtn.a];
    //while(pif.pixel_mon_cb.data_valid==1)
    for(int i=0;i<pxtn.pixel_data.size;i=i+1)
      begin
        if(pif.pixel_mon_cb.data_valid==1) 
           pxtn.pixel_data[i]= pif.pixel_mon_cb.pixel_data;
        else
             break;
         @(pif.pixel_mon_cb);
           
      end
    pixel_mport.write(pxtn);
           `uvm_info("PIXEL_MON",$sformatf("data from pixel_monitor \n %s",pxtn.sprint()),UVM_LOW)
           
  endtask
    
endclass