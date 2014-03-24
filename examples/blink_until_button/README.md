##blink_until_button

This program will toggle the state of GPIO1_28 every 100ms until GPIO0_30
is pulled low.

Either compile with the Makefile:

    # make

or manually:

    # pasm -b blink_until_button.p
    # gcc -c -Wall blink_until_button.c
    # gcc -lprussdrv blink_until_button.o -o blink_until_button

Run the Python script to configure the GPIO pins 
(requires [PyBBIO](https://github.com/alexanderhiam/PyBBIO)):

    # python blink_until_button_pinmux.py

If you haven't yet, enbale the PRU and uio_pruss driver (only needed once 
per boot):
 
    # echo BB-BONE-PRU-01 > /sys/devices/bone_capemgr.*/slots
    # modprobe uio_pruss

Wire an LED to GPIO1_28 (P9.12) or attach an oscilloscope and run 
blink_until_button:

    # ./blink_until_button

You should see it toggling. Connect GPIO0_30 (P9.11) to GND (P9.1) to stop 
the program.

The pins used and delay time can be configured through the `#define` 
statements in blink_until_button.p:

```c
// Define the GPIO pin used for the output:
#define OUT_MODULE GPIO1 // Modules defined in pru_gpio.hp
#define OUT_PIN    28
// Define the GPIO pin used for the input:
#define IN_MODULE  GPIO0
#define IN_PIN     30

// Configure delay in milliseconds between level changes:
#define DELAY_MS 100
```

If changing the pins you'll also have to change the pins in 
blink_until_button_pinmux.py:

```python
OUT_PIN = GPIO1_28
IN_PIN = GPIO0_30
```

and run it again.