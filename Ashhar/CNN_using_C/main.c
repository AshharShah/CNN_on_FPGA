#include "matrix.h"
#include <stdio.h>

extern void Matrix_Init(struct Matrix *x, int r, int c);
extern void Num_Zeros(struct Matrix *x, int r, int c);
extern void print_matrix(struct Matrix *x, int r, int c);
extern void free_matrix(struct Matrix *x);
extern struct Matrix add_matrices(struct Matrix *matrix1, struct Matrix *matrix2);
extern struct Matrix multiply_matrices(struct Matrix *matrix1, struct Matrix *matrix2);

int main()
{
    struct Matrix kernel;
    struct Matrix patch;

    int rows = 3;
    int cols = 3;

    // create a kernel matrix with zero as elements
    Matrix_Init(&kernel, rows, cols);
    Num_Zeros(&kernel, rows, cols);
    for (int i = 0; i < rows; i++)
    {
        for (int j = 0; j < cols; j++)
        {
            kernel.elements[i][j] = i+j;
        }
    }

    // create a patch matrix with the same dimensions as the kernel
    Matrix_Init(&patch, rows, cols);
    Num_Zeros(&patch, rows, cols);
    for (int i = 0; i < rows; i++)
    {
        for (int j = 0; j < cols; j++)
        {
            patch.elements[i][j] = i+j;
        }
    }

    // print the kernel and patch matrices
    printf("\n Kernel Matrix: \n");
    print_matrix(&kernel, rows, cols);
    printf("\n Patch Matrix: \n");
    print_matrix(&patch, rows, cols);

    // program to test the sum of the matrices
    struct Matrix add_result = add_matrices(&kernel, &patch);
    printf("\n Sum Result Matrix: \n");
    print_matrix(&add_result, rows, cols);

    // program to test the sum of the matrices
    struct Matrix multiply_result = multiply_matrices(&kernel, &patch);
    printf("\n Multiplication Result Matrix: \n");
    print_matrix(&multiply_result, rows, cols);

    return 0;
}