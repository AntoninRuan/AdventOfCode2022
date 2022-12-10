#ifndef ElvesCPU_h
#define ElvesCPU_h

#include <list>
#include <string>

using namespace std;

class ElvesCPU
{

    private:
        int x;
        list<string> buffered_instructions;
        struct {
            bool active;
            int value;
        } adding;

    public:
        ElvesCPU(list<string> start_instructions);
        int getX();
        void cycle();
        void addInstruction(string instr);

};

#endif