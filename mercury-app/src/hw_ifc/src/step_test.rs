/* Subscriber for Carrying out Commands for Chassis Drive Motors */
pub mod gantry_model;
use self::gantry_model::{
    GantryAxes, GantryModel, GantryPosition, StepperCtrlCmd, StepperCtrlCmdGroup,
};
use std::sync::{Arc, Mutex};
pub mod zynq;
use zynq::axigpio::{
    GPIOChannel::GpioChannel1, GPIOChannel::GpioChannel2, AXIGPIO, SIZEOF_AXIGPIO_REG,
};
use crate::zynq::axigpio::GPIOChannel;

use std::thread;
use std::time::Duration;

pub mod regmap;
use self::regmap::{
    GANTRY_DIR1_ADDR, GANTRY_DIR2_ADDR, GANTRY_DIR3_ADDR, GANTRY_RESET_ADDR, GANTRY_STEP1_ADDR,
    GANTRY_STEP2_ADDR, GANTRY_STEP3_ADDR,
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
}

fn main() {
    let stepper1 = Arc::new(Mutex::new(StepperController::new(
        AXIGPIO::new(GANTRY_DIR1_ADDR, SIZEOF_AXIGPIO_REG).unwrap(),
        AXIGPIO::new(GANTRY_STEP1_ADDR, SIZEOF_AXIGPIO_REG).unwrap(),
    )));

    let stepper2 = Arc::new(Mutex::new(StepperController::new(
        AXIGPIO::new(GANTRY_DIR2_ADDR, SIZEOF_AXIGPIO_REG).unwrap(),
        AXIGPIO::new(GANTRY_STEP2_ADDR, SIZEOF_AXIGPIO_REG).unwrap(),
    )));

    let stepper3 = Arc::new(Mutex::new(StepperController::new(
        AXIGPIO::new(GANTRY_DIR3_ADDR, SIZEOF_AXIGPIO_REG).unwrap(),
        AXIGPIO::new(GANTRY_STEP3_ADDR, SIZEOF_AXIGPIO_REG).unwrap(),
    )));

    let reset = Arc::new(Mutex::new(
        AXIGPIO::new(GANTRY_DIR3_ADDR, SIZEOF_AXIGPIO_REG).unwrap(),
    ));

    reset.lock().unwrap().write_gpio(1, GpioChannel1);

    stepper1.lock().unwrap().write_step_cmd(300);

    stepper2.lock().unwrap().write_step_cmd(300);

    stepper3.lock().unwrap().write_step_cmd(300);

    thread::sleep(Duration::from_secs(2));
}
