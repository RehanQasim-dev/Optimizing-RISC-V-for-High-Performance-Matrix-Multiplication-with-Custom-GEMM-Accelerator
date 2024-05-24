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


/**********************************************************************//**
 * UART data receive. This is a blocking function.
 *
 **************************************************************************/
uint8_t Uetrv32_Uart_Rx(void) {
   uint8_t rx_data; 

   while ((UART_Module.status & 0x02) == 0);

   rx_data = (uint8_t) UART_Module.rx_data;       // read data byte
   //UART_Module.status &= ~(0x02);

   return rx_data;
}



// unsigned int fact (unsigned int n);
const char message[15] = {'A','_','m','a','t', '\n', '\r'};
char dst[8] = {0,0,0,0,0,0,0,0};
const  uint8_t B[3][2] = {{7, 8},
                       {9, 7},
                       {11, 12}};

// /* ************************************************************************ 
//  * Main function.
//  **************************************************************************/
int main(void) {
  uint32_t count = 0;
  uint8_t rx_data;
 // Uetrv32_Plic_Init();

 // count = fact(6);

  // Initialize UART with desired baudrate
  Uetrv32_Uart_Init(1301);

 // for(count = 0; count < 8; count++) {
 //   dst[count] = message[count]; 
 // }
//    printf("Hello World");
 
    	  // UETrv32_Uart_Print((message)); 
  	Uetrv32_Uart_Tx('a');
    Uetrv32_Uart_Tx('b');
    Uetrv32_Uart_Tx('c');
    Uetrv32_Uart_Tx(message);
    for(int i =0; i<2; i++){
      for (int w =0; w<3; w++){
          UART_SendNumber(B[i][w]);
      }
    }
    // uint8_t  rx_byte = 0;
    // while (rx_byte != 'a') {
    //       rx_byte = (uint8_t) Uetrv32_Uart_Rx(); 
    //  }
    // rx_data=(uint8_t) Uetrv32_Uart_Rx();
    // Uetrv32_Uart_Tx(rx_data);
    // rx_data=(uint8_t) Uetrv32_Uart_Rx();
    // Uetrv32_Uart_Tx(rx_data);
    // rx_data=(uint8_t) Uetrv32_Uart_Rx();
    // Uetrv32_Uart_Tx(rx_data);
    // Uetrv32_Uart_Tx('r');
    while (1);

}