/* Subscriber for Carrying out Commands for Chassis Drive Motors */

use rosrust_msg::geometry_msgs::Twist;
use std::sync::{Arc, Mutex};
pub mod motor_model;
pub mod zynq;
use zynq::axitimer::{AXITimer, SIZEOF_AXITIMER_REG};
use zynq::axigpio::{AXIGPIO, SIZEOF_AXIGPIO_REG};
use self::motor_model::DriveMotorModel;

const TIMER_FRONT_RIGHT_ADDR : u32 = 0x4280_0000;
const TIMER_FRONT_LEFT_ADDR : u32 = 0x4281_0000;
const TIMER_BACK_RIGHT_ADDR : u32 = 0x4282_0000;
const TIMER_BACK_LEFT_ADDR : u32 = 0x4283_0000;
const DIRECTION_GPIO_ADDR : u32 = 0x0000_0000;

const MAX_SPEED : f64 = 10.0;

pub struct DriveController{
	model : DriveMotorModel,
	max_linear_vel: f64,	/* meters per second  */
	max_angular_vel: f64,	/* radians per second  */
	pwm_front_left: Arc<Mutex<AXITimer>>,
    pwm_front_right: Arc<Mutex<AXITimer>>,
    pwm_back_left: Arc<Mutex<AXITimer>>,
    pwm_back_right: Arc<Mutex<AXITimer>>,
	direction_ctrl: Arc<Mutex<AXIGPIO>>,
}

impl DriveController {
	pub fn new(pwm_front_left: Arc<Mutex<AXITimer>>,
			   pwm_front_right: Arc<Mutex<AXITimer>>,
			   pwm_back_left: Arc<Mutex<AXITimer>>,
			   pwm_back_right: Arc<Mutex<AXITimer>>,
			   direction_ctrl: Arc<Mutex<AXIGPIO>>) -> Self
	{
		/* Parameters */
		let wheel_base = rosrust::param("~wheel_base").unwrap().get().unwrap_or(0.2);
		let wheel_radius = rosrust::param("~wheel_radius").unwrap().get().unwrap_or(0.095);
		let max_velocity_meters_per_second = rosrust::param("~max_velocity_meters_per_second").unwrap().get().unwrap_or(10.0);
		let max_angular_velocity_rad_per_second = rosrust::param("~max_angular_velocity_rad_per_second").unwrap().get().unwrap_or(6.0);

		DriveController {
			model : DriveMotorModel::new(wheel_base, wheel_radius),
			max_linear_vel : max_velocity_meters_per_second,
			max_angular_vel : max_angular_velocity_rad_per_second,
			pwm_front_left,
			pwm_front_right,
			pwm_back_left,
			pwm_back_right,
			direction_ctrl,
		}
	}

	fn send_motor_commands(&self, left_pwm : f64, right_pwm : f64)
	{
		let left_pwm_u32 = left_pwm.clamp(0.0, u32::MAX as f64) as u32;
    	let right_pwm_u32 = right_pwm.clamp(0.0, u32::MAX as f64) as u32;

		/* Set PWM Duty Cycles */
		self.pwm_front_left.lock().unwrap().start_pwm(100, left_pwm_u32);
		self.pwm_front_right.lock().unwrap().start_pwm(100, right_pwm_u32);
		self.pwm_back_left.lock().unwrap().start_pwm(100, left_pwm_u32);
		self.pwm_back_right.lock().unwrap().start_pwm(100, right_pwm_u32);

		rosrust::ros_info!("Left Vel/Command: {}, Right Vel/Command: {}", left_pwm_u32, right_pwm_u32);
	}

	fn command_callback(&self, twist: Twist) {
		// Directly take the linear and angular speeds without clamping
		let linear_speed = twist.linear.x;
		let angular_speed = twist.angular.z;

		// Calculate preliminary left and right wheel speeds
		let mut left_speed = linear_speed - angular_speed;
		let mut right_speed = linear_speed + angular_speed;

		// Find the maximum absolute speed between the two wheels
		let max_wheel_speed = left_speed.abs().max(right_speed.abs());

		// Normalize wheel speeds if exceeding MAX_SPEED
		if max_wheel_speed > MAX_SPEED {
			left_speed = (left_speed / max_wheel_speed) * MAX_SPEED;
			right_speed = (right_speed / max_wheel_speed) * MAX_SPEED;
		}

		// Convert normalized wheel speeds to PWM duty cycle and direction
		let left_pwm = left_speed.abs() * 15.0 / MAX_SPEED;
		let right_pwm = right_speed.abs() * 15.0 / MAX_SPEED;

		let _left_dir = left_speed >= 0.0;
		let _right_dir = right_speed >= 0.0;

		/* Store the velocities */
		self.send_motor_commands(left_pwm, right_pwm);
	}
}

fn main()
{
	/* Initialize ROS node */
	rosrust::init("drive_sub");

	let pwm_front_right = Arc::new(Mutex::new(AXITimer::new(TIMER_FRONT_RIGHT_ADDR, SIZEOF_AXITIMER_REG).unwrap()));
    let pwm_front_left = Arc::new(Mutex::new(AXITimer::new(TIMER_FRONT_LEFT_ADDR, SIZEOF_AXITIMER_REG).unwrap()));
    let pwm_back_right = Arc::new(Mutex::new(AXITimer::new(TIMER_BACK_RIGHT_ADDR, SIZEOF_AXITIMER_REG).unwrap()));
    let pwm_back_left = Arc::new(Mutex::new(AXITimer::new(TIMER_BACK_LEFT_ADDR, SIZEOF_AXITIMER_REG).unwrap()));
	let direction_control = Arc::new(Mutex::new(AXIGPIO::new(DIRECTION_GPIO_ADDR, SIZEOF_AXIGPIO_REG).unwrap()));

    let drive_ctrl = DriveController::new(pwm_front_right,
                                          pwm_front_left,
                                          pwm_back_right,
                                          pwm_back_left,
										  direction_control);

	/*
	 * Create subscriber
	 * The subscriber is stopped when the returned object is destroyed
	 */
	let _subscriber_info = rosrust::subscribe_with_ids(
		"/drive/cmd_vel",
		2,
		move |v: Twist, _caller_id: &str| {
			drive_ctrl.command_callback(v);
		}
	)
	.unwrap();

	while rosrust::is_ok() {
		/* Spin forever, we only execute things on callbacks from here */
		rosrust::spin();
	}
}
