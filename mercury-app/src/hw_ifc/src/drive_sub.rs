/* Subscriber for Carrying out Commands for Chassis Drive Motors */

use rosrust_msg::geometry_msgs::Twist;
use std::sync::{Arc, Mutex};
pub mod chassis_model;
pub mod zynq;
use self::chassis_model::{ChassisModel, MotorCtrlCmdGroup, WheelPositions};
use zynq::axigpio::{GPIOChannel, AXIGPIO, SIZEOF_AXIGPIO_REG};
use zynq::axitimer::{AXITimer, SIZEOF_AXITIMER_REG};

const TIMER_FRONT_RIGHT_ADDR: u32 = 0x4280_0000;
const TIMER_FRONT_LEFT_ADDR: u32 = 0x4281_0000;
const TIMER_BACK_RIGHT_ADDR: u32 = 0x4282_0000;
const TIMER_BACK_LEFT_ADDR: u32 = 0x4283_0000;
const DIRECTION_GPIO_ADDR: u32 = 0x4121_0000;

const MAX_LINEAR_SPEED: f64 = 10.0; /* meters/second */
const MAX_ANGULAR_SPEED: f64 = 10.0; /* radians/second */
const WHEEL_RADIUS: f64 = 10.0; /* meters */
const BOT_WIDTH: f32 = 10.0; /* meters */
const BOT_LENGTH: f32 = 10.0; /* meters */

type PWMController = Arc<Mutex<AXITimer>>;
type DirectionController = Arc<Mutex<AXIGPIO>>;

pub struct DriveController {
    model: ChassisModel,
    pwm_front_left: PWMController,
    pwm_front_right: PWMController,
    pwm_back_left: PWMController,
    pwm_back_right: PWMController,
    direction_ctrl: DirectionController,
}

impl DriveController {
    pub fn new(
        pwm_front_left: PWMController,
        pwm_front_right: PWMController,
        pwm_back_left: PWMController,
        pwm_back_right: PWMController,
        direction_ctrl: DirectionController,
    ) -> Self {
        /* Parameters */
        let wheel_radius = WHEEL_RADIUS;
        let bot_width = BOT_WIDTH;
        let bot_length = BOT_LENGTH;
        let max_velocity_meters_per_second = MAX_LINEAR_SPEED;
        let max_angular_velocity_rad_per_second = MAX_ANGULAR_SPEED;

        DriveController {
            model: ChassisModel::new(
                bot_width,
                bot_length,
                wheel_radius,
                max_velocity_meters_per_second,
            ),
            pwm_front_left,
            pwm_front_right,
            pwm_back_left,
            pwm_back_right,
            direction_ctrl,
        }
    }

    fn send_motor_commands(&self, motor_commands: MotorCtrlCmdGroup) {
        let left_pwm_u32 = motor_commands[WheelPositions::LeftWheels]
            .dutycycle
            .clamp(0, u32::MAX);
        let right_pwm_u32 = motor_commands[WheelPositions::RightWheels]
            .dutycycle
            .clamp(0, u32::MAX);

        /* Set the directions */
        self.direction_ctrl.lock().unwrap().write_gpio(
            motor_commands[WheelPositions::LeftWheels].direction as u32,
            GPIOChannel::GpioChannel1,
        );
        self.direction_ctrl.lock().unwrap().write_gpio(
            motor_commands[WheelPositions::RightWheels].direction as u32,
            GPIOChannel::GpioChannel2,
        );

        /* Set PWM Duty Cycles */
        self.pwm_front_left
            .lock()
            .unwrap()
            .start_pwm(100, left_pwm_u32);
        self.pwm_front_right
            .lock()
            .unwrap()
            .start_pwm(100, right_pwm_u32);
        self.pwm_back_left
            .lock()
            .unwrap()
            .start_pwm(100, left_pwm_u32);
        self.pwm_back_right
            .lock()
            .unwrap()
            .start_pwm(100, right_pwm_u32);

        rosrust::ros_info!(
            "Left Vel/Command: {}, Right Vel/Command: {}",
            left_pwm_u32,
            right_pwm_u32
        );
    }

    fn command_callback(&self, twist: Twist) {
        /* Directly take the linear and angular speeds without clamping */
        let linear_speed = twist.linear.x;
        let angular_speed = twist.angular.z;

        /* Run Desired Speeds through Model of Chassis */
        let motor_cmds = self.model.calc_wheel_speeds(linear_speed, angular_speed);

        /* Make hardware call */
        self.send_motor_commands(motor_cmds);
    }
}

fn main() {
    /* Initialize ROS node */
    rosrust::init("drive_sub");

    let pwm_front_right = Arc::new(Mutex::new(
        AXITimer::new(TIMER_FRONT_RIGHT_ADDR, SIZEOF_AXITIMER_REG).unwrap(),
    ));
    let pwm_front_left = Arc::new(Mutex::new(
        AXITimer::new(TIMER_FRONT_LEFT_ADDR, SIZEOF_AXITIMER_REG).unwrap(),
    ));
    let pwm_back_right = Arc::new(Mutex::new(
        AXITimer::new(TIMER_BACK_RIGHT_ADDR, SIZEOF_AXITIMER_REG).unwrap(),
    ));
    let pwm_back_left = Arc::new(Mutex::new(
        AXITimer::new(TIMER_BACK_LEFT_ADDR, SIZEOF_AXITIMER_REG).unwrap(),
    ));
    let direction_control = Arc::new(Mutex::new(
        AXIGPIO::new(DIRECTION_GPIO_ADDR, SIZEOF_AXIGPIO_REG).unwrap(),
    ));

    let drive_ctrl = DriveController::new(
        pwm_front_right,
        pwm_front_left,
        pwm_back_right,
        pwm_back_left,
        direction_control,
    );

    /*
     * Create subscriber
     * The subscriber is stopped when the returned object is destroyed
     */
    let _subscriber_info =
        rosrust::subscribe_with_ids("/drive/cmd_vel", 2, move |v: Twist, _caller_id: &str| {
            drive_ctrl.command_callback(v);
        })
        .unwrap();

    while rosrust::is_ok() {
        /* Spin forever, we only execute things on callbacks from here */
        rosrust::spin();
    }
}
