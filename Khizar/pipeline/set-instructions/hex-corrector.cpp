#include <iostream>
#include <fstream>
#include <string>
using namespace std;

int main(int argc, char* argv[]) {
    
    int test_cases = atoi(argv[1]);
    string in_file_name, out_file_name;

    for(int i = 1; i <= test_cases; ++i) {

        in_file_name  = "./set-instructions/test-" + to_string(i) + ".hex";
        out_file_name = "./set-instructions/corrected-test-" + to_string(i) + ".hex";

        ifstream in(in_file_name);
        ofstream out(out_file_name);

        string line;

        while (getline(in, line)) {
            out << line[6] << line[7] << endl;
            out << line[4] << line[5] << endl;
            out << line[2] << line[3] << endl;
            out << line[0] << line[1] << endl;
        }

        in.close();
        out.close();
    }


    return 0;
}