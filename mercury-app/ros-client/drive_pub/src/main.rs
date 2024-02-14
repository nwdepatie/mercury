/* Publisher for Emitting Info Relevant to Chassis Drive Motors */

struct MotorControlNode {
    wheel_base: f64,
    wheel_radius: f64,
    max_velocity_meters_per_second: f64,
    max_angular_velocity_rad_per_second: f64,
    velocities: RwLock<(f64, f64)>,
}

fn main() {
    // Initialize node
    rosrust::init("drive_pub");

    // Create publisher
    let fault_pub = rosrust::publish("/drive/faults", 2).unwrap();
    let enc_vel_pub = rosrust::publish("/drive/encoder/ticks", 2).unwrap();
    let enc_ticks_pub = rosrust::publish("chatter", 2).unwrap();

    fault_pub.wait_for_subscribers(None).unwrap();
    enc_vel_pub.wait_for_subscribers(None).unwrap();
    enc_ticks_pub.wait_for_subscribers(None).unwrap();

    let log_names = rosrust::param("~log_names").unwrap().get().unwrap_or(false);

    let mut count = 0;

    // Create object that maintains 10Hz between sleep requests
    let rate = rosrust::rate(100.0);

    // Breaks when a shutdown signal is sent
    while rosrust::is_ok() {
        // Create string message
        let msg = rosrust_msg::std_msgs::String {
            data: format!("hello world from rosrust {}", count),
        };

        // Log event
        rosrust::ros_info!("Publishing: {}", msg.data);

        // Send string message to topic via publisher
        chatter_pub.send(msg).unwrap();

        if log_names {
            rosrust::ros_info!("Subscriber names: {:?}", chatter_pub.subscriber_names());
        }

        // Sleep to maintain 10Hz rate
        rate.sleep();

        count += 1;
    }
}