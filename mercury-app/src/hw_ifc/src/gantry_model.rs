/* Model Describing the Behavior of the Gantry */

use std::ops::{Index, IndexMut};

pub enum GantryAxes {
    X,
    Y,
    Z,
}

pub struct StepperCtrlCmd {
    pub steps: i32,
    speed: f64,
}

pub struct StepperCtrlCmdGroup {
    x: StepperCtrlCmd,
    y: StepperCtrlCmd,
    z: StepperCtrlCmd,
}

impl Index<GantryAxes> for StepperCtrlCmdGroup {
    type Output = StepperCtrlCmd;

    fn index(&self, axis: GantryAxes) -> &Self::Output {
        match axis {
            GantryAxes::X => &self.x,
            GantryAxes::Y => &self.y,
            GantryAxes::Z => &self.z,
        }
    }
}

impl IndexMut<GantryAxes> for StepperCtrlCmdGroup {
    fn index_mut(&mut self, axis: GantryAxes) -> &mut Self::Output {
        match axis {
            GantryAxes::X => &mut self.x,
            GantryAxes::Y => &mut self.y,
            GantryAxes::Z => &mut self.z,
        }
    }
}

pub struct GantryPosition {
    x: f64,
    y: f64,
    z: f64,
}

impl Index<GantryAxes> for GantryPosition {
    type Output = f64;

    fn index(&self, axis: GantryAxes) -> &Self::Output {
        match axis {
            GantryAxes::X => &self.x,
            GantryAxes::Y => &self.y,
            GantryAxes::Z => &self.z,
        }
    }
}

impl IndexMut<GantryAxes> for GantryPosition {
    fn index_mut(&mut self, axis: GantryAxes) -> &mut Self::Output {
        match axis {
            GantryAxes::X => &mut self.x,
            GantryAxes::Y => &mut self.y,
            GantryAxes::Z => &mut self.z,
        }
    }
}

impl GantryPosition {
    pub fn new(x: f64, y: f64, z: f64) -> GantryPosition {
        GantryPosition { x: x, y: y, z: z }
    }
}

pub struct GantryModel {
    current_position: GantryPosition,
    max_speed: f64,
}

impl GantryModel {
    pub fn new(max_speed: f64) -> GantryModel {
        GantryModel {
            current_position: GantryPosition {
                x: 0.0,
                y: 0.0,
                z: 0.0,
            },
            max_speed: max_speed,
        }
    }

    pub fn set_position(&mut self, pos: GantryPosition) {
        self.current_position = pos;
    }

    pub fn calc_control_signals(&mut self, target_position: GantryPosition) -> StepperCtrlCmdGroup {
        // assuming 1 unit = 1 step for simplicity
        let x_steps =
            (target_position[GantryAxes::X] - self.current_position[GantryAxes::X]) as i32;
        let y_steps =
            (target_position[GantryAxes::Y] - self.current_position[GantryAxes::Y]) as i32;
        let z_steps =
            (target_position[GantryAxes::Z] - self.current_position[GantryAxes::Z]) as i32;

        // Update current position
        self.current_position = target_position;

        StepperCtrlCmdGroup {
            x: StepperCtrlCmd {
                steps: x_steps,
                speed: self.max_speed,
            },
            y: StepperCtrlCmd {
                steps: y_steps,
                speed: self.max_speed,
            },
            z: StepperCtrlCmd {
                steps: z_steps,
                speed: self.max_speed,
            },
        }
    }
}
