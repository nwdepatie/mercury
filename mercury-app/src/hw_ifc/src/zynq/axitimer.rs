use crate::zynq::mmio::MemoryMappedIO;
use std::io::Result;

/* Timer Offsets */
const TCSR0_OFFSET : usize = 0x00;
const TLR0_OFFSET : usize = 0x04;
//const TCR0_OFFSET : usize = 0x08;
const TCSR1_OFFSET : usize = 0x10;
const TLR1_OFFSET : usize = 0x14;
//const TCR1_OFFSET : usize = 0x18;

pub const SIZEOF_AXITIMER_REG : u32 = 0x30;

/* Timer Commands */
const TCSR_PWM_ENABLE : u32 = 1 << 9;
//const TCSR_LOAD : u32 = 1 << 5;
const TSCR_ENALL : u32 = 1 << 10;
const TSCR_ARHT1 : u32 = 1 << 4;
const TSCR_GENT1 : u32 = 1 << 2;
const TSCR_UDT1 : u32 = 1 << 1;
const TSCR_ENT1 : u32 = 1 << 7;

pub struct AXITimer {
    mapped_mem: MemoryMappedIO,
}

impl AXITimer {
    /* Create a new AXITimer struct */
    pub fn new(phys_addr: u32, length: u32) -> Result<Self> {
        // Handle the Result returned by MemoryMappedIO::new
        let mut mem = MemoryMappedIO::new(phys_addr as usize, length as usize)?;

        // Initialize the timer registers
        mem.write_u32(TCSR0_OFFSET, 0);
        mem.write_u32(TCSR1_OFFSET, 0);

        // Enable PWM and other settings for both timers
        mem.write_u32(TCSR0_OFFSET, mem.read_u32(TCSR0_OFFSET) | TCSR_PWM_ENABLE | TSCR_GENT1 | TSCR_UDT1 | TSCR_ARHT1 | TSCR_ENT1);
        mem.write_u32(TCSR1_OFFSET, mem.read_u32(TCSR1_OFFSET) | TCSR_PWM_ENABLE | TSCR_GENT1 | TSCR_UDT1 | TSCR_ARHT1 | TSCR_ENT1);

        Ok(AXITimer { mapped_mem: mem })
    }

    /* Set the PWM duty cycle and period */
    pub fn start_pwm(&mut self, period : u32, duty_cycle : u32)
    {
        self.mapped_mem.write_u32(TCSR0_OFFSET, self.mapped_mem.read_u32(TCSR0_OFFSET) | TCSR_PWM_ENABLE | TSCR_GENT1 | TSCR_UDT1 | TSCR_ARHT1 | TSCR_ENT1);
        self.mapped_mem.write_u32(TCSR1_OFFSET, self.mapped_mem.read_u32(TCSR1_OFFSET) | TCSR_PWM_ENABLE | TSCR_GENT1 | TSCR_UDT1 | TSCR_ARHT1 | TSCR_ENT1);

        /* Calculate high time and load into register */
        let period_reg = (period & 0x0ffff) *100;
        let pulse_reg = (duty_cycle & 0x07f) * period_reg/100;

        self.mapped_mem.write_u32(TLR0_OFFSET, period_reg);

        self.mapped_mem.write_u32(TLR1_OFFSET, pulse_reg);

        /* Load values into timer counters by toggling load registers */
        self.mapped_mem.write_u32(TCSR0_OFFSET, self.mapped_mem.read_u32(TCSR0_OFFSET) | TSCR_ENALL);

        // Making sure we are writing what we want
    }
}
