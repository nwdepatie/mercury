/* Subscriber for Carrying out Commands for Chassis Drive Motors */
use rosrust;
use rosrust::ros_info;
pub mod gantry_model;
use self::gantry_model::{GantryAxes, GantryModel, GantryPosition, StepperCtrlCmdGroup};
use std::sync::{Arc, Mutex};
pub mod zynq;
use rosrust_msg::geometry_msgs::Twist;
use std::cmp::max;
use std::thread;
use std::time::Duration;
use zynq::axigpio::{GPIOChannel, AXIGPIO, SIZEOF_AXIGPIO_REG};

pub mod msg {
    rosrust::rosmsg_include!(
        mercury_services / movegantry,
        mercury_services / calibrategantry
    );
}

pub mod regmap;
use self::regmap::{
    GANTRY_DIR1_ADDR, GANTRY_DIR2_ADDR, GANTRY_DIR3_ADDR, GANTRY_DIR4_ADDR, GANTRY_DIR5_ADDR,
    GANTRY_STEP1_ADDR, GANTRY_STEP2_ADDR, GANTRY_STEP3_ADDR, GANTRY_STEP4_ADDR, GANTRY_STEP5_ADDR,
};

pub const STEPPER_SPEED: f64 = 770.0; /* Ticks/s */

pub struct StepperController {
    direction_control: AXIGPIO,
    step_control: AXIGPIO,
    is_running: bool,
}

impl StepperController {
    pub fn new(direction_control: AXIGPIO, mut step_control: AXIGPIO) -> StepperController {
        step_control.write_gpio(1, GPIOChannel::GpioChannel1);

        StepperController {
            direction_control: direction_control,
            step_control: step_control,
            is_running: false,
        }
    }

    pub fn set_direction(&mut self, is_forward: bool) {
        self.direction_control
            .write_gpio(is_forward as u32, GPIOChannel::GpioChannel1);
    }

    pub fn write_step_cmd(&mut self, num_steps: u32) {
        self.step_control.write_gpio(0, GPIOChannel::GpioChannel1);
        self.step_control
            .write_gpio(num_steps, GPIOChannel::GpioChannel1);
    }

    pub fn read_done(&mut self) -> bool {
        self.step_control.read_gpio(GPIOChannel::GpioChannel2) != 0
    }
}

pub struct GantryController {
    model: GantryModel,
    stepper1: Arc<Mutex<StepperController>>,
    stepper2: Arc<Mutex<StepperController>>,
    stepper3: Arc<Mutex<StepperController>>,
    stepper4: Arc<Mutex<StepperController>>,
    stepper5: Arc<Mutex<StepperController>>,
    reset: Arc<Mutex<AXIGPIO>>,
}

impl GantryController {
    pub fn new(
        stepper1: Arc<Mutex<StepperController>>,
        stepper2: Arc<Mutex<StepperController>>,
        stepper3: Arc<Mutex<StepperController>>,
        stepper4: Arc<Mutex<StepperController>>,
        stepper5: Arc<Mutex<StepperController>>,
        reset: Arc<Mutex<AXIGPIO>>,
    ) -> Self {
        GantryController {
            model: GantryModel::new(),
            stepper1: stepper1,
            stepper2: stepper2,
            stepper3: stepper3,
            stepper4: stepper4,
            stepper5: stepper5,
            reset: reset,
        }
    }

    fn write_steppers(&mut self, stepper_cmds: StepperCtrlCmdGroup) {
        if stepper_cmds[GantryAxes::X].steps != 0 {
            self.stepper2
                .lock()
                .unwrap()
                .set_direction(stepper_cmds[GantryAxes::X].steps > 0);
            self.stepper2
                .lock()
                .unwrap()
                .write_step_cmd(i32::abs(stepper_cmds[GantryAxes::X].steps) as u32);
            self.stepper3
                .lock()
                .unwrap()
                .set_direction(stepper_cmds[GantryAxes::X].steps > 0);
            self.stepper3
                .lock()
                .unwrap()
                .write_step_cmd(i32::abs(stepper_cmds[GantryAxes::X].steps) as u32);
        }
        if stepper_cmds[GantryAxes::Y].steps != 0 {
            self.stepper4
                .lock()
                .unwrap()
                .set_direction(stepper_cmds[GantryAxes::Y].steps > 0);
            self.stepper4
                .lock()
                .unwrap()
                .write_step_cmd(i32::abs(stepper_cmds[GantryAxes::Y].steps) as u32);
        }
        if stepper_cmds[GantryAxes::Z].steps != 0 {
            self.stepper5
                .lock()
                .unwrap()
                .set_direction(stepper_cmds[GantryAxes::Z].steps > 0);
            self.stepper5
                .lock()
                .unwrap()
                .write_step_cmd(i32::abs(stepper_cmds[GantryAxes::Z].steps) as u32);
        }
        if stepper_cmds[GantryAxes::ZPrime].steps != 0 {
            self.stepper1
                .lock()
                .unwrap()
                .set_direction(stepper_cmds[GantryAxes::ZPrime].steps > 0);
            self.stepper1
                .lock()
                .unwrap()
                .write_step_cmd(i32::abs(stepper_cmds[GantryAxes::ZPrime].steps) as u32);
        }
    }

    pub fn move_callback(&mut self, data: rosrust_msg::mercury_services::movegantryReq) {
        let stepper_cmds = self.model.calc_control_signals(GantryPosition::new(
            data.x,
            data.y,
            data.z,
            data.z_prime,
        ));

        rosrust::ros_info!(
            "X:{}\tY:{}\tZ:{}\tZ':{}",
            data.x,
            data.y,
            data.z,
            data.z_prime
        );

        let max_steps = max(
            max(
                i32::abs(stepper_cmds[GantryAxes::X].steps),
                i32::abs(stepper_cmds[GantryAxes::Y].steps),
            ),
            max(
                i32::abs(stepper_cmds[GantryAxes::Z].steps),
                i32::abs(stepper_cmds[GantryAxes::ZPrime].steps),
            ),
        ) as f64;

        self.write_steppers(stepper_cmds);

        ros_info!("Waiting {} s", max_steps / STEPPER_SPEED);

        thread::sleep(Duration::from_secs_f64(max_steps / STEPPER_SPEED));
    }

    pub fn calibrate_callback(&mut self) {
        let stepper_cmds = self
            .model
            .calc_control_signals(GantryPosition::new(0.0, 0.0, 0.0, 0.0));

        rosrust::ros_info!("CALIBRATING...");

        self.write_steppers(stepper_cmds);
    }

    fn cont_write_stepper(stepper: Arc<Mutex<StepperController>>, val: f64) {
        let mut stepper_guard = stepper.lock().unwrap();

        if !stepper_guard.read_done() {
            return;
        } else if !stepper_guard.is_running {
            ros_info!("Value written: {}", f64::abs(val * 100.0) as u32);
            stepper_guard.set_direction(val < 0.0);
            stepper_guard.write_step_cmd(f64::abs(val * 100.0) as u32);
            stepper_guard.is_running = true;
            return;
        } else {
            stepper_guard.is_running = false;
            return;
        }
    }

    fn command_callback(&self, twist: Twist) {
        let x = twist.linear.x;
        let y = twist.linear.y;
        let z = twist.linear.z;
        let z_prime = twist.angular.z;

        ros_info!("X:{}, Y:{}, Z:{}, Z'{}", x, y, z, z_prime);

        Self::cont_write_stepper(self.stepper1.clone(), x);
        Self::cont_write_stepper(self.stepper1.clone(), y);
        Self::cont_write_stepper(self.stepper1.clone(), z);
        Self::cont_write_stepper(self.stepper1.clone(), z_prime);
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

    let stepper4 = Arc::new(Mutex::new(StepperController::new(
        AXIGPIO::new(GANTRY_DIR4_ADDR, SIZEOF_AXIGPIO_REG).unwrap(),
        AXIGPIO::new(GANTRY_STEP4_ADDR, SIZEOF_AXIGPIO_REG).unwrap(),
    )));

    let stepper5 = Arc::new(Mutex::new(StepperController::new(
        AXIGPIO::new(GANTRY_DIR5_ADDR, SIZEOF_AXIGPIO_REG).unwrap(),
        AXIGPIO::new(GANTRY_STEP5_ADDR, SIZEOF_AXIGPIO_REG).unwrap(),
    )));

    let reset = Arc::new(Mutex::new(
        AXIGPIO::new(GANTRY_DIR3_ADDR, SIZEOF_AXIGPIO_REG).unwrap(),
    ));

    let gantry_ctrl = Arc::new(Mutex::new(GantryController::new(
        stepper1, stepper2, stepper3, stepper4, stepper5, reset,
    )));

    /* Create subscriber */
    let gantry_ctrl_clone = gantry_ctrl.clone();
    let _service_move = rosrust::service::<rosrust_msg::mercury_services::movegantry, _>(
        "/services/gantry/setgoal",
        move |coords: rosrust_msg::mercury_services::movegantryReq| {
            let mut gantry_ctrl = gantry_ctrl_clone.lock().unwrap();
            gantry_ctrl.move_callback(coords);

            Ok(rosrust_msg::mercury_services::movegantryRes { status: true })
        },
    )
    .unwrap();

    /* Create service */
    let gantry_ctrl_clone = gantry_ctrl.clone();
    let _service_calibrate = rosrust::service::<rosrust_msg::mercury_services::calibrategantry, _>(
        "/services/gantry/calibrate",
        move |_| {
            let mut gantry_ctrl = gantry_ctrl_clone.lock().unwrap();
            gantry_ctrl.calibrate_callback();

            Ok(rosrust_msg::mercury_services::calibrategantryRes { status: true })
        },
    )
    .unwrap();

    let gantry_ctrl_clone = gantry_ctrl.clone();
    let _subscriber_info =
        rosrust::subscribe_with_ids("/gantry/cmd_vel", 2, move |v: Twist, _caller_id: &str| {
            let gantry_ctrl = gantry_ctrl_clone.lock().unwrap();
            gantry_ctrl.command_callback(v);
        })
        .unwrap();

    while rosrust::is_ok() {
        /* Spin forever, we only execute things on callbacks from here */
        rosrust::spin();
    }
}
