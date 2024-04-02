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
    output pulse_out, // Pulse output to stepper motor
    output done_out // Signal to indicate when pulsing is complete
);

reg[31:0] pulse_count_internal = 0;
reg[17:0] pulse_length_counter = 0;
reg[17:0] pulse_length_counter_r = 0;
reg in_progress = 0;
reg done = 1;
//reg temp_stop = 0;

assign pulse_out = pulse_length_counter[17];
assign done_out = done;

// Pulse generation control
always @(posedge clk) begin
    // The Sean special
    pulse_length_counter_r <= pulse_length_counter;
    
    // reset
    if (pulse_count == 0) begin
        done <= 0;
    end
    // New set of pulses to send
    if (in_progress == 0 && pulse_count > 0 && done == 0) begin
        pulse_count_internal <= pulse_count;
        in_progress <= 1;
        if (pulse_count_internal != 0)
            done <= 0;
    // Continuously pulse
    end else if (pulse_count_internal > 0 && in_progress == 1) begin
        // Continuously pulse
        pulse_length_counter <= pulse_length_counter + 1;
        
        // if pulse is delivered
        if (pulse_length_counter[17] < pulse_length_counter_r[17]) begin
            // decrease pulse count
            pulse_count_internal <= pulse_count_internal - 1;
            // if we reach 0 set done bit
            //if (pulse_count_internal <= 0) begin
            //    in_progress <= 0;
             //   done <= 1;
                //temp_stop <= 1;
          //  end
        end
    end else if (pulse_count_internal <= 0 && in_progress == 1) begin
        in_progress <= 0;
        done <= 1;    
    end
    
end
endmodule
/*
always @(posedge pulse_length_counter[16]) begin
    pulse_count_internal <= pulse_count_internal - 1;
    if (pulse_count_internal == 0) begin
        in_progress <= 0;
        done <= 1;
        temp_stop <= 1;
    end
end
*/
/*
always @(posedge pulse_length_counter[16]) begin
    if (pulse_count_internal > 0) begin
        pulse_count_internal = pulse_count_internal - 1;
    end
endcase            
*/
    //if (!generating) begin
    //    done <= 1'b0; // Ensure 'done' is low when we are not in generating state
    //end
    
//assign pulse_out = pulse_count[4];

//assign pulse_out = 1;
/*
localparam DIVIDE_BY = 200000000; // 100MHz / 200000 = 0.5KHz toggle rate, 1KHz pulse rate

// Internal signals
reg [31:0] pulse_counter; // Counter for pulses generated
reg generating = 0; // Flag to indicate if pulse generation is active
reg pulse = 0;

// Pulse generation control
always @(posedge clk) begin
    if (pulse_counter < pulse_count && generating) begin
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
        // Start generating pulse
        generating <= 1'b1;
        pulse_counter <= 32'd0; // Reset counter
        done <= 1'b0; // Ensure done is low at the start
    end

    //if (!generating) begin
    //    done <= 1'b0; // Ensure 'done' is low when we are not in generating state
    //end
end

assign pulse_out = pulse;
*/
/*
always @(negedge rst_n) begin
    if (!rst_n) begin
        // Reset condition
        pulse_counter <= 32'd0;
        pulse <= 1'b0;
        generating <= 1'b0;
        done <= 1'b0;
    end
end
*/

//endmodule

