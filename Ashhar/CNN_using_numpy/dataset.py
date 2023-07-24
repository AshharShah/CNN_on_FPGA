import tensorflow as tf


class mnist:
    def getData():
        # Load MNIST dataset
        mnist = tf.keras.datasets.mnist

        # Split the dataset into training and testing sets
        (train_images, train_labels), (test_images, test_labels) = mnist.load_data()

        # Normalize the pixel values to be between 0 and 1
        train_images, test_images = train_images / 255.0, test_images / 255.0

        return (train_images, train_labels), (test_images, test_labels)
