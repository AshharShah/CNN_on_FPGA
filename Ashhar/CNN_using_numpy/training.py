# this file contains the functions that are used to train the CNN

import numpy as np
from conv import ConvolutionLayer
from maxpool import MaxPoolingLayer
from activations import Softmax

# function to perform forward propogation


def forward(image, y, layers):
    # normalize the input image
    output = image/255
    #output = image
    # perform forward propogation on all the layers in the CNN architecture
    for layer in layers:
        output = layer.forward_prop(output)

    # calculate hte loss and accuracy
    loss = -np.log(output[y])
    accuracy = 0
    if (np.argmax(output) == y):
        accuracy = 1

    return output, loss, accuracy


# function to perform backward propogation
def backward(gradient, layers, alpha=0.05):
    grad_back = gradient
    # iterate over the layers in a reverse order
    for layer in layers[::-1]:
        # if the layer is conv or softmax we send alpha
        if (type(layer) in [ConvolutionLayer, Softmax]):
            grad_back = layer.back_prop(grad_back, alpha)
        # if the layer is max pool we send the error only
        elif (type(layer) == MaxPoolingLayer):
            grad_back = layer.back_prop(grad_back)

    return grad_back


# function that will use the forward and backward function to trian the network
def CNN_train(image, y, layers, alpha=0.05):
    # perform forward propogation
    output, loss, accuracy = forward(image, y, layers)

    # calculate the error against the output
    gradient = np.zeros(10)
    gradient[y] = -1/output[y]

    # perform backpropogation on the network
    gradient_back = backward(gradient, layers, alpha)

    return loss, accuracy


# function to test our CNN against the test images and get its accuracy and loss
def CNN_test(image, y, layers):
    output, loss, accuracy = forward(image, y, layers)

    # calculate the error against the output
    gradient = np.zeros(10)
    gradient[y] = -1/output[y]

    return loss, accuracy

def CNN_predict(image, layers):
    # normalize the input image
    output = image/255
    #output = image
    # perform forward propogation on all the layers in the CNN architecture
    for layer in layers:
        output = layer.forward_prop(output)
        
    prediction = np.argmax(output)
    return prediction