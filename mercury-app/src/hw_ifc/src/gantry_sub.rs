/* Subscriber for Carrying out Commands for Chassis Drive Motors */
use rosrust;
pub mod gantry_model;
use self::gantry_model::{
    GantryAxes, GantryModel, GantryPosition, StepperCtrlCmd, StepperCtrlCmdGroup,
};

pub mod msg {
    rosrust::rosmsg_include!(hw_srv/calibrate);
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

    pub fn command_callback(&self, data: rosrust_msg::hw_srv::calibrate) {}
}

fn main() {
    /* Initialize ROS node */
    rosrust::init("gantry_sub");

    let gantry_ctrl = GantryController::new();

    /*
     * Create subscriber
     */
    //let _subscriber_info = rosrust::subscribe_with_ids(
    //    "/gantry/pose/goal",
    //    2,
    //    move |v: rosrust_msg::hw_srv::calibrate, _caller_id: &str| {
    //        gantry_ctrl.command_callback(v);
    //    },
    //)
    //.unwrap();

    /**
     * Create service
     */
    //let _service_raii =
    //    rosrust::service::<rosrust_msg::hw_srv::calibrate, _>("/services/gantry/calibrate", move |req| {
    //        gantry_ctrl.command_callback(req);
//
    //        Ok(rosrust_msg::hw_srv::calibrate { })
    //    })
    //    .unwrap();

    while rosrust::is_ok() {
        /* Spin forever, we only execute things on callbacks from here */
        rosrust::spin();
    }
}
