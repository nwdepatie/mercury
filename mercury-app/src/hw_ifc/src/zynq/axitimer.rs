use crate::zynq::pynq::MemoryMappedIO;

/* LED Offsets */
const CHANNEL_NUM: u8 = 0;

/* Timer Offsets */
const AXI_TIMER_BASE : u16 = 0x41240000;
const TCSR0_OFFSET : u16 = 0x00;
const TLR0_OFFSET : u16 = 0x04;
const TCR0_OFFSET : u16 = 0x08;
const TCSR1_OFFSET : u16 = 0x10;
const TLR1_OFFSET : u16 = 0x14;
const TCR1_OFFSET : u16 = 0x18;

/* Timer Commands */
const TCSR_PWM_ENABLE : u16 = 1 << 9;
const TCSR_LOAD : u16 = 1 << 5;
const TSCR_ENALL : u16 = 1 << 10;
const TSCR_ARHT1 : u16 = 1 << 4;
const TSCR_GENT1 : u16 = 1 << 2;
const TSCR_UDT1 : u16 = 1 << 1;
const TSCR_ENT0 : u16 = 1 << 7;

const AXI_CLOCK : u16 = 100000000; /* 100MHz */

pub struct AXITimer {
    mapped_mem : MemoryMappedIO,
}

impl AXITimer {
    /* Create a new AXITimer struct */
    pub fn new(phys_addr : u32, length : u32) -> Self
    {
        AXITimer{ mapped_mem : MemoryMappedIO::map(phys_addr, length) }
    }

    /* Set the PWM duty cycle and period */
    pub fn start_pwm(&self, period : f32, duty_cycle : f32)
    {
        /* Stop Timer 0 and Timer 1 */
        self.mapped_mem[TCSR0_OFFSET] = 0;
        self.mapped_mem[TCSR1_OFFSET] = 0;

        /* Enable PWM mode and start timers */
        self.mapped_mem[TCSR0_OFFSET] |= TCSR_PWM_ENABLE | TSCR_GENT1 | TSCR_UDT1;
        self.mapped_mem[TCSR1_OFFSET] |= TCSR_PWM_ENABLE | TSCR_GENT1 | TSCR_UDT1;

        /* Load period and duty cycle values */
        let high_time_ms = (duty_cycle / 100.0) * period;
        let high_time_reg = (duty_cycle * AXI_CLOCK) - 2;
        let period_time_reg = (period * AXI_CLOCK) - 2;
        self.mapped_mem[TLR0_OFFSET] = period_time_reg;
        self.mapped_mem[TLR1_OFFSET] = high_time_reg;

        /* Load values into timer counters by toggling load registers */
        self.mapped_mem[TCSR0_OFFSET] |= TCSR_LOAD;
        self.mapped_mem[TCSR0_OFFSET] &= !TCSR_LOAD;
        self.mapped_mem[TCSR1_OFFSET] |= TCSR_LOAD;
        self.mapped_mem[TCSR1_OFFSET] &= !TCSR_LOAD;
        self.mapped_mem[TCSR0_OFFSET] |= TSCR_ENALL;

        // Making sure we are writing what we want
        println!("Timer 0 Config:\t{}\n", self.mapped_mem[TCSR0_OFFSET]);
        println!("Timer 1 Config:\t{}\n", self.mapped_mem[TCSR1_OFFSET]);

        return;
    }
}
