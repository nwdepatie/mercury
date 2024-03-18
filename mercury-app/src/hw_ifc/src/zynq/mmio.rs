use memmap2::{MmapMut, MmapOptions};
use std::fs::OpenOptions;
use std::io::Result;
use std::ptr;

/// Represents a memory-mapped I/O region.
pub struct MemoryMappedIO {
    mmap: MmapMut,
}

impl MemoryMappedIO {
    /// Maps a physical memory region into the process's virtual address space.
    ///
    /// # Arguments
    ///
    /// * `phys_addr` - The physical address to map.
    /// * `length` - The length of the memory region to map.
    pub fn new(phys_addr: usize, length: usize) -> Result<Self> {
        let file = OpenOptions::new()
                            .read(true)
                            .write(true)
                            .create(true)
                            .open("/dev/mem")?;

        let page_size = 4096;
        let aligned_phys_addr = phys_addr & !(page_size - 1);
        let offset_within_page = phys_addr - aligned_phys_addr;
        let aligned_length = ((length + offset_within_page + page_size - 1) / page_size) * page_size;

        let mmap = unsafe {
            MmapOptions::new()
                .offset(aligned_phys_addr as u64) // Use the aligned physical address
                .len(aligned_length) // Use the adjusted length to ensure covering the intended memory area
                .map_mut(&file)?
        };
        println!("Memory mapping successful.");

        Ok(Self { mmap })
    }

    /// Reads a 32-bit value from the memory-mapped I/O region at the given offset.
    ///
    /// # Arguments
    ///
    /// * `offset` - The offset from the beginning of the mapped region.
    pub fn read_u32(&self, offset: usize) -> u32 {
        assert!(offset + 4 <= self.mmap.len());
        unsafe { ptr::read_volatile(self.mmap.as_ptr().add(offset) as *const u32) }
    }

    /// Writes a 32-bit value to the memory-mapped I/O region at the given offset.
    ///
    /// # Arguments
    ///
    /// * `offset` - The offset from the beginning of the mapped region.
    /// * `value` - The value to write.
    pub fn write_u32(&mut self, offset: usize, value: u32) {
        assert!(offset + 4 <= self.mmap.len());
        unsafe { ptr::write_volatile(self.mmap.as_mut_ptr().add(offset) as *mut u32, value) }
    }
}
