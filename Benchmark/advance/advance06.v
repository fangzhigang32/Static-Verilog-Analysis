module advance06
#(
    parameter                           CLK_DIV                    = 2     ,   
    parameter                           LITTLE_ENDIAN              = 1     ,   
    parameter                           ADDR_W                     = 32    ,
    parameter                           GP_OUTPUTS                 = 8     ,    
    parameter                           GP_INPUTS                  = 8     ,  
    parameter                           GP_IN_EVENT_MASK           = 8'h00 
)
(
    input                               clk_i                      ,
    input                               rst_i                      ,
    input                               ftdi_rxf_i                 ,
    input                               ftdi_txe_i                 ,
    output                              ftdi_siwua_o               ,
    output                              ftdi_wr_o                  ,
    output                              ftdi_rd_o                  ,
    inout              [   7: 0]        ftdi_d_io                  ,
    output             [GP_OUTPUTS-1: 0]        gp_o                       ,
    input              [GP_INPUTS-1: 0]        gp_i                       ,
    output             [ADDR_W-1: 0]        mem_addr_o                 ,
    output             [  31: 0]        mem_data_o                 ,
    input              [  31: 0]        mem_data_i                 ,
    output             [   3: 0]        mem_sel_o                  ,
    output reg                          mem_we_o                   ,
    output reg                          mem_stb_o                  ,
    output                              mem_cyc_o                  ,
    input                               mem_ack_i                  ,
    input                               mem_stall_i                 
);

    localparam                          CMD_NOP                    = 4'd0  ;
    localparam                          CMD_WR                     = 4'd1  ;
    localparam                          CMD_RD                     = 4'd2  ;
    localparam                          CMD_GP_WR                  = 4'd3  ;
    localparam                          CMD_GP_RD                  = 4'd4  ;
    localparam                          CMD_GP_RD_CLR              = 4'd5  ;

`define CMD_R               3:0
`define LEN_UPPER_R         7:4
`define LEN_LOWER_R         7:0

    localparam                          LEN_W                      = 12    ;

    localparam                          DATA_W                     = 8     ;

    localparam                          STATE_W                    = 4     ;
    localparam                          STATE_IDLE                 = 4'd0  ;
    localparam                          STATE_CMD                  = 4'd1  ;
    localparam                          STATE_LEN                  = 4'd2  ;
    localparam                          STATE_ADDR0                = 4'd3  ;
    localparam                          STATE_ADDR1                = 4'd4  ;
    localparam                          STATE_ADDR2                = 4'd5  ;
    localparam                          STATE_ADDR3                = 4'd6  ;
    localparam                          STATE_WRITE                = 4'd7  ;
    localparam                          STATE_READ                 = 4'd8  ;
    localparam                          STATE_DATA0                = 4'd9  ;
    localparam                          STATE_DATA1                = 4'd10 ;
    localparam                          STATE_DATA2                = 4'd11 ;
    localparam                          STATE_DATA3                = 4'd12 ;
    localparam                          STATE_GP_WR                = 4'd13 ;
    localparam                          STATE_GP_RD                = 4'd14 ;

    wire               [DATA_W-1: 0]        data_tx_w                   ;
    wire               [DATA_W-1: 0]        data_rx_w                   ;
    wire                                wr_w                        ;
    wire                                rd_w                        ;
    wire                                wr_accept_w                 ;
    wire                                rx_ready_w                  ;

    reg                [STATE_W-1: 0]        state_q                     ;
    reg                [LEN_W-1: 0]        len_q                       ;
    reg                [  31: 0]        mem_addr_q                  ;
    reg                                 mem_cyc_q                   ;
    reg                [   1: 0]        data_idx_q                  ;
    reg                [  31: 0]        data_q                      ;
    reg                [GP_OUTPUTS-1: 0]        gp_out_q                    ;
    reg                [GP_INPUTS-1: 0]        gp_in_q                     ;
    reg                [STATE_W-1: 0]        next_state_r                ;

always @ *
begin
    next_state_r = state_q;
    case (state_q)
    STATE_IDLE :
    begin
        if (rx_ready_w)
            next_state_r    = STATE_CMD;
    end

    STATE_CMD :
    begin
        if (data_rx_w[`CMD_R] == CMD_NOP)
            next_state_r  = STATE_IDLE;
        else if (data_rx_w[`CMD_R] == CMD_WR || data_rx_w[`CMD_R] == CMD_RD)
            next_state_r  = STATE_LEN;
        else if (data_rx_w[`CMD_R] == CMD_GP_WR)
            next_state_r  = STATE_GP_WR;
        else if (data_rx_w[`CMD_R] == CMD_GP_RD)
            next_state_r  = STATE_GP_RD;
        else
            next_state_r  = STATE_IDLE;
    end

    STATE_LEN :
    begin
        if (rx_ready_w)
            next_state_r  = STATE_ADDR0;
    end

    STATE_ADDR0 : if (rx_ready_w) next_state_r  = STATE_ADDR1;
    STATE_ADDR1 : if (rx_ready_w) next_state_r  = STATE_ADDR2;
    STATE_ADDR2 : if (rx_ready_w) next_state_r  = STATE_ADDR3;
    STATE_ADDR3 :
    begin
        if (rx_ready_w && mem_we_o)
            next_state_r  = STATE_WRITE;
        else if (rx_ready_w)
            next_state_r  = STATE_READ;
    end

    STATE_WRITE :
    begin
        if (len_q == {LEN_W{1'b0}} && mem_ack_i)
            next_state_r  = STATE_IDLE;
        else
            next_state_r  = STATE_WRITE;
    end

    STATE_READ :
    begin
        if (mem_ack_i)
            next_state_r  = STATE_DATA0;
    end

    STATE_DATA0 :
    begin
        if (wr_accept_w)
            next_state_r  = STATE_DATA1;
    end
    STATE_DATA1 :
    begin
        if (wr_accept_w)
            next_state_r  = STATE_DATA2;
    end
    STATE_DATA2 :
    begin
        if (wr_accept_w)
            next_state_r  = STATE_DATA3;
    end
    STATE_DATA3 :
    begin
        if (wr_accept_w && (len_q != {LEN_W{1'b0}}))
            next_state_r  = STATE_READ;
        else if (wr_accept_w)
            next_state_r  = STATE_IDLE;
    end

    STATE_GP_WR :
    begin
        if (rx_ready_w)
            next_state_r  = STATE_IDLE;
    end

    STATE_GP_RD :
    begin
        if (wr_accept_w)
            next_state_r  = STATE_IDLE;
    end
    default:
        ;
   endcase
end

always @ (posedge rst_i or posedge clk_i)
if (rst_i)
    state_q   <= STATE_IDLE;
else
    state_q   <= next_state_r;

ftdi_sync
#( .CLK_DIV(CLK_DIV) )
u_sync
(
    .clk_i                              (clk_i                     ),
    .rst_i                              (rst_i                     ),
    .ftdi_rxf_i                         (ftdi_rxf_i                ),
    .ftdi_txe_i                         (ftdi_txe_i                ),
    .ftdi_siwua_o                       (ftdi_siwua_o              ),
    .ftdi_wr_o                          (ftdi_wr_o                 ),
    .ftdi_rd_o                          (ftdi_rd_o                 ),
    .ftdi_d_io                          (ftdi_d_io                 ),
    .data_o                             (data_rx_w                 ),
    .data_i                             (data_tx_w                 ),
    .wr_i                               (wr_w                      ),
    .rd_i                               (rd_w                      ),
    .wr_accept_o                        (wr_accept_w               ),
    .rd_ready_o                         (rx_ready_w                ) 
);

assign wr_w = (state_q == STATE_DATA0) |
              (state_q == STATE_DATA1) |
              (state_q == STATE_DATA2) |
              (state_q == STATE_DATA3) |
              (state_q == STATE_GP_RD);

assign rd_w = (state_q == STATE_CMD) |
              (state_q == STATE_LEN) |
              (state_q == STATE_ADDR0) |
              (state_q == STATE_ADDR1) |
              (state_q == STATE_ADDR2) |
              (state_q == STATE_ADDR3) |
              (state_q == STATE_WRITE && !mem_cyc_o) |
              (state_q == STATE_GP_WR);

always @ (posedge rst_i or posedge clk_i)
if (rst_i)
    len_q       <= {LEN_W{1'b0}};
else if (state_q == STATE_CMD && rx_ready_w)
    len_q[11:8] <= data_rx_w[`LEN_UPPER_R];
else if (state_q == STATE_LEN && rx_ready_w)
    len_q[7:0]  <= data_rx_w[`LEN_LOWER_R];
else if (state_q == STATE_WRITE && rx_ready_w && !mem_cyc_o)
    len_q       <= len_q - {{(LEN_W-1){1'b0}}, 1'b1};
else if (state_q == STATE_READ && (mem_cyc_o && mem_ack_i))
    len_q       <= len_q - {{(LEN_W-1){1'b0}}, 1'b1};
else if (((state_q == STATE_DATA0) || (state_q == STATE_DATA1) || (state_q == STATE_DATA2)) && wr_accept_w)
    len_q       <= len_q - {{(LEN_W-1){1'b0}}, 1'b1};

always @ (posedge rst_i or posedge clk_i)
if (rst_i)
    mem_addr_q        <= 'd0;
else if (state_q == STATE_ADDR0 && rx_ready_w)
    mem_addr_q[31:24] <= data_rx_w;
else if (state_q == STATE_ADDR1 && rx_ready_w)
    mem_addr_q[23:16] <= data_rx_w;
else if (state_q == STATE_ADDR2 && rx_ready_w)
    mem_addr_q[15:8]  <= data_rx_w;
else if (state_q == STATE_ADDR3 && rx_ready_w)
    mem_addr_q[7:0]   <= data_rx_w;
else if (state_q == STATE_WRITE && (mem_cyc_o && mem_ack_i))
    mem_addr_q        <= {mem_addr_q[31:2], 2'b0} + 'd4;
else if (state_q == STATE_READ && (mem_cyc_o && mem_ack_i))
    mem_addr_q        <= {mem_addr_q[31:2], 2'b0} + 'd4;

    assign                              mem_addr_o                  = {mem_addr_q[ADDR_W-1:2], 2'b0};

always @ (posedge rst_i or posedge clk_i)
if (rst_i)
    data_idx_q <= 2'b0;
else if (state_q == STATE_ADDR3)
    data_idx_q <= data_rx_w[1:0];
else if (state_q == STATE_WRITE && rx_ready_w && !mem_cyc_o)
    data_idx_q <= data_idx_q + 2'd1;

always @ (posedge rst_i or posedge clk_i)
if (rst_i)
    data_q <= 32'b0;
else if (state_q == STATE_IDLE)
    data_q <= {{(32-GP_INPUTS){1'b0}}, gp_in_q};
else if (state_q == STATE_WRITE && rx_ready_w && !mem_cyc_o)
begin
    if (LITTLE_ENDIAN)
    begin
        case (data_idx_q)
            2'd0: data_q[7:0]   <= data_rx_w;
            2'd1: data_q[15:8]  <= data_rx_w;
            2'd2: data_q[23:16] <= data_rx_w;
            2'd3: data_q[31:24] <= data_rx_w;
        endcase
    end
    else
    begin
        case (data_idx_q)
            2'd3: data_q[7:0]   <= data_rx_w;
            2'd2: data_q[15:8]  <= data_rx_w;
            2'd1: data_q[23:16] <= data_rx_w;
            2'd0: data_q[31:24] <= data_rx_w;
        endcase
    end
end

else if (state_q == STATE_READ && mem_ack_i)
begin
    if (LITTLE_ENDIAN)
        data_q <= mem_data_i;
    else
        data_q <= {mem_data_i[7:0], mem_data_i[15:8], mem_data_i[23:16], mem_data_i[31:24]};
end
else if (((state_q == STATE_DATA0) || (state_q == STATE_DATA1) || (state_q == STATE_DATA2)) && wr_accept_w)
begin
    data_q <= {8'b0, data_q[31:8]};
end

    assign                              data_tx_w                   = data_q[7:0];

    assign                              mem_data_o                  = data_q;

always @ (posedge rst_i or posedge clk_i)
if (rst_i)
    mem_stb_o    <= 1'b0;
else if (mem_stb_o)
begin
    if (!mem_stall_i)
        mem_stb_o    <= 1'b0;
end

else if (state_q == STATE_WRITE && rx_ready_w && (data_idx_q == 2'd3 || len_q == 1))
    mem_stb_o   <= 1'b1;
else if (state_q == STATE_READ && !mem_cyc_o)
    mem_stb_o   <= 1'b1;

    reg                [   3: 0]        mem_sel_q                   ;
    reg                [   3: 0]        mem_sel_r                   ;

always @ *
begin
    mem_sel_r = 4'b1111;

    case (data_idx_q)
    2'd0: mem_sel_r = 4'b0001;
    2'd1: mem_sel_r = 4'b0011;
    2'd2: mem_sel_r = 4'b0111;
    2'd3: mem_sel_r = 4'b1111;
    endcase

    case (mem_addr_q[1:0])
    2'd0: mem_sel_r = mem_sel_r & 4'b1111;
    2'd1: mem_sel_r = mem_sel_r & 4'b1110;
    2'd2: mem_sel_r = mem_sel_r & 4'b1100;
    2'd3: mem_sel_r = mem_sel_r & 4'b1000;
    endcase
end

always @ (posedge rst_i or posedge clk_i)
if (rst_i)
    mem_sel_q    <= 4'b0;
else if (state_q == STATE_IDLE)
    mem_sel_q   <= 4'b1111;
else if (state_q == STATE_WRITE && rx_ready_w && (data_idx_q == 2'd3 || len_q == 1))
    mem_sel_q   <= mem_sel_r;

    assign                              mem_sel_o                   = LITTLE_ENDIAN ? mem_sel_q : {mem_sel_q[0], mem_sel_q[1], mem_sel_q[2], mem_sel_q[3]};

always @ (posedge rst_i or posedge clk_i)
if (rst_i)
    mem_we_o    <= 1'b0;
else if (state_q == STATE_CMD && rx_ready_w)
    mem_we_o    <= (data_rx_w[`CMD_R] == CMD_WR);

always @ (posedge clk_i or posedge rst_i)
if (rst_i == 1'b1)
    mem_cyc_q <= 1'b0;
else if (mem_stb_o)
    mem_cyc_q <= 1'b1;
else if (mem_ack_i)
    mem_cyc_q <= 1'b0;

    assign                              mem_cyc_o                   = mem_stb_o | mem_cyc_q;

always @ (posedge rst_i or posedge clk_i)
if (rst_i)
    gp_out_q <= {(GP_OUTPUTS){1'b0}};
else if (state_q == STATE_GP_WR && rx_ready_w)
    gp_out_q <= data_rx_w[GP_OUTPUTS-1:0];

    assign                              gp_o                        = gp_out_q;

    reg                [GP_INPUTS-1: 0]        gp_in_r                     ;
always @ *
begin
    if ((state_q == STATE_GP_RD) && wr_accept_w)
        gp_in_r = gp_i;
    else
        gp_in_r = (gp_in_q & GP_IN_EVENT_MASK) | gp_i;
end

always @ (posedge rst_i or posedge clk_i)
if (rst_i)
    gp_in_q <= {(GP_INPUTS){1'b0}};
else
    gp_in_q <= gp_in_r;

endmodule