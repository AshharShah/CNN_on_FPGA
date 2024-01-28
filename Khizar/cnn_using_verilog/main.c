#include "matrix.h"
#include "image.h"

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <math.h>

float alpha = 0.05;

float loss = 0;

// number should be divisible by 10
#define num_of_train_images 3000

// these are the functions that we will use for matrix related operations
extern void Matrix_Init(struct Matrix *x, int r, int c);
extern void print_matrix(struct Matrix *x, int r, int c);
extern struct Matrix multiply_matrices(struct Matrix *matrix1, struct Matrix *matrix2);

// function that will retrieve the images that are to be processed
extern void get_images(int per_num, struct Image *image);

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

// an array of images which represents our trainging data
struct Image image[num_of_train_images];

// objects required by the convolutional layer
float **filter;                   // this is a 2D kernel of size 3x3 which is used to perform convolution operation
float conv_output[14][14] = {0};  // this will contain the feature map of size 14x14 after convolution operation is applied
float conv_gradients[3][3] = {0}; // this will hold the gradient dL_dw for the kernels

// objects required by the maxpooling layer
float maxpool_output[7][7] = {0};      // this will represent the reduced feature map after the convolution operation is performed
float maxpool_gradients[14][14] = {0}; // this will represent the gradients which will be used by the convolution layer

// objects required by the flatten layer
float flatten_output[7 * 7] = {0}; // this is a 1D array of size 49 which will hold the reduced feature map in a flattened form

// objects required by the dense layer
float dense_weights[49][10] = {0}; // this represents the weights for the 10 classes of which we are to predict
float dense_logits[10] = {0};      // this 1D array will hold the values of the calculation z = w(t) * x
float softmax_vectors[10] = {0};   // the probability vector after we have applied the softmax activation function
float dE_dY[10] = {0};             // this will hold the loss for the softmax layer (cross-entropy)
float dense_gradients[7][7] = {0}; // this 2D array will store the gradients which are to be sent to the max-pooling layer

int forward(struct Image);
void backward(struct Image);
void shuffle_images(int);

int main()
{

    // initialize the images for the training dataset
    get_images(num_of_train_images, image);
    shuffle_images(num_of_train_images);

    printf("\n\n\t\t\t\t ******************* IMAGE *******************\n\n");
    for (int i = 0; i < 30; i++)
    {
        for (int j = 0; j < 30; j++)
        {
            printf(" %4d ", (int)(image[99].image_array[i][j] * 255));
        }
        printf("\n");
    }

    printf("\n\n IMAGE TARGET: %d \n\n", image[99].target);

    // initialize the filter for the convolution layer
    filter_init();
    // initialize the weights for the dense layer
    dense_weight_init();

    printf("\n\n\t\t\t\t ******************* FILTER *******************\n\n");
    for (int i = 0; i < 3; i++)
    {
        for (int j = -0; j < 3; j++)
        {
            printf(" %10f ", filter[i][j]);
        }
        printf("\n");
    }

    printf("\n\n\t\t\t\t ******************* DENSE *******************\n\n");
    for (int i = 0; i < 49; i++)
    {
        for (int j = -0; j < 10; j++)
        {
            printf(" %10f ", dense_weights[i][j]);
        }
        printf("\n");
    }

    float local_loss;
    int local_acc;

    // for(int k = 0; k < num_of_train_images; k++){
    //     local_loss = 0;
    //     local_acc = 0;
    //     int acc = forward(image[k]);
    //     local_loss += loss;
    //     local_acc += acc;
    //     backward(image[k]);
    //     printf("Average Loss: %f , Accuracy: %d", local_loss, local_acc);
    // }

    for (int k = 0; k < 4; k++)
    {

        printf("\n\n");

        local_acc = 0;
        local_loss = 0;
        for (int i = 0; i < num_of_train_images; i++)
        {

            for (int l = 0; l < 30; l++)
            {
                for (int m = 0; m < 30; m++)
                {
                    image[i].image_array[l][m] = image[i].image_array[l][m] / (float)255;
                }
            }

            int acc = forward(image[i]);
            local_loss += loss;
            local_acc += acc;

            for (int x = 0; x < 10; x++)
            {
                dE_dY[x] = 0.0;
            }

            // compute the error vector (cross-entropy)
            dE_dY[image[i].target] = (float)((double)-1.0 / (double)softmax_vectors[image[i].target]);

            // printf("\n\n\t\t\t\t ******************* Softmax Vector *******************\n\n");
            // for(int z = 0; z < 10; z++){
            //     printf(" %10f ", softmax_vectors[z]);
            // }
            // printf("\n\n");

            // printf("\n\n\t\t\t\t ******************* dE_dY *******************\n\n");
            // for(int z = 0; z < 10; z++){
            //     printf(" %10f ", dE_dY[z]);
            // }
            // printf("\n\n");

            // printf("\n\n\t\t\t\t ******************* FILTER *******************\n\n");
            // for(int z = 0; z < 3; z++){
            //     for(int y =-0; y < 3; y++){
            //         printf(" %10f ", filter[z][y]);
            //     }
            //     printf("\n");
            // }

            // printf("\n\n\t\t\t\t ******************* DENSE *******************\n\n");
            // for(int z = 0; z < 49; z++){
            //     for(int y =-0; y < 10; y++){
            //         printf(" %10f ", dense_weights[z][y]);
            //     }
            //     printf("\n");
            // }

            backward(image[i]);
            if (i % 100 == 0)
            {
                printf("Step: %d, Average Loss: %f , Accuracy: %d\n", i, local_loss, local_acc);
                local_acc = 0;
                local_loss = 0;
                sleep(1);
            }
        }
        if (local_loss < 1)
        {
            break;
        }
        printf("\n\n");
    }

    // free memory utilized by the kernel
    for (int i = 0; i < 3; i++)
    {
        free(filter[i]);
    }
    free(filter);

    return 0;
}

// THESE ARE THE FUNCTION THAT ARE USED BY THE CONVOLUTIONAL LAYER:

//     1) filter_init()

//         - This function takes a filter of size 3x3 and initializes it using random numbers ranging from 0-10

//     2) convolution_forward()

//         - This function performs the forward propogation for the convolutional layer, it takes an Image object
//         that contains the pixels for the input image and uses the filter to iterate over the image.

//         - It update the global variable named "conv_output" that will contain the feature map.

//     3) convolution_backward()

//         - This function will perform the back propogation for the convolution layer, it takes image on which it
//         applied the forward propogation function and the learning rate alpha.

//         - It will first retrieve all the patches that were used in the forward propogation, those patches will be
//         multiplied with their respective errors to generate a 3x3 matrix which would then be added for the total
//         error for the weights.

//         - After it has the error for the weights, it will update the weights of the kernel

// function to initialize the filters that are to be used in the convolution layer
void filter_init()
{
    // a 2D array of size 3x3
    filter = (float **)malloc(3 * sizeof(float *));
    for (int i = 0; i < 3; i++)
    {
        filter[i] = (float *)malloc(sizeof(float));
    }

    float stddev = sqrt(2.0 / 1);

    // initialize with random numbers from 0.01 - 0.001
    for (int i = 0; i < 3; i++)
    {
        for (int j = 0; j < 3; j++)
        {
            filter[i][j] = (float)rand() / RAND_MAX * 2.0 * stddev - stddev;
        }
    }
}

// function to perform forward propogation on the input image that is passed as an argument
void convolution_forward(struct Image img)
{
    // Perform convolution with stride 2
    for (int i = 0; i < 28; i += 2)
    {
        for (int j = 0; j < 28; j += 2)
        {
            // find the overall sum of the 3x3 patch
            float sum = 0;
            for (int k = 0; k < 3; k++)
            {
                for (int l = 0; l < 3; l++)
                {
                    sum += img.image_array[i + k][j + l] * filter[k][l];
                }
            }
            // update the output 14x14 matrix with the sum of the designated patch
            conv_output[i / 2][j / 2] = sum; // divide indices by 2 for output image
        }
    }
}

// function to perform backward propogation and update the weights for the kernel
void convolution_backward(struct Image img, float learn_rate)
{

    // retrieve the patches for the input image
    struct Patch patches[14 * 14];
    int m = 0;
    // iterate over the whole image with a stride of 2
    for (int i = 0; i < 28; i += 2)
    {
        for (int j = 0; j < 28; j += 2)
        {
            // update the patches variable to contain the patch matrix
            for (int k = 0; k < 3; k++)
            {
                for (int l = 0; l < 3; l++)
                {
                    patches[m].image_array[k][l] = img.image_array[i + k][j + l];
                }
            }
            m++;
        }
    }

    // find the gradient dL_dW by multiplying the patches with their respecitive gradients and summing together
    for (int i = 0; i < (14 * 14); i++)
    {
        for (int j = 0; j < 3; j++)
        {
            for (int k = 0; k < 3; k++)
            {
                conv_gradients[j][k] += patches[i].image_array[j][k] * maxpool_gradients[j][k];
            }
        }
    }

    // update the weights of the convolution layer
    for (int i = 0; i < 3; i++)
    {
        for (int j = 0; j < 3; j++)
        {
            filter[i][j] = filter[i][j] - (learn_rate * conv_gradients[i][j]);
        }
    }
}

// THESE ARE THE FUNCTIONS THAT ARE USED BY THE MAXPOOLING LAYER:

//     1) maxpool_forward()

//         - This function performs the forward propogation for the maxpooling layer.

//         - It takes the feature map that was generated by the concolutional layer and uses a filter
//           of size 2x2 with a stride of 2 to generate a reduced feature map.

//         - The reduced feature map is stored in the global variable named "maxpool_output"

//     2) maxpool_backward()

//         - This function perform the back propogation for the maxpooling layer.

//         - It creates a 1D vector `grad_copy` of size 49 that represent the values of the gradient sent from dense layer of size 7x7.

//         - It then perform the pooling operation to find the indexes which contained those max values in the 14x14 array. After it finds
//         the index, it inserts the corresponding error value in that specific index forming a 14x14 matrix which is to be sent to the
//         convolution layer for back propogation.

//         - All the other indexes of the 14x14 error matrix will be 0 as they did not take part in the forward propogation.

// function to perform maxpooling forward propogation and generate a reduced feature map
void maxpool_forward()
{
    // Perform max pooling operation
    for (int i = 0; i < 14; i += 2)
    {
        for (int j = 0; j < 14; j += 2)
        {
            // find the max value in the patch
            float maxVal = 0;
            for (int k = i; k < i + 2; k++)
            {
                for (int l = j; l < j + 2; l++)
                {
                    if (conv_output[k][l] > maxVal)
                    {
                        maxVal = conv_output[k][l];
                    }
                }
            }
            // insert the max value at the respective index
            maxpool_output[i / 2][j / 2] = maxVal;
        }
    }
}

// function to perform the maxpooling back propogation and generate a 2D matrix of size 14x14 to contain errors.
void maxpool_backward(float learn_rate)
{

    // generate a copy of the errors from the dense layer(7x7)
    float grad_copy[7 * 7] = {0};
    int x = 0;
    for (int i = 0; i < 7; i++)
    {
        for (int j = 0; j < 7; j++)
        {
            grad_copy[x] = dense_gradients[i][j];
            x++;
        }
    }

    x = 0;
    // Perform max pooling operation
    for (int i = 0; i < 14; i += 2)
    {
        for (int j = 0; j < 14; j += 2)
        {
            // retrieve the indexes of the max-value
            float maxVal = 0;
            int maxI = i;
            int maxJ = j;
            for (int k = i; k < i + 2; k++)
            {
                for (int l = j; l < j + 2; l++)
                {
                    if (conv_output[k][l] > maxVal)
                    {
                        maxVal = conv_output[k][l];
                        maxI = k;
                        maxJ = l;
                    }
                }
            }
            // update the 14x14 gradient matrix with the respective error value
            maxpool_gradients[maxI][maxJ] = grad_copy[x];
            x++;
        }
    }
}

// THESE ARE THE FUNCTIONS THAT ARE USED BY THE FLATTEN LAYER

//     1) flatten_forward()

//         - This function will convert the 2D array `maxpool_output` that contains the
//           reduced feature map into a 1D array and store it in the variable `flatten_output`.

//         - This function is used inside the dense layer and not as a stand-alone function.

void flatten_forward()
{
    int index = 0;
    for (int i = 0; i < 7; i++)
    {
        for (int j = 0; j < 7; j++)
        {
            flatten_output[index] = maxpool_output[i][j];
            index++;
        }
    }
}

// THESE ARE THE FUNCTIONS THAT ARE USED BY THE DENSE LAYER

//     1) dense_weight_init()

//         - This function will initialize the dense layer vector for classification
//           of the input image and apply the softmax activation function to it.

//     2) dense_forward()

//         - This function will implement the forward propogation for the dense layer.

//         - First it will take the reduced feature map and flatten it into a 1D array which can be used
//         for vector multiplication.

//         - After we have flattened the reduced feature map, we will use the equation z = x(t) * w to get
//         the logits which represent the score for a class.

//         - When we have the logits, we will apply the softmax activation function to retrieve the probality
//         vector which we will use to make our prediction.

//     3) dense_backward()

//         - This function will be used to implement the back propogation for the dense layer.

//         - It will use a 1D matrix of size 10 which contains the gradients of the cross-entropy loss. The gradients
//         will be multiplied/dot-product with the softmax derivative vector of size 10 (dY_dZ). This will inturn produce a
//         vector dE_dZ of size 10.

//         - The dE_dZ vector will be used to find the values dE_dw. First it will be converted to a (1x10) matrix and multiplied
//         with the flattend matrix of size (49,1) to generate a 49x10 size matrix dE_dw. Once we have dE_dw, we will update the 49x10
//         weight matrix of the dense layer.

//         - Our next step is to find the error dE_dX which we need to propogate backward, for this we will use the weight matrix dZ_dW
//         of size (49x10) and the dE_dZ of size (10x1) matrix we found above. This will generate a 2D matrix of size (49x1) which we will
//         convert to a shape of 7x7 that will be sent backward to the max-pooling layer.

void dense_weight_init()
{
    // initialize values for the 49x10 sized weight matrix
    float stddev = sqrt(2.0 / (10 + 10));

    for (int i = 0; i < 49; i++)
    {
        for (int j = 0; j < 10; j++)
        {
            dense_weights[i][j] = (float)rand() / RAND_MAX * 2.0 * stddev - stddev;
        }
    }
}

void dense_forward()
{

    // convert the 2D reduced feature map to a 1D feature map
    flatten_forward();

    // create matrix objects that will be used to perform multiplication on the two matrices
    struct Matrix flatten_transpose;
    struct Matrix weights;

    // initialize both of the matrices
    Matrix_Init(&flatten_transpose, 1, 49);
    Matrix_Init(&weights, 49, 10);
    // copy the flattened image and take its transpose to allow multiplication of the two
    for (int i = 0; i < 1; i++)
    {
        for (int j = 0; j < 49; j++)
        {
            flatten_transpose.elements[i][j] = flatten_output[j];
        }
    }

    // perform the dense layer operation y = w{t} * x to retrieve the logits
    for (int i = 0; i < 49; i++)
    {
        for (int j = 0; j < 10; j++)
        {
            weights.elements[i][j] = dense_weights[i][j];
        }
    }

    // display the logits to the user
    struct Matrix logits = multiply_matrices(&flatten_transpose, &weights);

    for (int i = 0; i < 1; i++)
    {
        for (int j = 0; j < 10; j++)
        {
            dense_logits[j] = logits.elements[i][j];
        }
    }

    // now we will apply the softmax activation function
    float deno = 0;
    for (int i = 0; i < 10; i++)
    {
        deno += exp(dense_logits[i]);
    }

    for (int i = 0; i < 10; i++)
    {
        softmax_vectors[i] = exp(dense_logits[i]) / deno;
    }
}

void dense_backward(float learn_rate)
{

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

    for (int i = 0; i < 10; i++)
    {
        transformation_eq[i] = exp(dense_logits[i]);
    }

    for (int i = 0; i < 10; i++)
    {
        S_total += transformation_eq[i];
    }

    for (int i = 0; i < 10; i++)
    {
        if (dE_dY[i] == 0)
        {
            continue;
        }

        for (int j = 0; j < 10; j++)
        {
            dY_dZ[j] = (-1.0 * transformation_eq[i] * transformation_eq[j]) / (S_total * S_total);
        }
        dY_dZ[i] = (transformation_eq[i] * (S_total - transformation_eq[i])) / (S_total * S_total);

        if (isnan(dY_dZ[i]))
        {
            dY_dZ[i] = 0.0;
        }

        // printf("\n\n\t\t\t\t ******************* S_total *******************\n\n");
        // printf(" %10f ", S_total);

        // printf("\n\n\t\t\t\t ******************* dY_dZ *******************\n\n");
        // printf(" %10f ", dY_dZ[i]);

        for (int j = 0; j < 10; j++)
        {
            dE_dZ[j] = dE_dY[j] * dY_dZ[j];
        }

        for (int j = 0; j < 10; j++)
        {
            dE_dZ_Matrix.elements[0][j] = dE_dZ[j];
        }
        for (int j = 0; j < 49; j++)
        {
            dZ_dw_Matrix.elements[j][0] = flatten_output[j];
        }

        struct Matrix dE_dW_Matrix = multiply_matrices(&dZ_dw_Matrix, &dE_dZ_Matrix);

        for (int j = 0; j < 49; j++)
        {
            for (int k = 0; k < 10; k++)
            {
                dense_weights[j][k] = dense_weights[j][k] - (learn_rate * dE_dW_Matrix.elements[j][k]);
            }
        }

        for (int j = 0; j < 10; j++)
        {
            dE_dZ_Matrix_2.elements[j][0] = dE_dZ[j];
        }

        for (int j = 0; j < 49; j++)
        {
            for (int k = 0; k < 10; k++)
            {
                dZ_dX_Matrix.elements[j][k] = dense_weights[j][k];
            }
        }

        dE_dX_Matrix = multiply_matrices(&dZ_dX_Matrix, &dE_dZ_Matrix_2);
    }

    int k = 0;
    for (int i = 0; i < 7; i++)
    {
        for (int j = 0; j < 7; j++)
        {
            dense_gradients[i][j] = dE_dX_Matrix.elements[k][0];
            k++;
        }
    }
}

// function to make a prediction by retrieving the index with the max value of the softmax probability vector
int predict()
{
    int max_index = 0;
    float max_val = softmax_vectors[0];

    for (int i = 1; i < 10; i++)
    {
        if (softmax_vectors[i] > max_val)
        {
            max_val = softmax_vectors[i];
            max_index = i;
        }
    }
    return max_index;
}

int forward(struct Image img)
{

    int target = img.target;

    convolution_forward(img); // get the feature map
    maxpool_forward();        // get the reduced feature map
    dense_forward();          // get the softmax probability vector

    // print the loss onto the console
    loss = -1.0 * log(softmax_vectors[target]);

    int accuracy = 0;

    if (predict() == target)
    {
        accuracy = 1;
    }

    return accuracy;
}

void backward(struct Image img)
{
    dense_backward(alpha);            // update the weights for the dense layer
    maxpool_backward(alpha);          // form a 14x14 matrix for errors
    convolution_backward(img, alpha); // update the kernel weights for the convolution layer
}

void shuffle_images(int length)
{
    for (int i = length - 1; i >= 0; i--)
    {
        int j = rand() % (i + 1);
        struct Image temp = image[i];
        image[i] = image[j];
        image[j] = temp;
    }
}