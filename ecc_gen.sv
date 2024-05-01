module ecc_gen(input dsi_clk,
               input [(dsi.FRAME_LENGTH*24)-1:0] payload,
               input			fifo_done,
               output reg [7:0] ecc,
               output reg		ecc_done
               );
  int i;
  initial begin
    ecc=0;
    ecc_done=0;
  end
//   final begin
//     ecc_done=1;
//   end
  always@(posedge dsi_clk) 
    begin
      forever begin
        @(posedge dsi_clk);
        if(fifo_done==1)
          break;
      end
     // if(dsi.dsi_reg.dsi_cmd[0]==0)
         ecc=8'hba;
       //else 
        // begin
        //foreach(payload[i]) begin
          //ecc=ecc^payload[i];  
        //end
      //end
      @(posedge dsi_clk);
      ecc_done=1;
      @(posedge dsi_clk);
      ecc_done=0;
    end
endmodule