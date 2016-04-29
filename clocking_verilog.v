`timescale 1ns / 1ps

module clocking_verilog(input clk_in, output clk_out);

    wire clk_in;
    reg clk_out;
 
    always @ (posedge clk_in)
        begin
            clk_out <= !clk_out ; 
        end
endmodule
