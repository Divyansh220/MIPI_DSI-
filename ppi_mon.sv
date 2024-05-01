class ppi_mon extends uvm_monitor;
  `uvm_component_utils(ppi_mon)
  
  virtual ppi_if ppi_if0;
  ppi_cfg ppi_cfgh;
  uvm_analysis_port#(ppi_trans) ppi_mport;
  ppi_trans ppi_xtn;
  bit ending =0;
  bit busy=1;
  int lane;
  
    bit [7:0] q[$];
  int k;

  
  function new(string name ="ppi_mon",uvm_component parent);
    super.new(name,parent);
    ppi_mport= new("ppi_mport",this);
  endfunction
  
  function void build_phase(uvm_phase phase);
     super.build_phase(phase);
    if(!uvm_config_db#(ppi_cfg)::get(this,"","ppi_cfg",ppi_cfgh))
      `uvm_fatal("PPI_CFG","not getting config ");
        endfunction
  
  function void connect_phase (uvm_phase phase);
    ppi_if0 = ppi_cfgh.vif;
  endfunction
  
   task run_phase(uvm_phase phase);
     forever 
       begin 
         collect_data();
         if(ending)
           begin
             busy=0;
             phase.drop_objection(this);
           end
       end
   endtask
  
  task collect_data();
    
    
    while(ppi_if0.ppi_mon_cb.ppi_lane0_en==0)
      @(ppi_if0.ppi_mon_cb);
    
    if(ppi_if0.ppi_mon_cb.ppi_lane0_en==1 && ppi_if0.ppi_mon_cb.ppi_lane1_en==1 && ppi_if0.ppi_mon_cb.ppi_lane2_en==1 && ppi_if0.ppi_mon_cb.ppi_lane3_en==1)
    collect_4lanes();
    else if (ppi_if0.ppi_mon_cb.ppi_lane0_en==1 && ppi_if0.ppi_mon_cb.ppi_lane1_en==1 && ppi_if0.ppi_mon_cb.ppi_lane2_en==1)
    collect_3lanes();
    else if(ppi_if0.ppi_mon_cb.ppi_lane0_en==1 &&ppi_if0.ppi_mon_cb.ppi_lane1_en==1)
            collect_2lanes();
    else if(ppi_if0.ppi_mon_cb.ppi_lane0_en==1)
            collect_1lane();

      
 endtask
            
  task collect_4lanes();
              $display("4 lanes are enabled");
  
              
              while(ppi_if0.ppi_mon_cb.ppi_lane0_en==1)//collecting
                begin
                  q.push_back(ppi_if0.ppi_mon_cb.ppi_lane0); //pusing data into queue
                  q.push_back(ppi_if0.ppi_mon_cb.ppi_lane1); 
                  q.push_back(ppi_if0.ppi_mon_cb.ppi_lane2);
                  q.push_back(ppi_if0.ppi_mon_cb.ppi_lane3); 
                  @(ppi_if0.ppi_mon_cb);
                end
              $display("data_collected from ppi_monitor is %p", q);
    lane= 4;
    		send_data();
  endtask
    
              
              
              
              
              
              
             task collect_3lanes();
               $display("3 lanes are enabled");
               while(ppi_if0.ppi_mon_cb.ppi_lane0_en==1)//collecting
                begin
                  q.push_back(ppi_if0.ppi_mon_cb.ppi_lane0); //pusing data into queue
                  q.push_back(ppi_if0.ppi_mon_cb.ppi_lane1); 
                  q.push_back(ppi_if0.ppi_mon_cb.ppi_lane2);
                  @(ppi_if0.ppi_mon_cb);
                end
              $display("data_collected from ppi_monitor is %p", q);
                   lane= 3;

    		send_data();
            endtask
             task collect_2lanes();
               $display("2 lanes are enabled");
               while(ppi_if0.ppi_mon_cb.ppi_lane0_en==1)//collecting
                begin
                  q.push_back(ppi_if0.ppi_mon_cb.ppi_lane0); //pusing data into queue
                  q.push_back(ppi_if0.ppi_mon_cb.ppi_lane1);  
                  @(ppi_if0.ppi_mon_cb);
                end
              $display("data_collected from ppi_monitor is %p", q);
                   lane= 2;
    		send_data();
            endtask
             task collect_1lane();
               $display("1 lane are enabled");
               while(ppi_if0.ppi_mon_cb.ppi_lane0_en==1)//collecting
                begin
                  q.push_back(ppi_if0.ppi_mon_cb.ppi_lane0); //pusing data into queue
                  @(ppi_if0.ppi_mon_cb);
                end
              $display("data_collected from ppi_monitor is %p", q);
                   lane= 1;
    		send_data();
            endtask
  
  task send_data();//processing the data
      k=0;
        ppi_xtn =ppi_trans::type_id::create("ppi_xtn");
    if(lane == 3)
      begin
        for(int i=0;i<30;i=i+1)//removing the short packet to get only payload data
                begin
                  q.pop_front();
                end
      end
    else
      begin
    for(int i=0;i<27;i=i+1)//removing the short packet to get only payload data
                begin
                  q.pop_front();
                end
      end
              ppi_xtn.wc[7:0]= q.pop_front();//word count will be of 2 bytes
              ppi_xtn.wc[15:8]= q.pop_front();
              
              ppi_xtn.ecc[7:0]= q.pop_front();
              ppi_xtn.payload = new[ppi_xtn.wc];//from wc we wre geeting the soze of lpayload
              
              for(int i=0;i<ppi_xtn.payload.size;i++)//payload
                begin
                  ppi_xtn.payload[i]= q.pop_front();                                       
                end
              ppi_xtn.crc[7:0]= q.pop_front();//crc will be of 2 bytes
              ppi_xtn.crc[15:8]= q.pop_front();
              q.delete();
              
              ppi_xtn.data= new[ppi_xtn.wc/3];//payload size is 20*3 =60(wc) bytes & for ppi we need 20 pixel so we divided 60/3 as we are receiving the 20 pixels
              for(int i=0;i<ppi_xtn.data.size;i++)
                begin
                  ppi_xtn.data[i]= {ppi_xtn.payload[k+2],ppi_xtn.payload[k+1],ppi_xtn.payload[k]};//concatenaton of payload in to pixel_data
                  k=k+3;
                end
    ppi_mport.write(ppi_xtn);
    `uvm_info("PPI_MONITOR",$sformatf("Monitored data from the ppi : %s", ppi_xtn.sprint()), UVM_MEDIUM);

    
  endtask
  
//   function void phase_ready_to_end(uvm_phase phase);          
//     if(phase.get_name=="run")
//       begin
//       ending =1;
//         if(busy)
//           phase.raise_objection(this);
        
//       end
//   endfunction
    
endclass