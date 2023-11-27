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
void get_images(int per_num, struct Image *image)
{

    int per_class = per_num / 10;

    char *folder_path_0 = "/home/ashhar/Desktop/CNN_on_FPGA/Ashhar/CNN_using_C/mnist_png/training/0/";
    char *folder_path_1 = "/home/ashhar/Desktop/CNN_on_FPGA/Ashhar/CNN_using_C/mnist_png/training/1/";
    char *folder_path_2 = "/home/ashhar/Desktop/CNN_on_FPGA/Ashhar/CNN_using_C/mnist_png/training/2/";
    char *folder_path_3 = "/home/ashhar/Desktop/CNN_on_FPGA/Ashhar/CNN_using_C/mnist_png/training/3/";
    char *folder_path_4 = "/home/ashhar/Desktop/CNN_on_FPGA/Ashhar/CNN_using_C/mnist_png/training/4/";
    char *folder_path_5 = "/home/ashhar/Desktop/CNN_on_FPGA/Ashhar/CNN_using_C/mnist_png/training/5/";
    char *folder_path_6 = "/home/ashhar/Desktop/CNN_on_FPGA/Ashhar/CNN_using_C/mnist_png/training/6/";
    char *folder_path_7 = "/home/ashhar/Desktop/CNN_on_FPGA/Ashhar/CNN_using_C/mnist_png/training/7/";
    char *folder_path_8 = "/home/ashhar/Desktop/CNN_on_FPGA/Ashhar/CNN_using_C/mnist_png/training/8/";
    char *folder_path_9 = "/home/ashhar/Desktop/CNN_on_FPGA/Ashhar/CNN_using_C/mnist_png/training/9/";

    DIR *dir;
    struct dirent *entry;

    for (int dir_id = 0; dir_id < 10; ++dir_id)
    {

        char c[2];
        char *folder_path;
        sprintf(folder_path, "%s%d", "./CNN_using_C/mnist_png/training/", dir_id);

        // check if the directory can be opened
        dir = opendir(folder_path);
        if (dir == NULL)
        {
            perror("opendir");
            return;
        }

        int i = 0;
        while ((entry = readdir(dir)) != NULL)
        {
            // only get 100 images of the digit 0
            if (i == (per_class * (dir_id + 1)))
            {
                break;
            }
            // check if the datatype is a regular file
            if (entry->d_type != DT_REG)
            {
                // This is a regular file.
                continue;
            }

            // get the full name/address of the file
            char result[512];
            char *filename = entry->d_name;
            snprintf(result, sizeof(result), "%s%s", folder_path, filename);
            printf("%s\n", result);

            uint8_t img[28][28];
            unsigned char *image_data;
            // Load the image data into the array.
            image_data = stbi_load(result, &image[i].width, &image[i].height, NULL, 0);

            // check if the image can be opened
            if (image_data == NULL)
            {
                printf("\nError Opening The Image!\n");
                // Handle error.
                exit(-1);
            }

            memcpy(img, image_data, image[i].width * image[i].height);

            // Pad the image with zeros
            for (int j = 0; j < 30; j++)
            {
                for (int k = 0; k < 30; k++)
                {
                    image[i].image_array[j][k] = 0;
                }
            }

            // add the image to the image object
            for (int j = 0; j < 28; j++)
            {
                for (int k = 0; k < 28; k++)
                {
                    image[i].image_array[j + 1][k + 1] = img[j][k] / (float)255;
                }
            }

            image[i].width += 2;
            image[i].height += 2;
            image[i].target = 0;
            i++;
        }

        closedir(dir);
    }
}