// project     : axi_regs
// date        : 22.01.2026
// author      : siarhei baldzenka
// e-mail      : sbaldzenka@proton.me
// description : https://github.com/sbaldzenka/axi_regs

`timescale 1ns/100ps

module axi_regs_tb();

    localparam CLK_100_MHZ_PERIOD = 10;

    localparam ADDR_WIDTH         = 32;
    localparam DATA_WIDTH         = 32;
    localparam WSTRB_WIDTH        = DATA_WIDTH/8;

    reg                    clk;
    reg                    resetn;

    reg                    s_axi_awvalid;
    reg  [ ADDR_WIDTH-1:0] s_axi_awaddr;
    wire                   s_axi_awready;
    reg                    s_axi_wvalid;
    reg  [ DATA_WIDTH-1:0] s_axi_wdata;
    reg  [WSTRB_WIDTH-1:0] s_axi_wstrb;
    wire                   s_axi_wready;
    wire                   s_axi_bvalid;
    wire [            1:0] s_axi_bresp;
    reg                    s_axi_bready;
    reg                    s_axi_arvalid;
    reg  [ ADDR_WIDTH-1:0] s_axi_araddr;
    wire                   s_axi_arready;
    wire                   s_axi_rvalid;
    wire [ DATA_WIDTH-1:0] s_axi_rdata;
    wire [            1:0] s_axi_rresp;
    reg                    s_axi_rready;

    reg                    reg_0_update;
    reg  [ DATA_WIDTH-1:0] reg_0_new_value;
    wire [ DATA_WIDTH-1:0] reg_0_current_value;

    reg                    reg_1_update;
    reg  [ DATA_WIDTH-1:0] reg_1_new_value;
    wire [ DATA_WIDTH-1:0] reg_1_current_value;
    
    reg                    reg_2_update;
    reg  [ DATA_WIDTH-1:0] reg_2_new_value;
    wire [ DATA_WIDTH-1:0] reg_2_current_value;

    reg                    reg_3_update;
    reg  [ DATA_WIDTH-1:0] reg_3_new_value;
    wire [ DATA_WIDTH-1:0] reg_3_current_value;

    initial begin
             clk    <= 1'b1;
             resetn <= 1'b1;
        #200 resetn <= 1'b0;
        #50  resetn <= 1'b1;
    end

    always #(CLK_100_MHZ_PERIOD/2) clk = ~clk;

    initial begin
               reg_0_update          <= 1'b0;
               reg_0_new_value       <= 'b0;
               reg_1_update          <= 1'b0;
               reg_1_new_value       <= 'b0;
               reg_2_update          <= 1'b0;
               reg_2_new_value       <= 'b0;
               reg_3_update          <= 1'b0;
               reg_3_new_value       <= 'b0;
          #300 reg_0_update          <= 1'b1;
               reg_0_new_value[31:0] <= 32'h11111111;
               reg_1_update          <= 1'b1;
               reg_1_new_value[31:0] <= 32'h22222222;
               reg_2_update          <= 1'b1;
               reg_2_new_value[31:0] <= 32'h33333333;
               reg_3_update          <= 1'b1;
               reg_3_new_value[31:0] <= 32'h44444444;
          #CLK_100_MHZ_PERIOD;
               reg_0_update          <= 1'b0;
               reg_0_new_value       <= 'b0;
               reg_1_update          <= 1'b0;
               reg_1_new_value       <= 'b0;
               reg_2_update          <= 1'b0;
               reg_2_new_value       <= 'b0;
               reg_3_update          <= 1'b0;
               reg_3_new_value       <= 'b0;
    end

    initial begin
              s_axi_arvalid      <= 1'b0;
              s_axi_araddr       <= '0;
              s_axi_rready       <= 1'b0;

        #700  s_axi_arvalid      <= 1'b1;
              s_axi_araddr[31:0] <= 32'h70000000;
        @(posedge s_axi_arready) #CLK_100_MHZ_PERIOD;
              s_axi_arvalid      <= 1'b0;
        @(posedge s_axi_rvalid) #(CLK_100_MHZ_PERIOD*3);
              s_axi_rready       <= 1'b1;
        #CLK_100_MHZ_PERIOD;
              s_axi_rready       <= 1'b0;

        #300  s_axi_arvalid      <= 1'b1;
              s_axi_araddr[31:0] <= 32'h70000004;
        @(posedge s_axi_arready) #CLK_100_MHZ_PERIOD;
              s_axi_arvalid      <= 1'b0;
        @(posedge s_axi_rvalid) #(CLK_100_MHZ_PERIOD*3);
              s_axi_rready       <= 1'b1;
        #CLK_100_MHZ_PERIOD;
              s_axi_rready       <= 1'b0;

        #300  s_axi_arvalid      <= 1'b1;
              s_axi_araddr[31:0] <= 32'h70000008;
        @(posedge s_axi_arready) #CLK_100_MHZ_PERIOD;
              s_axi_arvalid      <= 1'b0;
        @(posedge s_axi_rvalid) #(CLK_100_MHZ_PERIOD*3);
              s_axi_rready       <= 1'b1;
        #CLK_100_MHZ_PERIOD;
              s_axi_rready       <= 1'b0;

        #300  s_axi_arvalid      <= 1'b1;
              s_axi_araddr[31:0] <= 32'h7000000C;
        @(posedge s_axi_arready) #CLK_100_MHZ_PERIOD;
              s_axi_arvalid      <= 1'b0;
        @(posedge s_axi_rvalid) #(CLK_100_MHZ_PERIOD*3);
              s_axi_rready       <= 1'b1;
        #CLK_100_MHZ_PERIOD;
              s_axi_rready       <= 1'b0;

        #1500 s_axi_arvalid      <= 1'b1;
              s_axi_rready       <= 1'b1;
              s_axi_araddr[31:0] <= 32'h70000000;
        @(posedge s_axi_arready) #CLK_100_MHZ_PERIOD;
              s_axi_arvalid      <= 1'b0;
        @(posedge s_axi_rvalid) #CLK_100_MHZ_PERIOD;
              s_axi_rready       <= 1'b0;

        #300  s_axi_arvalid      <= 1'b1;
              s_axi_rready       <= 1'b1;
              s_axi_araddr[31:0] <= 32'h70000004;
        @(posedge s_axi_arready) #CLK_100_MHZ_PERIOD;
              s_axi_arvalid      <= 1'b0;
        @(posedge s_axi_rvalid) #CLK_100_MHZ_PERIOD;
              s_axi_rready       <= 1'b0;

        #300  s_axi_arvalid      <= 1'b1;
              s_axi_rready       <= 1'b1;
              s_axi_araddr[31:0] <= 32'h70000008;
        @(posedge s_axi_arready) #CLK_100_MHZ_PERIOD;
              s_axi_arvalid      <= 1'b0;
        @(posedge s_axi_rvalid) #CLK_100_MHZ_PERIOD;
              s_axi_rready       <= 1'b0;

        #300  s_axi_arvalid      <= 1'b1;
              s_axi_rready       <= 1'b1;
              s_axi_araddr[31:0] <= 32'h7000000C;
        @(posedge s_axi_arready) #CLK_100_MHZ_PERIOD;
              s_axi_arvalid      <= 1'b0;
        @(posedge s_axi_rvalid) #CLK_100_MHZ_PERIOD;
              s_axi_rready       <= 1'b0;
    end

    initial begin
              s_axi_awvalid      <= 1'b0;
              s_axi_awaddr       <= '0;
              s_axi_bready       <= 1'b0;
              s_axi_wvalid       <= 1'b0;
              s_axi_wdata        <= 'b0;
              s_axi_wstrb        <= 'b0;

        #2000 s_axi_awvalid      <= 1'b1;
              s_axi_awaddr[31:0] <= 32'h70000000;
              s_axi_wvalid       <= 1'b1;
              s_axi_wdata[31:0]  <= 32'h10000001;
              s_axi_wstrb[3:0]   <= 4'hF;
        @(posedge s_axi_awready) #CLK_100_MHZ_PERIOD;
              s_axi_awvalid      <= 1'b0;
              s_axi_awaddr       <= '0;
        @(posedge s_axi_wready) #CLK_100_MHZ_PERIOD;
              s_axi_wvalid       <= 1'b0;
              s_axi_wdata        <= 'b0;
              s_axi_wstrb        <= 'b0;
        @(posedge s_axi_bvalid) #(CLK_100_MHZ_PERIOD*3);
              s_axi_bready       <= 1'b1;
        #CLK_100_MHZ_PERIOD;
              s_axi_bready       <= 1'b0;

        #300 s_axi_awvalid      <= 1'b1;
              s_axi_awaddr[31:0] <= 32'h70000004;
              s_axi_bready       <= 1'b1;
              s_axi_wvalid       <= 1'b1;
              s_axi_wdata[31:0]  <= 32'h20000002;
              s_axi_wstrb[3:0]   <= 4'hF;
        @(posedge s_axi_awready) #CLK_100_MHZ_PERIOD;
              s_axi_awvalid      <= 1'b0;
              s_axi_awaddr       <= '0;
        @(posedge s_axi_wready) #CLK_100_MHZ_PERIOD;
              s_axi_wvalid       <= 1'b0;
              s_axi_wdata        <= 'b0;
              s_axi_wstrb        <= 'b0;
        @(posedge s_axi_bvalid) #(CLK_100_MHZ_PERIOD*3);
              s_axi_bready       <= 1'b1;
        #CLK_100_MHZ_PERIOD;
              s_axi_bready       <= 1'b0;

        #300 s_axi_awvalid      <= 1'b1;
              s_axi_awaddr[31:0] <= 32'h70000008;
              s_axi_bready       <= 1'b1;
              s_axi_wvalid       <= 1'b1;
              s_axi_wdata[31:0]  <= 32'h30000003;
              s_axi_wstrb[3:0]   <= 4'hF;
        @(posedge s_axi_awready) #CLK_100_MHZ_PERIOD;
              s_axi_awvalid      <= 1'b0;
              s_axi_awaddr       <= '0;
        @(posedge s_axi_wready) #CLK_100_MHZ_PERIOD;
              s_axi_wvalid       <= 1'b0;
              s_axi_wdata        <= 'b0;
              s_axi_wstrb        <= 'b0;
        @(posedge s_axi_bvalid) #CLK_100_MHZ_PERIOD;
              s_axi_bready       <= 1'b0;

        #300 s_axi_awvalid      <= 1'b1;
              s_axi_awaddr[31:0] <= 32'h7000000C;
              s_axi_bready       <= 1'b1;
              s_axi_wvalid       <= 1'b1;
              s_axi_wdata[31:0]  <= 32'h40000004;
              s_axi_wstrb[3:0]   <= 4'hF;
        @(posedge s_axi_awready) #CLK_100_MHZ_PERIOD;
              s_axi_awvalid      <= 1'b0;
              s_axi_awaddr       <= '0;
        @(posedge s_axi_wready) #CLK_100_MHZ_PERIOD;
              s_axi_wvalid       <= 1'b0;
              s_axi_wdata        <= 'b0;
              s_axi_wstrb        <= 'b0;
        @(posedge s_axi_bvalid) #CLK_100_MHZ_PERIOD;
              s_axi_bready       <= 1'b0;
    end

    defparam DUT_inst.ADDR_WIDTH  = ADDR_WIDTH;
    defparam DUT_inst.DATA_WIDTH  = DATA_WIDTH;
    defparam DUT_inst.WSTRB_WIDTH = WSTRB_WIDTH;

    axi_regs DUT_inst
    (
        .s_axi_aclk            ( clk                 ),
        .s_axi_aresetn         ( resetn              ),
        .s_axi_awvalid         ( s_axi_awvalid       ),
        .s_axi_awaddr          ( s_axi_awaddr        ),
        .s_axi_awready         ( s_axi_awready       ),
        .s_axi_wvalid          ( s_axi_wvalid        ),
        .s_axi_wdata           ( s_axi_wdata         ),
        .s_axi_wstrb           ( s_axi_wstrb         ),
        .s_axi_wready          ( s_axi_wready        ),
        .s_axi_bvalid          ( s_axi_bvalid        ),
        .s_axi_bresp           ( s_axi_bresp         ),
        .s_axi_bready          ( s_axi_bready        ),
        .s_axi_arvalid         ( s_axi_arvalid       ),
        .s_axi_araddr          ( s_axi_araddr        ),
        .s_axi_arready         ( s_axi_arready       ),
        .s_axi_rvalid          ( s_axi_rvalid        ),
        .s_axi_rdata           ( s_axi_rdata         ),
        .s_axi_rresp           ( s_axi_rresp         ),
        .s_axi_rready          ( s_axi_rready        ),
        .i_reg_0_update        ( reg_0_update        ),
        .i_reg_0_new_value     ( reg_0_new_value     ),
        .o_reg_0_current_value ( reg_0_current_value ),
        .i_reg_1_update        ( reg_1_update        ),
        .i_reg_1_new_value     ( reg_1_new_value     ),
        .o_reg_1_current_value ( reg_1_current_value ),
        .i_reg_2_update        ( reg_2_update        ),
        .i_reg_2_new_value     ( reg_2_new_value     ),
        .o_reg_2_current_value ( reg_2_current_value ),
        .i_reg_3_update        ( reg_3_update        ),
        .i_reg_3_new_value     ( reg_3_new_value     ),
        .o_reg_3_current_value ( reg_3_current_value )
    );

endmodule