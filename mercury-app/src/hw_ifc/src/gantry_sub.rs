/* Subscriber for Carrying out Commands for Chassis Drive Motors */
use rosrust;
pub mod gantry_model;
use self::gantry_model::{
    GantryAxes, GantryModel, GantryPosition, StepperCtrlCmd, StepperCtrlCmdGroup,
};
use std::sync::{Arc, Mutex};
pub mod zynq;
use zynq::axigpio::{GPIOChannel, AXIGPIO, SIZEOF_AXIGPIO_REG};

pub mod msg {
    rosrust::rosmsg_include!(hw_srv / movegantry, hw_srv / calibrategantry);
}

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

pub struct GantryController {
    model: GantryModel,
    stepper1: Arc<Mutex<StepperController>>,
    stepper2: Arc<Mutex<StepperController>>,
    stepper3: Arc<Mutex<StepperController>>,
    reset: Arc<Mutex<AXIGPIO>>,
}

impl GantryController {
    pub fn new(
        stepper1: Arc<Mutex<StepperController>>,
        stepper2: Arc<Mutex<StepperController>>,
        stepper3: Arc<Mutex<StepperController>>,
        reset: Arc<Mutex<AXIGPIO>>,
    ) -> Self {
        GantryController {
            model: GantryModel::new(),
            stepper1: stepper1,
            stepper2: stepper2,
            stepper3: stepper3,
            reset: reset,
        }
    }

    fn write_steppers(&mut self, stepper_cmds: StepperCtrlCmdGroup) {
        self.stepper1
            .lock()
            .unwrap()
            .set_direction(stepper_cmds[GantryAxes::X].steps < 0);
        self.stepper1
            .lock()
            .unwrap()
            .write_step_cmd(i32::abs(stepper_cmds[GantryAxes::X].steps) as u32);
        self.stepper2
            .lock()
            .unwrap()
            .set_direction(stepper_cmds[GantryAxes::Y].steps < 0);
        self.stepper2
            .lock()
            .unwrap()
            .write_step_cmd(i32::abs(stepper_cmds[GantryAxes::Y].steps) as u32);
        self.stepper3
            .lock()
            .unwrap()
            .set_direction(stepper_cmds[GantryAxes::Z].steps < 0);
        self.stepper3
            .lock()
            .unwrap()
            .write_step_cmd(i32::abs(stepper_cmds[GantryAxes::Z].steps) as u32);
    }

    pub fn move_callback(&mut self, data: rosrust_msg::hw_srv::movegantryReq) {
        let stepper_cmds = self
            .model
            .calc_control_signals(GantryPosition::new(data.x, data.y, data.z));

        rosrust::ros_info!("X:{}\tY:{}\tZ:{}", data.x, data.y, data.z);

        //self.write_steppers(stepper_cmds);
    }

    pub fn calibrate_callback(&mut self) {
        let stepper_cmds = self
            .model
            .calc_control_signals(GantryPosition::new(0.0, 0.0, 0.0));

        rosrust::ros_info!("CALIBRATING...");

        //self.write_steppers(stepper_cmds);
    }
}

fn main() {
    /* Initialize ROS node */
    rosrust::init("gantry_sub");

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

    let gantry_ctrl = Arc::new(Mutex::new(GantryController::new(
        stepper1, stepper2, stepper3, reset,
    )));

    /* Create subscriber */
    let gantry_ctrl_clone = gantry_ctrl.clone();
    let _service_move = rosrust::service::<rosrust_msg::hw_srv::movegantry, _>(
        "/services/gantry/setgoal",
        move |coords: rosrust_msg::hw_srv::movegantryReq| {
            let mut gantry_ctrl = gantry_ctrl_clone.lock().unwrap();
            gantry_ctrl.move_callback(coords);

            Ok(rosrust_msg::hw_srv::movegantryRes { status: true })
        },
    )
    .unwrap();

    /* Create service */
    let gantry_ctrl_clone = gantry_ctrl.clone();
    let _service_calibrate = rosrust::service::<rosrust_msg::hw_srv::calibrategantry, _>(
        "/services/gantry/calibrate",
        move |_| {
            let mut gantry_ctrl = gantry_ctrl_clone.lock().unwrap();
            gantry_ctrl.calibrate_callback();

            Ok(rosrust_msg::hw_srv::calibrategantryRes { status: true })
        },
    )
    .unwrap();

    while rosrust::is_ok() {
        /* Spin forever, we only execute things on callbacks from here */
        rosrust::spin();
    }
}
