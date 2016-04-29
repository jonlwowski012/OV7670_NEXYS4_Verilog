`timescale 1ns / 1ps

module ov7670_capture_verilog(input pclk,
                              input vsync,
                              input href,
                              input [7:0] d,
                              output [18:0] addr,
                              output [11:0] dout,
                              output we);
                              
    reg [15:0] d_latch = {16{1'b0}};
    reg [18:0] address = {19{1'b0}};
    reg  unsigned [18:0] address_next = {19{1'b0}};
    reg [1:0] wr_hold = {2{1'b0}};
    
    reg [11:0] dout_temp;
    reg we_temp;
    
    assign addr = address;
    assign dout = dout_temp;
    assign we = we_temp;
    
    always@ (posedge pclk)
        begin
            if(vsync == 1)
                begin
                    address <= {19{1'b0}};
                    address_next <= {19{1'b0}};
                    wr_hold <= {2{1'b0}};
                end
            else
                begin
                    dout_temp <= {d_latch[15:12],d_latch[10:7],d_latch[4:1]};
                    address <= address_next;
                    we_temp <= wr_hold[1];
                    wr_hold <= {wr_hold[0], (href && !wr_hold[0])};
                    d_latch <= {d_latch [7:0], d};
                    
                    if(wr_hold[1] == 1)
                        begin
                            address_next <= address_next+1;
                        end
                end
        end
        
endmodule
