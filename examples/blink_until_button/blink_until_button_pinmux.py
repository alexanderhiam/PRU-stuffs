# Configures the GPIO pins used by blink_until_button.

from bbio import *

OUT_PIN = GPIO1_28
IN_PIN = GPIO0_30

pinMode(OUT_PIN, OUTPUT, preserve_mode_on_exit=True)
pinMode(IN_PIN, INPUT, pull=PULLUP, preserve_mode_on_exit=True)
