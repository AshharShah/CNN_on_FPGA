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

    # function to perform backpropogation on the max pooling layer
    def back_prop(self, dE_dY):
        """
        In the max pooling class there are no trainable parameters so we have to perform the inverse
        of the max pooling operation, that is we take the error from the subsequent layer and reshape
        it so that it equals the shape before the max pooling operation.

        The values where the maximum number was found will remain unchanged, all the rest of the values
        will become zero
        """

        # create an empty array of the same size as the input to the max pooling layer
        dE_dK = np.zeros(self.image.shape)

        for patch, h, w in self.patches_generator(self.image):
            img_h, img_w, num_kernels = patch.shape
            # get the maximum value in each patch obtained
            max_val = np.amax(patch, axis=(0, 1))

            # iterate over all the values obtained in the patch
            for idx_h in range(img_h):
                for idx_w in range(img_w):
                    for idx_k in range(num_kernels):
                        # if we found the value where the maximum value is present
                        if (patch[idx_h, idx_w, idx_k] == max_val[idx_k]):
                            # add the max value to our backpropogation error
                            dE_dK[h*self.kernel_size+idx_h, w *
                                  self.kernel_size+idx_w, idx_k] = dE_dY[h, w, idx_k]

        # print(dE_dK.shape)
        return dE_dK
