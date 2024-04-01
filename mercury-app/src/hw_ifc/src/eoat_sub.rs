/* Subscriber for Carrying out Commands for Chassis Drive Motors */
pub mod regmap;
pub mod zynq;
use self::regmap::{LED_BRAKELIGHT};
use std::sync::{Arc, Mutex};
use zynq::axitimer::{AXITimer, SIZEOF_AXITIMER_REG};

pub mod msg {
    rosrust::rosmsg_include!(mercury_services / grip, mercury_services / release,);
}

pub struct EOATController {
    pwm_ctrl: AXITimer,
}

impl EOATController {
    pub fn new(pwm_ctrl: AXITimer) -> Self {
        EOATController { pwm_ctrl: pwm_ctrl }
    }

    fn grip(&mut self) {
        rosrust::ros_info!("Gripping EOAT");
        //self.pwm_ctrl.start_pwm(100, brightness);
    }

    fn release(&mut self) {
        rosrust::ros_info!("Releasing EOAT");
        //self.pwm_ctrl.start_pwm(100, brightness);
    }
}

fn main() {
    /* Initialize ROS node */
    rosrust::init("eoat_sub");

    let eoat_ctrl = Arc::new(Mutex::new(EOATController::new(
        AXITimer::new(LED_BRAKELIGHT, SIZEOF_AXITIMER_REG).unwrap(),
    )));

    /* Create service */
    let eoat_ctrl_clone = eoat_ctrl.clone();
    let _service_grip = rosrust::service::<rosrust_msg::mercury_services::grip, _>(
        "/services/eoat/grip",
        move |_cmd: rosrust_msg::mercury_services::gripReq| {
            let mut eoat_ctrl = eoat_ctrl_clone.lock().unwrap();
            eoat_ctrl.grip();

            Ok(rosrust_msg::mercury_services::gripRes { status: true })
        },
    )
    .unwrap();

    /* Create service */
    let eoat_ctrl_clone = eoat_ctrl.clone();
    let _service_release = rosrust::service::<rosrust_msg::mercury_services::release, _>(
        "/services/eoat/grip",
        move |_cmd: rosrust_msg::mercury_services::releaseReq| {
            let mut eoat_ctrl = eoat_ctrl_clone.lock().unwrap();
            eoat_ctrl.release();

            Ok(rosrust_msg::mercury_services::releaseRes { status: true })
        },
    )
    .unwrap();

    while rosrust::is_ok() {
        /* Spin forever, we only execute things on callbacks from here */
        rosrust::spin();
    }
}
