/* Publisher for Reporting on Chassis Drive Motor Status */
use rosrust;
use std::thread;
use std::thread::JoinHandle;

pub mod motor_model;
use self::motor_model::DriveMotorModel;

pub struct DriveObserver {
	model : DriveMotorModel,
	wheel_velocities : [f64; 4]
}

impl DriveObserver {
	pub fn new() -> Self
	{
		let wheel_base = rosrust::param("~wheel_base").unwrap().get().unwrap_or(0.2);
		let wheel_radius = rosrust::param("~wheel_radius").unwrap().get().unwrap_or(0.095);

		DriveObserver {
			model : DriveMotorModel::new(wheel_base, wheel_radius),
			wheel_velocities : [0.0, 0.0, 0.0, 0.0]
		}
	}

	pub fn check_faults(&self) -> u8
	{
		// TODO: Access hardware
		0
	}

	pub fn check_ticks(&self) -> [u16; 4]
	{
		// TODO: Access hardware
		[0, 0, 0, 0]
	}
}

fn start_fault_monitor(&drive_obsrv : &DriveObserver) -> JoinHandle<()>
{
	thread::spawn(|| {
		/* Create Publisher */
		let fault_pub = rosrust::publish("/drive/faults", 2).unwrap();
		fault_pub.wait_for_subscribers(None).unwrap();
		let rate = rosrust::rate(1000.0);

		/* Ends when shutdown signal sent */
		while rosrust::is_ok() {

			/* Format into string */
			let msg = rosrust_msg::std_msgs::String {
				data: format!("hello world from rosrust {}", drive_obsrv.check_faults()),
			};

			/* Log to console */
			rosrust::ros_info!("Publishing: {}", msg.data);

			/* Publish Message */
			fault_pub.send(msg).unwrap();

			/* Sleep */
			rate.sleep();
		}
	})
}

fn start_tick_monitor(&drive_obsrv : &DriveObserver) -> JoinHandle<()>
{
	thread::spawn(|| {
		/* Create Publisher */
		let tick_pub = rosrust::publish("/drive/encoder/ticks", 2).unwrap();
		tick_pub.wait_for_subscribers(None).unwrap();
		let rate = rosrust::rate(3000.0);

		/* Ends when shutdown signal sent */
		while rosrust::is_ok() {

			/* Format into string */
			let msg = rosrust_msg::std_msgs::String {
				data: format!("hello world from rosrust {}", drive_obsrv.check_ticks()[0]),
			};

			/* Log to console */
			rosrust::ros_info!("Publishing: {}", msg.data);

			/* Publish Message */
			tick_pub.send(msg).unwrap();

			/* Sleep */
			rate.sleep();
		}
	})
}

fn main()
{
	/* Initialize ROS node */
	rosrust::init("drive_pub");

	let drive_obsrv = DriveObserver::new();

	let fault_handle = start_fault_monitor(&drive_obsrv);
	let tick_handle = start_tick_monitor(&drive_obsrv);

	fault_handle.join().unwrap();
	tick_handle.join().unwrap();
}
