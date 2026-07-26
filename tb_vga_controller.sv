// ABDUL RAFAY
// PSEB USTP INSPIRE SESSION
// SIR SYED UNIVERSITY OF ENGINEERING & TECHNOLOGY
// WEEK # 04 (RTL)
// CODE TASK # 01
// TEST-BENCH VIDEO GRAPHICS CONTROLLER (VGA CONTROLLER) USING SRAM
module tb_vga_controller;
    logic        clk;
    logic        rst_n;
    logic [7:0]  sram_data;
    logic [16:0] sram_addr;
    logic        sram_oe;
    logic [3:0]  vga_r;
    logic [3:0]  vga_g;
    logic [3:0]  vga_b;
    logic        vga_hsync;
    logic        vga_vsync;
    logic        vga_blank;
    logic [7:0] sram_mem [0:307199];
    vga_controller uut (
        .clk(clk),
        .rst_n(rst_n),
        .sram_data(sram_data),
        .sram_addr(sram_addr),
        .sram_oe(sram_oe),
        .vga_r(vga_r),
        .vga_g(vga_g),
        .vga_b(vga_b),
        .vga_hsync(vga_hsync),
        .vga_vsync(vga_vsync),
        .vga_blank(vga_blank)
    );
    initial begin
        clk = 0;
        forever #20 clk = ~clk;
    end
    initial begin
        $dumpfile("vga_controller.vcd");
        $dumpvars(0, tb_vga_controller);
    end
    initial begin
        integer i;
        for (i = 0; i < 307200; i++) begin
            sram_mem[i] = 8'h00;
        end
        for (i = 0; i < 6400; i++) begin
            sram_mem[i] = 8'hF0;
        end
        for (i = 6400; i < 12800; i++) begin
            sram_mem[i] = 8'h0F;
        end
    end
    always_comb begin
        if (sram_oe) begin
            sram_data = sram_mem[sram_addr];
        end else begin
            sram_data = 8'h00;
        end
    end
    initial begin
        rst_n = 1'b0;
        #100 rst_n = 1'b1;
        #2000000 $finish;
    end
endmodule