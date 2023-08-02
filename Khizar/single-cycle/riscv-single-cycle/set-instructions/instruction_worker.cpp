#include <iostream>
#include <fstream>
#include <string>
using namespace std;

int main(int argc, char* argv[]) {
    
    ifstream in(argv[1]);
    ofstream out(argv[2]);

    string line;

    while (getline(in, line)) {
        out << line[6] << line[7] << endl;
        out << line[4] << line[5] << endl;
        out << line[2] << line[3] << endl;
        out << line[0] << line[1] << endl;
    }

    in.close();
    out.close();


    return 0;
}