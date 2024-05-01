// Code your design here
`include "dsi_reg_block.svh"
`include "dsi_clk_gen.sv"
`include "line_fifo.sv"
`include "ecc_gen.sv"
`include "crc_gen.sv"
`include "packetizer.sv"
`include "lane_manager.sv"
parameter [31:0]addr[13]={'h4000_0000,'h4000_0020, 'h4000_0024, 'h4000_0028, 'h4000_002C, 'h4000_0030, 'h4000_0034, 'h4000_0038, 'h4000_003C, 'h4000_0040, 'h4000_0060, 'h4000_0064, 'h4000_0068};
module dsi#(FRAME_LENGTH=1280, FRAME_WIDTH=720)
  			(input	[31:0]		haddr,
  			input				hwrite, 
           	input	[2:0]		hsize,   
           	input	[2:0]		hburst,
           	input	[1:0]		htrans,
           	input	[31:0]		hwdata,
           	input	[3:0]		hprot,
           	output	reg [1:0]	hresp,
  			output	reg			hready,
           
           	input 	[23:0] 		pixel_data,
  		   	input				data_valid,
  		   	input				hsync,
  			input				vsync,
           
            input				pclk,
           	output	reg			dsi_clk,
           	input				dsi_rst,
            output	reg [7:0]	ppi_data_lane0,
            output	reg [7:0]	ppi_data_lane1,
            output	reg [7:0]	ppi_data_lane2,
            output	reg [7:0]	ppi_data_lane3,
            output	reg			ppi_lane0_en,
            output	reg			ppi_lane1_en,
            output	reg			ppi_lane2_en,
            output	reg			ppi_lane3_en
			);
  
  assign hready = 1;
  
  reg [7:0]  ecc;
  reg [15:0] crc;
  reg [31:0] header;
  reg [15:0] WC;
  //reg reg_done;
  reg fifo_done;
  reg ecc_done;
  reg crc_done;
  reg packet_done;
  reg lane_done;
  
  dsi_reg_block dsi_reg;
  
  initial begin
    dsi_reg=new();
  end
  
  reg [(FRAME_LENGTH*24)-1:0] payload;
  reg [FRAME_LENGTH*24+80-1:0] long_packet;
  reg [63:0] short_packet;
  
  dsi_clk_gen gen_dsi_clk (.pclk(pclk),
                           .dsi_clk(dsi_clk)
                 		  );
  
  line_fifo gen_payload(.pclk(pclk),
                        .WC(WC),
                        .pixel_data(pixel_data),
                        .data_valid(data_valid),
                        //.reg_done(reg_done),
                        .payload(payload),
                        .fifo_done(fifo_done)
                		);

  ecc_gen gen_ecc(.dsi_clk(dsi_clk),
                  .payload(payload),
                  .fifo_done(fifo_done),
                  .ecc(ecc),
                  .ecc_done(ecc_done)
             	  );
  
  crc_gen gen_crc(.dsi_clk(dsi_clk),
                  .payload(payload),
                  .fifo_done(fifo_done),
                  .crc(crc),
                  .crc_done(crc_done)
             	  );
  
  packetizer packet(.dsi_clk(dsi_clk),
                    .WC(WC),
                    .payload(payload),
                    .ecc(ecc),
                    .crc(crc),
                    .fifo_done(fifo_done),
                    .ecc_done(ecc_done),
                    .crc_done(crc_done),
                    .short_packet(short_packet),
                    .long_packet(long_packet),
                    .packet_done(packet_done)
                 	);
  
  lane_manager lane_manage (.dsi_clk(dsi_clk),
               				.short_packet(short_packet),
               				.long_packet(long_packet),
                            .packet_done(packet_done),
               				.ppi_data_lane0(ppi_data_lane0),
               				.ppi_data_lane1(ppi_data_lane1),
               				.ppi_data_lane2(ppi_data_lane2),
                            .ppi_data_lane3(ppi_data_lane3),
                            .lane_done(lane_done)
               				);
  always@(posedge pclk or negedge dsi_rst)
    begin
      if(~dsi_rst) begin
//***************************************************
//    Uncomment the below lines for front door access
//***************************************************
        dsi_reg.payload		= 0;
        dsi_reg.dsi_cmd		= 0;
        dsi_reg.dsi_lng		= 0;
        dsi_reg.dsi_ctrl0	= 0;
        dsi_reg.dsi_ctrl1	= 0;
        dsi_reg.dsi_ctrl2	= 0;
        dsi_reg.dsi_ctrl3	= 0;
        dsi_reg.dsi_ctrl4	= 0;
        dsi_reg.dsi_ctrl5	= 0;
        dsi_reg.rx_cmd_data = 0;
        dsi_reg.rx_cmd		= 0;
        dsi_reg.rd_cmd_wc   = 0;
        dsi_reg.rd_cmd_err  = 0;
      end
      else begin
      	case(haddr)
          addr[1]: begin dsi_reg.payload	= hwdata;	hresp = 0; end
          addr[2]: begin dsi_reg.dsi_cmd	= hwdata;	hresp = 0; end
          addr[3]: begin dsi_reg.dsi_lng	= hwdata;	hresp = 0; end
          addr[4]: begin dsi_reg.dsi_ctrl0	= hwdata;	hresp = 0; end
          addr[5]: begin dsi_reg.dsi_ctrl1	= hwdata;	hresp = 0; end
          addr[6]: begin dsi_reg.dsi_ctrl2	= hwdata;	hresp = 0; end
          addr[7]: begin dsi_reg.dsi_ctrl3	= hwdata;	hresp = 0; end
          addr[8]: begin dsi_reg.dsi_ctrl4	= hwdata;	hresp = 0; end
          addr[9]: begin dsi_reg.dsi_ctrl5	= hwdata;	hresp = 0; end
      	endcase
//         reg_done=1;
//         @(posedge pclk);
//         reg_done=0;
      end
    end
  
//   always@(posedge pclk or negedge dsi_rst)
//     begin
//       if(lane_done) begin
//         @(posedge dsi_clk);
//         fifo_done=0; 
//         ecc_done=0;
//         crc_done=0;
//         packet_done=0;
//         lane_done=0;
//       end
//     end
endmodule