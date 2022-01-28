`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/28/2022 11:46:54 AM
// Design Name: 
// Module Name: tb_coridic
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`define CLK_PERIOD  5.00ns

module tb_coridic();

reg clk = 0;
reg ce = 1;
reg reset = 1;


initial begin
    #(10*`CLK_PERIOD);
    reset <= 1'b0;
end


wire [11:0] sin_wave;
wire [11:0] cos_wave;

Sine_wave #(
.DATA_WIDTH (12),
.ANGLE_WIDTH(16)
) Sine_wave (
.clk            ( clk      ),
.reset          ( reset    ),
.ce             ( ce       ),
.ampl           ( 800      ), 
.step           ( 500      ), 
.sin_wave       ( sin_wave ),
.cos_wave       ( cos_wave )  
);


always begin
    #(`CLK_PERIOD/2) clk = ~clk;
end

endmodule
