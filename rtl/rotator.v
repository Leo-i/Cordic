`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.12.2021 15:51:13
// Design Name: 
// Module Name: rotator
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


module rotator
    #( 
    parameter DATA_WIDTH    = 12,
    parameter ANGLE_WIDTH   = 16,
    parameter ROTATOR_NUMBER = 1
    )(  
    input                                   clk,
    input                                   rst,

    input  wire signed [DATA_WIDTH:0]       x_i,
    input  wire signed [DATA_WIDTH:0]       y_i,
    input  wire signed [ANGLE_WIDTH:0]      z_i,
    input              [1:0]                quarter_in,
    input  wire        [ANGLE_WIDTH:0]      atan,

    output reg signed  [DATA_WIDTH:0]       x_o,
    output reg signed  [DATA_WIDTH:0]       y_o,
    output reg signed  [ANGLE_WIDTH:0]      z_o,
    output reg         [1:0]                quarter_out
);

wire signed [DATA_WIDTH:0] shifted_x;
wire signed [DATA_WIDTH:0] shifted_y;
assign shifted_x = x_i >>> ROTATOR_NUMBER;
assign shifted_y = y_i >>> ROTATOR_NUMBER;

always@(posedge clk)begin
    
    if (rst) begin

        x_o <= 0;
        y_o <= 0;
        z_o <= 0;
        quarter_out <=0;

    end else begin

        quarter_out <= quarter_in;

        if (z_i > 0) begin

            x_o = x_i - shifted_y;
            y_o = y_i + shifted_x;
            z_o = z_i - atan;
             
        end else begin

            x_o = x_i + shifted_y;
            y_o = y_i - shifted_x;
            z_o = z_i + atan;
            
        end
    end

end

endmodule
