`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/21/2024 11:49:41 AM
// Design Name: 
// Module Name: stepper_pulse
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


module stepper_pulse(
    input wire clk, // System clock
    input wire rst_n, // Active low reset
    input wire [31:0] pulse_count, // Number of pulses to generate from AXI GPIO
    output reg pulse, // Pulse output to stepper motor
    output reg done // Signal to indicate when pulsing is complete
);

localparam DIVIDE_BY = 2000; // 1000KHz / 2000 = 0.5KHz toggle rate, 1KHz pulse rate

// Internal signals
reg [31:0] pulse_counter; // Counter for pulses generated
reg generating; // Flag to indicate if pulse generation is active

// Pulse generation control
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset condition
        pulse_counter <= 32'd0;
        pulse <= 1'b0;
        generating <= 1'b0;
        done <= 1'b0;
    end else if (pulse_counter < pulse_count && generating) begin
        // Generate pulse
        pulse <= !pulse; // Toggle the pulse
        done <= 1'b0; // Not done yet
        if (pulse) // Count on one edge to avoid double counting
            pulse_counter <= pulse_counter + 1;
    end else if (generating) begin
        // Finished generating pulses
        generating <= 1'b0;
        pulse <= 1'b0; // Ensure pulse is low when not generating
        done <= 1'b1; // Signal that pulsing is complete
    end else if (pulse_count > 0 && !generating && pulse_counter == 0) begin
        generating <= 1'b1;
        pulse_counter <= 32'd0; // Reset counter
        done <= 1'b0; // Ensure done is low at the start
    end

    if (!generating) begin
        done <= 1'b0; // Ensure 'done' is low when we are not in generating state
    end
end

endmodule

