`timescale 1ns / 1ps
module vga(input clk25,
	       output [3:0] vga_red,
	       output [3:0] vga_green,
           output [3:0] vga_blue,
           output vga_hsync,
           output vga_vsync,
           output [18:0] frame_addr,
           input [11:0] frame_pixel); 
	
	
	
	parameter hRez = 640;
	parameter hStartSync = 640+16;
	parameter hEndSync = 640+16+96;
	parameter hMaxCount = 800;

	parameter vRez = 480;
	parameter vStartSync = 480+10;
	parameter vEndSync = 480+10+2;
	parameter vMaxCount = 480+10+2+33;

	parameter hsync_active = 0;
	parameter vsync_active = 0;
	
	reg unsigned [9:0] hCounter = {10{1'b0}};
	reg unsigned [9:0] vCounter = {10{1'b0}};
	reg unsigned [18:0] address = {19{1'b0}};
	reg unsigned [18:0] address_temp = {19{1'b0}};
	reg blank = 1;
	
	reg [3:0] vga_red_temp;
	reg [3:0] vga_blue_temp;
	reg [3:0] vga_green_temp;
	reg vga_hsync_temp;
	reg vga_vsync_temp;
	
        
	always @(posedge clk25)
		begin
			if (hCounter == hMaxCount-1)
				begin
					hCounter <= {10{1'b0}};
					if(vCounter == vMaxCount-1)
						begin
							vCounter <= {10{1'b0}};
						end
                    else 
                        begin
                            vCounter <= vCounter+1;
                        end
				end
			else 
				begin
					hCounter <= hCounter+1;
				end	
			
			
			
			if(blank == 0)
				begin
					vga_red_temp   <= frame_pixel[11:8];
					vga_green_temp <= frame_pixel[7:4];
					vga_blue_temp  <= frame_pixel[3:0];
				end
			else
				begin
					vga_red_temp   <= {4{1'b0}};
					vga_green_temp <= {4{1'b0}};
					vga_blue_temp <= {4{1'b0}};
				end
			
			
			
			if(vCounter >= vRez)
				begin
					address <= {19{1'b0}};
					blank <= 1;
				end
			else
				begin
					if(hCounter < 640)
						begin
							blank <= 0;
							address <= address+1'b1;
						end
					else
						begin
							blank <= 1;
						end
				end
			
			
			if(hCounter > hStartSync && hCounter <= hEndSync)
				begin
					vga_hsync_temp <= hsync_active;
				end
			else
				begin
					vga_hsync_temp <= !hsync_active;
				end
				
			
			if(vCounter >= vStartSync && vCounter < vEndSync)
				begin
					vga_vsync_temp <= vsync_active;
				end
			else
				begin
					vga_vsync_temp <= !vsync_active;
				end
			
		end
	
	assign frame_addr = address;
	assign vga_red = vga_red_temp;
	assign vga_blue = vga_blue_temp;
	assign vga_green = vga_green_temp;
	assign vga_hsync = vga_hsync_temp;
	assign vga_vsync = vga_vsync_temp;
	
	
endmodule