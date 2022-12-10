#include <iostream>
#include <list>
#include <fstream>
#include <string>
#include <sstream>
#include "ElvesCPU.h"

using namespace std;

void part1(list<string> lines)
{
    ElvesCPU cpu(lines);
    int sum = 0;
    for (int cycle = 1; cycle <= 240; cycle ++)
    {
        if (cycle == 20 || (cycle-20) % 40 == 0){
            sum += cycle * cpu.getX();
        }
        cpu.cycle();
    }
    cout << "Part1: " << sum << endl; 
}

void part2(list<string> lines)
{
    ElvesCPU cpu(lines);
    for (int cycle = 1; cycle <= 240; cycle ++)
    {
        int h_pos = (cycle - 1) % 40;
        if(cycle != 1 && h_pos % 40 == 0)
        {
            cout << endl;
        }
        if (abs(cpu.getX() - h_pos) <= 1)
        {
            cout << "█";
        }
        else
        {
            cout << " ";
        }

        cpu.cycle();
    }

    cout << endl;
}

int main() 
{
    
    list<string> lines;
    
    fstream newfile;
    newfile.open("input.txt", ios::in);
    if (newfile.is_open())
    {
        string tmp;
        while(getline(newfile, tmp))
        {
            lines.push_back(tmp);
        }
        newfile.close();
    }

    part1(lines);
    part2(lines);

    return 0;

}