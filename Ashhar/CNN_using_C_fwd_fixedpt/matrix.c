#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include "matrix.h"

// variables that define the Qn.m format that we have selected for computation
#define N 8
#define M 16

// functions that perform Q conversions and multiplication/addition operations on two nunmbers in Q formats
int floatToQ(float);
int QAdd(int, int);
int QMult(int, int);

int floatToQ(float value) {
    int result = value * (1 << M);
    return result;
}

// Q8.16 multiplication function
int QMult(int a, int b) {

    int Q8_16_SHIFT = M;
    int Q8_16_ONE = (1 << Q8_16_SHIFT);

    // Perform multiplication
    int result = (int)a * b;

    // Round the result
    result = (result + Q8_16_ONE / 2) >> Q8_16_SHIFT;

    // // Ensure the result is within the valid range for Q8.16 format
    // if (result > INT32_MAX) {
    //     return INT32_MAX;
    // } else if (result < INT32_MIN) {
    //     return INT32_MIN;
    // }

    return (int)result;
}

int QAdd(int num1, int num2) {
  // Define masks for integer and fractional parts
  int int_mask = (1 << N) - 1;    // Mask for N bits
  int frac_mask = (1 << M) - 1;   // Mask for M bits

  // Extract integer and fractional parts
  int int_part1 = (num1 >> M) & int_mask;  // Right shift to get integer part
  int frac_part1 = num1 & frac_mask;       // Mask to get fractional part

  int int_part2 = (num2 >> M) & int_mask;
  int frac_part2 = num2 & frac_mask;

  // Add integer parts
  int sum_int = int_part1 + int_part2;

  // Add fractional parts
  int sum_frac = frac_part1 + frac_part2;

  // Check for overflow in fractional part
  if (sum_frac > frac_mask) {
      sum_int += 1;          // Carry overflow to integer part
      sum_frac -= (1 << M);  // Subtract 2^M to get correct fractional part
  }

  // Combine integer and fractional parts
  int result = ((sum_int & int_mask) << M) | (sum_frac & frac_mask);

  return result;
}

// initialize the matrix
void Matrix_Init(struct Matrix *x, int r, int c)
{
    x->rows = r;
    x->columns = c;

    x->elements = (int **)malloc(r * sizeof(int *));

    for (int i = 0; i < r; i++)
    {
        x->elements[i] = (int *)malloc(c * sizeof(int));
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
            printf(" %d ", x->elements[i][j]);
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

struct Matrix multiply_matrices(struct Matrix *matrix1, struct Matrix *matrix2) {

  struct Matrix result;

  Matrix_Init(&result, matrix1->rows, matrix2->columns);

  printf("\n\n MATRIX MULTIPLICATION \n\n");

  for (int i = 0; i < matrix1->rows; i++) {
    for (int j = 0; j < matrix2->columns; j++) {
      result.elements[i][j] = 0;
      for (int k = 0; k < matrix1->columns; k++) {

        int test = QMult(matrix1->elements[i][k], matrix2->elements[k][j]);
        printf("%d x %d : %d \n",matrix1->elements[i][k], matrix2->elements[k][j], test);

        int test2 = QAdd(test, result.elements[i][j]);
        printf("%d + %d : %d \n",test, result.elements[i][j], test2);
        printf("\n\n");


        result.elements[i][j] = QAdd(result.elements[i][j], QMult(matrix1->elements[i][k], matrix2->elements[k][j]));
        // result.elements[i][j] += matrix1->elements[i][k] * matrix2->elements[k][j];
      }
    }
  }
  return result;
}