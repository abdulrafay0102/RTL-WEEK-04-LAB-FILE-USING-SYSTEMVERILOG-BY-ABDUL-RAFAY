// ABDUL RAFAY
// PSEB USTP INSPIRE SESSION
// SIR SYED UNIVERSITY OF ENGINEERING & TECHNOLOGY
// WEEK # 04 (RTL)
// CODE TASK # 01
// VIDEO GRAPHICS CONTROLLER (VGA CONTROLLER) USING SRAM
module vga_controller (
    input  logic        clk,
    input  logic        rst_n,
    input  logic [7:0]  sram_data,
    output logic [16:0] sram_addr,
    output logic        sram_oe,
    output logic [3:0]  vga_r,
    output logic [3:0]  vga_g,
    output logic [3:0]  vga_b,
    output logic        vga_hsync,
    output logic        vga_vsync,
    output logic        vga_blank
);
    logic [9:0] h_count;
    logic [9:0] v_count;
    logic       h_visible;
    logic       v_visible;
    logic       video_active;
    localparam H_VISIBLE = 640;
    localparam H_FRONT   = 16;
    localparam H_SYNC    = 96;
    localparam H_BACK    = 48;
    localparam H_TOTAL   = 800;
    localparam V_VISIBLE = 480;
    localparam V_FRONT   = 10;
    localparam V_SYNC    = 2;
    localparam V_BACK    = 33;
    localparam V_TOTAL   = 525;
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            h_count <= 10'd0;
        end else if (h_count == H_TOTAL - 1) begin
            h_count <= 10'd0;
        end else begin
            h_count <= h_count + 10'd1;
        end
    end
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            v_count <= 10'd0;
        end else if (h_count == H_TOTAL - 1) begin
            if (v_count == V_TOTAL - 1) begin
                v_count <= 10'd0;
            end else begin
                v_count <= v_count + 10'd1;
            end
        end
    end
    assign h_visible = (h_count < H_VISIBLE) ? 1'b1 : 1'b0;
    assign v_visible = (v_count < V_VISIBLE) ? 1'b1 : 1'b0;
    assign video_active = h_visible && v_visible;
    assign vga_hsync = ((h_count >= (H_VISIBLE + H_FRONT)) && 
                        (h_count < (H_VISIBLE + H_FRONT + H_SYNC))) ? 1'b0 : 1'b1;
    assign vga_vsync = ((v_count >= (V_VISIBLE + V_FRONT)) && 
                        (v_count < (V_VISIBLE + V_FRONT + V_SYNC))) ? 1'b0 : 1'b1;
    assign vga_blank = ~video_active;
    assign sram_addr = video_active ? {9'd0, v_count[8:1], h_count[9:1]} : 17'd0;
    assign sram_oe = video_active;
    assign vga_r = video_active ? sram_data[7:4] : 4'd0;
    assign vga_g = video_active ? sram_data[3:2] : 4'd0;
    assign vga_b = video_active ? sram_data[1:0] : 4'd0;
endmodule