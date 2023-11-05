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

struct Image{
    // Declare a 2D array to store the image data.
    uint8_t image_array[28][28];
    int height;
    int width;
    int channels;
};

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

    struct Image image;

    // Load the image data into the array.
    unsigned char* image_data = stbi_load("/home/ashhar/Desktop/CNN_on_FPGA/Ashhar/CNN_using_C/mnist_png/training/0/6034.png", &image.width, &image.height, &image.channels, 0);

    if (image_data == NULL) {
        printf("\nError Opening The Image!\n");
        // Handle error.
        return 1;
    }

    memcpy(image.image_array, image_data, image.width * image.height * image.channels);

    printf(" Height Of Image: %d\n", image.height);
    printf(" Width Of Image: %d\n", image.width);
    printf(" Channels In Image: %d\n", image.channels);
    printf("\n\n");

    printf("\t\t INPUT IMAGE \t\t\n\n");
    for(int i = 0; i < 28; i++){
        for(int j =0; j < 28; j++){
            printf(" %3d ", image.image_array[i][j]);
        }
        printf("\n");
    }

    int paddedImage[30][30] = {0}; // Padded image with zeros
    int output[14][14];
    int filter[3][3];

    for(int i = 0; i < 3; i++){
        for(int j = 0; j < 3; j++){
            filter[i][j] = rand() % 10;
        }
    }

    // Pad the image with zeros
    for (int i = 0; i < 28; i++) {
        for (int j = 0; j < 28; j++) {
            paddedImage[i + 1][j + 1] = image.image_array[i][j];
        }
    }

    printf("\n\n\t\t PADDED IMAGE \t\t\n\n");
    for(int i = 0; i < 30; i++){
        for(int j =0; j < 30; j++){
            printf(" %3d ", paddedImage[i][j]);
        }
        printf("\n");
    }

    // Perform convolution with stride 2
    for (int i = 0; i < 28; i += 2) {
        for (int j = 0; j < 28; j += 2) {
            int sum = 0;
            for (int k = 0; k < 3; k++) {
                for (int l = 0; l < 3; l++) {
                    sum += paddedImage[i + k][j + l] * filter[k][l];
                }
            }
            output[i / 2][j / 2] = sum; // Divide indices by 2 for output image
        }
    }

    printf("\n\n\t\t FEATURE MAP \t\t\n\n");
    for(int i = 0; i < 14; i++){
        for(int j =0; j < 14; j++){
            printf(" %5d ", output[i][j]);
        }
        printf("\n");
    }


    return 0;
}