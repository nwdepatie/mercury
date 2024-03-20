/* Test App for GPIO */
pub mod zynq;
use zynq::axigpio::{AXIGPIO, SIZEOF_AXIGPIO_REG, GPIOChannel:: GpioChannel1, GPIOChannel::GpioChannel2};
use std::{thread, time};
use std::env;

const DIRECTION_GPIO_ADDR : u32 = 0x4121_0000;

fn main()
{
    let args: Vec<String> = env::args().collect();

    /* Note that this is testing GPIO preconfigured to be an output */
    let mut gpio0 = AXIGPIO::new(DIRECTION_GPIO_ADDR, SIZEOF_AXIGPIO_REG).unwrap();

    let mut val = 0;

    loop{
        println!("Writing {} to Channel 1...", val);
        gpio0.write_gpio(val, GpioChannel1);
        val = (val + 1) % 2;
        println!("Writing {} to Channel 2...", val);
        gpio0.write_gpio(val, GpioChannel1);
        thread::sleep(time::Duration::from_millis(1));
    }
}