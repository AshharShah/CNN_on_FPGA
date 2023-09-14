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

    def backward(self, dE_dY, alpha):

        for i, gradient in enumerate(dE_dY):

            if gradient == 0:
                continue
            # convert raw scores or logits into probability-like values that can be interpreted as class probabilities
            transformation_eq = np.exp(self.output)
            # the normalization constant S_total is used to normalize the transformed values in transformation_eq such that they sum up to 1
            S_total = np.sum(transformation_eq)

            # when i is not equal to l
            dY_dZ = -transformation_eq[i]*transformation_eq / (S_total**2)
            dY_dZ[i] = transformation_eq[i] * \
                (S_total - transformation_eq[i]) / \
                (S_total**2)    # when i is equal to l

            # gradient of output Z with respect to the weight and input
            dZ_dw = self.flattened_image
            dZ_dX = self.weight

            # gradient of the loss with respect to the output
            dE_dZ = gradient * dY_dZ

            # print(dZ_dw[np.newaxis].T.shape)
            # print(dE_dZ[np.newaxis].shape)

            # print(dE_dZ[np.newaxis])

            # calculate the gradient of the loss with respect to the weight
            dE_dw = dZ_dw[np.newaxis].T @ dE_dZ[np.newaxis]

            # print(dE_dw.shape)

            # calculate the gradient of the loss with respect to the bias
            dE_db = dE_dZ

            # update the wight and the bias
            self.weight = self.weight - alpha*dE_dw
            self.bias = self.bias - alpha*dE_db

            # calculate the gradient of the loss with respect to the input
            dE_dX = dZ_dX @ dE_dZ

            # reshape back to the original (13x13x1) image before the flatten operation
            print(dE_dX.reshape(self.original_shape).shape)

        return dE_dX.reshape(self.original_shape)
