module advance_4
(
    input                               clk_i                       
    ,input           rst_i
    ,input           inport_awvalid_i
    ,input  [ 31:0]  inport_awaddr_i
    ,input  [  3:0]  inport_awid_i
    ,input  [  7:0]  inport_awlen_i
    ,input  [  1:0]  inport_awburst_i
    ,input           inport_wvalid_i
    ,input  [ 31:0]  inport_wdata_i
    ,input  [  3:0]  inport_wstrb_i
    ,input           inport_wlast_i
    ,input           inport_bready_i
    ,input           inport_arvalid_i
    ,input  [ 31:0]  inport_araddr_i
    ,input  [  3:0]  inport_arid_i
    ,input  [  7:0]  inport_arlen_i
    ,input  [  1:0]  inport_arburst_i
    ,input           inport_rready_i
    ,input  [ 15:0]  sram_data_in_i
    ,output          inport_awready_o
    ,output          inport_wready_o
    ,output          inport_bvalid_o
    ,output [  1:0]  inport_bresp_o
    ,output [  3:0]  inport_bid_o
    ,output          inport_arready_o
    ,output          inport_rvalid_o
    ,output [ 31:0]  inport_rdata_o
    ,output [  1:0]  inport_rresp_o
    ,output [  3:0]  inport_rid_o
    ,output          inport_rlast_o
    ,output [ 31:0]  sram_address_o
    ,output [ 15:0]  sram_data_out_o
    ,output          sram_oe_n_o
    ,output          sram_cs_n_o
    ,output [  1:0]  sram_be_n_o
    ,output          sram_we_n_o
);

    parameter                           WRITE_WAIT_CYCLES          = 4'd7  ;
    parameter                           READ_WAIT_CYCLES           = 4'd7  ;
    parameter                           WRITE_HOLD_CYCLES          = 4'd7  ;

    wire               [  31: 0]        ram_addr_w                  ;
    wire               [   3: 0]        ram_wr_w                    ;
    wire                                ram_rd_w                    ;
    wire                                ram_accept_w                ;
    wire               [  31: 0]        ram_write_data_w            ;
    wire               [  31: 0]        ram_read_data_w             ;
    wire                                ram_ack_w                   ;

    wire                                ram_req_w                 =(ram_wr_w != 4'b0) | ram_rd_w;

asram16_axi4_pmem
u_axi
(
    .clk_i                              (clk_i                     ),
    .rst_i                              (rst_i                     ),

    .axi_awvalid_i                      (inport_awvalid_i          ),
    .axi_awaddr_i                       (inport_awaddr_i           ),
    .axi_awid_i                         (inport_awid_i             ),
    .axi_awlen_i                        (inport_awlen_i            ),
    .axi_awburst_i                      (inport_awburst_i          ),
    .axi_wvalid_i                       (inport_wvalid_i           ),
    .axi_wdata_i                        (inport_wdata_i            ),
    .axi_wstrb_i                        (inport_wstrb_i            ),
    .axi_wlast_i                        (inport_wlast_i            ),
    .axi_bready_i                       (inport_bready_i           ),
    .axi_arvalid_i                      (inport_arvalid_i          ),
    .axi_araddr_i                       (inport_araddr_i           ),
    .axi_arid_i                         (inport_arid_i             ),
    .axi_arlen_i                        (inport_arlen_i            ),
    .axi_arburst_i                      (inport_arburst_i          ),
    .axi_rready_i                       (inport_rready_i           ),
    .axi_awready_o                      (inport_awready_o          ),
    .axi_wready_o                       (inport_wready_o           ),
    .axi_bvalid_o                       (inport_bvalid_o           ),
    .axi_bresp_o                        (inport_bresp_o            ),
    .axi_bid_o                          (inport_bid_o              ),
    .axi_arready_o                      (inport_arready_o          ),
    .axi_rvalid_o                       (inport_rvalid_o           ),
    .axi_rdata_o                        (inport_rdata_o            ),
    .axi_rresp_o                        (inport_rresp_o            ),
    .axi_rid_o                          (inport_rid_o              ),
    .axi_rlast_o                        (inport_rlast_o            ),
    .ram_addr_o                         (ram_addr_w                ),
    .ram_accept_i                       (ram_accept_w              ),
    .ram_wr_o                           (ram_wr_w                  ),
    .ram_rd_o                           (ram_rd_w                  ),
    .ram_len_o                          (                          ),
    .ram_write_data_o                   (ram_write_data_w          ),
    .ram_ack_i                          (ram_ack_w                 ),
    .ram_error_i                        (1'b0                      ),
    .ram_read_data_i                    (ram_read_data_w           ) 
);

    reg                [  31: 0]        sram_address_q              ;
    reg                [  15: 0]        sram_data_q                 ;
    reg                                 sram_oe_n_q                 ;
    reg                [   1: 0]        sram_be_n_q                 ;
    reg                                 sram_we_n_q                 ;

    reg                [   3: 0]        state_q                     ;
    reg                [   3: 0]        wait_q                      ;
    localparam                          MEM_IDLE                   = 4'd0  ;
    localparam                          MEM_WRITE_DATA1            = 4'd1  ;
    localparam                          MEM_WRITE_SETUP2           = 4'd2  ;
    localparam                          MEM_WRITE_DATA2            = 4'd3  ;
    localparam                          MEM_READ_DATA1             = 4'd4  ;
    localparam                          MEM_READ_DATA2             = 4'd5  ;
    localparam                          MEM_WAIT_READ1             = 4'd6  ;
    localparam                          MEM_WAIT_READ2             = 4'd7  ;
    localparam                          MEM_WAIT_WRITE1            = 4'd8  ;
    localparam                          MEM_WAIT_HOLD1             = 4'd9  ;
    localparam                          MEM_WAIT_HOLD2             = 4'd10 ;
    localparam                          MEM_WAIT_HOLD3             = 4'd11 ;

    reg                [  31: 0]        data_q                      ;
    reg                [   1: 0]        we_q                        ;
    reg                                 ack_q                       ;

    reg                [   3: 0]        state_next_r                ;
always @ *
begin
   state_next_r = state_q;
   
   case (state_q)
   MEM_IDLE :
   begin
       if ((|ram_wr_w) & ram_req_w)
       begin
           if (WRITE_WAIT_CYCLES != 4'b0000)
                state_next_r = MEM_WAIT_WRITE1;
           else
                state_next_r = MEM_WRITE_DATA1;
       end
       else if (ram_rd_w & ram_req_w)
       begin
           if (READ_WAIT_CYCLES != 4'b0000)
                state_next_r = MEM_WAIT_READ1;
           else
                state_next_r = MEM_READ_DATA1;
       end
   end
         
   MEM_WRITE_DATA1 :
   begin
       if (WRITE_HOLD_CYCLES != 4'b0000)
            state_next_r = MEM_WAIT_HOLD1;
       else
            state_next_r = MEM_WRITE_SETUP2;
   end

   MEM_WRITE_SETUP2 :
   begin
       if (WRITE_WAIT_CYCLES != 4'b0000)
            state_next_r = MEM_WAIT_HOLD2;
       else
            state_next_r = MEM_WRITE_DATA2;
   end

   MEM_WRITE_DATA2 :
   begin
       if (WRITE_HOLD_CYCLES != 4'b0000)
            state_next_r = MEM_WAIT_HOLD3;
       else
          state_next_r   = MEM_IDLE;
   end

   MEM_READ_DATA1 :
   begin
       if (READ_WAIT_CYCLES != 4'b0000)
            state_next_r = MEM_WAIT_READ2;
       else
            state_next_r = MEM_READ_DATA2;
   end

   MEM_READ_DATA2 :
   begin
       if (ram_req_w & ram_rd_w)
       begin
            if (READ_WAIT_CYCLES != 4'b0000)
                state_next_r = MEM_WAIT_READ1;
            else
                state_next_r = MEM_READ_DATA1;
       end
       else
       begin
            state_next_r    = MEM_IDLE;
       end
   end
   MEM_WAIT_READ1 :
   begin
        if (wait_q == 4'b0001)
            state_next_r = MEM_READ_DATA1;
   end
   MEM_WAIT_READ2 :
   begin
        if (wait_q == 4'b0001)
            state_next_r = MEM_READ_DATA2;
   end

   MEM_WAIT_WRITE1 :
   begin
        if (wait_q == 4'b0001)
            state_next_r = MEM_WRITE_DATA1;
   end

   MEM_WAIT_HOLD1 :
   begin
        if (wait_q == 4'b0001)
            state_next_r = MEM_WRITE_SETUP2;
   end

   MEM_WAIT_HOLD2 :
   begin
        if (wait_q == 4'b0001)
            state_next_r = MEM_WRITE_DATA2;
   end

   MEM_WAIT_HOLD3 :
   begin
        if (wait_q == 4'b0001)
            state_next_r = MEM_IDLE;
   end
   default :
        ;
   endcase
end

always @ (posedge clk_i or posedge rst_i)
if (rst_i)
begin
   wait_q         <= 4'b0000;
   state_q        <= MEM_IDLE;
end
else
begin

   state_q <= state_next_r;
   
   case (state_q)
    
   MEM_IDLE :
   begin
       if ((|ram_wr_w) & ram_req_w)
       begin
           wait_q    <= WRITE_WAIT_CYCLES;
       end
       else if (ram_req_w)
       begin
           wait_q    <= READ_WAIT_CYCLES;
       end
   end
       
   MEM_WRITE_DATA1 :
   begin
        wait_q    <= WRITE_HOLD_CYCLES;
   end
        
   MEM_WRITE_DATA2 :
   begin
       wait_q    <= WRITE_HOLD_CYCLES;
   end

   MEM_WRITE_SETUP2 :
   begin
       wait_q    <= WRITE_WAIT_CYCLES;
   end

   MEM_READ_DATA1 :
   begin
       wait_q    <= READ_WAIT_CYCLES;
   end

   MEM_READ_DATA2 :
   begin
        wait_q    <= READ_WAIT_CYCLES;
   end
       
   MEM_WAIT_READ1,
   MEM_WAIT_READ2,
   MEM_WAIT_WRITE1,
   MEM_WAIT_HOLD1,
   MEM_WAIT_HOLD2,
   MEM_WAIT_HOLD3:
   begin
        wait_q    <= wait_q - 4'd1;
   end
   default :
        ;
   endcase
end
 
always @ (posedge clk_i or posedge rst_i)
if (rst_i)
begin
   sram_oe_n_q     <= 1'b1;
   sram_we_n_q     <= 1'b1;
   sram_address_q  <= 32'b0;
   sram_data_q     <= 16'h0000;
   sram_be_n_q     <= 2'b11;
   ack_q           <= 1'b0;
   data_q          <= 32'h00000000;
   we_q            <= 2'b00;
end
else
begin

   ack_q      <= 1'b0;
   
   case (state_q)
  
   MEM_IDLE :
   begin

       if ((|ram_wr_w) & ram_req_w)
       begin
           data_q           <= ram_write_data_w;
           we_q             <= ram_wr_w[3:2];

           sram_address_q   <= {1'b0, ram_addr_w[31:1]};
           sram_data_q      <= ram_write_data_w[15:0];
           sram_be_n_q      <= ~ram_wr_w[1:0];
           sram_we_n_q      <= 1'b0;
       end
       else if (ram_req_w)
       begin
           data_q           <= 32'h00000000;
           we_q             <= 2'b00;

           sram_address_q   <= {1'b0, ram_addr_w[31:1]};
           sram_data_q      <= 16'h0000;
           sram_be_n_q      <= 2'b00;
           sram_we_n_q      <= 1'b1;
           sram_oe_n_q      <= 1'b0;
       end
   end
        
   MEM_WRITE_DATA1 :
   begin

       sram_we_n_q    <= 1'b1;
   end

   MEM_WRITE_SETUP2 :
   begin

       sram_address_q     <= sram_address_q + 32'd1;
       sram_be_n_q        <= ~we_q;
       sram_data_q        <= data_q[31:16];
       sram_we_n_q        <= 1'b0;
   end

   MEM_WRITE_DATA2,
   MEM_WAIT_HOLD3 :
   begin

       sram_we_n_q    <= 1'b1;

       if (state_next_r == MEM_IDLE)
          ack_q        <= 1'b1;
   end

   MEM_READ_DATA1 :
   begin
       sram_oe_n_q    <= 1'b0;
       data_q         <= {16'h0000, sram_data_in_i[15:0]};
       sram_address_q <= sram_address_q + 32'd1;
   end

   MEM_READ_DATA2 :
   begin
       data_q         <= {sram_data_in_i[15:0], data_q[15:0]};
       ack_q          <= 1'b1;
       if (ram_req_w & ram_rd_w)
       begin
           sram_address_q   <= {1'b0, ram_addr_w[31:1]};
       end
       else
       begin
            sram_oe_n_q     <= 1'b1;
       end
   end
   
   default :
   ;
   endcase
end
    assign                              ram_read_data_w             = data_q;
    assign                              ram_accept_w                = ~((state_q != MEM_IDLE) ? ~ack_q : 1'b0);
    assign                              ram_ack_w                   = ack_q;

    assign                              sram_address_o              = sram_address_q;
    assign                              sram_data_out_o             = sram_data_q;
    assign                              sram_oe_n_o                 = sram_oe_n_q;
    assign                              sram_cs_n_o                 = 1'b0;
    assign                              sram_be_n_o                 = sram_be_n_q;
    assign                              sram_we_n_o                 = sram_we_n_q;
endmodule