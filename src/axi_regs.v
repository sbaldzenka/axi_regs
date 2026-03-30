// project     : axi_regs_tb
// date        : 22.01.2026
// author      : siarhei baldzenka
// e-mail      : sbaldzenka@proton.me
// description : https://github.com/sbaldzenka/axi_regs

`timescale 1ns/100ps

module axi_regs
#(
    parameter ADDR_WIDTH  = 32,
    parameter DATA_WIDTH  = 32,
    parameter WSTRB_WIDTH = DATA_WIDTH/8
)
(
    // global signals
    input  wire                   s_axi_aclk,
    input  wire                   s_axi_aresetn,
    // axi-lite bus
    input  wire                   s_axi_awvalid,
    input  wire [ ADDR_WIDTH-1:0] s_axi_awaddr,
    output reg                    s_axi_awready,
    input  wire                   s_axi_wvalid,
    input  wire [ DATA_WIDTH-1:0] s_axi_wdata,
    input  wire [WSTRB_WIDTH-1:0] s_axi_wstrb,
    output reg                    s_axi_wready,
    output reg                    s_axi_bvalid,
    output wire [            1:0] s_axi_bresp,
    input  wire                   s_axi_bready,
    input  wire                   s_axi_arvalid,
    input  wire [ ADDR_WIDTH-1:0] s_axi_araddr,
    output reg                    s_axi_arready,
    output reg                    s_axi_rvalid,
    output reg  [ DATA_WIDTH-1:0] s_axi_rdata,
    output reg  [            1:0] s_axi_rresp,
    input  wire                   s_axi_rready,
    // registers
    // reg #0
    input  wire                   i_reg_0_update,
    input  wire [ DATA_WIDTH-1:0] i_reg_0_new_value,
    output reg  [ DATA_WIDTH-1:0] o_reg_0_current_value,
    // reg #1
    input  wire                   i_reg_1_update,
    input  wire [ DATA_WIDTH-1:0] i_reg_1_new_value,
    output reg  [ DATA_WIDTH-1:0] o_reg_1_current_value,
    // reg #2
    input  wire                   i_reg_2_update,
    input  wire [ DATA_WIDTH-1:0] i_reg_2_new_value,
    output reg  [ DATA_WIDTH-1:0] o_reg_2_current_value,
    // reg #3
    input  wire                   i_reg_3_update,
    input  wire [ DATA_WIDTH-1:0] i_reg_3_new_value,
    output reg  [ DATA_WIDTH-1:0] o_reg_3_current_value
);

    reg [ADDR_WIDTH-1:0] buffer_addr;

    parameter [3:0] S_IDLE           = 0,
                    S_GET_RADDR      = 1,
                    S_CHECK_RADDR    = 2,
                    S_WAIT_READY_REG = 3,
                    S_SEND_REG       = 4,
                    S_GET_WADDR      = 5,
                    S_WAIT_WDATA     = 6,
                    S_GET_WDATA      = 7,
                    S_WAIT_RESP      = 8,
                    S_SEND_RESP      = 9;

    reg [DATA_WIDTH-1:0] reg_0;
    reg [DATA_WIDTH-1:0] reg_1;
    reg [DATA_WIDTH-1:0] reg_2;
    reg [DATA_WIDTH-1:0] reg_3;

    reg [3:0] state;

    assign s_axi_bresp = 2'b00;

    always@(posedge s_axi_aclk) begin
        if (!s_axi_aresetn) begin
            state <= S_IDLE;
        end else begin
            case (state)
                S_IDLE: begin
                    if (s_axi_arvalid) begin
                        state <= S_GET_RADDR;
                    end

                    if (s_axi_awvalid) begin
                        state <= S_GET_WADDR;
                    end
                end

                S_GET_RADDR: begin
                    state <= S_CHECK_RADDR;
                end

                S_CHECK_RADDR: begin
                    state <= S_WAIT_READY_REG;
                end

                S_WAIT_READY_REG: begin
                    if (s_axi_rready) begin
                        state <= S_SEND_REG;
                    end
                end

                S_SEND_REG: begin
                    state <= S_IDLE;
                end

                S_GET_WADDR: begin
                    state <= S_WAIT_WDATA;
                end

                S_WAIT_WDATA: begin
                    if (s_axi_wvalid) begin
                        state <= S_GET_WDATA;
                    end
                end

                S_GET_WDATA: begin
                    state <= S_WAIT_RESP;
                end

                S_WAIT_RESP: begin
                    if (s_axi_bready) begin
                        state <= S_SEND_RESP;
                    end
                end

                S_SEND_RESP: begin
                    state <= S_IDLE;
                end
            endcase
        end
    end

    always@(posedge s_axi_aclk) begin
        if (!s_axi_aresetn) begin
            buffer_addr <= 'b0;
        end else if (state == S_GET_RADDR) begin
            buffer_addr <= s_axi_araddr;
        end else if (state == S_GET_WADDR) begin
            buffer_addr <= s_axi_awaddr;
        end
    end

    always@(posedge s_axi_aclk) begin
        if (state == S_GET_RADDR) begin
            s_axi_arready <= 1'b1;
        end else begin
            s_axi_arready <= 1'b0;
        end
    end

    always@(posedge s_axi_aclk) begin
        if (state == S_GET_WADDR) begin
            s_axi_awready <= 1'b1;
        end else begin
            s_axi_awready <= 1'b0;
        end
    end

    always@(posedge s_axi_aclk) begin
        if (state == S_GET_WDATA) begin
            s_axi_wready <= 1'b1;
        end else begin
            s_axi_wready <= 1'b0;
        end
    end

    always@(posedge s_axi_aclk) begin
        if (state == S_SEND_RESP) begin
            s_axi_bvalid <= 1'b1;
        end else begin
            s_axi_bvalid <= 1'b0;
        end
    end

    always@(posedge s_axi_aclk) begin
        if (state == S_SEND_REG) begin
            s_axi_rvalid <= 1'b1;
            s_axi_rresp  <= 2'b00;
        end else begin
            s_axi_rvalid <= 1'b0;
            s_axi_rresp  <= 2'b00;
        end
    end

    always @(posedge s_axi_aclk) begin
        if(!s_axi_aresetn) begin
            reg_0 <= 'b0;
            reg_1 <= 'b0;
            reg_2 <= 'b0;
            reg_3 <= 'b0;
        end else begin
            if (i_reg_0_update) begin
                reg_0 <= i_reg_0_new_value;
            end

            if (i_reg_1_update) begin
                reg_1 <= i_reg_1_new_value;
            end

            if (i_reg_2_update) begin
                reg_2 <= i_reg_2_new_value;
            end

            if (i_reg_3_update) begin
                reg_3 <= i_reg_3_new_value;
            end

            if (state == S_GET_WDATA) begin
                case (buffer_addr[7:0])
                    8'h00: reg_0 <= s_axi_wdata;
                    8'h04: reg_1 <= s_axi_wdata;
                    8'h08: reg_2 <= s_axi_wdata;
                    8'h0C: reg_3 <= s_axi_wdata;
                endcase
            end
        end
    end

    always @(posedge s_axi_aclk) begin
        o_reg_0_current_value <= reg_0;
        o_reg_1_current_value <= reg_1;
        o_reg_2_current_value <= reg_2;
        o_reg_3_current_value <= reg_3;
    end

    always @(posedge s_axi_aclk) begin
        if (!s_axi_aresetn) begin
            s_axi_rdata <= 'b0;
        end else begin
            if (state == S_SEND_REG) begin
                case (buffer_addr[7:0])
                    8'h00:   s_axi_rdata <= reg_0;
                    8'h04:   s_axi_rdata <= reg_1;
                    8'h08:   s_axi_rdata <= reg_2;
                    8'h0C:   s_axi_rdata <= reg_3;
                    default: s_axi_rdata <= 'b0;
                endcase
            end
        end
    end

endmodule