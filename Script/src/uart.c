#include <stdint.h>
#include <stdio.h>
#include <inttypes.h>
#include "uart.h"


/**********************************************************************//**
 * Initialize UART module.
 *
 * @note Configure the baud divisor register.
 *
 * @param baud.
 **************************************************************************/
void Uetrv32_Uart_Init(uint32_t baud) {
  
  UART_Module.baud = baud;
}


/**********************************************************************//**
 * UART data transmit. This is a blocking function.
 *
 **************************************************************************/
void Uetrv32_Uart_Tx(uint32_t tx_data) {
  
  while ((UART_Module.status & 0x01) == 0);
	UART_Module.tx_data = tx_data;             // trigger transfer

  return ;
}

/**********************************************************************//**
 * Print string (zero-terminated) via UART. 
 *
 * @note This function is blocking.
 *
 * @param[in] s -- Pointer to string.
 **************************************************************************/
void UETrv32_Uart_Print(const char *s) {

  char c = 0;
  while ((c = *s++)) {
    Uetrv32_Uart_Tx(((uint32_t) c));
  }
}
//// 





// unsigned int fact (unsigned int n);
// const char message[15] = {'h','l','l','o',' ', 'w', 'r', 'l','d', '\n', '\r'};
// char dst[8] = {0,0,0,0,0,0,0,0};


// /* ************************************************************************ 
//  * Main function.
//  **************************************************************************/
// int main(void) {
//   uint32_t count = 0;

//  // Uetrv32_Plic_Init();

//  // count = fact(6);

//   // Initialize UART with desired baudrate
//   Uetrv32_Uart_Init(1301);

//  // for(count = 0; count < 8; count++) {
//  //   dst[count] = message[count]; 
//  // }
// //    printf("Hello World");
 
//     	  UETrv32_Uart_Print((message)); 
  	
  
// }