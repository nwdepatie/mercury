/* Subscriber for Carrying out Commands for Chassis Drive Motors */
use rosrust;
pub mod gantry_model;
use self::gantry_model::{
    GantryAxes, GantryModel, GantryPosition, StepperCtrlCmd, StepperCtrlCmdGroup,
};
use std::sync::{Arc, Mutex};

pub mod msg {
    rosrust::rosmsg_include!(hw_srv / movegantry, hw_srv / calibrategantry);
}

const MAX_SPEED: f64 = 10.0; /* meters/second */

pub struct GantryController {
    model: GantryModel,
}

impl GantryController {
    pub fn new() -> Self {
        GantryController {
            model: GantryModel::new(MAX_SPEED),
        }
    }

    pub fn move_callback(&mut self, data: rosrust_msg::hw_srv::movegantryReq) {
        let stepper_cmds = self
            .model
            .calc_control_signals(GantryPosition::new(data.x, data.y, data.z));
        //stepper_cmds[GantryAxes::X];
        //stepper_cmds[GantryAxes::Y];
        //stepper_cmds[GantryAxes::Z];
    }

    pub fn calibrate_callback(&mut self) {
        let stepper_cmds = self
            .model
            .calc_control_signals(GantryPosition::new(0.0, 0.0, 0.0));
    }
}

fn main() {
    /* Initialize ROS node */
    rosrust::init("gantry_sub");

    let gantry_ctrl = Arc::new(Mutex::new(GantryController::new()));

    /* Create subscriber */
    let gantry_ctrl_clone = gantry_ctrl.clone();
    let _service_move = rosrust::service::<rosrust_msg::hw_srv::movegantry, _>(
        "/gantry/pose/goal",
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
