
#define BAUD_DIV 1301

#include <stdbool.h>

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

void UART_Send_8bit_number(int8_t number) {
    char buffer[3];  // Buffer to hold digits, max 10 digits for 32-bit number + null terminator
    int index = 0;
    bool is_neg=0;
    if (number < 0) {
    is_neg=1;
    number = -number;
    }
    // Handle the case when the number is 0
    if (number == 0) {
        UETrv32_Uart_Print("   ");
        Uetrv32_Uart_Tx('0');
        return;
    }

    // Extract digits from the number
    while (number > 0) {
        buffer[index++] = (number % 10) + '0'; // Convert digit to character
        number /= 10;
    }



    if (is_neg) {
        Uetrv32_Uart_Tx('-');
        if (index<2){
            for (int i = 1-index ; i >= 0; i--) {
                Uetrv32_Uart_Tx(' ');
            }
       }
    }
    else {
        Uetrv32_Uart_Tx(' ');
        if (index<2){
            for (int i = 1-index ; i >= 0; i--) {
                Uetrv32_Uart_Tx(' ');
            }
       }
    }
    // Digits are in reverse order, so send them in reverse
    for (int i = index - 1; i >= 0; i--) {
        Uetrv32_Uart_Tx(buffer[i]);
    }
}

void UART_Send_32bit_number(int32_t number) {
    char buffer[11];  // Buffer to hold digits, max 10 digits for 32-bit number + null terminator
    int index = 0;
    bool is_neg=0;
    if (number < 0) {
    is_neg=1;
    number = -number;
    }
    // Handle the case when the number is 0
    if (number == 0) {
        UETrv32_Uart_Print("     ");
        Uetrv32_Uart_Tx('0');
        return;
    }

    // Extract digits from the number
    while (number > 0) {
        buffer[index++] = (number % 10) + '0'; // Convert digit to character
        number /= 10;
    }

        if (is_neg) {
        Uetrv32_Uart_Tx('-');
        if (index<5){
            for (int i = 4-index ; i >= 0; i--) {
                Uetrv32_Uart_Tx(' ');
            }
       }
    }
    else {
        Uetrv32_Uart_Tx(' ');
        if (index<5){
            for (int i = 4-index ; i >= 0; i--) {
                Uetrv32_Uart_Tx(' ');
            }
       }
    }
    // Digits are in reverse order, so send them in reverse
    for (int i = index - 1; i >= 0; i--) {
        Uetrv32_Uart_Tx(buffer[i]);
    }
}

void printMatrix(int rows, int cols, int32_t C[rows][cols]) {
    for (int i = 0; i < rows; i++) {
        // Print opening bracket for each row
        Uetrv32_Uart_Tx('[');

        for (int j = 0; j < cols; j++) {
            int a = C[i][j];

            UART_Send_32bit_number(a);

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
uint32_t Get_Data_Word(void) {

  union {
    uint32_t word;
    uint8_t  byte[sizeof(uint32_t)];
  } data;

  uint32_t i;
		
  for (i=0; i<4; i++) {
     data.byte[i] = (uint8_t) Uetrv32_Uart_Rx(); 
   //  Uetrv32_Uart_Tx((uint32_t) data.byte[i]);   
  }
	
  return data.word;
}

void display_input_matrix(int rows, int cols, int8_t matrix[rows][cols]) {
    int i, j;
    bool rows_g = rows > 10;
    bool cols_g = cols > 10;

    UETrv32_Uart_Print("[\n\r");

    int rows_to_print = rows_g ? 5 : rows;

    // Display the first set of rows
    for (i = 0; i < rows_to_print; i++) {
        UETrv32_Uart_Print("  [");
        if (cols_g) {
            for (j = 0; j < 5; j++) {
                UART_Send_8bit_number(matrix[i][j]);
                Uetrv32_Uart_Tx(' ');
            }
            UETrv32_Uart_Print("... ");
            for (j = cols - 5; j < cols; j++) {
                UART_Send_8bit_number(matrix[i][j]);
                                Uetrv32_Uart_Tx(' ');

            }
        } else {
            for (j = 0; j < cols; j++) {
                UART_Send_8bit_number(matrix[i][j]);
                                Uetrv32_Uart_Tx(' ');

            }
        }
        UETrv32_Uart_Print("]\n\r");
    }

    if (rows_g) {
        // Ellipsis for skipped rows
        UETrv32_Uart_Print("  ...\n\r");

        // Display the last set of rows
        for (i = rows - 5; i < rows; i++) {
            UETrv32_Uart_Print("  [");
            if (cols_g) {
                for (j = 0; j < 5; j++) {
                    UART_Send_8bit_number(matrix[i][j]);
                                    Uetrv32_Uart_Tx(' ');

                }
                UETrv32_Uart_Print("... ");
                for (j = cols - 5; j < cols; j++) {
                    UART_Send_8bit_number(matrix[i][j]);
                                    Uetrv32_Uart_Tx(' ');

                }
            } else {
                for (j = 0; j < cols; j++) {
                    UART_Send_8bit_number(matrix[i][j]);
                                    Uetrv32_Uart_Tx(' ');

                }
            }
            UETrv32_Uart_Print("]\n\r");
        }
    }

    UETrv32_Uart_Print("]\n\r");
}
void display_result_matrix(int rows, int cols, int32_t matrix[rows][cols]) {
    int i, j;
    bool rows_g = rows > 10;
    bool cols_g = cols > 10;

    UETrv32_Uart_Print("[\n\r");

    int rows_to_print = rows_g ? 5 : rows;

    // Display the first set of rows
    for (i = 0; i < rows_to_print; i++) {
        UETrv32_Uart_Print("  [");
        if (cols_g) {
            for (j = 0; j < 5; j++) {
                UART_Send_32bit_number(matrix[i][j]);
                Uetrv32_Uart_Tx(' ');
            }
            UETrv32_Uart_Print("... ");
            for (j = cols - 5; j < cols; j++) {
                UART_Send_32bit_number(matrix[i][j]);
                                Uetrv32_Uart_Tx(' ');

            }
        } else {
            for (j = 0; j < cols; j++) {
                UART_Send_32bit_number(matrix[i][j]);
                                Uetrv32_Uart_Tx(' ');

            }
        }
        UETrv32_Uart_Print("]\n\r");
    }

    if (rows_g) {
        // Ellipsis for skipped rows
        UETrv32_Uart_Print("  ...\n\r");

        // Display the last set of rows
        for (i = rows - 5; i < rows; i++) {
            UETrv32_Uart_Print("  [");
            if (cols_g) {
                for (j = 0; j < 5; j++) {
                    UART_Send_32bit_number(matrix[i][j]);
                                    Uetrv32_Uart_Tx(' ');

                }
                UETrv32_Uart_Print("... ");
                for (j = cols - 5; j < cols; j++) {
                    UART_Send_32bit_number(matrix[i][j]);
                                    Uetrv32_Uart_Tx(' ');

                }
            } else {
                for (j = 0; j < cols; j++) {
                    UART_Send_32bit_number(matrix[i][j]);
                                    Uetrv32_Uart_Tx(' ');

                }
            }
            UETrv32_Uart_Print("]\n\r");
        }
    }

    UETrv32_Uart_Print("]\n\r");
}