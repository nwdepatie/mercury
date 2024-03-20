/* Test App for PWM */
pub mod zynq;
use zynq::axitimer::{AXITimer, SIZEOF_AXITIMER_REG};
use std::{thread, time};
use std::env;

const TIMER_FRONT_RIGHT_ADDR : u32 = 0x42800000;
const TIMER_FRONT_LEFT_ADDR : u32 = 0x42810000;
const TIMER_BACK_RIGHT_ADDR : u32 = 0x42820000;
const TIMER_BACK_LEFT_ADDR : u32 = 0x42830000;

fn main()
{
    let args: Vec<String> = env::args().collect();

	let mut pwm_front_right = AXITimer::new(TIMER_FRONT_RIGHT_ADDR, 4096).unwrap();
    let mut pwm_front_left = AXITimer::new(TIMER_FRONT_LEFT_ADDR, 4096).unwrap();
    let mut pwm_back_right = AXITimer::new(TIMER_BACK_RIGHT_ADDR, 4096).unwrap();
    let mut pwm_back_left = AXITimer::new(TIMER_BACK_LEFT_ADDR, 4096).unwrap();

	let mut duty_cycle : u32 = args[1].parse().unwrap();

    loop{
        println!("Attempting to write {}...", duty_cycle);
        println!("PWM 1:");
        pwm_front_right.start_pwm(100, duty_cycle);
        println!("PWM 2:");
        pwm_front_left.start_pwm(100, duty_cycle);
        println!("PWM 3:");
        pwm_back_right.start_pwm(100, duty_cycle);
        println!("PWM 4:");
        pwm_back_left.start_pwm(20, duty_cycle);
        duty_cycle = (duty_cycle + 1) % 100;
        println!("END\n\n");
        thread::sleep(time::Duration::from_millis(50));
    }
}