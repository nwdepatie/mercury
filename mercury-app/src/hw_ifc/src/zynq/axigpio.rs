use crate::zynq::mmio::MemoryMappedIO;
use std::io::Result;

pub const SIZEOF_AXIGPIO_REG: u32 = 0x32;

pub enum GPIODirection {
    GpioOutput = 0,
    GpioInput,
}

pub enum GPIOChannel {
    GpioChannel1,
    GpioChannel2,
}

const GPIO_DATA: usize = 0x0000;
const GPIO_TRI: usize = 0x0004;
const GPIO2_DATA: usize = 0x0008;
const GPIO2_TRI: usize = 0x000C;

/// Unused Registers
//const GIER : usize = 0x011C;
//const IP_IER : usize = 0x0128;
//const IP_ISR : usize = 0x0120;

pub struct AXIGPIO {
    mapped_mem: MemoryMappedIO,
}

impl AXIGPIO {
    /* Create a new AXITimer struct */
    pub fn new(phys_addr: u32, length: u32) -> Result<Self> {
        // Handle the Result returned by MemoryMappedIO::new
        let mut mem = MemoryMappedIO::new(phys_addr as usize, length as usize)?;

        mem.write_u32(GPIO_DATA, 0);
        mem.write_u32(GPIO2_DATA, 0);

        Ok(AXIGPIO { mapped_mem: mem })
    }

    pub fn set_dir(&mut self, direction: GPIODirection, channel: GPIOChannel) {
        let reg = match channel {
            GPIOChannel::GpioChannel1 => GPIO_TRI,
            GPIOChannel::GpioChannel2 => GPIO2_TRI,
        };

        self.mapped_mem.write_u32(reg, direction as u32);
    }

    pub fn write_gpio(&mut self, val: u32, channel: GPIOChannel) {
        let reg = match channel {
            GPIOChannel::GpioChannel1 => GPIO_DATA,
            GPIOChannel::GpioChannel2 => GPIO2_DATA,
        };

        self.mapped_mem.write_u32(reg, val);
    }
}
