#include "matrix.h"
#include "image.h"

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <time.h>
#include <math.h>

float alpha = 0.025;

float loss = 0;

// number should be divisible by 10
#define num_of_train_images 10000

// these are the functions that we will use for matrix related operations
extern void Matrix_Init(struct Matrix *x, int r, int c);
extern void print_matrix(struct Matrix *x, int r, int c);
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

// an array of images which represents our trainging data
struct Image image[num_of_train_images];  

// objects required by the convolutional layer
float **filter; // this is a 2D kernel of size 3x3 which is used to perform convolution operation
float conv_output[26][26] = {0};    // this will contain the feature map of size 14x14 after convolution operation is applied

// objects required by the maxpooling layer
float maxpool_output[13][13] = {0};   // this will represent the reduced feature map after the convolution operation is performed

// objects required by the flatten layer
float flatten_output[13*13] = {0};    // this is a 1D array of size 49 which will hold the reduced feature map in a flattened form

// objects required by the dense layer
float dense_weights[169][10] = {0};  // this represents the weights for the 10 classes of which we are to predict
float bias_vector[10] = {0};
float dense_logits[10] = {0};   // this 1D array will hold the values of the calculation z = w(t) * x
float softmax_vectors[10] = {0};    // the probability vector after we have applied the softmax activation function

int forward(struct Image);
void backward(struct Image);
void shuffle_images(int num_imgs);

int main(){

    // initialize the images for the training dataset
    get_images(num_of_train_images, image);

    // shuffle the images in the dataset
    shuffle_images(num_of_train_images);
    
    // initialize the filter for the convolution layer
    filter_init();
    // initialize the weights for the dense layer
    dense_weight_init();


    // printf("\n\n\t\t\t\t ******************* Initial Image *******************\n\n");
    // for(int i = 0; i < 30; i++){
    //     for(int j =-0; j < 30; j++){
    //         printf(" %6d ", (int)( image[70].image_array[i][j] * 255 * 255));
    //     }
    //     printf("\n\n");
    // }
    // printf("\n\n IMAGE TARGET: %d \n\n", image[70].target);


    // convolution_forward(image[70]);

    // printf("\n\n\t\t\t\t ******************* Convolution Image *******************\n\n");
    // for(int i = 0; i < 26; i++){
    //     for(int j =-0; j < 26; j++){
    //         printf(" %6d ", (int)( conv_output[i][j] * 255 * 255));
    //     }
    //     printf("\n\n");
    // }

    // maxpool_forward();
    // printf("\n\n\t\t\t\t ******************* MaxPool Image *******************\n\n");
    // for(int i = 0; i < 13; i++){
    //     for(int j =-0; j < 13; j++){
    //         printf(" %6d ", (int)( maxpool_output[i][j] * 255 * 255));
    //     }
    //     printf("\n\n");
    // }

    // flatten_forward();
    // printf("\n\n\t\t\t\t ******************* Flatten Image *******************\n\n");
    // for(int i = 0; i < 13 * 13; i++){
    //     printf(" %6d \n", (int)( flatten_output[i] * 255 * 255));
    // }

    // dense_forward();
    // printf("\n\n\t\t\t\t ******************* Softmax Probabilities *******************\n\n");
    // for(int i = 0; i < 10; i++){
    //     printf(" %10f \n", softmax_vectors[i]);
    // }

    // printf("\nPredicted Value: %d\n", predict());

    int total_acc = 0;
    int total_loss = 0;

    for(int k = 0; k < num_of_train_images; k++){

        printf("\n\n\t\t\t\t\t\t\t\t******************* Initial Image *******************\n\n");
        for(int i = 0; i < 30; i++){
            for(int j =-0; j < 30; j++){
                printf(" %4d ", (int)( image[k].image_array[i][j] * 255 * 255));
            }
            printf("\n");
        }

        int acc = forward(image[k]);

        total_acc += acc;
        total_loss += loss;

        printf("\n\t||||||||||||||||| IMAGE TARGET: %d | Prediction: %d | Loss: %f |||||||||||||||||\n\n", image[k].target, predict(), loss);
    }
    printf("\nAverage Accuracy: %f\n", (float)total_acc / (float)num_of_train_images);
    printf("\nAverage Loss: %f\n", (float)total_loss / (float)num_of_train_images);

    // free memory utilized by the kernel
    for(int i = 0; i < 3; i++){
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
    
// function to initialize the filters that are to be used in the convolution layer
void filter_init(){
    // a 2D array of size 3x3
    filter = (float**)malloc(3 * sizeof(float*));
    for(int i = 0; i < 3; i++){
        filter[i] = (float*)malloc(sizeof(float));
    }

    FILE *file;

    file = fopen("convWeights.txt", "r");

    if (file == NULL) {
        printf("Error opening the file.\n");
        exit(1);
    }

    // Read numbers from the file
    for (int i = 0; i < 3; ++i) {
        for (int j = 0; j < 3; ++j) {
            if (fscanf(file, "%f", &filter[i][j]) != 1) {
                printf("Error reading from file.\n");
                fclose(file);
                exit(1);
            }
        }
    }

    printf("\n\n\t\t****************************************** FILTER VALUES ******************************************\n");
    // Read numbers from the file
    for (int i = 0; i < 3; ++i) {
        for (int j = 0; j < 3; ++j) {
            printf("%10f ", filter[i][j]);
        }
        printf("\n");
    }

    // Close the file
    fclose(file);
}

// function to perform forward propogation on the input image that is passed as an argument
void convolution_forward(struct Image img){
    // Perform convolution with stride 1
    for (int i = 0; i < 26; ++i) {
        for (int j = 0; j < 26; ++j) {
            // find the overall sum of the 3x3 patch
            float sum = 0;
            for (int k = 0; k < 3; ++k) {
                for (int l = 0; l < 3; ++l) {
                    sum += img.image_array[i + k][j + l] * filter[k][l];
                }
            }
            // update the output 26x26 matrix with the sum of the designated patch
            conv_output[i][j] = sum; // Update the output feature map
        }
    }
}

// THESE ARE THE FUNCTIONS THAT ARE USED BY THE MAXPOOLING LAYER:

//     1) maxpool_forward()
    
//         - This function performs the forward propogation for the maxpooling layer.
    
//         - It takes the feature map that was generated by the concolutional layer and uses a filter
//           of size 2x2 with a stride of 2 to generate a reduced feature map.
    
//         - The reduced feature map is stored in the global variable named "maxpool_output" 


// function to perform maxpooling forward propogation and generate a reduced feature map
void maxpool_forward(){
    // Perform max pooling operation
    for (int i = 0; i < 26; i += 2) {
        for (int j = 0; j < 26; j += 2) {
            // find the max value in the patch
            float maxVal = 0;
            for (int k = i; k < i + 2; k++) {
                for (int l = j; l < j + 2; l++) {
                    if (conv_output[k][l] > maxVal) {
                        maxVal = conv_output[k][l];
                    }
                }
            }
            // insert the max value at the respective index
            maxpool_output[i / 2][j / 2] = maxVal;
        }
    }
}

// THESE ARE THE FUNCTIONS THAT ARE USED BY THE FLATTEN LAYER

//     1) flatten_forward()

//         - This function will convert the 2D array `maxpool_output` that contains the 
//           reduced feature map into a 1D array and store it in the variable `flatten_output`.

//         - This function is used inside the dense layer and not as a stand-alone function.


void flatten_forward(){
    int index = 0;
    for(int i = 0; i < 13; i++){
        for(int j = 0; j < 13; j++){
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

void dense_weight_init(){
    // initialize values for the 49x10 sized weight matrix
    FILE *file;

    file = fopen("denseWeights.txt", "r");

    if (file == NULL) {
        printf("Error opening the file.\n");
        exit(1);
    }

    // Read numbers from the file
    for (int i = 0; i < 169; ++i) {
        for (int j = 0; j < 10; ++j) {
            if (fscanf(file, "%f", &dense_weights[i][j]) != 1) {
                printf("Error reading from file.\n");
                fclose(file);
                exit(1);
            }
        }
    }

    printf("\n\n\t\t****************************************** DENSE WEIGHTS VALUES ******************************************\n");
    // Read numbers from the file
    for (int i = 0; i < 169; ++i) {
        for (int j = 0; j < 10; ++j) {
            printf("%10f ", dense_weights[i][j]);
        }
        printf("\n");
    }

    // Close the file
    fclose(file);

    file = fopen("denseBias.txt", "r");

    if (file == NULL) {
        printf("Error opening the file.\n");
        exit(1);
    }

    for (int i = 0; i < 10; ++i) {
        if (fscanf(file, "%f", &bias_vector[i]) != 1) {
            printf("Error reading from file.\n");
            fclose(file);
            exit(1);
        }
    }

    printf("\n\n\t\t****************************************** BIAS VECTOR VALUES ******************************************\n");
    // Read numbers from the file
    for (int i = 0; i < 10; ++i) {
        printf("%10f ", bias_vector[i]);
    }
    printf("\n");
}

void dense_forward(){

    // convert the 2D reduced feature map to a 1D feature map
    flatten_forward();

    // create matrix objects that will be used to perform multiplication on the two matrices
    struct Matrix flatten_transpose;
    struct Matrix weights;

    // initialize both of the matrices
    Matrix_Init(&flatten_transpose, 1, 169);
    Matrix_Init(&weights, 169, 10);

    // copy the flattened image and take its transpose to allow multiplication of the two
    for(int i = 0; i < 1; i++){
        for(int j = 0; j < 169; j++){
            flatten_transpose.elements[i][j] = flatten_output[j];
        }
    }

    // perform the dense layer operation y = w{t} * x to retrieve the logits
    for(int i = 0; i < 169; i++){
        for(int j = 0; j < 10; j++){
            weights.elements[i][j] = dense_weights[i][j];
        }
    }
    
    // display the logits to the user
    struct Matrix logits = multiply_matrices(&flatten_transpose, &weights);

    for(int i = 0; i < 1; i++){
        for(int j = 0; j < 10; j++){
            dense_logits[j] = logits.elements[i][j] + bias_vector[j];
        }
    }

    // now we will apply the softmax activation function 
    float deno = 0;
    for(int i = 0; i < 10; i++){
        deno += exp(dense_logits[i]);
    }

    for(int i = 0; i < 10; i++){
        softmax_vectors[i] = exp(dense_logits[i]) / deno;
    }

}

// function to make a prediction by retrieving the index with the max value of the softmax probability vector
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

int forward(struct Image img){

    int target = img.target;

    convolution_forward(img);  // get the feature map
    maxpool_forward();  // get the reduced feature map
    dense_forward();    // get the softmax probability vector

    // print the loss onto the console
    loss = -1.0 * log(softmax_vectors[target]);
    
    int accuracy = 0;

    if(predict() == target){
        accuracy = 1;
    }

    return accuracy;
}

void shuffle_images(int length) {
    srand(time(NULL));
    for (int i = length - 1; i >= 0; i--) {
        int j = rand() % (i + 1);
        struct Image temp = image[i];
        image[i] = image[j];
        image[j] = temp;
    }
}