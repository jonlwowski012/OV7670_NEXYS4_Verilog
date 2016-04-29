`timescale 1ns / 1ps
module ov7670_controller_verilog(input clk, input resend, output config_finished, output sioc, inout siod, output reset, output pwdn, output xclk);

    reg sys_clk = 0;
    wire [15:0] command;
    wire finished = 0;
    wire taken = 0;
    reg send;
    reg [7:0] camera_address = 2'h42;
    
    assign config_finished = finished;
    
    
    assign reset = 1;
    assign pwdn = 0;
    assign xclk = sys_clk;
    
    always@(finished)
        begin
            send = ~finished;
        end
    always@(posedge clk)
        begin
            sys_clk = ~sys_clk;
        end
    
    ov7670_registers_verilog orv(.clk(clk),.advance(taken), .command(command), .finished(finished), .resend(resend));
    i2c_sender_verilog isv(.clk(clk), .taken(taken), .siod(siod), .sioc(sioc), .send(send), .id(camera_address), .rega(command[15:8]), .value(command[7:0]));
endmodule
