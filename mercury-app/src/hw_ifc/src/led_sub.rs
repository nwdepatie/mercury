/* Subscriber for Carrying out Commands for Chassis Drive Motors */
pub mod regmap;
pub mod zynq;
use self::regmap::{LED_BRAKELIGHT, LED_FRONT_LOWER, LED_FRONT_UPPER, LED_WORKCELL};
use std::sync::{Arc, Mutex};
use zynq::axitimer::{AXITimer, SIZEOF_AXITIMER_REG};

pub mod msg {
    rosrust::rosmsg_include!(
        mercury_services / brakelight,
        mercury_services / worklight,
        mercury_services / frontlight
    );
}

pub struct LEDController {
    pwm_ctrl: AXITimer,
}

impl LEDController {
    pub fn new(pwm_ctrl: AXITimer) -> Self {
        LEDController { pwm_ctrl: pwm_ctrl }
    }

    fn set_brightness(&mut self, brightness: u32) {
        rosrust::ros_info!("LED Brightness set to {}", brightness);
        self.pwm_ctrl.start_pwm(100, brightness);
    }
}

fn main() {
    /* Initialize ROS node */
    rosrust::init("led_sub");

    let brakelight = Arc::new(Mutex::new(LEDController::new(
        AXITimer::new(LED_BRAKELIGHT, SIZEOF_AXITIMER_REG).unwrap(),
    )));
    let frontlight_lower = Arc::new(Mutex::new(LEDController::new(
        AXITimer::new(LED_FRONT_LOWER, SIZEOF_AXITIMER_REG).unwrap(),
    )));
    let frontlight_upper = Arc::new(Mutex::new(LEDController::new(
        AXITimer::new(LED_FRONT_UPPER, SIZEOF_AXITIMER_REG).unwrap(),
    )));
    let workcell = Arc::new(Mutex::new(LEDController::new(
        AXITimer::new(LED_WORKCELL, SIZEOF_AXITIMER_REG).unwrap(),
    )));

    /* Create service */
    let _service_brakelight = rosrust::service::<rosrust_msg::mercury_services::brakelight, _>(
        "/services/brakelight",
        move |cmd: rosrust_msg::mercury_services::brakelightReq| {
            brakelight
                .clone()
                .lock()
                .unwrap()
                .set_brightness(cmd.brightness);

            Ok(rosrust_msg::mercury_services::brakelightRes { status: true })
        },
    )
    .unwrap();

    /* Create service */
    let _service_workcell = rosrust::service::<rosrust_msg::mercury_services::worklight, _>(
        "/services/workcell",
        move |cmd: rosrust_msg::mercury_services::worklightReq| {
            workcell
                .clone()
                .lock()
                .unwrap()
                .set_brightness(cmd.brightness);

            Ok(rosrust_msg::mercury_services::worklightRes { status: true })
        },
    )
    .unwrap();

    /* Create service */
    let _service_brakelight = rosrust::service::<rosrust_msg::mercury_services::frontlight, _>(
        "/services/frontlight",
        move |cmd: rosrust_msg::mercury_services::frontlightReq| {
            frontlight_lower
                .clone()
                .lock()
                .unwrap()
                .set_brightness(cmd.lower_brightness);
            frontlight_upper
                .clone()
                .lock()
                .unwrap()
                .set_brightness(cmd.upper_brightness);

            Ok(rosrust_msg::mercury_services::frontlightRes { status: true })
        },
    )
    .unwrap();

    while rosrust::is_ok() {
        /* Spin forever, we only execute things on callbacks from here */
        rosrust::spin();
    }
}
