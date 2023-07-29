import numpy as np
from flatten import FlattenLayer

# class for sigmoid operation


class Sigmoid:
    def sigmoid(x):
        # (1 / 1 + e^(-x))
        return 1 / (1 + np.exp(-x))


# class for softmax activation function (this layer also acts as a dense layer for the CNN model)


class Softmax:
    def __init__(self, input_shape, output_shape):
        # Initiallize weights and biases
        self.weight = np.random.randn(input_shape, output_shape)/input_shape
        self.bias = np.zeros(output_shape)

    def forward(self, image):
        # store the orignal shape of the image for back propogation
        self.original_shape = image.shape
        # flatten the image for the ANN dense layer
        flattened_image = FlattenLayer.forward(image)
        # store the flattened image for back propogation
        self.flattened_image = flattened_image
        # perform the ANN dense layer forward propogation
        dense_output = np.dot(flattened_image, self.weight) + self.bias
        # save the output
        self.output = dense_output
        # apply softmax activation function
        softmax = np.exp(dense_output) / np.sum(np.exp(dense_output), axis=0)
        return softmax

    def backward():
        return
