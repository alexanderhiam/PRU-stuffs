# Uses PyBBIO to load an overlay to set the pinnmux, export from kernel 
# control, and set the mode for GPIO1_28 to be used by pru_blink.p

from bbio import *

GPIO_PIN = GPIO1_28

pinMode(GPIO_PIN, OUTPUT, preserve_mode_on_exit=True)
# By setting preserve_mode_on_exit True the pin will be will remain 
# configured after program completion.
