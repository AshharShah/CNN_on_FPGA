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

void read_images_from_folder(const char* folder_path, int per_class, int target_value, struct Image* image, int* i) {
    DIR *dir;
    struct dirent *entry;

    dir = opendir(folder_path);
    if (dir == NULL) {
        perror("opendir");
        return;
    }

    while ((entry = readdir(dir)) != NULL) {
        if (*i == (per_class * (target_value + 1))) {
            break;
        }

        if (entry->d_type != DT_REG) {
            continue;
        }

        char result[512];
        char *filename = entry->d_name;
        snprintf(result, sizeof(result), "%s%s", folder_path, filename);

        printf("\n%s\n", result);

        uint8_t img[28][28];
        unsigned char* image_data;

        image_data = stbi_load(result, &image[*i].width, &image[*i].height, NULL, 0);

        if (image_data == NULL) {
            printf("\nError Opening The Image!\n");
            exit(-1);
        }

        memcpy(img, image_data, image[*i].width * image[*i].height);

        for (int j = 0; j < 30; j++) {
            for (int k = 0; k < 30; k++) {
                image[*i].image_array[j][k] = 0;
            }
        }

        for (int j = 0; j < 28; j++) {
            for (int k = 0; k < 28; k++) {
                image[*i].image_array[j+1][k+1] = img[j][k] / (float)255;
            }
        }

        image[*i].width += 2;
        image[*i].height += 2;
        image[*i].target = target_value;
        (*i)++;
    }

    closedir(dir);
}

void get_images(int per_num, struct Image* image){
    int per_class = per_num / 10;
    char* folder_paths[] = {
        "/home/ashhar/Desktop/CNN_on_FPGA/Ashhar/CNN_using_C/mnist_png/training/0/",
        "/home/ashhar/Desktop/CNN_on_FPGA/Ashhar/CNN_using_C/mnist_png/training/1/",
        "/home/ashhar/Desktop/CNN_on_FPGA/Ashhar/CNN_using_C/mnist_png/training/2/",
        "/home/ashhar/Desktop/CNN_on_FPGA/Ashhar/CNN_using_C/mnist_png/training/3/",
        "/home/ashhar/Desktop/CNN_on_FPGA/Ashhar/CNN_using_C/mnist_png/training/4/",
        "/home/ashhar/Desktop/CNN_on_FPGA/Ashhar/CNN_using_C/mnist_png/training/5/",
        "/home/ashhar/Desktop/CNN_on_FPGA/Ashhar/CNN_using_C/mnist_png/training/6/",
        "/home/ashhar/Desktop/CNN_on_FPGA/Ashhar/CNN_using_C/mnist_png/training/7/",
        "/home/ashhar/Desktop/CNN_on_FPGA/Ashhar/CNN_using_C/mnist_png/training/8/",
        "/home/ashhar/Desktop/CNN_on_FPGA/Ashhar/CNN_using_C/mnist_png/training/9/"
    };

    int i = 0;
    for (int target = 0; target < 10; target++) {
        read_images_from_folder(folder_paths[target], per_class, target, image, &i);
    }
}