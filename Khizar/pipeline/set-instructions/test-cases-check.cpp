#include <iostream>
#include <fstream>
#include <string>
using namespace std;

int main(int argc, char *argv[])
{
    string file = argv[1];

    ifstream in(file);

    string line;

    getline(in, line);

    if (line.length() == 0)
    {
        cout << "Test Case " << file[-1] << ": PASSED" << endl;
    }
    else
    {
        cout << "Test Case " << file[-1] << ": ------FAIL------" << endl;
    }

    in.close();

    return 0;
}