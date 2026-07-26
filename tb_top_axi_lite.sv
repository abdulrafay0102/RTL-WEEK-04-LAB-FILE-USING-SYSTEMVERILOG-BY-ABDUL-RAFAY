// ABDUL RAFAY
// PSEB USTP INSPIRE SESSION
// SIR SYED UNIVERSITY OF ENGINEERING & TECHNOLOGY
// WEEK # 04 (RTL)
// CODE TASK # 02
// TEST-BENCH FOR AXI LITE
module tb_top_axi_lite;
    logic        clk;
    logic        rst_n;
    logic        start;
    logic        wr_rd;
    logic [7:0]  addr;
    logic [31:0] wdata;
    logic [31:0] rdata;
    logic        done;
    top_axi_lite dut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .wr_rd(wr_rd),
        .addr(addr),
        .wdata(wdata),
        .rdata(rdata),
        .done(done)
    );
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    initial begin
        $dumpfile("axi_lite.vcd");
        $dumpvars(0, tb_top_axi_lite);
    end
    initial begin
        rst_n = 1'b0;
        start = 1'b0;
        wr_rd = 1'b0;
        addr = 8'd0;
        wdata = 32'd0;
        #15 rst_n = 1'b1;
        #10;       
        wr_rd = 1'b1;
        addr = 8'h10;
        wdata = 32'hA5A5A5A5;
        start = 1'b1;
        #10 start = 1'b0;
        wait(done);
        #10;
        wr_rd = 1'b1;
        addr = 8'h20;
        wdata = 32'h12345678;
        start = 1'b1;
        #10 start = 1'b0;
        wait(done);
        #10;
        wr_rd = 1'b0;
        addr = 8'h10;
        start = 1'b1;
        #10 start = 1'b0;
        wait(done);
        #10;        
        wr_rd = 1'b0;
        addr = 8'h20;
        start = 1'b1;
        #10 start = 1'b0;
        wait(done);
        #20;
        $finish;
    end
endmodule