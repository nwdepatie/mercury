/* Model Describing the Behavior of the Chassis */

use std::f64::consts::PI;
use std::ops::{Index, IndexMut};

pub enum WheelPositions {
    LeftWheels,
    RightWheels,
}

pub struct MotorCtrlCmd {
    speed: f64,
    pub dutycycle: u32,
    pub direction: bool,
}

pub struct MotorCtrlCmdGroup {
    left_side: MotorCtrlCmd,
    right_side: MotorCtrlCmd,
}

impl Index<WheelPositions> for MotorCtrlCmdGroup {
    type Output = MotorCtrlCmd;

    fn index(&self, side: WheelPositions) -> &Self::Output {
        match side {
            WheelPositions::LeftWheels => &self.left_side,
            WheelPositions::RightWheels => &self.right_side,
        }
    }
}

impl IndexMut<WheelPositions> for MotorCtrlCmdGroup {
    fn index_mut(&mut self, side: WheelPositions) -> &mut Self::Output {
        match side {
            WheelPositions::LeftWheels => &mut self.left_side,
            WheelPositions::RightWheels => &mut self.right_side,
        }
    }
}

pub struct ChassisModel {
    width: f32,
    length: f32,
    wheel_radius: f64,
    max_speed: f64,
}

impl ChassisModel {
    pub fn new(width: f32, length: f32, wheel_radius: f64, max_speed: f64) -> ChassisModel {
        ChassisModel {
            width: width,
            length: length,
            wheel_radius: wheel_radius,
            max_speed: max_speed,
        }
    }

    pub fn calc_wheel_speeds(&self, linear_speed: f64, angular_speed: f64) -> MotorCtrlCmdGroup {
        let mut cmds = MotorCtrlCmdGroup {
            left_side: MotorCtrlCmd {
                speed: 0.0,
                dutycycle: 0,
                direction: false,
            },
            right_side: MotorCtrlCmd {
                speed: 0.0,
                dutycycle: 0,
                direction: false,
            },
        };

        rosrust::ros_info!("Linear Speed: {} m/s", linear_speed);
        rosrust::ros_info!("Angular Speed: {} m/s", angular_speed);
        rosrust::ros_info!("Wheel Radius: {} m", self.wheel_radius);

        cmds[WheelPositions::LeftWheels].speed = (linear_speed / (2.0 * PI * self.wheel_radius))
            + (angular_speed / (2.0 * self.wheel_radius));

        cmds[WheelPositions::RightWheels].speed = (linear_speed / (2.0 * PI * self.wheel_radius))
            - (angular_speed / (2.0 * self.wheel_radius));

        rosrust::ros_info!(
            "Left Vel/Speed: {} rad/s, Right Vel/Speed: {} rad/s",
            cmds[WheelPositions::LeftWheels].speed,
            cmds[WheelPositions::RightWheels].speed
        );

        /* Find the maximum absolute speed between the two wheels */
        let max_wheel_speed = cmds[WheelPositions::LeftWheels]
            .speed
            .abs()
            .max(cmds[WheelPositions::RightWheels].speed.abs());

        rosrust::ros_info!(
            "Max Speed {}",
            max_wheel_speed
        );

        /* Normalize wheel speeds if exceeding MAX_SPEED */
        if max_wheel_speed > self.max_speed {
            cmds[WheelPositions::LeftWheels].speed =
                (cmds[WheelPositions::LeftWheels].speed / max_wheel_speed) * self.max_speed;
            cmds[WheelPositions::RightWheels].speed =
                (cmds[WheelPositions::RightWheels].speed / max_wheel_speed) * self.max_speed;
        }

        rosrust::ros_info!(
            "Left Vel/Normalized Speed: {} rad/s, Right Vel/Normalized Speed: {} rad/s",
            cmds[WheelPositions::LeftWheels].speed,
            cmds[WheelPositions::RightWheels].speed
        );

        let rpm_to_rad_per_s = 2.0 * PI / 60.0;  // Conversion factor from RPM to rad/s
        // Max RPM
        let max_rpm = 4000.0;
        let rad_per_s_high = max_rpm * rpm_to_rad_per_s;

        /* Convert normalized wheel speeds to PWM duty cycle and direction */
        cmds[WheelPositions::LeftWheels].speed /= rad_per_s_high;
        cmds[WheelPositions::RightWheels].speed /=  rad_per_s_high;
        rosrust::ros_info!(
            "Left Vel/RPM Scaled: {} (from 0 to 1), Right Vel/RPM Scaled: {} rad/s",
            cmds[WheelPositions::LeftWheels].speed,
            cmds[WheelPositions::RightWheels].speed
        );

        /* Convert normalized wheel speeds to PWM duty cycle and direction */
        cmds[WheelPositions::LeftWheels].dutycycle =
            ((cmds[WheelPositions::LeftWheels].speed.abs() * (127.0 as f64)) as u32);
        cmds[WheelPositions::RightWheels].dutycycle =
            ((cmds[WheelPositions::RightWheels].speed.abs() * (127.0 as f64)) as u32);

        rosrust::ros_info!(
            "Left Vel/RPM As u32: {} / {}, Right Vel/RPM as u32: {} / {}",
            cmds[WheelPositions::LeftWheels].speed,
            u32::MAX,
            cmds[WheelPositions::RightWheels].speed,
            u32::MAX
        );

        cmds[WheelPositions::LeftWheels].direction = cmds[WheelPositions::LeftWheels].speed >= 0.0;
        cmds[WheelPositions::RightWheels].direction =
            cmds[WheelPositions::RightWheels].speed >= 0.0;

        rosrust::ros_info!(
            "Left Vel/Duty Cycles: {}, Right Vel/Duty Cycles: {}",
            cmds[WheelPositions::LeftWheels].dutycycle,
            cmds[WheelPositions::RightWheels].dutycycle
        );

        rosrust::ros_info!(
            "Left Vel/Direction: {}, Right Vel/Direction: {}",
            cmds[WheelPositions::LeftWheels].direction,
            cmds[WheelPositions::RightWheels].direction
        );

        cmds
    }
}
