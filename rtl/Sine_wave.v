`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.12.2021 14:37:23
// Design Name: 
// Module Name: Sine_wave
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


module Sine_wave
    #(
        parameter DATA_WIDTH    = 12,
        parameter ANGLE_WIDTH   = 16
    )(
    input                       clk,
    input                       reset,
    input                       ce,

    input  [DATA_WIDTH:0]       ampl, // have to multiplied on 0.607
    input  [ANGLE_WIDTH-1:0]    step, // = required_signal_freq*(6.264*2^(ANGLE_WIDTH-1))/input_freq

    output [DATA_WIDTH:0]    sin_wave,
    output [DATA_WIDTH:0]    cos_wave   
);

localparam  MID_LVL = 2 << (DATA_WIDTH-1);
localparam angle_90 = 51315;//$round(90*0.01744*(2 << (ANGLE_WIDTH-2) ));


wire signed [DATA_WIDTH:0] Xo_cordic, Yo_cordic;
reg [ANGLE_WIDTH-1:0] angle ;


wire [1:0] quarter;

localparam QUARTER_1 = 0;
localparam QUARTER_2 = 1;
localparam QUARTER_3 = 2;
localparam QUARTER_4 = 3;

reg [2:0] state;

cordic # (
    .DATA_WIDTH    (DATA_WIDTH),
    .ANGLE_WIDTH   (ANGLE_WIDTH)
    ) cordic ( 
    .clk        ( clk), 
    .rst        ( reset      ),
    .x_i        ( ampl       ), 
    .quarter_in ( state      ),
    .theta_i    ( angle      ),
    .x_o        ( Xo_cordic  ), 
    .y_o        ( Yo_cordic  ),
    .quarter_out( quarter    )
);


assign sin_wave = (quarter == QUARTER_1) | (quarter == QUARTER_2) ? MID_LVL + Yo_cordic : MID_LVL -Yo_cordic;
assign cos_wave = (quarter == QUARTER_1) | (quarter == QUARTER_4) ? MID_LVL + Xo_cordic : MID_LVL -Xo_cordic;


always@(posedge (clk & ce) )begin

    if (reset) begin
        state <= QUARTER_1;
        angle <= 0;
    end else begin
        
        case (state)

            QUARTER_1: begin

                if (angle < angle_90 - step)
                    angle <= angle + step;
                else begin
                    state <= QUARTER_2;
                end
                
            end

            QUARTER_2: begin

                if (angle > step)
                    angle <= angle - step;
                else begin
                    state <= QUARTER_3;
                end
                
            end

            QUARTER_3: begin

                if (angle < angle_90 - step)
                    angle <= angle + step;
                else begin
                    state <= QUARTER_4;
                end
                
            end

            QUARTER_4: begin

                if (angle > step)
                    angle <= angle - step;
                else begin
                    state <= QUARTER_1;
                end
                
            end

        endcase

    end
  


end

endmodule
