// ABDUL RAFAY
// PSEB USTP INSPIRE SESSION
// SIR SYED UNIVERSITY OF ENGINEERING & TECHNOLOGY
// WEEK # 04 (RTL)
// CODE TASK # 02
// AXI LITE SLAVE 
module axi_lite_slave (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        awvalid,
    output logic        awready,
    input  logic [7:0]  awaddr,
    input  logic        wvalid,
    output logic        wready,
    input  logic [31:0] wdata,
    input  logic [3:0]  wstrb,
    input  logic        bready,
    output logic        bvalid,
    output logic [1:0]  bresp,
    input  logic        arvalid,
    output logic        arready,
    input  logic [7:0]  araddr,
    output logic        rvalid,
    input  logic        rready,
    output logic [31:0] rdata,
    output logic [1:0]  rresp
);
    logic [31:0] mem [0:255];
    typedef enum logic [1:0] {IDLE, WR_RESP, RD_RESP} state_t;
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
                if (awvalid && wvalid)
                    next_state = WR_RESP;
                else if (arvalid)
                    next_state = RD_RESP;
            end
            WR_RESP: if (bready) next_state = IDLE;
            RD_RESP: if (rready) next_state = IDLE;
        endcase
    end
    always_comb begin
        awready = 1'b0;
        wready = 1'b0;
        bvalid = 1'b0;
        bresp = 2'b00;
        arready = 1'b0;
        rvalid = 1'b0;
        rdata = 32'd0;
        rresp = 2'b00;
        case (state)
            IDLE: begin
                awready = 1'b1;
                arready = 1'b1;
            end
            WR_RESP: begin
                if (awvalid && wvalid) begin
                    mem[awaddr] = wdata;
                    bvalid = 1'b1;
                    bresp = 2'b00;
                end
            end
            RD_RESP: begin
                if (arvalid) begin
                    rdata = mem[araddr];
                    rvalid = 1'b1;
                    rresp = 2'b00;
                end
            end
        endcase
    end
endmodule