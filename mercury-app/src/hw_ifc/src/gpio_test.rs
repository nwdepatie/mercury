/* Test App for GPIO */
pub mod zynq;
use std::env;
use std::{thread, time};
use zynq::axigpio::{
    GPIOChannel::GpioChannel1, GPIOChannel::GpioChannel2, AXIGPIO, SIZEOF_AXIGPIO_REG,
};
pub mod regmap;
use self::regmap::{
    DRV_DIR_GPIO_ADDR, DRV_TIMER_BACK_LEFT_ADDR, DRV_TIMER_BACK_RIGHT_ADDR,
    DRV_TIMER_FRONT_LEFT_ADDR, DRV_TIMER_FRONT_RIGHT_ADDR, GANTRY_STEP2_ADDR,
};

fn main() {
    let args: Vec<String> = env::args().collect();

    /* Note that this is testing GPIO preconfigured to be an output */
    let mut gpio0 = AXIGPIO::new(GANTRY_STEP2_ADDR, SIZEOF_AXIGPIO_REG).unwrap();

    let mut val = 0;

    loop {
        println!("Writing {} to Channel 1...", val);
        gpio0.write_gpio(val, GpioChannel1);
        val = (val + 1) % 2;
        println!("Writing {} to Channel 2...", val);
        gpio0.write_gpio(val, GpioChannel1);
        thread::sleep(time::Duration::from_millis(100));
    }
}
