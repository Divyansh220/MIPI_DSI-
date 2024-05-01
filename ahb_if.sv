interface ahb_if (input bit clk);
  logic [31:0]haddr;
  logic hwrite;
  logic [2:0]hsize;
  logic [2:0]hburst;
  logic [1:0]htrans;
  logic [31:0]hwdata;
  logic [3:0]hprot;
  logic [1:0]hresp;
  logic hready;
  
  clocking ahb_drv_cb@(posedge clk);
    default input #1 output #1;
    input hresp;
    input hready;
    output haddr;
    output hwrite;
    output hsize;
    output hburst;
    output hwdata;
    output htrans;
  endclocking
  
  clocking ahb_mon_cb@(posedge clk);
    default input #1 output #1;
    input haddr;
    input hwrite;
    input hsize;
    input hburst;
    input htrans;
    input hwdata;
    input hprot;
    input hresp;
    input hready;
  endclocking
  
  //	modport ahb_drv_mp@(clocking ahb_drv_cb);
    //modport ahb_mon_mp@(clocking ahb_mon_cb);

endinterface
      
     
    
  