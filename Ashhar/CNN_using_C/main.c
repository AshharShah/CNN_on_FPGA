#include "matrix.h"
#include "image.h"

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <math.h>

int img_index = 0;
int target_class = 0;
float alpha = 0.01;


extern void Matrix_Init(struct Matrix *x, int r, int c);
// extern void Num_Zeros(struct Matrix *x, int r, int c);
extern void print_matrix(struct Matrix *x, int r, int c);
// extern void free_matrix(struct Matrix *x);
// extern struct Matrix add_matrices(struct Matrix *matrix1, struct Matrix *matrix2);
// extern struct Matrix multiply_matrices(struct Matrix *matrix1, struct Matrix *matrix2);
extern struct Matrix multiply_matrices(struct Matrix *matrix1, struct Matrix *matrix2);

// function that will retrieve the images that are to be processed
extern void get_images(int per_num, struct Image* image);


// functions for the convolutional layer
void filter_init();
void convolution_forward(struct Image);
void convolution_backward(struct Image, float);

// functions for the maxpooling layer
void maxpool_forward();
void maxpool_backward(float);

// functions for the flatten layer
void flatten_forward();

// functions for the dense layer
void dense_weight_init();
void dense_forward();
int predict();
void dense_backward(float);


// objects required by the convolutional layer
float **filter;
struct Image image[2];
float conv_output[14][14] = {0};
float conv_gradients[3][3] = {0};

// objects required by the maxpooling layer
float maxpool_output[7][7] = {0};
float maxpool_gradients[14][14] = {0};

// objects required by the flatten layer
float flatten_output[7*7] = {0};

// objects required by the dense layer
float dense_weights[49][10] = {0};
float dense_logits[10] = {0};
float softmax_vectors[10] = {0};
float dE_dY[10] = {0};
float dense_gradients[7][7] = {0};


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
            printf(" %5d ", (int)(conv_output[i][j] * 255));
        }
        printf("\n\n");
    }

    // perform maxpool forward propogation for a single image
    maxpool_forward();

    // display the feature map for the convolved image
    printf("\n\n\t\t\t\t ******************* REDUCED FEATURE MAP *******************\n\n");
    printf(" Height Of Feature Map: %d\n", 7);
    printf(" Width Of Feature Map: %d\n", 7);
    printf("\n\n");
    for(int i = 0; i < 7; i++){
        for(int j =0; j < 7; j++){
            printf(" %5d ", (int)(maxpool_output[i][j] * 255));
        }
        printf("\n\n");
    }

    // initialize the weights for the dense layer
    dense_weight_init();

    // printf("\n\n\t\t\t\t ******************* DENSE LAYER WEIGHTS *******************\n\n  ");
    // for(int i = 0; i < 10; i++){
    //     printf(" Class %d    ", i);
    // }
    // printf("\n\n");
    // for(int i = 0; i < 7*7; i++){
    //     for(int j = 0; j < 10; j++){
    //         printf(" %10f ", dense_weights[i][j]);
    //     }
    //     printf("\n");
    // }

    dense_forward();

    // printf("\n\n\t\t\t\t ******************* FLATTENED FEATURE MAP *******************\n\n");
    // for(int i = 0; i < 7*7; i++){
    //     printf("%5d\n", (int)(flatten_output[i]*255));
    // }

    // perform validation to see if softmax was correctly computed
    float soft_sum = 0.0;
    for(int i = 0; i < 10; i++){
        soft_sum += softmax_vectors[i];
    }

    printf("\n\n SUM OF SOFTMAX VECTORS: %f \n", soft_sum);
    
    dE_dY[target_class] = -1 / softmax_vectors[target_class];

    printf("\n\n\t\t\t\t ******************* GRADIENT FOR SOFTMAX LAYER *******************\n\n  ");
    for(int i = 0; i < 10; i++){
        printf(" %10f ", dE_dY[i]);
    }
    printf("\n\n");

    dense_backward(alpha);

    // printf("\n\n\t\t\t\t ******************* DENSE LAYER WEIGHTS *******************\n\n  ");
    // for(int i = 0; i < 10; i++){
    //     printf(" Class %d    ", i);
    // }
    // printf("\n\n");
    // for(int i = 0; i < 7*7; i++){
    //     for(int j = 0; j < 10; j++){
    //         printf(" %10f ", dense_weights[i][j]);
    //     }
    //     printf("\n");
    // }

    // display the feature map for the convolved image
    printf("\n\n\t\t\t\t ******************* MAXPOOL GRADIENTS *******************\n\n");
    for(int i = 0; i < 7; i++){
        for(int j =0; j < 7; j++){
            printf(" %10f ", dense_gradients[i][j]);
        }
        printf("\n\n");
    }

    maxpool_backward(alpha);

    convolution_backward(image[img_index], alpha);

    for(int i = 0; i < 15; i++){
        convolution_forward(image[img_index]);
        maxpool_forward();
        dense_forward();
        dE_dY[target_class] = -1 / softmax_vectors[target_class];
        float loss = -1.0 * log(softmax_vectors[0]);
        printf("\n\n LOSS: %f \n\n", loss);
        if(loss < 0.05){
            break;
        }
        dense_backward(alpha);
        maxpool_backward(alpha);
        convolution_backward(image[img_index], alpha);
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
            filter[i][j] = (rand() % 10) / 100.0;
        }
    }

    printf("\n\n\t\t\t\t ******************* INITIAL KERNEL *******************\n\n");
    for(int i = 0; i < 3; i++){
        for(int j = 0; j < 3; j++){
            printf(" %10f ", filter[i][j]);
        }
        printf("\n\n");
    }
}

// function to perform forward propogation on the input image that is passed as an argument
void convolution_forward(struct Image img){
    // Perform convolution with stride 2
    for (int i = 0; i < 28; i += 2) {
        for (int j = 0; j < 28; j += 2) {
            float sum = 0;
            for (int k = 0; k < 3; k++) {
                for (int l = 0; l < 3; l++) {
                    sum += img.image_array[i + k][j + l] * filter[k][l];
                }
            }
            conv_output[i / 2][j / 2] = sum; // Divide indices by 2 for output image
        }
    }
}

void convolution_backward(struct Image img, float learn_rate){

    // retrieve the patches for the input image
    struct Patch patches[14*14];
    int m = 0;
        // Perform convolution with stride 2
    for (int i = 0; i < 28; i += 2) {
        for (int j = 0; j < 28; j += 2) {

            for (int k = 0; k < 3; k++) {
                for (int l = 0; l < 3; l++) {
                    patches[m].image_array[k][l] = img.image_array[i + k][j + l];
                }
            }
            m++;
        }
    }

    for(int i = 0; i < (14*14); i++){
        for(int j = 0; j < 3; j++){
            for(int k = 0; k < 3; k++){
                conv_gradients[j][k] += patches[i].image_array[j][k] * maxpool_gradients[j][k];
            }
        }
    }

    // printf("\n\n\t\t\t\t ******************* PATCHES *******************\n\n");
    // for(int i = 0; i < 14*14; i++){
    //     printf(" PATCH %d :  ", i);
    //     for(int j = 0; j < 3; j++){
    //         for(int k = 0; k < 3; k++){
    //             printf(" %10f ", patches[i].image_array[j][k]);
    //         }
    //     }
    //     printf("\n\n");
    // }

    printf("\n\n\t\t\t\t ******************* CONV GRADIENTS *******************\n\n");
    for(int i = 0; i < 3; i++){
        for(int j = 0; j < 3; j++){
            printf(" %10f ", conv_gradients[i][j]);
        }
        printf("\n\n");
    }

    for(int i = 0; i < 3; i++){
        for(int j = 0; j < 3; j++){
            filter[i][j] = filter[i][j] -  (learn_rate * conv_gradients[i][j]);
        }
    }

    printf("\n\n\t\t\t\t ******************* UPDATED KERNEL *******************\n\n");
    for(int i = 0; i < 3; i++){
        for(int j = 0; j < 3; j++){
            printf(" %10f ", filter[i][j]);
        }
        printf("\n\n");
    }
}

// THESE ARE THE FUNCTIONS THAT ARE USED BY THE MAXPOOLING LAYER:

    // 1) maxpool_forward()
    //
    //     - This function performs the forward propogation for the maxpooling layer.
    //
    //     - It takes the feature map that was generated by the concolutional layer and uses a filter
    //       of size 2x2 with a stride of 2 to generate a reduced feature map.
    //
    //     - The reduced feature map is stored in the global variable named "maxpool_output" 


// function to perform maxpooling forward propogation and generate a reduced feature map
void maxpool_forward(){
    // Perform max pooling operation
    for (int i = 0; i < 14; i += 2) {
        for (int j = 0; j < 14; j += 2) {
            float maxVal = 0;
            for (int k = i; k < i + 2; k++) {
                for (int l = j; l < j + 2; l++) {
                    if (conv_output[k][l] > maxVal) {
                        maxVal = conv_output[k][l];
                    }
                }
            }
            maxpool_output[i / 2][j / 2] = maxVal;
        }
    }
}

void maxpool_backward(float learn_rate){

    float grad_copy[7*7] = {0};
    int x = 0;
    for(int i = 0; i < 7; i++){
        for(int j = 0; j < 7; j++){
            grad_copy[x] = dense_gradients[i][j];
            x++;
        }
    }
    
    x = 0;
    // Perform max pooling operation
    for (int i = 0; i < 14; i += 2) {
        for (int j = 0; j < 14; j += 2) {
            float maxVal = 0;
            int maxI = i;
            int maxJ = j;            
            for (int k = i; k < i + 2; k++) {
                for (int l = j; l < j + 2; l++) {
                    if (conv_output[k][l] > maxVal) {
                        maxVal = conv_output[k][l];
                        maxI = k;
                        maxJ = l;
                    }
                }
            }
            maxpool_gradients[maxI][maxJ] = grad_copy[x];
            x++;
        }
    }

    printf("\n\n\t\t\t\t ******************* CONVOLUTION GRADIENTS *******************\n\n");
    for(int i = 0; i < 14; i++){
        for(int j =-0; j < 14; j++){
            printf(" %10f ", ( maxpool_gradients[i][j]));
        }
        printf("\n\n");
    }
}

// THESE ARE THE FUNCTIONS THAT ARE USED BY THE FLATTEN LAYER

    // 1) flatten_forward()

    //     - This function will convert the 2D array `maxpool_output` that contains the 
    //       reduced feature map into a 1D array and store it in the variable `flatten_output`


void flatten_forward(){
    int index = 0;
    for(int i = 0; i < 7; i++){
        for(int j = 0; j < 7; j++){
            flatten_output[index] = maxpool_output[i][j];
            index++;
        }
    }
}

// THESE ARE THE FUNCTIONS THAT ARE USED BY THE DENSE LAYER

    // 1) dense_weight_init()

        // - This function will initialize the dense layer vector for classification
        //   of the input image and apply the softmax activation function to it.

void dense_weight_init(){
    for(int i = 0; i < 49; i++){
        for(int j = 0; j < 10; j++){
            dense_weights[i][j] = (rand() % 10) / 100.0;
        }
    }
}

void dense_forward(){

    // convert the 2D reduced feature map to a 1D feature map
    flatten_forward();

    // create matrix objects that will be used to perform multiplication on the two matrices
    struct Matrix flatten_transpose;
    struct Matrix weights;

    // initialize both of the matrices
    Matrix_Init(&flatten_transpose, 1, 49);
    Matrix_Init(&weights, 49, 10);
    // copy the flattened image and take its transpose to allow multiplication of the two
    for(int i = 0; i < 1; i++){
        for(int j = 0; j < 49; j++){
            flatten_transpose.elements[i][j] = flatten_output[j];
        }
    }

    // print the transposed matrix
    // printf("\n\n\t\t\t\t ******************* FLATTEN LAYER TRANSPOSE *******************\n\n");
    // for(int i = 0; i < 1; i++){
    //     for(int j = 0; j < 49; j++){
    //         printf("%4d ", (int)(flatten_transpose.elements[i][j] * 255));
    //     }
    // }
    // printf("\n");

    // perform the dense layer operation y = w{t} * x to retrieve the logits
    for(int i = 0; i < 49; i++){
        for(int j = 0; j < 10; j++){
            weights.elements[i][j] = dense_weights[i][j];
        }
    }
    
    // display the logits to the user
    struct Matrix logits = multiply_matrices(&flatten_transpose, &weights);
    printf("\n\n\t\t\t\t ******************* LOGITS *******************\n\n");
    print_matrix(&logits, 1, 10);

    for(int i = 0; i < 1; i++){
        for(int j = 0; j < 10; j++){
            dense_logits[j] = logits.elements[i][j];
        }
    }

    // printf("\n\n\t\t\t\t ******************* LOGITS TRANSPOSED *******************\n\n");
    // for(int i = 0; i < 10; i++){
    //     printf(" %10f\n", dense_logits[i]);
    // }

    // now we will apply the softmax activation function 
    float deno = 0;
    for(int i = 0; i < 10; i++){
        deno += exp(dense_logits[i]);
    }

    for(int i = 0; i < 10; i++){
        softmax_vectors[i] = exp(dense_logits[i]) / deno;
    }

    printf("\n\n\t\t\t\t ******************* SOFTMAX PROBABILITIES*******************\n\n");
    for(int i = 0; i < 10; i++){
        printf(" CLASS %d:  %10f\n", i, softmax_vectors[i]);
    }

    int prediction = predict();

    printf("\n\n The Predicted Class: %d\n\n", prediction);

}

void dense_backward(float learn_rate){

    float transformation_eq[10];
    float S_total = 0;
    float dY_dZ[10] = {0};
    float dE_dZ[10] = {0};
    
    struct Matrix dZ_dw_Matrix;
    Matrix_Init(&dZ_dw_Matrix, 49, 1);
    struct Matrix dE_dZ_Matrix;
    Matrix_Init(&dE_dZ_Matrix, 1, 10);

    struct Matrix dE_dZ_Matrix_2;
    Matrix_Init(&dE_dZ_Matrix_2, 10, 1);

    struct Matrix dZ_dX_Matrix;
    Matrix_Init(&dZ_dX_Matrix, 49, 10);

    struct Matrix dE_dX_Matrix;
    

    for(int i = 0; i < 10; i++){
        transformation_eq[i] = exp(dense_logits[i]);
    }

    for(int i = 0; i < 10; i++){
        S_total += transformation_eq[i];
    }


    for(int i = 0; i < 10; i++){
        if(dE_dY[i] == 0){
            continue;
        }

        for(int j = 0; j < 10; j++){
            dY_dZ[j] = (-1.0 * transformation_eq[i] * transformation_eq[j]) / (S_total * S_total);
        }
        dY_dZ[i] = ( transformation_eq[i] * (S_total - transformation_eq[i]) ) / (S_total * S_total);

        for(int j = 0; j < 10; j++){
            dE_dZ[j] = dE_dY[j] * dY_dZ[j];
        }

        for(int j = 0; j < 10; j++){
            dE_dZ_Matrix.elements[0][j] = dE_dZ[j];
        }
        for(int j = 0; j < 49; j++){
            dZ_dw_Matrix.elements[j][0] = flatten_output[j];
        }

        struct Matrix dE_dW_Matrix = multiply_matrices(&dZ_dw_Matrix, &dE_dZ_Matrix);
        // printf("\n\n\t\t\t\t ******************* dE_dW *******************\n\n");
        // print_matrix(&dE_dW_Matrix, 49, 10);

        for(int j = 0; j < 49; j++){
            for(int k = 0; k < 10; k++){
                dense_weights[j][k] = dense_weights[j][k] - (learn_rate * dE_dW_Matrix.elements[j][k]);
            }
        }

        for(int j = 0; j < 10; j++){
            dE_dZ_Matrix_2.elements[j][0] = dE_dZ[j];
        }

        for(int j = 0; j < 49; j++){
            for(int k = 0; k < 10; k++){
                dZ_dX_Matrix.elements[j][k] = dense_weights[j][k];
            }
        }

        dE_dX_Matrix = multiply_matrices(&dZ_dX_Matrix, &dE_dZ_Matrix_2);
        // printf("\n\n\t\t\t\t ******************* dE_dX *******************\n\n");
        // print_matrix(&dE_dX_Matrix, 49, 1);


    }

    // printf("\n\n\t\t\t\t ******************* dY_dZ 10x1 Vector *******************\n\n");
    // for(int i = 0; i < 10; i++){
    //     printf("%f\n", dY_dZ[i]);
    // }

    // printf("\n\n\t\t\t\t ******************* dE_dZ 10x1 Vector *******************\n\n");
    // for(int i = 0; i < 10; i++){
    //     printf("%f\n", dE_dZ[i]);
    // }

    // printf("\n\n\t\t\t\t ******************* dZ_dw *******************\n\n");
    // print_matrix(&dZ_dw_Matrix, 49, 1);

    // printf("\n\n\t\t\t\t ******************* dE_dZ *******************\n\n");
    // print_matrix(&dE_dZ_Matrix, 1, 10);
    
    int k = 0;
    for(int i = 0; i < 7; i++){
        for(int j = 0; j < 7; j++){
            dense_gradients[i][j] = dE_dX_Matrix.elements[k][0];
            k++;
        }
    }

}

int predict(){
    int max_index = 0;
    float max_val = softmax_vectors[0];

    for(int i = 1; i < 10; i++){
        if(softmax_vectors[i] > max_val){
            max_val = softmax_vectors[i];
            max_index = i;
        }
    }
    return max_index;
}