module dsi_clk_gen(input pclk,
                   
                   output reg dsi_clk               
        		   );
  
  reg [2:0]	 DIV;
  reg [31:0] start_time;
  reg [31:0] end_time;
  reg [31:0] pclk_tp;
  reg [31:0] dsi_clk_tp;
  
  initial dsi_clk=0;
  
  always@(posedge pclk)
    begin
      case (dsi.dsi_reg.dsi_ctrl0[1:0]) 
        2'b00: DIV=1; 
        2'b01: DIV=2;
        2'b10: DIV=3;
        2'b11: DIV=4;
        
      endcase 
    
    @(posedge pclk);
    start_time 	= $time;
    @(posedge pclk);
    end_time	= $time;  
    pclk_tp		= end_time - start_time;
    dsi_clk_tp=(pclk_tp/3)*DIV;
    
    forever #(dsi_clk_tp/2) dsi_clk = ~ dsi_clk;
      
    end
endmodule