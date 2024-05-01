module line_fifo(input 					    pclk,
                 input [15:0] 				WC,
                 input [23:0] 				pixel_data,
                 input 						data_valid,
                 //input						reg_done,
                 output reg [(dsi.FRAME_LENGTH*24)-1:0] payload,
                 output reg					fifo_done
                );
  reg [23:0] payload_temp [dsi.FRAME_LENGTH];
  int i,j,k;
  
  initial begin
    i=0;
    j=0;
    k=0;
    fifo_done=0;
    foreach(payload[i])
      payload[i]=0;
    i=0;
    foreach(payload_temp[k])
      payload[k]=0;
    $display("[Line Fifo @%0t] Payload=%0p",$time,pixel_data);
  end
  
  always@(posedge pclk)
    begin
      fork
//         forever begin
//           @(posedge pclk);
//           if(reg_done==1)
//             break;
//         end
        $display("[%0t] data_valid=%0p",$time,data_valid);
        forever begin
          @(posedge pclk);
          if(fifo_done==0)
            break;
        end
        forever begin
          @(posedge pclk);
          $display("[%0t] data_valid=%0p",$time,data_valid);
          if(data_valid==1)
            break;
        end
      join
      $display("[%0t] pixel_data=%0b",$time,pixel_data);
      forever begin
        payload_temp[i]=pixel_data;
        i++;
        @(posedge pclk);
        if(data_valid==0)
          begin
            i=0;
            break;
          end
      end
      $display("[%0t] payload_temp=%0p",$time,payload_temp);
      foreach (payload_temp[j])
        payload[j*24+:24]=payload_temp[j];
      $display("[%0t] payload=%0h",$time,payload);
      fifo_done = 1;
      @(posedge pclk);
      fifo_done = 0;
//       foreach(payload[i])
//         payload[i]=0;
    end
  
endmodule