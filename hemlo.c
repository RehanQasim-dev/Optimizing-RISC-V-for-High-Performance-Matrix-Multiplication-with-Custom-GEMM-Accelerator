#include <stdio.h>
#include <stdlib.h> // for random number generation
#include <stdint.h>
#include <stdbool.h>

// Define the dimensions of the matrix
#define M 11 // Number of rows
#define K 11 // Number of columns

// Function to generate a random value
int random_value() {
    return rand() % 100 + 1; // Generates a random value between 1 and 100
}

#include <stdbool.h>

#include <stdbool.h>
#include <stdio.h>

void displayMatrix(int rows, int cols, int matrix[rows][cols]) {
    int i, j;
    bool rows_g = rows > 10;
    bool cols_g = cols > 10;

    printf("[\n");

    int rows_to_print = rows_g ? 5 : rows;

    // Display the first set of rows
    for (i = 0; i < rows_to_print; i++) {
        printf("  [");
        if (cols_g) {
            for (j = 0; j < 5; j++) {
                printf("%d ", matrix[i][j]);
            }
            printf("... ");
            for (j = cols - 5; j < cols; j++) {
                printf("%d ", matrix[i][j]);
            }
        } else {
            for (j = 0; j < cols; j++) {
                printf("%d ", matrix[i][j]);
            }
        }
        printf("]\n");
    }

    if (rows_g) {
        // Ellipsis for skipped rows
        printf("  ...\n");

        // Display the last set of rows
        for (i = rows - 5; i < rows; i++) {
            printf("  [");
            if (cols_g) {
                for (j = 0; j < 5; j++) {
                    printf("%d ", matrix[i][j]);
                }
                printf("... ");
                for (j = cols - 5; j < cols; j++) {
                    printf("%d ", matrix[i][j]);
                }
            } else {
                for (j = 0; j < cols; j++) {
                    printf("%d ", matrix[i][j]);
                }
            }
            printf("]\n");
        }
    }

    printf("]\n");
}


int main() {
    // Seed the random number generator
    // srand((unsigned) time(NULL));

    // Create the matrix
    int matrixA[M][K];
    for (int i = 0; i < M; i++) {
        for (int j = 0; j < K; j++) {
            matrixA[i][j] = random_value();
        }
    }

    // Print the matrix
    displayMatrix(M, K, matrixA);

    return 0;
}
