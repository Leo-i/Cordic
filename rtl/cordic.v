`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.12.2021 15:27:37
// Design Name: 
// Module Name: cordic
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


module cordic#(
    parameter DATA_WIDTH    = 12,
    parameter ANGLE_WIDTH   = 16
    )(
    input                           clk,
    input                           rst,
    input  signed [DATA_WIDTH:0]    x_i,
    input         [1:0]             quarter_in,
    input         [ANGLE_WIDTH-1:0]   theta_i, //вычисляемая фаза
    output signed [DATA_WIDTH:0]    x_o,
    output signed [DATA_WIDTH:0]    y_o,
    output        [1:0]             quarter_out
    );

genvar i;

wire signed   [DATA_WIDTH:0]  x_wire     [ROTATORS_COUNT:0]; 
wire signed   [DATA_WIDTH:0]  y_wire     [ROTATORS_COUNT:0]; 
wire signed   [ANGLE_WIDTH:0] z_wire     [ROTATORS_COUNT:0]; 
wire          [1:0]           quarter    [ROTATORS_COUNT:0]; 

assign x_wire[0][DATA_WIDTH:0] = x_i[DATA_WIDTH:0];
assign y_wire[0][DATA_WIDTH:0] = 0;
assign z_wire[0][ANGLE_WIDTH:0] = theta_i[ANGLE_WIDTH-1:0];
assign quarter[0][1:0] = quarter_in[1:0];

assign x_o[DATA_WIDTH:0] = x_wire[ROTATORS_COUNT][DATA_WIDTH:0];
assign y_o[DATA_WIDTH:0] = y_wire[ROTATORS_COUNT][DATA_WIDTH:0];
assign quarter_out[1:0] = quarter[ROTATORS_COUNT][1:0];

parameter ROTATORS_COUNT = 16;

generate
    for(i=0; i < ROTATORS_COUNT; i = i + 1) begin
        rotator
        #( 
        .DATA_WIDTH    (DATA_WIDTH),
        .ANGLE_WIDTH   (ANGLE_WIDTH),
        .ROTATOR_NUMBER(i)
        ) rotator (  
        .clk        ( clk ),
        .rst        ( rst ),
        .x_i        ( x_wire[i][DATA_WIDTH:0]   ),
        .y_i        ( y_wire[i][DATA_WIDTH:0]   ),
        .z_i        ( z_wire[i][ANGLE_WIDTH:0]  ),
        .quarter_in (quarter[i]                 ),
        .atan       ( tanangle(i)               ),
        .x_o        ( x_wire[i+1][DATA_WIDTH:0] ),
        .y_o        ( y_wire[i+1][DATA_WIDTH:0] ),
        .z_o        ( z_wire[i+1][ANGLE_WIDTH:0]),
        .quarter_out( quarter[i+1]              )
        );
    end
endgenerate


function [ANGLE_WIDTH:0] tanangle;
    input [3:0] i;
begin

    case (i)
    4'b0000: tanangle = 0.7850*(2 << (ANGLE_WIDTH-2) ); 
    4'b0001: tanangle = 0.4640*(2 << (ANGLE_WIDTH-2) );
    4'b0010: tanangle = 0.2450*(2 << (ANGLE_WIDTH-2) );
    4'b0011: tanangle = 0.1244*(2 << (ANGLE_WIDTH-2) ); 
    4'b0100: tanangle = 0.0624*(2 << (ANGLE_WIDTH-2) );
    4'b0101: tanangle = 0.0312*(2 << (ANGLE_WIDTH-2) ); 
    4'b0110: tanangle = 0.0156*(2 << (ANGLE_WIDTH-2) ); 
    4'b0111: tanangle = 0.0078*(2 << (ANGLE_WIDTH-2) ); 
    4'b1000: tanangle = 0.0039*(2 << (ANGLE_WIDTH-2) );
    4'b1001: tanangle = 0.00198*(2 << (ANGLE_WIDTH-2) ); 
    4'b1010: tanangle = 0.00098*(2 << (ANGLE_WIDTH-2) ); 
    4'b1011: tanangle = 0.00049*(2 << (ANGLE_WIDTH-2) ); 
    4'b1100: tanangle = 0.00024*(2 << (ANGLE_WIDTH-2) );
    4'b1101: tanangle = 0.00012*(2 << (ANGLE_WIDTH-2) ); 
    4'b1110: tanangle = 0.00006*(2 << (ANGLE_WIDTH-2) ); 
    4'b1111: tanangle = 0.00003*(2 << (ANGLE_WIDTH-2) ); 
    endcase
    end

endfunction


endmodule


