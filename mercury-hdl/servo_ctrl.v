`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/21/2024 11:49:41 AM
// Design Name: 
// Module Name: servo_ctrl
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


module servo_ctrl(
    input wire clk, // System clock
    input wire set, 
    input wire servo_dir,
    input wire[31:0] duration,
    output pwm,
    output done
);

/* 
 * Note: servo opens at one duty cycle, closes at another, doesn't move at 0 duty cycle, we are hardcoding this 
 * These duty cycles were chosen because they are roughly the same servo speed
 */
parameter pwm_period = 20000;//204081; /* num clock pulses inside 490 Hz PWM period */
parameter close_duty_period = pwm_period * 549 / 1000;
parameter open_duty_period = pwm_period * 941 / 1000;

reg[31:0] pwm_gen = 0;
reg running = 0;
reg pwm_out = 0;
reg[63:0] current_time = 0;

assign pwm = pwm_out;
assign done = ~running;
//assign pwm = pwm_gen[18];

always @(posedge clk) begin
    if (duration != 0) begin 
        pwm_out <= 1;
    end
    else
        pwm_out <= 0;
end
/*
pwm_gen <= pwm_gen + 1;
    if (set) begin
        running <= 1;
        current_time <= 0;
        pwm_gen <= 0;
    end else if (running) begin
        if (current_time < duration * 1000) begin
            pwm_gen <= (pwm_gen == pwm_period - 1) ? 0 : pwm_gen + 1;
            pwm_out <= (servo_dir ? (pwm_gen < close_duty_period) : (pwm_gen < open_duty_period));
            current_time <= current_time + 1;
        end else begin
            running <= 0;
            pwm_out <= 0;
        end
    end else begin
        pwm_out <= 0;
    end
*/
endmodule

//endmodule

