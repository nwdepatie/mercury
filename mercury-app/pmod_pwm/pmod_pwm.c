/*
 * https://www.realdigital.org/doc/4b3000d07f821a225e90486b4ea33815 Q
 */

#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>
#include <sys/mman.h>
#include <err.h>
#include <stdlib.h>

/* MIO Base Addr */
#define MIO_PIN_16 0xF8000740
#define MIO_PIN_17 0xF8000744
#define MIO_PIN_18 0xF8000748
#define MIO_PIN_50 0xF80007C8
#define MIO_PIN_51 0xF80007CC
#define GPIO_DIRM_0 0xE000A204 // Direction mode bank 0
#define GPIO_OUTE_0 0xE000A208 // Output enable bank 0
#define GPIO_DIRM_1 0xE000A244 // Direction mode bank 1

// register offsets
#define REG_OFFSET(REG, OFF) ((REG)+(OFF))

/// stop infinite loop flag
static unsigned char stopLoop = 0;

/* @brief Handle signals
	 @param num Signal Number */
static void signal_handler(int num)
{
	stopLoop = 1;
}

// map GPIO peripheral; base address will be mapped to gpioregs pointer
static int map_peripheral(unsigned int** peripheral, unsigned int peripheral_addr)
{
	int fd = 0;

	/* Cleanse input */
	if (!peripheral || !peripheral_addr) {
		// invalid pointers
		return 1;
	}

	/* Open /dev/mem to retrieve memory */
	fd = open("/dev/mem", O_RDWR);
	if (fd < 0) {
		// can't open file
		return fd;
	}

	/* mmap the GPIO register */
	*peripheral = mmap(NULL, 8, PROT_READ | PROT_WRITE, MAP_SHARED, fd, peripheral_addr);
	//if (PTR_ERR(*gpioregs)) {
	//  return PTR_ERR(*gpioregs);
	//}

	close(fd);

	// success
	return 0;
}

int main(int argc, char** argv)
{
	unsigned int *gpiocfg;

	float period      = 1; /* ms */
	float duty_cycle  = 50; /* percent */

	// try to setup LEDs
	if (map_peripheral(&gpiocfg, GPIO_DIRM_0)) {
		// failed to setup
		return 1;
	}

	char input[256];

	// Get Temperature in Fahrenheit from user
	printf("Enter a decimal number N to count up to: ");
	fgets(input, sizeof(input), stdin);
	int number = atoi(input);
	int counter = 0;

	while (!stopLoop) {
		err = axigpio_single_set(gpio, 0, CHANNEL_NUM);
		if (err)
			return err;

		usleep(MS_TO_US(period * duty_cycle / 100));

		err = axigpio_single_clear(gpio, 0, CHANNEL_NUM);
		if (err)
			return err;

		usleep(MS_TO_US(period * (1 - (duty_cycle / 100))));
	}

	//de-initialize peripherals here
	axigpio_free(gpio);
	return 0;
}
