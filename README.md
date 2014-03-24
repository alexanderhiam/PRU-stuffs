##My PRU Stuffs

This repository contains my notes and code as I play with the AM3359 PRU 
on the BeagleBone Black.

###Links  

 - [Reference guide](http://processors.wiki.ti.com/index.php/PRU_Assembly_Reference_Guide)
 - [PASM instructions](http://processors.wiki.ti.com/index.php/PRU_Assembly_Instructions)


###Setup  
These were the steps I took to setup the assembler and the prussdrv C library
on the BBB. I started with this: http://elinux.org/BeagleBone_PRU_Notes

First, install the PRU assembler and prussdrv library:

    # cd ~
    # git clone git@github.com:beagleboard/am335x_pru_package.git
    # cd am335x_pru_package
    # make
    # make install

This put `libprussdrv.so` in `/usr/local/lib`, which was not in my gcc library path,
so I added it by putting this into `~/.bashrc`:

    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib

Then source it with:

     # . ~/.bashrc

Next the PRU needs to be enabled, which can be done with a Device Tree overlay that 
was included with the Debian image I'm using:

    # echo BB-BONE-PRU-01 > /sys/devices/bone_capemgr.*/slots

Next enable the uio_pruss kernel module, which exports PRU host event interrupts to 
user-space, and also exposes the PRU L3 RAM and DDR RAM for user-space reading and writing:

    # modprobe uio_pruss

The PRUSS should now be ready to use! The am335x_pru_package includes a few demos:

    # cd ~/am335x_pru_package/pru_sw/example_apps/bin
    # ./PRU_memAcc_DDR_sharedRAM
 
If all goes well you should see:

    INFO: Starting PRU_memAcc_DDR_sharedRAM example.
            INFO: Initializing example.
            INFO: Executing example.
            INFO: Waiting for HALT command.
            INFO: PRU completed transfer.
    Example executed succesfully.

###Examples

Included example programs:

 - Blink: `./examples/blink/`
 - Blink until button press: `./examples/blink_until_button/`

###Helper libraries

I've split out some helpful assembly into macros and put them into their own
files inside `examples/include/`.