`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/03/2024 03:44:32 AM
// Design Name: 
// Module Name: servo_ctrl_tb
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

module servo_ctrl_tb;

// Testbench generated signals
reg clk;
reg set;
reg servo_dir;
reg [31:0] duration;
wire pwm;
wire done;

// Instantiate the Unit Under Test (UUT)
servo_ctrl uut (
    .clk(clk),
    .set(set),
    .servo_dir(servo_dir),
    .duration(duration),
    .pwm(pwm),
    .done(done),
    .ahhh(ahhh)
);

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk; // Generate a clock with a period of 10ns (100MHz)
end

// Test stimulus
initial begin
    // Initialize Inputs
    set = 0;
    servo_dir = 0;
    duration = 0;

    // Wait for global reset
    #100;

    // Scenario 1: Set direction to open, duration to a specific time
    servo_dir = 0; // Assuming 0 for open, 1 for close
    duration = 100; // Set duration for PWM signal
    #10; // Wait a bit before starting
    set = 1; // Trigger the start of PWM operation
    #10; // Wait a bit and then release set
    set = 0;
    
    // Wait for the operation to complete
    wait(done == 1);
    #100; // Wait some time after operation completes

    // Scenario 2: Set direction to close, with a different duration
    servo_dir = 1; // Change direction
    duration = 200; // New duration for PWM signal
    #10; // Small delay
    set = 1; // Start operation
    #10; // Delay then release set
    set = 0;

    // Wait and observe
    #50000000; // Wait enough time to observe the behavior

    $finish; // End simulation
end

endmodule

