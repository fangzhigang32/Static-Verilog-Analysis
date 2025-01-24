module advance_19(
    input  wire                         CLK                        ,
    input  wire                         RESET                      ,
    input  wire                         EN                         ,
    output reg         [   5: 0]        STATE                      ,
    output reg                          W_EN                       ,
    output reg                          SELECTOR                   ,

    input  wire        [  12: 0]        IADDR                      ,
    input  wire        [  12: 0]        WADDR                      ,
    input  wire        [  12: 0]        OADDR                      ,

    output reg                          share_wen                  ,
    output reg                          share_ren                  ,
    output reg                          share_cen                  ,
    output reg         [  12: 0]        share_addr                 ,
    output reg                          weight_wen                 ,
    output reg                          weight_ren                 ,
    output reg                          weight_cen                 ,
    output reg         [  12: 0]        weight_addr                ,
    output reg                          activate_wen               ,
    output reg                          activate_ren               ,
    output reg                          activate_cen               ,
    output reg         [  12: 0]        activate_addr              ,
    output reg                          output_wen                 ,
    output reg                          output_ren                 ,
    output reg                          output_cen                 ,
    output reg         [  12: 0]        output_addr                 
    );
    parameter                           IDLE                       = 6'd0  ;     
    parameter                           INPUTA                     = 6'd1  ;    
    parameter                           INPUTW                     = 6'd2  ;  
    parameter                           INPUTSW                    = 6'd3  ;
    parameter                           INPUTSA                    = 6'd4  ;
    parameter                           CALCULATE                  = 6'd5  ;
    parameter                           OUTPUT                     = 6'd6  ;
    parameter                           RETURN                     = 6'd7  ;
    parameter                           OUTPUTTOSHARE              = 6'd8  ;

always @(posedge CLK or negedge RESET) begin
    if(~RESET) begin
        STATE <= IDLE;
        W_EN <= 0;
        SELECTOR <=0;
        share_wen <= 1;
        share_ren <= 0;
        share_cen <= 1;
        share_addr <= 0;
        weight_wen <= 1;
        weight_ren <= 0;
        weight_cen <= 1;
        weight_addr <= 0;
        activate_wen <= 1;
        activate_ren <= 0;
        activate_cen <= 1;
        activate_addr <= 0;
    output                              _wen <= 1                  ;
    output                              _ren <= 0                  ;
    output                              _cen <= 1                  ;
    output                              _addr <= 0                 ;
    end else if (EN) begin
        if (STATE == IDLE) begin
            STATE <= INPUTSW;
            share_wen <= 0;
            share_ren <= 1;
            share_cen <= 1;
            weight_addr <= 0;
            share_addr <= WADDR;
        end
        else if(STATE == INPUTSW)begin
            share_addr <= share_addr +1;
            if(share_addr >= 16+WADDR)begin
                STATE <= INPUTSA;
                share_addr <= IADDR;
            end
        end
        else if(STATE == INPUTSA)begin
            share_addr <= share_addr +1;
            if(share_addr == 15+IADDR)begin
                STATE <= INPUTW;
                share_wen <= 1;
                share_ren <= 1;
                share_cen <= 0;
                share_addr <= WADDR;
                weight_addr <= -1;
            end
        end
        else if (STATE == INPUTW)begin
            weight_wen <= 0;
            weight_ren <= 1;
            weight_cen <= 1;
            share_addr <= share_addr +1;
            weight_addr <= weight_addr +1;
            if(share_addr == 16+WADDR)begin
                STATE <= INPUTA;
                share_addr <= IADDR;
                weight_wen <= 1;
                weight_ren <= 1;
                weight_cen <= 0;
                weight_addr <= -1;
                activate_addr <= -1;
                SELECTOR = 1;
                W_EN = 1;
            end
        end
        else if (STATE == INPUTA)begin
            activate_wen <= 0;
            activate_ren <= 1;
            activate_cen <= 1;
            share_addr <= share_addr +1;
            activate_addr <= activate_addr +1;
            weight_addr <= weight_addr +1;
            if(share_addr == 16+IADDR)begin
                STATE <= CALCULATE;
                share_wen <= 1;
                share_ren <= 0;
                share_cen <= 1;
                activate_wen <= 1;
                activate_ren <= 1;
                activate_cen <= 0;
                activate_addr <= -1;
                
            end
        end
        else if (STATE == CALCULATE)begin
            W_EN = 0;
            SELECTOR = 0;
            activate_addr <= activate_addr +1;
            if(activate_addr == 16)begin
                STATE <= OUTPUT;
                activate_wen <= 1;
                activate_ren <= 0;
                activate_cen <= 1;
    output                              _addr <= 0                 ;
    output                              _wen <= 0                  ;
    output                              _ren <= 1                  ;
    output                              _cen <= 1                  ;
            end
        end
        else if (STATE == OUTPUT)begin
    output                              _addr <= output_addr + 1   ;
            if(output_addr == 30)begin
                STATE <= RETURN;
            end
        end
        else if (STATE == RETURN)begin
            STATE <= IDLE;
        end
    end

end

endmodule