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

void free_matrix(struct Matrix *x) {
  for (int i = 0; i < x->rows; i++) {
    free(x->elements[i]);
  }
  free(x->elements);
  free(x);
}

struct Matrix add_matrices(struct Matrix *matrix1, struct Matrix *matrix2) {
  struct Matrix result;

  Matrix_Init(&result, matrix1->rows, matrix1->columns);

  for (int i = 0; i < matrix1->rows; i++) {
    for (int j = 0; j < matrix1->columns; j++) {
      result.elements[i][j] = matrix1->elements[i][j] + matrix2->elements[i][j];
    }
  }
  return result;
}

// struct Matrix *multiply_matrices(struct Matrix *matrix1, struct Matrix *matrix2) {
//   if (matrix1->columns != matrix2->rows) {
//     printf("The number of columns in the first matrix must equal the number of rows in the second matrix to be multiplied.\n");
//     return NULL;
//   }

//   struct Matrix result;
//   Matrix_Init(&result, matrix1->rows, matrix2->columns);
//   for (int i = 0; i < matrix1->rows; i++) {
//     for (int j = 0; j < matrix2->columns; j++) {
//       for (int k = 0; k < matrix1->columns; k++) {
//         result->elements[i][j] += matrix1->elements[i][k] * matrix2->elements[k][j];
//       }
//     }
//   }
//   return result;
// }