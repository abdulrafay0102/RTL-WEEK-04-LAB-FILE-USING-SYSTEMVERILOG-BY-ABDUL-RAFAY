// ABDUL RAFAY
// PSEB USTP INSPIRE SESSION
// SIR SYED UNIVERSITY OF ENGINEERING & TECHNOLOGY
// WEEK # 02 (IND. PROTOCOL)
// TEST BENCH FOR AHB SLAVE 
`timescale 1ns / 1ps
module tb_ahb_slave;
    localparam ADDR_WIDTH = 32;
    localparam DATA_WIDTH = 32;
    localparam CLK_PERIOD = 10;
    logic                    HCLK;
    logic                    HRESETn;
    logic                    HSEL;
    logic [ADDR_WIDTH-1:0]   HADDR;
    logic                    HWRITE;
    logic [1:0]              HTRANS;
    logic [2:0]              HSIZE;
    logic [DATA_WIDTH-1:0]   HWDATA;
    logic                    HREADY;
    logic [DATA_WIDTH-1:0]   HRDATA;
    logic                    HREADYOUT;
    logic                    HRESP;
    ahb_slave #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH),
        .MEM_DEPTH(8)
    ) dut (
        .HCLK(HCLK),
        .HRESETn(HRESETn),
        .HSEL(HSEL),
        .HADDR(HADDR),
        .HWRITE(HWRITE),
        .HTRANS(HTRANS),
        .HSIZE(HSIZE),
        .HWDATA(HWDATA),
        .HREADY(HREADY),
        .HRDATA(HRDATA),
        .HREADYOUT(HREADYOUT),
        .HRESP(HRESP)
    );
    always #(CLK_PERIOD / 2) HCLK = ~HCLK;
    task ahb_write(input logic [ADDR_WIDTH-1:0] addr, input logic [DATA_WIDTH-1:0] data);
        @(posedge HCLK);
        HSEL   <= 1'b1;
        HADDR  <= addr;
        HWRITE <= 1'b1;
        HTRANS <= 2'b10;
        @(posedge HCLK);
        HTRANS <= 2'b00; 
        HWDATA <= data;
        @(posedge HCLK);
        HSEL   <= 1'b0;
    endtask
    task ahb_read(input logic [ADDR_WIDTH-1:0] addr);
        @(posedge HCLK);
        HSEL   <= 1'b1;
        HADDR  <= addr;
        HWRITE <= 1'b0;
        HTRANS <= 2'b10; 
        @(posedge HCLK);
        HTRANS <= 2'b00;
        @(posedge HCLK);
        HSEL   <= 1'b0;
    endtask
    initial begin
        HCLK    = 0;
        HRESETn = 0;
        HSEL    = 0;
        HADDR   = 0;
        HWRITE  = 0;
        HTRANS  = 2'b00;
        HSIZE   = 3'b010;
        HWDATA  = 0;
        HREADY  = 1;
        #20;
        HRESETn = 1;
        $display("[TB] Reset Deasserted. Starting AHB Transfers...");
        ahb_write(32'h0000_0000, 32'hACE0_ACE0);
        ahb_write(32'h0000_0004, 32'hBAAD_F00D);
        #20;
        ahb_read(32'h0000_0000);
        ahb_read(32'h0000_0004);
        #40;
        $display("[TB] AHB Simulation Completed Successfully!");
        $finish;
    end
    endmodule
