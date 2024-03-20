pub enum WheelPositions {
    LeftWheels,
    RightWheels,
}

pub struct MotorCtrlCmd {
    speed : f64,
    dutycycle : u32,
    direction : u8
}

pub struct ChassisModel {
	width : f32,
	length : f32,
    wheel_radius : f32,
    max_speed : f64,
}

impl ChassisModel {
    pub fn new(width: f32, length: f32, wheel_radius: f32, max_speed: f64) -> ChassisModel{
        ChassisModel {
            width: width,
	        length: length,
            wheel_radius: wheel_radius,
            max_speed: max_speed,
        }
    }

    pub fn calc_wheel_speeds(&self, linear_speed : f64, angular_speed : f64) ->  Vec<MotorCtrlCmd> {
        let mut cmds : Vec<MotorCtrlCmd>;

        cmds[WheelPositions::LeftWheels].speed = (linear_speed / (2 * PI * self.wheel_radius)) +
                                 (angular_speed / (2 * self.wheel_radius));

        cmds[WheelPositions::RightWheels].speed = (linear_speed / (2 * PI * self.wheel_radius)) -
                                  (angular_speed / (2 * self.wheel_radius));

		/* Find the maximum absolute speed between the two wheels */
		let max_wheel_speed = cmds[WheelPositions::LeftWheels].speed.abs().max(cmds[WheelPositions::RightWheels].speed.abs());

		/* Normalize wheel speeds if exceeding MAX_SPEED */
		if max_wheel_speed > self.max_speed {
			cmds[WheelPositions::LeftWheels].speed = (cmds[WheelPositions::LeftWheels].speed / max_wheel_speed) * self.max_speed;
			cmds[WheelPositions::RightWheels].speed = (cmds[WheelPositions::RightWheels].speed / max_wheel_speed) * self.max_speed;
		}

		/* Convert normalized wheel speeds to PWM duty cycle and direction */
		cmds[WheelPositions::LeftWheels].dutycycle = cmds[WheelPositions::LeftWheels].speed.abs() * 15.0 / self.max_speed;
		cmds[WheelPositions::RightWheels].dutycycle = cmds[WheelPositions::RightWheels].speed.abs() * 15.0 / self.max_speed;

		cmds[WheelPositions::LeftWheels].direction = cmds[WheelPositions::LeftWheels].speed >= 0.0;
		cmds[WheelPositions::RightWheels].direction = cmds[WheelPositions::RightWheels].speed >= 0.0;

        cmds
    }
}
