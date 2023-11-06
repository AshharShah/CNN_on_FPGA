#include "matrix.h"
#include "image.h"

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>

int img_index = 1;


// extern void Matrix_Init(struct Matrix *x, int r, int c);
// extern void Num_Zeros(struct Matrix *x, int r, int c);
// extern void print_matrix(struct Matrix *x, int r, int c);
// extern void free_matrix(struct Matrix *x);
// extern struct Matrix add_matrices(struct Matrix *matrix1, struct Matrix *matrix2);
// extern struct Matrix multiply_matrices(struct Matrix *matrix1, struct Matrix *matrix2);
// extern struct Matrix multiply_matrices(struct Matrix *matrix1, struct Matrix *matrix2);

// function that will retrieve the images that are to be processed
extern void get_images(int per_num, struct Image* image);


// functions for the convolutional layer
void filter_init();
void convolution_forward(struct Image);


// objects required by the convolutional layer
float **filter;
struct Image image[2];
float conv_output[14][14];



int main()
{
    // struct Matrix kernel;
    // struct Matrix patch;

    // int rows = 3;
    // int cols = 3;

    // // create a kernel matrix with zero as elements
    // Matrix_Init(&kernel, rows, cols);
    // Num_Zeros(&kernel, rows, cols);
    // for (int i = 0; i < rows; i++)
    // {
    //     for (int j = 0; j < cols; j++)
    //     {
    //         kernel.elements[i][j] = i+j;
    //     }
    // }

    // // create a patch matrix with the same dimensions as the kernel
    // Matrix_Init(&patch, rows, cols);
    // Num_Zeros(&patch, rows, cols);
    // for (int i = 0; i < rows; i++)
    // {
    //     for (int j = 0; j < cols; j++)
    //     {
    //         patch.elements[i][j] = i+j;
    //     }
    // }

    // // print the kernel and patch matrices
    // printf("\n Kernel Matrix: \n");
    // print_matrix(&kernel, rows, cols);
    // printf("\n Patch Matrix: \n");
    // print_matrix(&patch, rows, cols);

    // // program to test the sum of the matrices
    // struct Matrix add_result = add_matrices(&kernel, &patch);
    // printf("\n Sum Result Matrix: \n");
    // print_matrix(&add_result, rows, cols);

    // // program to test the sum of the matrices
    // struct Matrix multiply_result = multiply_matrices(&kernel, &patch);
    // printf("\n Multiplication Result Matrix: \n");
    // print_matrix(&multiply_result, rows, cols);
    // printf("\n\n");


    // initialize the images for the training dataset
    get_images(10, image);
    
    // initialize the filter for the convolution layer
    filter_init();


    // display the input image which we are dealing with
    printf("\n\n\t\t\t\t ******************* INPUT IMAGE (With Padding) ******************* \n\n");
    printf(" Height Of Image: %d\n", image[img_index].height);
    printf(" Width Of Image: %d\n", image[img_index].width);
    printf("\n\n");
    for(int i = 0; i < 30; i++){
        for(int j = 0; j < 30; j++){
            printf(" %4d ", (int)(image[img_index].image_array[i][j] * 255));
        }
        printf("\n");
    }

    // perform convolution forward propogation for a single image
    convolution_forward(image[img_index]);

    // display the feature map for the convolved image
    printf("\n\n\t\t\t\t ******************* FEATURE MAP *******************\n\n");
    printf(" Height Of Feature Map: %d\n", 14);
    printf(" Width Of Feature Map: %d\n", 14);
    printf("\n\n");
    for(int i = 0; i < 14; i++){
        for(int j =0; j < 14; j++){
            printf(" %4d ", (int)(conv_output[i][j] * 255));
        }
        printf("\n\n");
    }


    for(int i = 0; i < 3; i++){
        free(filter[i]);
    }
    free(filter);

    return 0;
}



// THESE ARE THE FUNCTION THAT ARE USED BY THE CONVOLUTIONAL LAYER:

    // 1) filter_init()
    //
    //     - This function takes a filter of size 3x3 and initializes it using random numbers ranging from 0-10
    //
    // 2) convolution_forward()
    //
    //     - This function performs the forward propogation for the convolutional layer, it takes an Image object
    //     that contains the pixels for the input image and uses the filter to iterate over the image.

    //     - It update the global variable named "conv_output" that will contain the feature map.


// function to initialize the filters that are to be used in the convolution layer
void filter_init(){
    filter = (float**)malloc(3 * sizeof(float*));
    for(int i = 0; i < 3; i++){
        filter[i] = (float*)malloc(sizeof(float));
    }

    for(int i = 0; i < 3; i++){
        for(int j = 0; j < 3; j++){
            filter[i][j] = rand() % 10;
        }
    }

}

// function to perform forward propogation on the input image that is passed as an argument
void convolution_forward(struct Image img){
    // Perform convolution with stride 2
    for (int i = 0; i < 28; i += 2) {
        for (int j = 0; j < 28; j += 2) {
            int sum = 0;
            for (int k = 0; k < 3; k++) {
                for (int l = 0; l < 3; l++) {
                    sum += img.image_array[i + k][j + l] * filter[k][l];
                }
            }
            conv_output[i / 2][j / 2] = sum; // Divide indices by 2 for output image
        }
    }
}