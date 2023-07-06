#include <stdio.h>
#include <unistd.h>

int func(int n) {

    if (n < 3) {
        return n;
    }

    return func(n-1) + 2*func(n-2) + 3*func(n-3);
}


int main() {

    for(int i=0; i<50; ++i) {
        printf("%d -> %d\n", i, func(i));
    }
    


    return 0;
}

