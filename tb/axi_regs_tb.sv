/*
---------------------------------------------------------------------------------------

MIT License

Copyright (c) 2026 Siarhei Baldzenka

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

---------------------------------------------------------------------------------------

project     : axi_regs
version     : 1.0
date        : 22.01.2026
author      : siarhei baldzenka
e-mail      : sbaldzenka@proton.me
description : https://github.com/sbaldzenka/axi_regs

---------------------------------------------------------------------------------------
*/

`timescale 1ns/100ps

module axi_regs_tb
#(
    // sim parameters
    parameter CLK_100_MHZ_PERIOD = 10,
    // axi-lite parameters
    parameter ADDR_WIDTH         = 32,
    parameter DATA_WIDTH         = 32,
    parameter WSTRB_WIDTH        = DATA_WIDTH/8,
    // register parameters
    parameter NUM_OF_REGS        = 6,
    parameter OFFSET             = DATA_WIDTH/8
);

    // signals
    logic                                    clk;
    logic                                    resetn;

    logic                                    s_axi_awvalid;
    logic                  [ ADDR_WIDTH-1:0] s_axi_awaddr;
    logic                                    s_axi_awready;
    logic                                    s_axi_wvalid;
    logic                  [ DATA_WIDTH-1:0] s_axi_wdata;
    logic                  [WSTRB_WIDTH-1:0] s_axi_wstrb;
    logic                                    s_axi_wready;
    logic                                    s_axi_bvalid;
    logic                  [            1:0] s_axi_bresp;
    logic                                    s_axi_bready;
    logic                                    s_axi_arvalid;
    logic                  [ ADDR_WIDTH-1:0] s_axi_araddr;
    logic                                    s_axi_arready;
    logic                                    s_axi_rvalid;
    logic                  [ DATA_WIDTH-1:0] s_axi_rdata;
    logic                  [            1:0] s_axi_rresp;
    logic                                    s_axi_rready;

    logic [0:NUM_OF_REGS-1]                  i_reg_update;
    logic [0:NUM_OF_REGS-1][ DATA_WIDTH-1:0] i_reg_new_value;
    logic [0:NUM_OF_REGS-1][ DATA_WIDTH-1:0] o_reg_current_value;

    // tasks
    task reset_n_generate;
        begin
            resetn = 1'b1;
            #(CLK_100_MHZ_PERIOD*2);
            resetn = 1'b0;
            #(CLK_100_MHZ_PERIOD*5);
            resetn = 1'b1;
        end
    endtask

    task load_ext_data();
        begin
            i_reg_update    <= 'b0;
            i_reg_new_value <= 'b0;
            @(posedge clk);

            for (int index = 0; index < NUM_OF_REGS; index++) begin
                i_reg_update[index]    <= 1'b1;
                i_reg_new_value[index] <= i_reg_new_value[index] + 100 + index;
            end

            #CLK_100_MHZ_PERIOD;
            i_reg_update    <= 'b0;
            i_reg_new_value <= 'b0;
        end
    endtask

    task write_axi_data(input logic [31:0] addr, input logic [31:0] data);
        begin
            s_axi_bready       <= 1'b0;
            s_axi_wvalid       <= 1'b0;
            s_axi_wdata        <= 'b0;
            s_axi_wstrb        <= 'b0;
            #100;
            @(posedge clk);
            s_axi_awvalid      <= 1'b1;
            s_axi_awaddr[31:0] <= addr;
            s_axi_wvalid       <= 1'b1;
            s_axi_wdata[31:0]  <= data;
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
        end
    endtask

    task read_axi_data(input logic [31:0] addr);
        begin
            s_axi_arvalid      <= 1'b0;
            s_axi_araddr       <= '0;
            s_axi_rready       <= 1'b0;
            #100;
            s_axi_arvalid      <= 1'b1;
            s_axi_araddr[31:0] <= addr;
            @(posedge s_axi_arready) #CLK_100_MHZ_PERIOD;
            s_axi_arvalid      <= 1'b0;
            @(posedge s_axi_rvalid) #(CLK_100_MHZ_PERIOD*3);
            s_axi_rready       <= 1'b1;
            #CLK_100_MHZ_PERIOD;
            s_axi_rready       <= 1'b0;
        end
    endtask

    // test logic
    always #(CLK_100_MHZ_PERIOD/2) clk = ~clk;

    initial begin
        clk             <= 1'b0;
        resetn          <= 1'b1;
        i_reg_update    <= 'b0;
        i_reg_new_value <= 'b0;
        s_axi_arvalid   <= 1'b0;
        s_axi_araddr    <= '0;
        s_axi_rready    <= 1'b0;
        s_axi_awvalid   <= 1'b0;
        s_axi_awaddr    <= '0;
        s_axi_bready    <= 1'b0;
        s_axi_wvalid    <= 1'b0;
        s_axi_wdata     <= 'b0;
        s_axi_wstrb     <= 'b0;
    end

    initial begin
        reset_n_generate();
        #100;
        load_ext_data();
        #100;

        for (int index = 0; index < NUM_OF_REGS; index++) begin
            #100 read_axi_data(32'h70000000 + (index*OFFSET));
        end

        #100;

        for (int index = 0; index < NUM_OF_REGS; index++) begin
            #100 write_axi_data(32'h70000000 + (index*OFFSET), 32'h10000000 + index);
        end

        #100;

        for (int index = 0; index < NUM_OF_REGS; index++) begin
            #100 read_axi_data(32'h70000000 + (index*OFFSET));
        end
    end

    defparam DUT_inst.ADDR_WIDTH  = ADDR_WIDTH;
    defparam DUT_inst.DATA_WIDTH  = DATA_WIDTH;
    defparam DUT_inst.WSTRB_WIDTH = WSTRB_WIDTH;
    defparam DUT_inst.NUM_OF_REGS = NUM_OF_REGS;
    defparam DUT_inst.OFFSET      = OFFSET;

    axi_regs DUT_inst
    (
        .s_axi_aclk    ( clk    ),
        .s_axi_aresetn ( resetn ),
        .*
    );

endmodule