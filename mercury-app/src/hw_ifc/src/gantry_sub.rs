/* Subscriber for Carrying out Commands for Chassis Drive Motors */
use rosrust;
pub mod gantry_model;
use self::gantry_model::{
    GantryAxes, GantryModel, GantryPosition, StepperCtrlCmd, StepperCtrlCmdGroup,
};
use std::sync::Arc;

pub mod msg {
    rosrust::rosmsg_include!(hw_srv / movegantry, hw_srv / calibrategantry);
}

pub struct GantryController {
    model: GantryModel,
}

impl GantryController {
    pub fn new() -> Self {
        GantryController {
            model: GantryModel::new(),
        }
    }

    pub fn move_callback(&self, data: rosrust_msg::hw_srv::movegantryReq) {}

    pub fn calibrate_callback(&self) {}
}

fn main() {
    /* Initialize ROS node */
    rosrust::init("gantry_sub");

    let gantry_ctrl = Arc::new(GantryController::new());

    /* Create subscriber */
    let gantry_ctrl_clone = gantry_ctrl.clone();
    let service_move = rosrust::service::<rosrust_msg::hw_srv::movegantry, _>(
        "/gantry/pose/goal",
        move |coords: rosrust_msg::hw_srv::movegantryReq| {
            gantry_ctrl_clone.move_callback(coords);

            Ok(rosrust_msg::hw_srv::movegantryRes { status: true })
        },
    )
    .unwrap();

    /* Create service */
    let gantry_ctrl_clone = gantry_ctrl.clone();
    let service_calibrate = rosrust::service::<rosrust_msg::hw_srv::calibrategantry, _>(
        "/services/gantry/calibrate",
        move |_| {
            gantry_ctrl_clone.calibrate_callback();

            Ok(rosrust_msg::hw_srv::calibrategantryRes { status: true })
        },
    )
    .unwrap();

    while rosrust::is_ok() {
        /* Spin forever, we only execute things on callbacks from here */
        rosrust::spin();
    }
}
