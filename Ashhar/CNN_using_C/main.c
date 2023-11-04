#include "matrix.h"
#include <stdio.h>


#define STB_IMAGE_IMPLEMENTATION
#include "stb/stb_image.h"
#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "stb/stb_image_write.h"

extern void Matrix_Init(struct Matrix *x, int r, int c);
extern void Num_Zeros(struct Matrix *x, int r, int c);
extern void print_matrix(struct Matrix *x, int r, int c);
extern void free_matrix(struct Matrix *x);
extern struct Matrix add_matrices(struct Matrix *matrix1, struct Matrix *matrix2);
extern struct Matrix multiply_matrices(struct Matrix *matrix1, struct Matrix *matrix2);
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
    printf("\n\n");

    // Declare a 2D array to store the image data.
    uint8_t image_array[640][480];
    int height = 0;
    int width = 0;
    int channels = 0;

    // Load the image data into the array.
    unsigned char* image_data = stbi_load("/home/ashhar/Desktop/CNN_on_FPGA/Ashhar/CNN_using_C/mnist_png/training/0/6034.png", &width, &height, &channels, 0);

    if (image_data == NULL) {
        printf("\nError Opening The Image!\n");
        // Handle error.
        return 1;
    }

    memcpy(image_array, image_data, width * height * channels);

    printf("Height Of Image: %d\n", height);
    printf("Width Of Image: %d\n", width);
    printf("Channels In Image: %d\n", channels);

    return 0;
}