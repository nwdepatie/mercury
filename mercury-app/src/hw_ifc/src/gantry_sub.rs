/* Subscriber for Carrying out Commands for Chassis Drive Motors */

use rosrust;
use rosrust_msg::geometry_msgs::Twist;
use std::sync::RwLock;

pub mod msg {
    rosrust::rosmsg_include!(gantry/calibrate);
}


pub struct GantryController {
	model : GantryModel,
	max_linear_vel: f64,	/* meters per second  */
	max_angular_vel: f64,	/* radians per second  */
	velocities: RwLock<(f64, f64)>, /* Left and right velocities */
}

impl GantryController {
	pub fn new() -> Self
	{
		// Parameters
		let wheel_base = rosrust::param("~wheel_base").unwrap().get().unwrap_or(0.2);
		let wheel_radius = rosrust::param("~wheel_radius").unwrap().get().unwrap_or(0.095);
		let max_velocity_meters_per_second = rosrust::param("~max_velocity_meters_per_second").unwrap().get().unwrap_or(10.0);
		let max_angular_velocity_rad_per_second = rosrust::param("~max_angular_velocity_rad_per_second").unwrap().get().unwrap_or(6.0);

		GantryController {
			model : GantryModel::new(wheel_base, wheel_radius),
			max_linear_vel : max_velocity_meters_per_second,
			max_angular_vel : max_angular_velocity_rad_per_second,
			velocities: RwLock::new((0.0, 0.0)),
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

		// TODO Make hardware call

		rosrust::ros_info!("Left Vel/Command: {}, Right Vel/Command: {}", velocities.0, velocities.1);
	}

	pub fn command_callback(&self, data: Twist)
	{
		let linear_velocity = self.clamp_linear_speed(data.linear.x);
		let angular_velocity = self.clamp_angular_speed(data.angular.z);

		let left_velocity = linear_velocity - (angular_velocity * self.model.wheel_base() / 2.0);
		let right_velocity = linear_velocity + (angular_velocity * self.model.wheel_base() / 2.0);

		// Store the velocities safely
		let mut velocities = self.velocities.write().unwrap();
		*velocities = (left_velocity, right_velocity);
		self.send_motor_commands();
	}
}

fn main()
{
	/* Initialize ROS node */
	rosrust::init("gantry_sub");

	let gantry_ctrl = GantryController::new();

	/*
	 * Create subscriber
	 */
	let _subscriber_info = rosrust::subscribe_with_ids(
		"/gantry/pose/goal",
		2,
		move |v: Twist, _caller_id: &str| {
			gantry_ctrl.command_callback(v);
		}
	)
	.unwrap();

	/**
	 * Create service
	 */
	let _service_raii = rosrust::service::<msg::gantry::calibrate, _>("/services/gantry/calibrate", move |req| {
		gantry_ctrl.command_callback(req);

		Ok(msg::gantry::calibrate { sum })
	})
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