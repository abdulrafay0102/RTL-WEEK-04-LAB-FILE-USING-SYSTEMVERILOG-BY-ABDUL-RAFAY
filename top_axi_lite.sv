// ABDUL RAFAY
// PSEB USTP INSPIRE SESSION
// SIR SYED UNIVERSITY OF ENGINEERING & TECHNOLOGY
// WEEK # 04 (RTL)
// CODE TASK # 02
// TOP AXI LITE
module top_axi_lite (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        start,
    input  logic        wr_rd,
    input  logic [7:0]  addr,
    input  logic [31:0] wdata,
    output logic [31:0] rdata,
    output logic        done
);
    logic        awvalid;
    logic        awready;
    logic [7:0]  awaddr;
    logic        wvalid;
    logic        wready;
    logic [31:0] wdata_out;
    logic [3:0]  wstrb;
    logic        bready;
    logic        bvalid;
    logic [1:0]  bresp;
    logic        arvalid;
    logic        arready;
    logic [7:0]  araddr;
    logic        rvalid;
    logic        rready;
    logic [31:0] rdata_in;
    logic [1:0]  rresp;
    axi_lite_master master (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .wr_rd(wr_rd),
        .addr(addr),
        .wdata(wdata),
        .rdata(rdata),
        .done(done),
        .awvalid(awvalid),
        .awready(awready),
        .awaddr(awaddr),
        .wvalid(wvalid),
        .wready(wready),
        .wdata_out(wdata_out),
        .wstrb(wstrb),
        .bready(bready),
        .bvalid(bvalid),
        .bresp(bresp),
        .arvalid(arvalid),
        .arready(arready),
        .araddr(araddr),
        .rvalid(rvalid),
        .rready(rready),
        .rdata_in(rdata_in),
        .rresp(rresp)
    );
    axi_lite_slave slave (
        .clk(clk),
        .rst_n(rst_n),
        .awvalid(awvalid),
        .awready(awready),
        .awaddr(awaddr),
        .wvalid(wvalid),
        .wready(wready),
        .wdata(wdata_out),
        .wstrb(wstrb),
        .bready(bready),
        .bvalid(bvalid),
        .bresp(bresp),
        .arvalid(arvalid),
        .arready(arready),
        .araddr(araddr),
        .rvalid(rvalid),
        .rready(rready),
        .rdata(rdata_in),
        .rresp(rresp)
    );
endmodule