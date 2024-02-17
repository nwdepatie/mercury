fn main() {
    // Initialize node
    rosrust::init("talker");

    // Create publisher
    let chatter_pub = rosrust::publish("chatter", 2).unwrap();
    chatter_pub.wait_for_subscribers(None).unwrap();

    let log_names = rosrust::param("~log_names").unwrap().get().unwrap_or(false);

    let mut count = 0;

    // Create object that maintains 10Hz between sleep requests
    let rate = rosrust::rate(1000.0);

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