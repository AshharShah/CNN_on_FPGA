#include <stdio.h>
#include <unistd.h>

int func(int n) {

    if (n < 3) {
        return n;
    }

    return func(n-1) + 2*func(n-2) + 3*func(n-3);
}


int main() {

    
    printf("%d\n", func(15));


    return 0;
}

