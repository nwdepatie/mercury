/* Subscriber for Carrying out Commands for Chassis Drive Motors */
pub mod gantry_model;

use std::sync::{Arc, Mutex};
pub mod zynq;
use crate::zynq::axigpio::GPIOChannel;
use zynq::axigpio::{AXIGPIO, SIZEOF_AXIGPIO_REG};

use std::thread;
use std::time::Duration;

pub mod regmap;
use self::regmap::{
    GANTRY_DIR1_ADDR, GANTRY_DIR2_ADDR, GANTRY_DIR3_ADDR, GANTRY_DIR4_ADDR, GANTRY_STEP1_ADDR,
    GANTRY_STEP2_ADDR, GANTRY_STEP3_ADDR, GANTRY_STEP4_ADDR,
};

pub struct StepperController {
    direction_control: AXIGPIO,
    step_control: AXIGPIO,
}

impl StepperController {
    pub fn new(direction_control: AXIGPIO, step_control: AXIGPIO) -> StepperController {
        StepperController {
            direction_control: direction_control,
            step_control: step_control,
        }
    }

    pub fn set_direction(&mut self, is_forward: bool) {
        self.direction_control
            .write_gpio(is_forward as u32, GPIOChannel::GpioChannel1);
    }

    pub fn write_step_cmd(&mut self, num_steps: u32) {
        self.step_control
            .write_gpio(num_steps, GPIOChannel::GpioChannel1);
    }

    pub fn read_gpio(&mut self) -> u32 {
        self.step_control.read_gpio(GPIOChannel::GpioChannel2)
    }
}

fn main() {
    let stepper1 = Arc::new(Mutex::new(StepperController::new(
        AXIGPIO::new(GANTRY_DIR1_ADDR, SIZEOF_AXIGPIO_REG).unwrap(),
        AXIGPIO::new(GANTRY_STEP1_ADDR, SIZEOF_AXIGPIO_REG).unwrap(),
    )));

    let _stepper2 = Arc::new(Mutex::new(StepperController::new(
        AXIGPIO::new(GANTRY_DIR2_ADDR, SIZEOF_AXIGPIO_REG).unwrap(),
        AXIGPIO::new(GANTRY_STEP2_ADDR, SIZEOF_AXIGPIO_REG).unwrap(),
    )));

    let _stepper3 = Arc::new(Mutex::new(StepperController::new(
        AXIGPIO::new(GANTRY_DIR3_ADDR, SIZEOF_AXIGPIO_REG).unwrap(),
        AXIGPIO::new(GANTRY_STEP3_ADDR, SIZEOF_AXIGPIO_REG).unwrap(),
    )));

    let _stepper4 = Arc::new(Mutex::new(StepperController::new(
        AXIGPIO::new(GANTRY_DIR4_ADDR, SIZEOF_AXIGPIO_REG).unwrap(),
        AXIGPIO::new(GANTRY_STEP4_ADDR, SIZEOF_AXIGPIO_REG).unwrap(),
    )));

    stepper1.lock().unwrap().set_direction(true);

    stepper1.lock().unwrap().write_step_cmd(0);

    stepper1.lock().unwrap().write_step_cmd(3000);

    println!("Done: {}", stepper1.lock().unwrap().read_gpio());

    thread::sleep(Duration::from_millis(5000));

    stepper1.lock().unwrap().set_direction(false);

    stepper1.lock().unwrap().write_step_cmd(0);

    stepper1.lock().unwrap().write_step_cmd(3000);

    println!("Done: {}", stepper1.lock().unwrap().read_gpio());
}
