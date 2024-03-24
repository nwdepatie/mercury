`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/24/2024 11:11:54 AM
// Design Name: 
// Module Name: stepper_pulse_test
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


`timescale 1ns / 1ps

module stepper_pulse_tb;

// Inputs
reg clk;
reg rst_n;
reg [31:0] pulse_count;

// Outputs
wire pulse;
wire done;

// Instantiate the Unit Under Test (UUT)
stepper_pulse uut (
    .clk(clk), 
    .rst_n(rst_n), 
    .pulse_count(pulse_count), 
    .pulse(pulse), 
    .done(done)
);

initial begin
    // Initialize Inputs
    clk = 0;
    rst_n = 0;
    pulse_count = 20; // Example pulse count

    // Reset the design
    #100;
    rst_n = 1;
    
    // Wait 1000 ns for global reset to finish
    #10000000;
    
end

// Clock generation
always #10 clk = ~clk; // Generate a clock with a period of 20ns (50MHz)

endmodule

