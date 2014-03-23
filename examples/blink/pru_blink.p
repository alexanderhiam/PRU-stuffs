// * pru_blink.p
// * Mar. 2014
// *
// * Toggles the state of a GPIO pin a configured number of times, delaying
// * a configured ammount of time between each toggle.
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

// These are used in the PRU initialization, do not change!
#define REG_SYSCFG         C4
#define PRU0_ARM_INTERRUPT 19       
        
START:
        // Clear SYSCFG[STANDBY_INIT] to enable OCP master port:
        lbco r0, REG_SYSCFG, 4, 4  // These three instructions are required
        clr r0, r0, 4              // to initialize the PRU
        sbco r0, REG_SYSCFG, 4, 4  //

        // Use register R2 for the loop count:
        mov r2, N_LOOPS
BLINKLOOP:
        setgpio GPIO_MODULE, GPIO_PIN    // Set pin high
        DELAY_MACRO DELAY_TIME           // delay
        cleargpio GPIO_MODULE, GPIO_PIN  // set pin low
        DELAY_MACRO DELAY_TIME           // delay

        // Decrement counter value in R2 by 1:
        sub r2, r2, 1
        // If the value in R2 is not equal to 0 return to label BLINKLOOP:
        qbne BLINKLOOP, r2, 0

        // This sends an interrupt to the kernel, which the uio_pruss driver
        // forwards to the pru_blink executable to tell it that the program
        // has finished executing:
        mov r31.b0, PRU0_ARM_INTERRUPT+16

        // Disable the PRU:
        halt
