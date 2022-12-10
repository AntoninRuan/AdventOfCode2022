#include "ElvesCPU.h"
#include <iostream>
#include <sstream>

list<string> split (string s, char del = ' ') {
    stringstream ss(s);
    string world;
    list<string> result;
    while (!ss.eof()) {
        getline(ss, world, del);
        result.push_back(world);
    }
    return result;
}

ElvesCPU::ElvesCPU(list<string> start_instructions)
{
    buffered_instructions = start_instructions;
    x = 1;
    adding.active = false;
    adding.value = 0;
}

void ElvesCPU::cycle()
{
    if (buffered_instructions.empty())
    {
        return;
    }

    if (adding.active) {
        x += adding.value;
        adding.active = false;
        return;
    }

    string instr = buffered_instructions.front(); buffered_instructions.pop_front();
    list<string> parsed = split(instr);
    string op = parsed.front(); parsed.pop_front();
    if (op == "noop"){
        return;
    }
    int value = stoi(parsed.back()); parsed.pop_back();
    adding.active = true;
    adding.value = value;
}


int ElvesCPU::getX()
{
    return x;
}