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

    fn index(&self, side: GantryAxes) -> &Self::Output {
        match side {
            GantryAxes::X => &self.x,
            GantryAxes::Y => &self.y,
            GantryAxes::Z => &self.z,
        }
    }
}

impl IndexMut<GantryAxes> for StepperCtrlCmdGroup {
    fn index_mut(&mut self, side: GantryAxes) -> &mut Self::Output {
        match side {
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

pub struct GantryModel {
    current_position: GantryPosition,
}

impl GantryModel {
    pub fn new() -> GantryModel {
        GantryModel {
            current_position: GantryPosition {
                x: 0.0,
                y: 0.0,
                z: 0.0,
            },
        }
    }

    pub fn set_position(&mut self, pos: GantryPosition) {
        self.current_position = pos;
    }

    pub fn calc_control_signals(
        &mut self,
        target_position: GantryPosition,
        max_speed: f64,
    ) -> StepperCtrlCmdGroup {
        // assuming 1 unit = 1 step for simplicity
        let x_steps = (target_position.x - self.current_position.x) as i32;
        let y_steps = (target_position.y - self.current_position.y) as i32;
        let z_steps = (target_position.z - self.current_position.z) as i32;

        // Update current position
        self.current_position = target_position;

        StepperCtrlCmdGroup {
            x: StepperCtrlCmd {
                steps: x_steps,
                speed: max_speed,
            },
            y: StepperCtrlCmd {
                steps: y_steps,
                speed: max_speed,
            },
            z: StepperCtrlCmd {
                steps: z_steps,
                speed: max_speed,
            },
        }
    }
}
