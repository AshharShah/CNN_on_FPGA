#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include "matrix.h"

// initialize the matrix
void Matrix_Init(struct Matrix *x, int r, int c)
{
    x->rows = r;
    x->columns = c;

    x->elements = (float **)malloc(r * sizeof(float *));

    for (int i = 0; i < r; i++)
    {
        x->elements[i] = (float *)malloc(c * sizeof(float));
    }
};

// take matrix and add all zeros
void Num_Zeros(struct Matrix *x, int r, int c)
{
    for (int i = 0; i < r; i++)
    {
        for (int j = 0; j < c; j++)
        {
            x->elements[i][j] = 0;
        }
    }
}

void print_matrix(struct Matrix *x, int r, int c)
{
    for (int i = 0; i < r; i++)
    {
        for (int j = 0; j < c; j++)
        {
            printf(" %f ", x->elements[i][j]);
        }
        printf("\n");
    }
}