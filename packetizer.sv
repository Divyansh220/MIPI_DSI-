module packetizer(input 							dsi_clk,
                  input [15:0] 						WC,
                  input [(dsi.FRAME_LENGTH*24)-1:0] payload,
                  input [7:0] 						ecc,
                  input [15:0] 						crc,
                  input								fifo_done,
                  input								ecc_done,
                  input								crc_done,
                  output reg [63:0] 				short_packet,
                  output reg [dsi.FRAME_LENGTH*24+80-1:0] 	long_packet,
                  output reg 						packet_done
                 );
  
  reg [31:0] header;
  initial begin
    short_packet	= 0;
    long_packet		= 0;
    packet_done		= 0;
  end
//   final begin
//     packet_done=1;
//   end
//   task gen_header();
//     header={dsi.dsi_reg.dsi_cmd[8:1],dsi.dsi_reg.dsi_lng[16:1],ecc};
//   endtask
  
//   task send_short_packet();
//     short_packet={8'h1,8'hFF,dsi.dsi_reg.dsi_cmd[8:1],16'b0,ecc,8'hFF,8'h1};
//   endtask
  
//   task send_long_packet();
//     gen_header;
//     long_packet={8'h1,8'hFF,header,payload,crc,8'hFF,8'h1};
//   endtask
  
  always@(posedge dsi_clk)
  begin
    fork
      forever begin
        @(posedge dsi_clk);
        if(fifo_done==1)
          break;
        end
      forever begin
        @(posedge dsi_clk);
        if(ecc_done==1)
          break;
        end
      forever begin
        @(posedge dsi_clk);
        if(crc_done==1)
          break;
        end
    join
    //if(dsi.dsi_reg.dsi_cmd[0]==0) begin
    short_packet={8'h1,8'hFF,ecc,16'hCAFE,dsi.dsi_reg.dsi_cmd[8:1],8'hFF,8'h1};
    //end
    //else begin
      header={ecc,dsi.dsi_reg.dsi_lng[16:1],dsi.dsi_reg.dsi_cmd[8:1]};
      long_packet={8'h81,8'hFF,crc,payload,header,8'hFF,8'h81};
    //$display(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>",header,ecc);
    //end
    @(posedge dsi_clk);
    packet_done=1;
    @(posedge dsi_clk);
    packet_done=0;
  end
endmodule