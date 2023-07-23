import numpy as np

# our layer that is used to flatten an given image


class FlattenLayer:
    def forward(image):
        # get shape of image
        height, width, depth = image.shape
        # make an empty list
        flattened_image = [0] * (height*width*depth)

        # append each pixel to our list
        idx = 0
        for d in range(depth):
            for h in range(height):
                for w in range(width):
                    flattened_image[idx] = image[h, w, d]
                    idx += 1
        # convert the flattened list to a numpy array
        flattened_image = np.array(flattened_image)
        # return the numpy array
        return flattened_image
