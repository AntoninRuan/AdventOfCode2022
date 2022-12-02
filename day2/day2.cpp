#include <iostream>
#include <fstream>
#include <string>
#include <list>
#include <bits/stdc++.h>

using namespace std;

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

// A, X = ROCK; B, Y = PAPER; C, Z = SCISSORS
int calcScore(string opp, string pl) {
    int score = 0;
    if (pl == "X") {
        score += 1;

        if (opp == "A") {
            score += 3;
        } else if (opp == "B") {
            score += 0;
        } else if (opp == "C") {
            score += 6;
        }
    } else if (pl == "Y") {
        score += 2;

        if (opp == "A") {
            score += 6;
        } else if (opp == "B") {
            score += 3;
        } else if (opp == "C") {
            score += 0;
        }
    } else if (pl == "Z") {
        score += 3;

        if (opp == "A") {
            score += 0;
        } else if (opp == "B") {
            score += 6;
        } else if (opp == "C") {
            score += 3;
        }
    }
    return score;
}

void part1(list<string> input) {
    int score = 0;
    for (string line : input) {
        list<string> parsed = split(line);
        string opp = parsed.front(); parsed.pop_front();
        string pl = parsed.front(); parsed.pop_front();
        score += calcScore(opp, pl);
    }
    cout << "Final Score (Part 1): " << score << endl;
}

// A, X = ROCK; B, Y = PAPER; C, Z = SCISSORS
int choosePlay(string opp, string pl) {
    if (opp == "A") {
        if (pl == "X") {
            return calcScore(opp, "Z");
        } else if (pl == "Y") {
            return calcScore(opp, "X");
        } else if (pl == "Z") {
            return calcScore(opp, "Y");
        }
    } else if (opp == "B") {
        if (pl == "X") {
            return calcScore(opp, "X");
        } else if (pl == "Y") {
            return calcScore(opp, "Y");
        } else if (pl == "Z") {
            return calcScore(opp, "Z");
        }
    } else if (opp == "C") {
        if (pl == "X") {
            return calcScore(opp, "Y");
        } else if (pl == "Y") {
            return calcScore(opp, "Z");
        } else if (pl == "Z") {
            return calcScore(opp, "X");
        }
    }
    return -1;
}

void part2(list<string> input) {
    int score = 0;
    for (string line: input) {
        list<string> parsed = split(line);
        string opp = parsed.front(); parsed.pop_front();
        string pl = parsed.front(); parsed.pop_front();
        score += choosePlay(opp, pl);
    }
    cout << "Final Score (Part 2): " << score << endl;
}

int main() {

    list<string> input;

    fstream newfile;
    newfile.open("input.txt", ios::in);
    if (newfile.is_open()) {
        string tmp;
        while(getline(newfile, tmp)) {
            input.push_back(tmp);
        }
        newfile.close();
    }

    part1(input);
    part2(input);
}