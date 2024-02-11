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

// register offsets
#define REG_OFFSET(REG, OFF) ((REG)+(OFF))

// map GPIO peripheral; base address will be mapped to gpioregs pointer
static int map_gpio(unsigned int** gpioregs, unsigned int gpio_addr)
{
  int fd = 0;

  /* Cleanse input */
  if (!gpioregs || !gpio_addr) {
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
  *gpioregs = mmap(NULL, 8, PROT_READ | PROT_WRITE, MAP_SHARED, fd, gpio_addr);
  //if (PTR_ERR(*gpioregs)) {
  //  return PTR_ERR(*gpioregs);
  //}

  close(fd);

  // success
  return 0;
}

int main(int argc, char** argv)
{
  unsigned int *gpioregs;

  // try to setup LEDs
  if (map_gpio(&gpioregs, LED_GPIO_ADDR)) {
    // failed to setup
    return 1;
  }

  // reset control register
  *REG_OFFSET(gpioregs, 0) = 0x00;

    char input[256];

    // Get Temperature in Fahrenheit from user
    printf("Enter a decimal number N to count up to: ");
    fgets(input, sizeof(input), stdin);
    int number = atoi(input);
    int counter = 0;

  while (counter <= number) {
      //do something here!
      *REG_OFFSET(gpioregs, 0) = counter;
      usleep(1000000);
      counter++;
  }

  return 0;
}
