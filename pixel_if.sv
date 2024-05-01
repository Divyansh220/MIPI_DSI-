interface pixel_if(input bit clk);
  logic hsync;
  logic vsync;
  logic [23:0] pixel_data;
  logic data_valid;
  
  clocking pixel_drv_cb@(posedge clk);
    default input #1 output #1;
    output hsync;
    output vsync;
    output pixel_data;
    output data_valid;
  endclocking
  
  clocking pixel_mon_cb@(posedge clk);
    default input #1 output #1;
    input hsync;
    input vsync;
    input pixel_data;
    input data_valid;
  endclocking
  
 //	modport pixel_drv_mp(clocking pixel_drv_cb);
   //   modport pixel_mon_mp(clocking pixel_mon_cb);
      
 endinterface
  
  