module crc_gen(input 								dsi_clk,
               input [(dsi.FRAME_LENGTH*24)-1:0] 	payload,
               input								fifo_done,
               output reg [15:0]					crc,
               output reg							crc_done
              );
  int i;
  reg [15:0] crc_poly;
  initial begin
    crc=0;
    crc_poly = 16'hCAFE;
    crc_done=0;
  end
//   final begin
//     crc_done=1;
//   end
  always@(posedge dsi_clk) 
    begin
      forever begin
        @(posedge dsi_clk);
        if(fifo_done==1)
          break;
      end
      foreach(payload[i]) begin
        if(crc[15]^payload[i]==1)
          crc={crc[14:0],1'b1}^crc_poly;
        else
          crc={crc[14:0],1'b0};
      end
      @(posedge dsi_clk);
      crc_done=1;
      @(posedge dsi_clk);
      crc_done=0;
   end
endmodule