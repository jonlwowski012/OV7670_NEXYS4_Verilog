`timescale 1ns / 1ps

module OV7670_top_verilog(input clk100, output OV7670_SIOC, inout OV7670_SIOD, output OV7670_RESET,
                          output OV7670_PWDN, input OV7670_VSYNC, input OV7670_HREF, input OV7670_PCLK,
                          output OV7670_XCLK, input [7:0] OV7670_D, output [7:0] LED, output [3:0] vga_red,
                          output [3:0] vga_green, output [3:0] vga_blue, output vga_hsync, output vga_vsync, input btn);
                          
    wire [18:0] frame_addr;
    wire [11:0] frame_pixel;
    wire [18:0] capture_addr;
    wire [11:0] capture_data;
    wire capture_we;
    wire resend;
    wire config_finished;
    
    reg clk_feedback;
    reg clk50u;
    wire clk50;
    reg clk25u;
    wire clk25;
    reg buffered_pclk;
    
    assign LED = 8'b00000000 & config_finished;
                          
    debounce db1(.clk(clk50),.i(btn),.o(resend));
    vga vg1(.clk25(clk25),.vga_red(vga_red),.vga_green(vga_green),.vga_blue(vga_blue),.vga_hsync(vga_hsync),.vga_vsync(vga_vsync),.frame_addr(frame_addr),.frame_pixel(frame_pixel));
    frame_buffer fb1(.clka(OV7670_PCLK),.wea(capture_we),.addra(capture_addr),.dina(capture_data),.clkb(clk50),.addrb(frame_addr),.doutb(frame_pixel));
    ov7670_capture_verilog cap1(.pclk(OV7670_PCLK),.vsync(OV7670_VSYNC),.href(OV7670_HREF),.d(OV7670_D),.addr(capture_addr),.dout(capture_data),.we(capture_we));
    ov7670_controller_verilog con1(.clk(clk50),.sioc(OV7670_SIOC),.resend(resend),.config_finished(config_finished),.siod(OV7670_SIOD),.pwdn(OV7670_PWDN),.reset(OV7670_RESET),.xclk(OV7670_XCLK));
    
    clocking_verilog clk1(.clk_in(clk100),.clk_out(clk50));
    clocking_verilog clk2(.clk_in(clk50),.clk_out(clk25));
    
endmodule
