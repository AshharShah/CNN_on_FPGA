#include "matrix.h"
#include <stdio.h>

extern void Matrix_Init(struct Matrix *x, int r, int c);
extern void Num_Zeros(struct Matrix *x, int r, int c);
extern void print_matrix(struct Matrix *x, int r, int c);

int main()
{
    struct Matrix kernel;

    Matrix_Init(&kernel, 2, 2);

    Num_Zeros(&kernel, 2, 2);

    print_matrix(&kernel, 2, 2);

    return 0;
}