#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>
#include <png.h>
#include "image.h"


// function to read a single image
struct Image *read_image(char *filename) {
    // allocate memory for the image 
    struct Image *image = malloc(sizeof(struct Image));
    if (image == NULL) {
        printf("Could Not Allocate Memory for Image!\n");
        return NULL;
    }   

    // Open the image file.
    FILE *fp = fopen(filename, "rb");
    if (fp == NULL) {
        printf("Could Not Allocate Memory For File Pointer!\n");
        free(image);
        return NULL;
    }

    // Read the image header.
    png_structp png_ptr = png_create_read_struct(PNG_LIBPNG_VER_STRING, NULL, NULL, NULL);
    if (png_ptr == NULL) {
        fclose(fp);
        free(image);
        return NULL;
    }

    png_infop info_ptr = png_create_info_struct(png_ptr);
    if (info_ptr == NULL) {
        png_destroy_read_struct(&png_ptr, NULL, NULL);
        fclose(fp);
        free(image);
        return NULL;
    }

    png_init_io(png_ptr, fp);
    png_read_info(png_ptr, info_ptr);

    // Get the image dimensions.
    image->width = png_get_image_width(png_ptr, info_ptr);
    image->height = png_get_image_height(png_ptr, info_ptr);
    image->channels = png_get_channels(png_ptr, info_ptr);

    // Allocate memory for the image data.
    image->data = malloc(image->width * image->height * image->channels);
    if (image->data == NULL) {
      png_destroy_read_struct(&png_ptr, &info_ptr, NULL);
      fclose(fp);
      free(image);
      return NULL;
    }

    // Read the image data.
    png_read_image(png_ptr, (png_bytepp)image->data);

    // Close the image file.
    fclose(fp);

    // Destroy the PNG structures.
    png_destroy_read_struct(&png_ptr, &info_ptr, NULL);

    return image;
}

struct Image ***read_folder_of_images(char *folder_path){

    // Get the list of image files in the folder.
    DIR *dir = opendir(folder_path);
    if (dir == NULL) {
      return NULL;
    }

    // Count the number of image files in the folder.
    int num_images = 0;
    struct dirent *entry;
    while ((entry = readdir(dir)) != NULL) {
      if (strstr(entry->d_name, ".png") != NULL || strstr(entry->d_name, ".jpg") != NULL) {
        num_images++;
      }
    }  

    // Allocate memory for the 3D array of images.
    struct Image ***images = malloc(sizeof(struct Image **) * num_images);
    for (int i = 0; i < num_images; i++) {
      images[i] = malloc(sizeof(struct Image *) * 3);
    }   

    // Read each image file and store the image data in the 3D array.
    int image_index = 0;
    rewinddir(dir);

    while ((entry = readdir(dir)) != NULL) {
        if (strstr(entry->d_name, ".png") != NULL || strstr(entry->d_name, ".jpg") != NULL) {
            // Get the full path to the image file.
            char image_file_path[1024];
            sprintf(image_file_path, "%s/%s", folder_path, entry->d_name);

            // Read the image file.
            struct Image *image = read_image(image_file_path);

            // Store the image data in the 3D array.
            images[image_index][0] = image;

            // Use a union to cast the integer value to a pointer to a struct Image structure.
            union {
                int width;
                int height;
                struct Image *image;
            } image_union;

            image_union.width = image->width;
            images[image_index][1] = image_union.image;

            image_union.height = image->height;
            images[image_index][2] = image_union.image;

            image_index++;
        }   
    }

    // Close the directory.
    closedir(dir);  
    return images;
}

int main(){
    char folder_path[] = "/home/ashhar/Desktop/CNN_on_FPGA/Ashhar/CNN_using_C/mnist_png/training/0";
    struct Image ***images = read_folder_of_images(folder_path);
}
