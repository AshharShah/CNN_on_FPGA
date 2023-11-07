# Ashhar's Progress!

## Implemented CNN using Tensorflow

Coded a Cat and Dog CNN classifier. 

## Working On CNN in Python using Numpy

    1) Added Convolutional Layer.

    2) Added Maxpooling (Forward Prop Only).

    3) Tested Forward Prop for Maxpool and Conv.

    4) Added Sigmoid Activation Function.

    5) Adeed Flatten Layer (For Expansion to ANN).

    6) Tested Sigmoid + Flatten.

    7) Completed all forward propogation steps.

    8) Visualized the forward propogation steps in jupyter notebook (main.ipynb).

    9) Added Softmax layer for the final output (inclusive Dense layer).

    10) Tested the Softmax layer forward propogation.

    11) Displayed the output of the first pass of the neural network.

    12) Computed the loss.

    13) Computed the back prpogation for the Sigmoid / Dense Layer.

    14) Computed the back propogation for the MaxPooling Layer.

    15) Computed the back propogation for the Convolution Layer.
    
    16) Performed CNN training and testing **(Accuracy of 90%)**.

## Working On CNN in C from scratch

    1) Created a file `matrix.c` and `matrix.h` that contain the functions and the structure for the matrix multiplication and addition steps.

    2) Created a file `image.c` and `image.h` that contain the function to retrieve and Image and the structure that defines our Images.

    3) Created functions called `filiter_init()` and `convolution_forward()` that initialize the **kernel of size 3x3** and use it with a **stride of 2** to perform forward propogation for the convolution layer which in turn initializes a 2D matrix `conv_output` that contains the feature map.

    4) Created function `maxpool_forward` that performs the forward propogation for
    our maxpooling layer and updates the variable `maxpool_output`, which is essentially
    a 2D array to contain the reduced feature map.
