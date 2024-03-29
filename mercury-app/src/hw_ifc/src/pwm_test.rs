/* Test App for PWM */
pub mod zynq;
use std::env;
use std::{thread, time};
use zynq::axitimer::{AXITimer, SIZEOF_AXITIMER_REG};
pub mod regmap;
use self::regmap::{
    DRV_DIR_GPIO_ADDR, DRV_TIMER_BACK_LEFT_ADDR, DRV_TIMER_BACK_RIGHT_ADDR,
    DRV_TIMER_FRONT_LEFT_ADDR, DRV_TIMER_FRONT_RIGHT_ADDR,
};

fn main() {
    let args: Vec<String> = env::args().collect();

    let mut pwm_front_right = AXITimer::new(DRV_TIMER_FRONT_RIGHT_ADDR, 4096).unwrap();
    let mut pwm_front_left = AXITimer::new(DRV_TIMER_FRONT_LEFT_ADDR, 4096).unwrap();
    let mut pwm_back_right = AXITimer::new(DRV_TIMER_BACK_RIGHT_ADDR, 4096).unwrap();
    let mut pwm_back_left = AXITimer::new(DRV_TIMER_BACK_LEFT_ADDR, 4096).unwrap();

    let mut duty_cycle: u32 = args[1].parse().unwrap();

    loop {
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
