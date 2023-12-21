#include <stdint.h>

#define STB_IMAGE_IMPLEMENTATION
#include "stb/stb_image.h"

#define SIZE UINT_MAX

const char *byte_to_binary(uint8_t x)
{
    static char b[33];
    b[0] = '\0';

    unsigned long int z;
    for (z = 255; z > 0; z >>= 1)
    {
        strcat(b, ((x & z) == z) ? "1" : "0");
    }

    return b;
}

int main()
{
    int width, height, bpp;

    uint8_t *rgb_image = stbi_load("image2.png", &width, &height, &bpp, 0);
    FILE *fptr;
    fptr = fopen("image1file.bin", "wb");

    printf("h = %d\nw = %d\nn = %d\n", height, width, bpp);

    for (int i = 0; i < height; ++i)
    {
        for (int j = 0; j < width; ++j)
        {
            // fprintf(fptr, "%he\n", rgb_image[i * width + j]);
            // printf(" %3d ", rgb_image[i * width + j]);
            // printf("%s\n", byte_to_binary(rgb_image[i * width + j]));
            // if (!(rgb_image[i * width + j] == 0))
            uint8_t im = (float)rgb_image[i * width + j];
            fprintf(fptr, "%s\n", byte_to_binary(im));
            printf(" %3.1f ", (float)rgb_image[i * width + j] / 255);
            // else
            //     printf("     ");
        }
        printf("\n");
        // fprintf(fptr, "\n");
    }

    stbi_image_free(rgb_image);

    return 0;
}