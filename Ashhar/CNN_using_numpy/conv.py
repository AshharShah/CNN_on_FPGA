import numpy as np


class ConvolutionLayer:
    # constructor for the convolutional layer
    def __init__(self, kernel_num, kernel_size):
        self.kernel_num = kernel_num
        self.kernel_size = kernel_size
        # generate random filters
        # divide by (k_size**2) to normalize
        self.kernels = np.random.randn(
            kernel_num, kernel_size, kernel_size) / (kernel_size**2)

    # function to divide a input image to patches
    def patches_generator(self, image):
        # Extract image height and width
        image_h, image_w = image.shape
        self.image = image
        # iterate over the image
        for h in range(image_h-self.kernel_size+1):
            for w in range(image_w-self.kernel_size+1):
                # get the image patch
                patch = image[h:(h+self.kernel_size), w:(w+self.kernel_size)]
                yield patch, h, w

    # function that forward propogates and gets the output for the convolutional layer
    def forward_prop(self, image):
        # Extract image height and width
        image_h, image_w = image.shape
        self.image = image
        # initialize a empty numpy array which returns the output of the convolutional function
        convolution_output = np.zeros(
            (image_h-self.kernel_size+1, image_w-self.kernel_size+1, self.kernel_num))
        # use the generator to get patches and their coordinates
        for patch, h, w in self.patches_generator(image):
            # perform convolution on each individual patch
            convolution_output[h, w] = np.sum(patch*self.kernels, axis=(1, 2))
        return convolution_output

    # function that performs backward propogation and adjusts the weights
    # the value of dE_dY comes from the following/next layers (MaxPool)
    def back_prop(self, dE_dY, alpha):

        # initialize the gradient of the loss function
        dE_dk = np.zeros(self.kernels.shape)
        # iterate over all the patches in the image
        for patch, h, w in self.patches_generator(self.image):
            # for each kernel in the layer
            for f in range(self.kernel_num):
                # get loss value of the against the patch
                dE_dk[f] += patch * dE_dY[h, w, f]
        # update the weights
        self.kernels -= alpha*dE_dk
        # print(dE_dk.shape)
        return dE_dk
