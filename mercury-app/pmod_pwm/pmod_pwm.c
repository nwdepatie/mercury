/*
 * https://www.realdigital.org/doc/4b3000d07f821a225e90486b4ea33815
 * https://docs.xilinx.com/r/en-US/ug585-zynq-7000-SoC-TRM/Register-MIO_PIN_13-Details
 */

#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>
#include <sys/mman.h>
#include <stdlib.h>
#include <stdint.h>
#include <signal.h> // For signal handling

/* Base Addresses */
#define SLCR_BASE 0xF8000000 // Base address for SLCR
#define GPIO_BASE 0xE000A000 // Base address for GPIO

/* MIO Pin Offsets */
#define MIO_PIN_13_OFFSET 0x734 // MIO Pin 13 offset from SLCR_BASE

/* GPIO Configuration */
#define GPIO_DIRM_OFFSET 0x204 // Offset for GPIO direction mode
#define GPIO_OUTE_OFFSET 0x208 // Offset for GPIO output enable

#define PAGE_SIZE 4096 // Typical page size

#define MS_TO_US(x) (x * 1000) // Corrected for simplicity

/// stop infinite loop flag
static volatile unsigned char stopLoop = 0;

/* @brief Handle signals
   @param num Signal Number */
static void signal_handler(int num)
{
    stopLoop = 1;
}

// map GPIO peripheral; base address will be mapped to peripheral pointer
static int map_peripheral(void **peripheral, uint32_t base_addr, uint32_t offset, size_t map_size)
{
    int fd = open("/dev/mem", O_RDWR | O_SYNC);
    if (fd < 0) {
        perror("open");
        return -1;
    }

    // Adjust base address to be page-aligned
    off_t page_base = (base_addr + offset) & ~(PAGE_SIZE - 1);
    off_t page_offset = (base_addr + offset) - page_base;

    *peripheral = mmap(NULL, map_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, page_base);
    if (*peripheral == MAP_FAILED) {
        perror("mmap");
        close(fd);
        return -2;
    }

    // Adjust the peripheral pointer by page_offset to point to the correct register
    *peripheral += page_offset / sizeof(uint32_t); // Adjust for uint32_t pointer arithmetic

    close(fd);
    return 0;
}

int main(int argc, char **argv)
{
    signal(SIGINT, signal_handler); // Setup signal handling for graceful exit

    uint32_t *slcr, *gpio;
	float period      = 1; /* ms */
	float duty_cycle  = 50; /* percent */

	printf("Mapping peripherals...\n");

    // Map SLCR for MIO configuration
    if (map_peripheral((void **)&slcr, SLCR_BASE, MIO_PIN_13_OFFSET, PAGE_SIZE)) {
        fprintf(stderr, "Failed to map SLCR\n");
        return 1;
    }

    // Map GPIO
    if (map_peripheral((void **)&gpio, GPIO_BASE, GPIO_DIRM_OFFSET, PAGE_SIZE)) {
        fprintf(stderr, "Failed to map GPIO\n");
        munmap(slcr, PAGE_SIZE); // Cleanup previous mapping
        return 1;
    }

	printf("Configuring peripherals...\n");

    // Correctly configure MIO13 for GPIO use
    slcr[0] = 0x00001600; // Configuration value for MIO_PIN_13 based on desired function

    // Configure GPIO Controller
    gpio[GPIO_DIRM_OFFSET / sizeof(uint32_t)] = 0x00002000; // Assuming GPIO13 is what you want to control
    gpio[GPIO_OUTE_OFFSET / sizeof(uint32_t)] = 0x00002000; // Enable output

	printf("Writing PWM...\n");

	while (!stopLoop) {
		//set high

		usleep(MS_TO_US(period * duty_cycle / 100));

		//set low

		usleep(MS_TO_US(period * (1 - (duty_cycle / 100))));
	}

	printf("\nUnmapping peripherals...\n");

	//de-initialize peripherals here
	munmap(slcr, 8);
	munmap(gpio, 4);
	return 0;
}
