/* blink_until_button.c
 * Mar. 2014
 * 
 * Uses the prussdrv library to Load blink_until_button.bin into PRU0 and 
 * wait for it to finish execution.
 *
 *   Copyright (c) 2014 - Alexander Hiam <hiamalexander@gmail.com>
 *
 *   This program is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY ; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License     
 *   along with this program.  If not, see <http://www.gnu.org/licenses/>. 
 */

#include <stdio.h>

#include <prussdrv.h>
#include <pruss_intc_mapping.h>

#define PRU_NUM 0

int main(void) {
  unsigned int status;
  tpruss_intc_initdata pruss_intc_initdata = PRUSS_INTC_INITDATA;

  prussdrv_init ();
  printf("prussdrv initialized\n");

  status = prussdrv_open(PRU_EVTOUT_0);
  if (status) {
    printf("prussdrv_open open failed!\n");
    return (status);
  }

  prussdrv_pruintc_init(&pruss_intc_initdata);
  printf("interrupt initialized\n");

  printf("Running blink_until_button\n");
  status = prussdrv_exec_program(PRU_NUM, "./blink_until_button.bin");
  if (status) {
    printf("prussdrv_exec_program failed!\n");
    return (status);
  }

  printf("waiting for interrupt (halt instruction)\n");
  prussdrv_pru_wait_event(PRU_EVTOUT_0);
  printf("blink_until_button finished running!\n");
  prussdrv_pru_clear_event(PRU_EVTOUT_0, PRU0_ARM_INTERRUPT);

  return 0;
}
