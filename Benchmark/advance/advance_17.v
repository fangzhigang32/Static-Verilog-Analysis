module advance_17(clk,
              rst_n,
              i_data_in,
              i_empty_fifo,
              o_rd_in,
              o_data_in_aes,
              o_load_data,
              o_key_aes,
              o_key_mode,
              o_load_key,
              o_en_clk,
              o_mode,
              o_error,
              fifo_state,
              done_data,
              data_chain,
              data_len
              );

    input                               clk                        ;
    input                               rst_n                      ;
    input                               i_empty_fifo               ;
    input                               fifo_state                 ;
    input                               done_data                  ;
    input              [  33: 0]        i_data_in                  ;
    input              [ 127: 0]        data_chain                 ;

    output reg                          o_rd_in                    ;
    output reg                          o_error                    ;
    output reg                          o_load_data                ;
    output reg                          o_en_clk                   ;
    output reg                          o_load_key                 ;

    output                              o_mode                     ;
    output             [   1: 0]        o_key_mode                 ;
    output             [   7: 0]        data_len                   ;
    output             [ 127: 0]        o_data_in_aes              ;
    output             [ 255: 0]        o_key_aes                  ;

    reg                                 work_mode                   ;
    reg                [   1: 0]        key_len_mode                ;
    reg                [   1: 0]        cstate                      ;
    reg                [   1: 0]        nstate                      ;
    reg                [   2: 0]        cnt_flag                    ;
    reg                [   3: 0]        cnt_key                     ;
    reg                [   3: 0]        cnt_iv                      ;
    reg                [   7: 0]        number_data                 ;
    reg                [   7: 0]        cnt_data                    ;
    reg                [  31: 0]        data_buff[3:0]              ;
    reg                [  31: 0]        iv_buff[3:0]                ;
    reg                [  31: 0]        key_buff[7:0]               ;

    parameter                           s0                         = 2'd0  ,s1 = 2'd1,s2 = 2'd2,s3 = 2'd3;

always@(negedge clk or negedge rst_n) begin
    if(!rst_n) cstate <= s0;
    else cstate <= nstate;
end

always@(i_empty_fifo, fifo_state, cstate, cnt_key, cnt_data, cnt_iv, cnt_flag) begin
    if((!i_empty_fifo)&&(!fifo_state))
    begin
        case(cstate)
           s0:begin
                if(i_data_in[33:32] == 2'b01) nstate = s1;
                else nstate = s0;
              end
           s1:begin
                if(key_len_mode == 2'b00) begin
                    if(cnt_key <= 4'b0011) nstate = s1;
                    else  nstate = s2;
                end
                else begin
                       if(key_len_mode == 2'b01) begin
                           if(cnt_key <= 4'b0101)  nstate = s1;
                           else  nstate = s2;
                       end
                       else begin
                              if(key_len_mode == 2'b10) begin
                                   if(cnt_key == 4'b1000) nstate = s2;
                                   else  nstate = s1;
                              end
                              else nstate = s0;
                            end
                     end
              end
           s2:begin
                if(cnt_iv==4'b0100) nstate = s3;
                else  nstate = s2;
              end
           s3:begin
                if(cnt_data == number_data) nstate = s0;
                else nstate = s3;
              end
           default: nstate = s0;
        endcase
    end
    else nstate = nstate;
end

always@(negedge clk or negedge rst_n) begin
    if(!rst_n) begin
        o_rd_in <= 1'b0;
        o_error <= 1'b0;
        o_load_key <= 1'b0;
        o_load_data <= 1'b0;
        o_en_clk <= 1'b0;
        key_len_mode <= 2'd0;
        cnt_key <= 4'd0;
        cnt_iv <= 4'd0;
        cnt_flag <= 3'd0;
        cnt_data <= 8'd0;
        number_data <= 8'd0;
        data_buff[0] <= 32'd0;
        data_buff[1] <= 32'd0;
        data_buff[2] <= 32'd0;
        data_buff[3] <= 32'd0;
        iv_buff[0] <= 32'd0;
        iv_buff[1] <= 32'd0;
        iv_buff[2] <= 32'd0;
        iv_buff[3] <= 32'd0;
        key_buff[0] <= 32'd0;
        key_buff[1] <= 32'd0;
        key_buff[2] <= 32'd0;
        key_buff[3] <= 32'd0;
        key_buff[4] <= 32'd0;
        key_buff[5] <= 32'd0;
        key_buff[6] <= 32'd0;
        key_buff[7] <= 32'd0;
    end
    else begin
           if(i_empty_fifo || fifo_state) begin
               if(fifo_state) begin
                   o_rd_in <= 1'b0;
                   o_en_clk <= 1'b0;
                   o_error <= 1'b0;
                   o_load_data <= 1'b0;
                   o_load_key <= 1'b0;
               end
               else begin
                      o_rd_in <= 1'b0;
                      o_error <= 1'b0;
                      o_load_data <= 1'b0;
                      o_load_key <= 1'b0;
                    end
           end
           else begin
                o_en_clk <= 1'b1;
                case(nstate)
                  s0:begin
                       o_rd_in <= 1'b1;
                       cnt_data <= 8'd0;
                       o_load_data <= 1'd0;
                       if(i_data_in[33:32] == 2'b01) begin
                           o_error <= 1'b0;
                           work_mode <= i_data_in[8];
                           if(i_data_in[11:9] == 3'b101) begin
                               key_len_mode <= 2'b00;
                               number_data <= (i_data_in[7:0] - 8'd9);
                           end
                           else begin
                                  if(i_data_in[11:9] == 3'b100) begin
                                      key_len_mode <= 2'b01;
                                      number_data <= (i_data_in[7:0] - 8'd11);
                                  end
                                  else begin
                                         if(i_data_in[11:9] == 3'b011) begin
                                             key_len_mode <= 2'b10;
                                             number_data <= (i_data_in[7:0] - 8'd13);
                                         end
                                         else begin
                                                key_len_mode <= 2'b11;
                                                number_data <= 8'd0;
                                              end
                                       end
                                end
                       end
                       else o_error <= 1'b1;
                     end
                  s1:begin
                       if(key_len_mode == 2'b00) begin
                           if(cnt_key == 4'b0011) begin
                               cnt_key <= cnt_key + 4'd1;
                               o_load_key <= 4'd1;
                               key_buff[cnt_key ] <= i_data_in[31:0];
                           end
                           else begin
                                  if(cnt_key <= 4'b0010) begin
                                      o_load_key <= 4'd0;
                                      key_buff[cnt_key] <= i_data_in[31:0];
                                      cnt_key <= cnt_key + 4'd1;
                                  end
                                end
                       end
                       else begin
                              if(key_len_mode == 2'b01) begin
                                  if(cnt_key == 4'b0101) begin
                                      cnt_key <= cnt_key + 4'd1;
                                      o_load_key <= 4'd1;
                                      key_buff[cnt_key] <= i_data_in[31:0];
                                  end
                                  else begin
                                         if(cnt_key <= 4'b0100) begin
                                             o_load_key <= 4'd0;
                                             key_buff[cnt_key] <= i_data_in[31:0];
                                             cnt_key <= cnt_key + 4'd1;
                                         end
                                       end
                              end
                              else begin
                                     if(key_len_mode == 2'b10) begin
                                         if(cnt_key == 4'b0111) begin
                                             cnt_key <= cnt_key + 4'd1;
                                             o_load_key <= 4'd1;
                                             key_buff[cnt_key] <= i_data_in[31:0];
                                         end
                                         else begin
                                                if(cnt_key <= 4'b0110) begin
                                                    o_load_key <= 4'd0;
                                                    key_buff[cnt_key] <= i_data_in[31:0];
                                                    cnt_key <= cnt_key + 4'd1;
                                                end
                                              end
                                     end
                                     else o_error <= 1'b1;
                                   end
                            end
                     end
                  s2:begin
                       cnt_key <= 4'd0;
                       o_load_key <= 1'd0;
                       if(cnt_iv <= 4'b0100) begin
                           cnt_iv <= cnt_iv + 4'd1;
                           iv_buff[cnt_iv] <= i_data_in[31:0];
                       end
                       else begin
                              cnt_iv <= cnt_iv + 4'd1;
                              iv_buff[cnt_iv] <= i_data_in[31:0];
                            end
                     end
                  s3:begin
                       cnt_iv <= 4'd0;
                       if(done_data) begin
                           cnt_flag <= 3'd0;
                           if(cnt_data == number_data - 8'd1) begin
                               cnt_data <= cnt_data + 8'd1;
                               if(i_data_in[33:32] == 2'b10) begin
                                   {data_buff[3],data_buff[2],data_buff[1],data_buff[0]} <= {i_data_in[31:0],data_buff[2],data_buff[1],data_buff[0]} ^ data_chain;
                                   o_load_data <= 1'b1;
                                   o_error <= 1'b0;
                               end
                               else begin
                                      o_error <= 1'b1;
                                      o_load_data <= 1'b0;
                                    end
                           end
                           else begin
                                  {data_buff[3],data_buff[2],data_buff[1],data_buff[0]} <= {i_data_in[31:0],data_buff[2],data_buff[1],data_buff[0]} ^ data_chain;
                                  cnt_data <= cnt_data + 8'd1;
                                  o_load_data <= 1'b1;
                                  o_error <= 1'b0;
                                end
                       end
                       else begin
                              if(cnt_data == 8'd3) begin
                                  {data_buff[3],data_buff[2],data_buff[1],data_buff[0]} <= {i_data_in[31:0],data_buff[2],data_buff[1],data_buff[0]} ^ {iv_buff[3],iv_buff[2],iv_buff[1],iv_buff[0]};
                                  o_load_data <= 1'b1;
                                  o_error <= 1'b0;
                                  cnt_data <= cnt_data + 8'd1;
                                  cnt_flag <= 3'd0;
                              end
                              else begin
                                     if(cnt_flag <= 3'b010) begin
                                        o_load_data <= 1'b0;
                                        cnt_data <= cnt_data + 8'd1;
                                        cnt_flag <= cnt_flag + 3'd1;
                                        data_buff[cnt_flag] <= i_data_in[31:0];
                                     end
                                   end
                            end
                     end
                  default:;
                endcase
              end
         end
end

    assign                              data_len                    = number_data;
    assign                              o_mode                      = work_mode;
    assign                              o_key_mode                  = key_len_mode;
    assign                              o_data_in_aes               = {data_buff[3],data_buff[2],data_buff[1],data_buff[0]};
    assign                              o_key_aes                   = {key_buff[7],key_buff[6],key_buff[5],key_buff[4],key_buff[3],key_buff[2],key_buff[1],key_buff[0]};
endmodule