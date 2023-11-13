#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include "image.h"
#include <dirent.h>
#include <string.h>


#define STB_IMAGE_IMPLEMENTATION
#include "stb/stb_image.h"
#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "stb/stb_image_write.h"

// function to populate the "images" object of our Image structure (will generalize later on)
void get_images(int per_num, struct Image* image){

    char* folder_path = "/home/ashhar/Desktop/CNN_on_FPGA/Ashhar/CNN_using_C/mnist_png/training/0/";

    DIR *dir;
    struct dirent *entry;

    // check if the directory can be opened
    dir = opendir(folder_path);
    if (dir == NULL) {
        perror("opendir");
        return;
    }


    while ((entry = readdir(dir)) != NULL) {
        char result[512];

        snprintf(result, sizeof(result), "%s%s", folder_path, entry->d_name);
        //char *result = strcat(folder_path, entry->d_name);

        printf("%s\n", result);

        //printf("%s\n",  strcat(folder_path, entry->d_name));
    }

    closedir(dir);

    uint8_t img[28][28];
    unsigned char* image_data;
    
    // Load the image data into the array.
    image_data = stbi_load("/home/ashhar/Desktop/CNN_on_FPGA/Ashhar/CNN_using_C/mnist_png/training/0/6034.png", &image[0].width, &image[0].height, NULL, 0);

    if (image_data == NULL) {
        printf("\nError Opening The Image!\n");
        // Handle error.
        exit(-1);
    }

    memcpy(img, image_data, image[0].width * image[0].height);

    // Pad the image with zeros
    for (int i = 0; i < 28; i++) {
        for (int j = 0; j < 28; j++) {
            image[0].image_array[i][j] = 0;
        }
    }

    // Pad the image with zeros
    for (int i = 0; i < 28; i++) {
        for (int j = 0; j < 28; j++) {
            image[0].image_array[i+1][j+1] = img[i][j] / (float) 255;
        }
    }

    image[0].width += 2;
    image[0].height += 2;

    // Load the image data into the array.
    image_data = stbi_load("/home/ashhar/Desktop/CNN_on_FPGA/Ashhar/CNN_using_C/mnist_png/training/3/59957.png", &image[1].width, &image[1].height, NULL, 0);

    if (image_data == NULL) {
        printf("\nError Opening The Image!\n");
        // Handle error.
        exit(-1);
    }

    memcpy(img, image_data, image[1].width * image[1].height);

    // Pad the image with zeros
    for (int i = 0; i < 28; i++) {
        for (int j = 0; j < 28; j++) {
            image[1].image_array[i][j] = 0;
        }
    }

    // Pad the image with zeros
    for (int i = 0; i < 28; i++) {
        for (int j = 0; j < 28; j++) {
            image[1].image_array[i+1][j+1] = img[i][j] / (float)255;
        }
    }
    image[1].width += 2;
    image[1].height += 2;
}