
#define BAUD_DIV 1301


/** UART module prototype */
typedef struct __attribute__((packed,aligned(4))) {
	uint32_t tx_data;
	uint32_t rx_data;  
	uint32_t tx_crtl;
	uint32_t rx_ctrl;  
	uint32_t int_mask;
	uint32_t status; 
	uint32_t baud;     
} Uetrv32_Uart_Struct;

/** UART module hardware access */
#define UART_Module (*((volatile Uetrv32_Uart_Struct*) (0x80000000UL)))


// Function prototypes
void Uetrv32_Uart_Init(uint32_t baud);
void Uetrv32_Uart_Tx(uint32_t tx_data);
uint8_t Uetrv32_Uart_Rx(void);
void Uetrv32_Uart_Isr(void);
void UETrv32_Uart_Print(const char *s);
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
    // printf("%c",tx_data);
  return ;
}

void UETrv32_Uart_Print(const char *s) {

  char c = 0;
  while ((c = *s++)) {
    Uetrv32_Uart_Tx(((uint32_t) c));
  }
}

uint8_t Uetrv32_Uart_Rx(void) {
   uint8_t rx_data; 

   while ((UART_Module.status & 0x02) == 0);

   rx_data = (uint8_t) UART_Module.rx_data;       // read data byte
   UART_Module.status &= ~(0x02);

   return rx_data;
}

void UART_SendNumber(int32_t number) {
    char buffer[11];  // Buffer to hold digits, max 10 digits for 32-bit number + null terminator
    int index = 0;
    
    // Handle the case when the number is 0
    if (number == 0) {
        Uetrv32_Uart_Tx('0');
        return;
    }

    // Extract digits from the number
    while (number > 0) {
        buffer[index++] = (number % 10) + '0'; // Convert digit to character
        number /= 10;
    }

    // Digits are in reverse order, so send them in reverse
    for (int i = index - 1; i >= 0; i--) {
        Uetrv32_Uart_Tx(buffer[i]);
    }
}
void printMatrix(int rows, int cols, int8_t C[rows][cols]) {
    for (int i = 0; i < rows; i++) {
        // Print opening bracket for each row
        Uetrv32_Uart_Tx('[');

        for (int j = 0; j < cols; j++) {
            int a = C[i][j];
            if (a < 0) {
                Uetrv32_Uart_Tx('-');
                a = -a;
            }
            UART_SendNumber(a);

            if (j < cols - 1) {
                Uetrv32_Uart_Tx(',');
                Uetrv32_Uart_Tx(' ');
            }
        }

        // Print closing bracket for each row
        Uetrv32_Uart_Tx(']');

        // Add a newline character after each row except the last one
        if (i < rows - 1) {
            Uetrv32_Uart_Tx('\n');
            Uetrv32_Uart_Tx('\r');
        }
    }
}