#include <stdio.h>
#include "board.h"
#include "gpio_pins.h"
#include "fsl_debug_console.h"

extern void asmmain(void);
extern void init_LPTimer(void);

#define IO_MAXLINE 20
#if (defined (FSL_RTOS_MQX) && (MQX_COMMON_CONFIG != MQX_LITE_CONFIG))
#define PRINTF    printf
#define SCANNF    scanf
#define PUTCHAR   putchar
#define GETCHAR   getchar

#define PRINTF   debug_printf
#define SCANF    debug_scanf
#define PUTCHAR  debug_putchar
#define GETCHAR  debug_getchar
#endif

int time = 0;

void print_f(int d){ // This is used to print out messages, not any of the values
	PRINTF("Interuppt Count : %d, %d Seconds have passed\r\n", d, time);
	time = time+10;
	if (time==70){
		exit(0);
	}
}

int main(void)
{
	hardware_init();
	PRINTF("Low Powe Timer Example\n\r");
	asmmain();
}

