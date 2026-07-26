// ABDUL RAFAY
// PSEB USTP INSPIRE SESSION
// SIR SYED UNIVERSITY OF ENGINEERING & TECHNOLOGY
// WEEK # 04 (RTL)
// CODE TASK # 02
// AXI LITE MASTER 
module axi_lite_master (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        start,
    input  logic        wr_rd,
    input  logic [7:0]  addr,
    input  logic [31:0] wdata,
    output logic [31:0] rdata,
    output logic        done,
    output logic        awvalid,
    input  logic        awready,
    output logic [7:0]  awaddr,
    output logic        wvalid,
    input  logic        wready,
    output logic [31:0] wdata_out,
    output logic [3:0]  wstrb,
    output logic        bready,
    input  logic        bvalid,
    input  logic [1:0]  bresp,
    output logic        arvalid,
    input  logic        arready,
    output logic [7:0]  araddr,
    input  logic        rvalid,
    output logic        rready,
    input  logic [31:0] rdata_in,
    input  logic [1:0]  rresp
);
    typedef enum logic [1:0] {IDLE, WRITE, READ} state_t;
    state_t state, next_state;
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end
    always_comb begin
        next_state = state;
        case (state)
            IDLE: begin
                if (start && wr_rd)
                    next_state = WRITE;
                else if (start && !wr_rd)
                    next_state = READ;
            end
            WRITE: if (bvalid && bready) next_state = IDLE;
            READ:  if (rvalid && rready) next_state = IDLE;
        endcase
    end
    always_comb begin
        awvalid = 1'b0;
        awaddr = 8'd0;
        wvalid = 1'b0;
        wdata_out = 32'd0;
        wstrb = 4'hF;
        bready = 1'b0;
        arvalid = 1'b0;
        araddr = 8'd0;
        rready = 1'b0;
        rdata = 32'd0;
        done = 1'b0;
        case (state)
            IDLE: begin
                awaddr = addr;
                araddr = addr;
                wdata_out = wdata;
            end
            WRITE: begin
                awvalid = 1'b1;
                awaddr = addr;
                if (awready) begin
                    wvalid = 1'b1;
                    wdata_out = wdata;
                    if (wready) begin
                        bready = 1'b1;
                        if (bvalid && bready) begin
                            done = 1'b1;
                        end
                    end
                end
            end
            READ: begin
                arvalid = 1'b1;
                araddr = addr;
                if (arready) begin
                    rready = 1'b1;
                    if (rvalid && rready) begin
                        rdata = rdata_in;
                        done = 1'b1;
                    end
                end
            end
        endcase
    end
endmodule