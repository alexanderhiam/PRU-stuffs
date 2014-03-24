##pru_blink

This is a basic blink program for the PRU. By default it will set GPIO1_28 
low, wait 200ms, set GPIO1_28 high, wait 200ms, and repeat this cycle 10 
times.

Either compile with the Makefile:

    # make

or manually:

    # pasm -b pru_blink.p
    # gcc -c -Wall pru_blink.c
    # gcc -lprussdrv pru_blink.o -o pru_blink

Run the Python script to load an overlay for GPIO1_28 and configure it as an
output (requires [PyBBIO](https://github.com/alexanderhiam/PyBBIO)):

    # python pru_blink_pinmux.py

If you haven't yet, enbale the PRU and uio_pruss driver (only need to once per boot):
 
    # echo BB-BONE-PRU-01 > /sys/devices/bone_capemgr.*/slots
    # modprobe uio_pruss

Wire an LED to GPIO1_28 or attach an oscilloscope and run pru_blink:

    # ./pru_blink

You should see the state changing. When the PRU has finished execution it will send a
signal to the `pru_blink` executable and it should exit.

The program can be easily configured with the `#define` statements in pru_blink.p:

```c
// Define the GPIO pin used:
#define GPIO_MODULE        GPIO1 // Modules defined in pru_gpio.hp
#define GPIO_PIN           28
// For GPIO1_28, GPIO_MODULE would be GPIO1 and GPIO_PIN would be 28

// The number of on-off cycles:
#define N_LOOPS            10

// Configure delay between level changes:
#define DELAY_MACRO        delayms // delay DELAY_TIME milliseconds
//#define DELAY_MACRO        delayus // delay DELAY_TIME microseconds
#define DELAY_TIME         200
```

For example, to instead use GPIO0_30 and change the level every 10 microseconds
you would change it to:

```c
// Define the GPIO pin used:
#define GPIO_MODULE        GPIO0 // Modules defined in pru_gpio.hp
#define GPIO_PIN           30
// For GPIO1_28, GPIO_MODULE would be GPIO1 and GPIO_PIN would be 28

// The number of on-off cycles:
#define N_LOOPS            10

// Configure delay between level changes:
//#define DELAY_MACRO        delayms // delay DELAY_TIME milliseconds
#define DELAY_MACRO        delayus // delay DELAY_TIME microseconds
#define DELAY_TIME         10
```

Then rebuild and run it.

If you change the gpio pin you will also need to change it in the pru_blink_pinmux.py:

```python
GPIO_PIN = GPIO1_28
```

and run it again.