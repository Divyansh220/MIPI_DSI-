module lane_manager(input 				dsi_clk,
                    input 		[63:0] 	short_packet,
                    input [dsi.FRAME_LENGTH*24+80-1:0] long_packet,
                    input				packet_done,
                    output	reg [7:0]	ppi_data_lane0,
                    output	reg [7:0]	ppi_data_lane1,
            		output	reg [7:0]	ppi_data_lane2,
                    output	reg [7:0]	ppi_data_lane3,
                    output	reg			lane_done
                   );
  reg [15:0] WC;
  initial lane_done=0;
//   final begin
//     lane_done=1;
//   end
  always@(posedge dsi_clk)
    begin
      forever begin
        @(posedge dsi_clk);
        if(packet_done==1)
          break;
      end
      WC=(dsi.dsi_reg.dsi_lng[16:1]);
    // WC=96*16;
      $display("WC=%0d",WC);
      @(posedge dsi_clk);
      $display("short_packet=%0h",short_packet);
      $display("long_packet=%0h",long_packet);
//         if(dsi.dsi_reg.dsi_cmd[0]==0) begin
//           for(int i=0; i<(64)/8; i++) begin
//             ppi_data_lane0=short_packet[i*8+:8];
//             @(posedge dsi_clk);
//             $display("ppi_data_lane0=%0h",ppi_data_lane0);
//           end
//           for(int i=0; i<(64)/8; i++) begin
//             ppi_data_lane0=short_packet[i*8+:8];
//             @(posedge dsi_clk);
//           end
//           for(int i=0; i<(64)/8; i++) begin
//             ppi_data_lane0=short_packet[i*8+:8];
//             @(posedge dsi_clk);
//           end
//         end
//         if(dsi.dsi_reg.dsi_cmd[0]==1) begin
//           case (dsi.dsi_reg.dsi_ctrl0[1:0])
//             2'b00: begin
//                    for(int i=0; i<(8+8+32+WC+16+8+8)/8; i++) begin
//                      ppi_data_lane0=long_packet[i*8+:8];
//                      @(posedge dsi_clk);
//                    end
//                  end
//             2'b01: begin
//                    for(int i=0; i<(8+8+8+WC+8+8+8)/8; i=i+2) begin
//                      ppi_data_lane0=long_packet[i*8+:8];
//                      ppi_data_lane1=long_packet[(i+1)*8+:8];
//                      @(posedge dsi_clk);
//                    end
//                  end
//             2'b10: begin
//                    for(int i=0; i<(8+8+8+WC+8+8+8)/8; i=i+3) begin
//                      ppi_data_lane0=long_packet[i*8+:8];
//                      ppi_data_lane1=long_packet[(i+1)*8+:8];
//                      ppi_data_lane2=long_packet[(i+2)*8+:8];
//                      @(posedge dsi_clk);
//                    end
//                  end
//             2'b11: begin  
//                    for(int i=0; i<(8+8+8+WC+8+8+8)/8; i=i+4) begin
//                      ppi_data_lane0=long_packet[i*8+:8];
//                      ppi_data_lane1=long_packet[(i+1)*8+:8];
//                      ppi_data_lane2=long_packet[(i+2)*8+:8];
//                      ppi_data_lane2=long_packet[(i+3)*8+:8];
//                      @(posedge dsi_clk);
//                    end
//                  end
//           endcase
//       end
      $display("..........................................",dsi.dsi_reg.dsi_ctrl0[1:0]);
               
    case (dsi.dsi_reg.dsi_ctrl0[1:0])
      2'b00: begin
        dsi.ppi_lane0_en=1;
        //if(dsi.dsi_reg.dsi_cmd[0]==0) begin
          for(int i=0; i<64/8; i++) begin
            ppi_data_lane0=short_packet[i*8+:8];
            @(posedge dsi_clk);
          end
          for(int i=0; i<64/8; i++) begin
            ppi_data_lane0=short_packet[i*8+:8];
            @(posedge dsi_clk);
          end
          for(int i=0; i<64/8; i++) begin
            ppi_data_lane0=short_packet[i*8+:8];
            @(posedge dsi_clk);
          end
        //end
        //if(dsi.dsi_reg.dsi_cmd[0]==1) begin
        for(int i=0; i<(WC+10); i++) begin
            ppi_data_lane0=long_packet[i*8+:8];
            @(posedge dsi_clk);
          end
        //end
          for(int i=0; i<64/8; i++) begin
            ppi_data_lane0=short_packet[i*8+:8];
            @(posedge dsi_clk);
          end
        dsi.ppi_lane0_en=0;
        @(posedge dsi_clk);
        lane_done=1;
        @(posedge dsi_clk);
        lane_done=0;
      end
      2'b01: begin
        dsi.ppi_lane0_en=1;
        dsi.ppi_lane1_en=1;
        //if(dsi.dsi_reg.dsi_cmd[0]==0) begin
          for(int i=0; i<64/8; i=i+2) begin
            ppi_data_lane0=short_packet[i*8+:8];
            ppi_data_lane1=short_packet[(i+1)*8+:8];
            @(posedge dsi_clk);
          end
          for(int i=0; i<64/8; i=i+2) begin
            ppi_data_lane0=short_packet[i*8+:8];
            ppi_data_lane1=short_packet[(i+1)*8+:8];
            @(posedge dsi_clk);
          end
          for(int i=0; i<64/8; i=i+2) begin
            ppi_data_lane0=short_packet[i*8+:8];
            ppi_data_lane1=short_packet[(i+1)*8+:8];
            @(posedge dsi_clk);
          end
        //end
        //if(dsi.dsi_reg.dsi_cmd[0]==1) begin
          $display("WC=%0d",WC);
        for(int i=0; i<(WC+10); i=i+2) begin
            ppi_data_lane0=long_packet[i*8+:8];
            ppi_data_lane1=long_packet[(i+1)*8+:8];
            
          //$display(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>ppi_data_lane0=%0p",long_packet[i*8+:8]);
          //$display("ppi_data_lane1=%0p",long_packet[(i+1)*8+:8],i);
          @(posedge dsi_clk);
//           if(i==32)
//             break;
          end
        //$display(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>ppi_data_lane0=%0p",ppi_data_lane0);
          $display("ppi_data_lane1=%0p",ppi_data_lane1);
        //end
          for(int i=0; i<64/8; i=i+2) begin
            ppi_data_lane0=short_packet[i*8+:8];
            ppi_data_lane1=short_packet[(i+1)*8+:8];
            @(posedge dsi_clk);
          end
        dsi.ppi_lane0_en=0;
        dsi.ppi_lane1_en=0;
        @(posedge dsi_clk);
        lane_done=1;
        @(posedge dsi_clk);
        lane_done=0;
      end
      2'b10: begin
        dsi.ppi_lane0_en=1;
        dsi.ppi_lane1_en=1;
        dsi.ppi_lane2_en=1;
        //if(dsi.dsi_reg.dsi_cmd[0]==0) begin
          for(int i=0; i<64/8; i=i+3) begin
            ppi_data_lane0=short_packet[i*8+:8];
            ppi_data_lane1=short_packet[(i+1)*8+:8];
            ppi_data_lane2=short_packet[(i+2)*8+:8];
            @(posedge dsi_clk);
          end
          for(int i=0; i<64/8; i=i+3) begin
            ppi_data_lane0=short_packet[i*8+:8];
            ppi_data_lane1=short_packet[(i+1)*8+:8];
            ppi_data_lane2=short_packet[(i+2)*8+:8];
            @(posedge dsi_clk);
          end
          for(int i=0; i<64/8; i=i+3) begin
            ppi_data_lane0=short_packet[i*8+:8];
            ppi_data_lane1=short_packet[(i+1)*8+:8];
            ppi_data_lane2=short_packet[(i+2)*8+:8];
            @(posedge dsi_clk);
          end
        //end
        //if(dsi.dsi_reg.dsi_cmd[0]==1) begin
        for(int i=0; i<(WC+10); i=i+3) begin
            ppi_data_lane0=long_packet[i*8+:8];
            ppi_data_lane1=long_packet[(i+1)*8+:8];
            ppi_data_lane2=long_packet[(i+2)*8+:8];
            @(posedge dsi_clk);
          end
        //end
          for(int i=0; i<64/8; i=i+3) begin
            ppi_data_lane0=short_packet[i*8+:8];
            ppi_data_lane1=short_packet[(i+1)*8+:8];
            ppi_data_lane2=short_packet[(i+2)*8+:8];
            @(posedge dsi_clk);
          end
        dsi.ppi_lane0_en=0;
        dsi.ppi_lane1_en=0;
        dsi.ppi_lane2_en=0;
        @(posedge dsi_clk);
        lane_done=1;
        @(posedge dsi_clk);
        lane_done=0;
      end
      2'b11: begin
        dsi.ppi_lane0_en=1;
        dsi.ppi_lane1_en=1;
        dsi.ppi_lane2_en=1;
        dsi.ppi_lane3_en=1;
        //if(dsi.dsi_reg.dsi_cmd[0]==0) begin
          for(int i=0; i<64/8; i=i+4) begin
            ppi_data_lane0=short_packet[i*8+:8];
            ppi_data_lane1=short_packet[(i+1)*8+:8];
            ppi_data_lane2=short_packet[(i+2)*8+:8];
            ppi_data_lane3=short_packet[(i+3)*8+:8];
            @(posedge dsi_clk);
          end
          for(int i=0; i<64/8; i=i+4) begin
            ppi_data_lane0=short_packet[i*8+:8];
            ppi_data_lane1=short_packet[(i+1)*8+:8];
            ppi_data_lane2=short_packet[(i+2)*8+:8];
            ppi_data_lane3=short_packet[(i+3)*8+:8];
            @(posedge dsi_clk);
          end
          for(int i=0; i<64/8; i=i+4) begin
            ppi_data_lane0=short_packet[i*8+:8];
            ppi_data_lane1=short_packet[(i+1)*8+:8];
            ppi_data_lane2=short_packet[(i+2)*8+:8];
            ppi_data_lane3=short_packet[(i+3)*8+:8];
            @(posedge dsi_clk);
          end
        //end
        //if(dsi.dsi_reg.dsi_cmd[0]==1) begin
        for(int i=0; i<(WC+10); i=i+4) begin
            ppi_data_lane0=long_packet[i*8+:8];
            ppi_data_lane1=long_packet[(i+1)*8+:8];
            ppi_data_lane2=long_packet[(i+2)*8+:8];
            ppi_data_lane3=long_packet[(i+3)*8+:8];
            @(posedge dsi_clk);
          end
        //end
          for(int i=0; i<64/8; i=i+4) begin
            ppi_data_lane0=short_packet[i*8+:8];
            ppi_data_lane1=short_packet[(i+1)*8+:8];
            ppi_data_lane2=short_packet[(i+2)*8+:8];
            ppi_data_lane3=short_packet[(i+3)*8+:8];
            @(posedge dsi_clk);
          end
        dsi.ppi_lane0_en=0;
        dsi.ppi_lane1_en=0;
        dsi.ppi_lane2_en=0;
        dsi.ppi_lane3_en=0;
        @(posedge dsi_clk);
        lane_done=1;
        @(posedge dsi_clk);
        lane_done=0;
      end
    endcase
  end
endmodule