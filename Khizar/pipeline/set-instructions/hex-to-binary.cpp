#include <iostream>
#include <fstream>
#include <string>
using namespace std;

void hextobinary(string &, string &);

int main(int argc, char *argv[])
{

    ifstream in(argv[1]);
    ofstream out(argv[2]);

    string line;
    int i;

    while (getline(in, line))
    {
        string outstring;
        hextobinary(line, outstring);
        cout << line << " --> " << outstring << endl;

        out << outstring[6] << outstring[7] << endl;
        out << outstring[4] << outstring[5] << endl;
        out << outstring[2] << outstring[3] << endl;
        out << outstring[0] << outstring[1] << endl;
    }

    in.close();
    out.close();

    return 0;
}

void hextobinary(string &in, string &out)
{
    for (int i = 0; i < in.size(); ++i)
    {

        switch (in[i])
        {
        case '0':
            out += "0000";
            break;
        case '1':
            out += "0001";
            break;
        case '2':
            out += "0010";
            break;
        case '3':
            out += "0011";
            break;
        case '4':
            out += "0100";
            break;
        case '5':
            out += "0101";
            break;
        case '6':
            out += "0110";
            break;
        case '7':
            out += "0111";
            break;
        case '8':
            out += "1000";
            break;
        case '9':
            out += "1001";
            break;
        case 'A':
        case 'a':
            out += "1010";
            break;
        case 'B':
        case 'b':
            out += "1011";
            break;
        case 'C':
        case 'c':
            out += "1100";
            break;
        case 'D':
        case 'd':
            out += "1101";
            break;
        case 'E':
        case 'e':
            out += "1110";
            break;
        case 'F':
        case 'f':
            out += "1111";
            break;
        default:
            cout << "\nInvalid hexadecimal digit " << in[i];
        }
    }
}
