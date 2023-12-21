#include <stdint.h>
#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>

int main()
{
    int width, height, bpp;

    int fptr;
    fptr = open("./filter.txt", O_RDONLY);

    int nptr;
    nptr = open("./filterhex.txt", O_RDWR | O_CREAT);

    FILE *f;
    f = fdopen(fptr, "r");

    float b;
    char hexr[100];

    for (int i = 0; i < 9; ++i)
    {
        fscanf(f, "%f", &b);
        // printf("%f --> %X\n", b, b);
        sprintf(hexr, "%A\n", b);
        dprintf(nptr, "%s ", hexr);
    }

    return 0;
}