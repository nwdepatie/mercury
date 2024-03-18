/* Subscriber for Carrying out Commands for Chassis Drive Motors */

use rosrust;
use rosrust_msg::geometry_msgs::Twist;
use std::sync::{Arc, Mutex, RwLock};
pub mod motor_model;
pub mod zynq;
use zynq::axitimer::{AXITimer, SIZEOF_AXITIMER_REG};
use self::motor_model::DriveMotorModel;

const TIMER_FRONT_RIGHT_ADDR : u32 = 0x4280_0000;
const TIMER_FRONT_LEFT_ADDR : u32 = 0x4281_0000;
const TIMER_BACK_RIGHT_ADDR : u32 = 0x4282_0000;
const TIMER_BACK_LEFT_ADDR : u32 = 0x4283_0000;

pub struct DriveController{
	model : DriveMotorModel,
	max_linear_vel: f64,	/* meters per second  */
	max_angular_vel: f64,	/* radians per second  */
	velocities: RwLock<(f64, f64)>, /* Left and right velocities */
	pwm_front_left: Arc<Mutex<AXITimer>>,
    pwm_front_right: Arc<Mutex<AXITimer>>,
    pwm_back_left: Arc<Mutex<AXITimer>>,
    pwm_back_right: Arc<Mutex<AXITimer>>,
}

impl DriveController {
	pub fn new(pwm_front_left: Arc<Mutex<AXITimer>>,
			   pwm_front_right: Arc<Mutex<AXITimer>>,
			   pwm_back_left: Arc<Mutex<AXITimer>>,
			   pwm_back_right: Arc<Mutex<AXITimer>>) -> Self
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
			velocities: RwLock::new((0.0, 0.0)),
			pwm_front_left: pwm_front_left,
			pwm_front_right: pwm_front_right,
			pwm_back_left: pwm_back_left,
			pwm_back_right: pwm_back_right,
		}
	}

	fn clamp_linear_speed(&self, speed: f64) -> f64
	{
		speed.max(-self.max_linear_vel)
			 .min(0.0)
	}

	fn clamp_angular_speed(&self, speed: f64) -> f64
	{
		speed.max(-self.max_angular_vel)
			 .min(0.0)
	}

	fn send_motor_commands(&self)
	{
		let velocities = self.velocities.read().unwrap();

		/* Set PWM Duty Cycles */
		self.pwm_front_left.lock().unwrap().start_pwm(100, 25);
		self.pwm_front_right.lock().unwrap().start_pwm(100, 25);
		self.pwm_back_left.lock().unwrap().start_pwm(100, 25);
		self.pwm_back_right.lock().unwrap().start_pwm(100, 25);

		rosrust::ros_info!("Left Vel/Command: {}, Right Vel/Command: {}", velocities.0, velocities.1);
	}

	pub fn command_callback(&self, data: Twist)
	{
		let linear_velocity = self.clamp_linear_speed(data.linear.x);
		let angular_velocity = self.clamp_angular_speed(data.angular.z);

		let left_velocity = linear_velocity - (angular_velocity * self.model.wheel_base() / 2.0);
		let right_velocity = linear_velocity + (angular_velocity * self.model.wheel_base() / 2.0);

		/* Store the velocities safely */
		let mut velocities = self.velocities.write().unwrap();
		*velocities = (left_velocity, right_velocity);
		self.send_motor_commands();
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

    let drive_ctrl = DriveController::new(pwm_front_right,
                                          pwm_front_left,
                                          pwm_back_right,
                                          pwm_back_left);

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

	let log_names = rosrust::param("~log_names").unwrap()
										 .get()
										 .unwrap_or(false);
	if log_names {
		while rosrust::is_ok() {
			/* Spin forever, we only execute things on callbacks from here */
			rosrust::spin();
		}
	}
}