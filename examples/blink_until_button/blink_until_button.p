// * blink_until_button.p
// * Mar. 2014
// *
// * Toggles the output pin at a given rate until a low level is sensed
// * on the input pin.
// *
// * See #define statements below for configuration.
// *
// *   Copyright (c) 2014 - Alexander Hiam <hiamalexander@gmail.com>
// *
// *   This program is free software: you can redistribute it and/or modify
// *   it under the terms of the GNU General Public License as published by
// *   the Free Software Foundation, either version 3 of the License, or
// *   (at your option) any later version.
// *
// *   This program is distributed in the hope that it will be useful,
// *   but WITHOUT ANY WARRANTY ; without even the implied warranty of
// *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// *   GNU General Public License for more details.
// *
// *   You should have received a copy of the GNU General Public License     
// *   along with this program.  If not, see <http://www.gnu.org/licenses/>. 


// This tells pasm the PRU should start execution at the first instruction:
.origin 0
// If using the debugger this specifies the code entry point for it to use:
.entrypoint START

#include "../include/pru_gpio.hp"  // include the GPIO driver
#include "../include/pru_delay.hp" // include the delay driver

// Define the GPIO pin used for the output:
#define OUT_MODULE GPIO1 // Modules defined in pru_gpio.hp
#define OUT_PIN    28
// Define the GPIO pin used for the input:
#define IN_MODULE  GPIO0
#define IN_PIN     30

// Configure delay in milliseconds between level changes:
#define DELAY_MS 100

// These are used in the PRU initialization, do not change!
#define REG_SYSCFG         C4
#define PRU0_ARM_INTERRUPT 19       
        
START:
        // Clear SYSCFG[STANDBY_INIT] to enable OCP master port:
        lbco r0, REG_SYSCFG, 4, 4  // These three instructions are required
        clr r0, r0, 4              // to initialize the PRU
        sbco r0, REG_SYSCFG, 4, 4  //

BLINKLOOP:
        togglegpio OUT_MODULE, OUT_PIN
        delayms DELAY_MS

        getgpio IN_MODULE, IN_PIN
        // At this point the register R0 contains either a 0 or 1, indicating
        // the level read on the input pin. If it's 1 (high) continue blinking,
        // otherwise stop:
        qbeq BLINKLOOP, r0, 1

        // This sends an interrupt to the kernel, which the uio_pruss driver
        // forwards to the blink_until_button executable to tell it that the 
        // program has finished executing:
        mov r31.b0, PRU0_ARM_INTERRUPT+16

        // Disable the PRU:
        halt
