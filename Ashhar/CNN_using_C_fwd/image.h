struct Image{
    // Declare a 2D array to store the image data.
    float image_array[28][28];
    int height;
    int width;
    int target;
};

struct Patch{
    // Declare a 2D array to store the image data.
    float image_array[3][3];
    int height;
    int width;
};