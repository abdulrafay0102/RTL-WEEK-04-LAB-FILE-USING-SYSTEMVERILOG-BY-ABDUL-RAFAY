// ABDUL RAFAY
// PSEB USTP INSPIRE SESSION
// SIR SYED UNIVERSITY OF ENGINEERING & TECHNOLOGY
// WEEK # 02 (IND. PROTOCOL)
// AHB SLAVE 
module ahb_slave #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32,
    parameter MEM_DEPTH  = 8
)(
    input  logic                    HCLK,
    input  logic                    HRESETn,  
    input  logic                    HSEL,      
    input  logic [ADDR_WIDTH-1:0]   HADDR,     
    input  logic                    HWRITE,    
    input  logic [1:0]              HTRANS,   
    input  logic [2:0]              HSIZE,     
    input  logic [DATA_WIDTH-1:0]   HWDATA,    
    input  logic                    HREADY,    
    output logic [DATA_WIDTH-1:0]   HRDATA,    
    output logic                    HREADYOUT, 
    output logic                    HRESP      
);
    localparam TRN_IDLE   = 2'b00;
    localparam TRN_NONSEQ = 2'b10;
    logic [DATA_WIDTH-1:0] mem [0:MEM_DEPTH-1];
    logic [ADDR_WIDTH-1:0] addr_reg;
    logic                  write_reg;
    logic                  active_reg;
    always_ff @(posedge HCLK or negedge HRESETn) begin
        if (!HRESETn) begin
            addr_reg   <= '0;
            write_reg  <= '0;
            active_reg <= '0;
        end else if (HREADY) begin
            if (HSEL && (HTRANS == TRN_NONSEQ)) begin
                addr_reg   <= HADDR;
                write_reg  <= HWRITE;
                active_reg <= 1'b1;
            end else begin
                active_reg <= 1'b0;
            end
        end
    end
    always_comb begin
        HREADYOUT = 1'b1;
        HRESP     = 1'b0;
    end
    always_ff @(posedge HCLK or negedge HRESETn) begin
        if (!HRESETn) begin
            HRDATA <= '0;
            for (int i = 0; i < MEM_DEPTH; i++) begin
                mem[i] <= '0;
            end
        end else begin
            if (active_reg && HREADYOUT) begin
                if (write_reg) begin
                    mem[addr_reg % MEM_DEPTH] <= HWDATA; 
                end else begin
                    HRDATA <= mem[addr_reg % MEM_DEPTH]; 
                end
            end
        end
    end
endmodule
