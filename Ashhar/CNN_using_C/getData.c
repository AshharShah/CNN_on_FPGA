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