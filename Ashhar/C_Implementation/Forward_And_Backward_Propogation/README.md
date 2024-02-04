## CNN In C From Scratch (With Training)

The code here implements a CNN in C on the **Mnist Dataset**, this is essentially a bare-bone CNN architecture that **over-fits a single image** to train the weights for only one specific image.

## The Image.c and Image.h Files

The `Image.c` file is a part of the CNN In C project, focusing on Convolutional Neural Networks (CNNs). This file contains functions for reading images from a specified folder, processing them, and organizing the data into a structure called `Image`.

The `Image.h` file contains the datastructure that we will be using to store the images and its details such as the height and width and the target value of the image. 

### Functionality

#### `read_images_from_folder`

This function reads images from a given folder path, considering a specified number of images per class and a target value. It utilizes the STB image library to load image data and processes it to be suitable for further use. The processed image data is stored in the `Image` structure.

- **Parameters:**
  - `folder_path`: The path to the folder containing the images.
  - `per_class`: Number of images per class.
  - `target_value`: The target value (class) for the images being read.
  - `image`: An array of `struct Image` where the image data will be stored.
  - `i`: A pointer to the index for the `image` array.

#### `get_images`

This function orchestrates the process of getting images from different folders for each class. It specifies the paths for each class's folder and then calls the `read_images_from_folder` function for each class to read and process the images.

- **Parameters:**
  - `per_num`: Total number of images.
  - `image`: An array of `struct Image` where the image data will be stored.

## The Matrix.c and Matrix.h file

The `matrix.c` file is a part of the CNN In C project, focusing on Convolutional Neural Networks (CNNs). This file contains functions for initializing matrices, performing operations like addition and multiplication on matrices, and freeing allocated memory.

### Functions

#### `Matrix_Init`

This function initializes a matrix with the specified number of rows and columns. It allocates memory for the matrix elements.

- **Parameters:**
  - `x`: Pointer to the matrix structure.
  - `r`: Number of rows in the matrix.
  - `c`: Number of columns in the matrix.

#### `Num_Zeros`

This function sets all elements of a matrix to zero.

- **Parameters:**
  - `x`: Pointer to the matrix structure.
  - `r`: Number of rows in the matrix.
  - `c`: Number of columns in the matrix.

#### `print_matrix`

This function prints the elements of a matrix.

- **Parameters:**
  - `x`: Pointer to the matrix structure.
  - `r`: Number of rows in the matrix.
  - `c`: Number of columns in the matrix.

#### `free_matrix`

This function frees the memory allocated for a matrix.

- **Parameters:**
  - `x`: Pointer to the matrix structure.

#### `add_matrices`

This function adds two matrices element-wise and returns the result.

- **Parameters:**
  - `matrix1`: Pointer to the first matrix structure.
  - `matrix2`: Pointer to the second matrix structure.

- **Returns:**
  - `result`: A new matrix containing the sum of `matrix1` and `matrix2`.

#### `multiply_matrices`

This function multiplies two matrices and returns the result.

- **Parameters:**
  - `matrix1`: Pointer to the first matrix structure.
  - `matrix2`: Pointer to the second matrix structure.

- **Returns:**
  - `result`: A new matrix containing the product of `matrix1` and `matrix2`.

## The Main.c file

### Functions for Image Processing
    1) shuffle_images()
        - This function is used to shuffle the images in the image array because we have read images in a sequential format. This can be used to help facilitate the training of the neural network.

### Functions for The Convolution Layer

    1) filter_init()
    
        - This function takes a filter of size 3x3 and initializes it using random numbers ranging from 0-10
    
    2) convolution_forward()
    
        - This function performs the forward propogation for the convolutional layer, it takes an Image object
        that contains the pixels for the input image and uses the filter to iterate over the image.

        - It update the global variable named "conv_output" that will contain the feature map.
    
    3) convolution_backward()

        - This function will perform the back propogation for the convolution layer, it takes image on which it 
        applied the forward propogation function and the learning rate alpha.

        - It will first retrieve all the patches that were used in the forward propogation, those patches will be 
        multiplied with their respective errors to generate a 3x3 matrix which would then be added for the total 
        error for the weights.

        - After it has the error for the weights, it will update the weights of the kernel

### Functions for the Max-Pooling Layer

    1) maxpool_forward()
    
        - This function performs the forward propogation for the maxpooling layer.
    
        - It takes the feature map that was generated by the concolutional layer and uses a filter
          of size 2x2 with a stride of 2 to generate a reduced feature map.
    
        - The reduced feature map is stored in the global variable named "maxpool_output" 
    
    2) maxpool_backward()

        - This function perform the back propogation for the maxpooling layer.

        - It creates a 1D vector `grad_copy` of size 49 that represent the values of the gradient sent from dense layer of size 7x7.

        - It then perform the pooling operation to find the indexes which contained those max values in the 14x14 array. After it finds
        the index, it inserts the corresponding error value in that specific index forming a 14x14 matrix which is to be sent to the 
        convolution layer for back propogation. 

        - All the other indexes of the 14x14 error matrix will be 0 as they did not take part in the forward propogation.

### Functions for the Dense Layer
  
      1) dense_weight_init()
  
          - This function will initialize the dense layer vector for classification
            of the input image and apply the softmax activation function to it.
  
      2) dense_forward()
  
          - This function will implement the forward propogation for the dense layer.
          
          - First it will take the reduced feature map and flatten it into a 1D array which can be used 
          for vector multiplication.
  
          - After we have flattened the reduced feature map, we will use the equation z = x(t) * w to get
          the logits which represent the score for a class.
  
          - When we have the logits, we will apply the softmax activation function to retrieve the probality
          vector which we will use to make our prediction.
  
      3) dense_backward()
  
          - This function will be used to implement the back propogation for the dense layer.
  
          - It will use a 1D matrix of size 10 which contains the gradients of the cross-entropy loss. The gradients 
          will be multiplied/dot-product with the softmax derivative vector of size 10 (dY_dZ). This will inturn produce a
          vector dE_dZ of size 10.
  
          - The dE_dZ vector will be used to find the values dE_dw. First it will be converted to a (1x10) matrix and multiplied
          with the flattend matrix of size (49,1) to generate a 49x10 size matrix dE_dw. Once we have dE_dw, we will update the 49x10 
          weight matrix of the dense layer. 
  
          - Our next step is to find the error dE_dX which we need to propogate backward, for this we will use the weight matrix dZ_dW
          of size (49x10) and the dE_dZ of size (10x1) matrix we found above. This will generate a 2D matrix of size (49x1) which we will
          convert to a shape of 7x7 that will be sent backward to the max-pooling layer.

