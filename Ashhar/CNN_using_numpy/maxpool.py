import numpy as np

"""This layer will take the input which is a image from the convolution layer
and it will reduce the size of the feature map"""

# the max pool layer defined in a class


class MaxPoolingLayer:
    # defint the constructor that will take the kernel size as input
    def __init__(self, kernel_size):
        self.kernel_size = kernel_size

    # divide the input image into different patches that will be used to perform pooling
    def patches_generator(self, image):
        # Compute the ouput size
        # define the height of the max pooled image (floor for whole number division)
        output_h = image.shape[0] // self.kernel_size
        # define the width of the max pooled image (floor for whole number division)
        output_w = image.shape[1] // self.kernel_size
        self.image = image
        # iterate over the whole image pixels
        for h in range(output_h):
            for w in range(output_w):
                # retrieve a patch from the image
                patch = image[(h*self.kernel_size):(h*self.kernel_size+self.kernel_size),
                              (w*self.kernel_size):(w*self.kernel_size+self.kernel_size)]
                yield patch, h, w

    # function to perform forward propogation on the image
    def forward_prop(self, image):
        # get the dimensions of the image
        image_h, image_w, num_kernels = image.shape
        # initialize a empty array for the max pooled image
        max_pooling_output = np.zeros(
            (image_h//self.kernel_size, image_w//self.kernel_size, num_kernels))
        for patch, h, w in self.patches_generator(image):
            max_pooling_output[h, w] = np.amax(patch, axis=(0, 1))
        return max_pooling_output

    def back_prop(self, dE_dY):

        return 0
