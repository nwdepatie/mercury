pub struct DriveMotorModel {
	wheel_base: f64,
	wheel_radius: f64,
}

impl DriveMotorModel {
    pub fn new(wheel_base : f64, wheel_radius : f64) -> DriveMotorModel{
        DriveMotorModel {
            wheel_base,
            wheel_radius
        }
    }

    /* Immutable access */
    pub fn wheel_base(&self) -> &f64 {
        &self.wheel_base
    }
    pub fn wheel_radius(&self) -> &f64 {
        &self.wheel_radius
    }
}
