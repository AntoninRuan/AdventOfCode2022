from typing import List
import numpy as np

def sign(x: int) -> int:
    if x > 0:
        return 1
    
    if x < 0:
        return -1

    return 0

class Rope():

    def __init__(self, ) -> None:
        self.head_x, self.head_y = 0, 0
        self.tail_x, self.tail_y = 0, 0
        self.visited = [(0, 0)]
        self.attached = None

    def left(self):
        self.head_x -= 1
        self.update_tail()

    def right(self):
        self.head_x += 1
        self.update_tail()

    def up(self):
        self.head_y += 1
        self.update_tail()

    def down(self):
        self.head_y -= 1
        self.update_tail()
        

    def update_tail(self):
        if not self.__is_tail_correct():
            d_x, d_y = self.head_x - self.tail_x, self.head_y - self.tail_y
            if abs(d_x) == 2:
                d_x -= sign(d_x) * 1
            if abs(d_y) == 2:
                d_y -= sign(d_y) * 1
            self.tail_x += d_x
            self.tail_y += d_y
            if self.attached is not None:
                self.attached.head_x += d_x
                self.attached.head_y += d_y
                self.attached.update_tail()
            if (self.tail_x, self.tail_y) not in self.visited:
                self.visited.append((self.tail_x, self.tail_y))

    def __is_tail_correct(self) -> bool:
        return np.sqrt((self.head_x - self.tail_x)**2 + (self.head_y - self.tail_y)**2) < 2

    def attach(self, rope) -> None:
        self.attached = rope



def part1(content: List[str]) -> None:
    rope = Rope()
    for line in content:
        instr, nb = line.split()
        nb = int(nb)
        for _ in range(nb):
            if instr == 'R':
                rope.right()
            elif instr == 'L':
                rope.left()
            elif instr == 'U':
                rope.up()
            elif instr == 'D':
                rope.down()

    print("Part1:", len(rope.visited))

def print_grid(size, offset, pos_to_print):
    grid = [['.' for _ in range(size[1])] for _ in range(size[0])]
    for pos in pos_to_print:
        grid[-(pos[1] + offset[1])][pos[0] + offset[0]] = pos[2]
    
    for line in grid:
        for char in line:
            print(char, sep="",end="")
        print("") 

def part2(content : List[str]) -> None:
    knots = []
    for i in range(9):
        knots.append(Rope())
        if i != 0:
            knots[i-1].attach(knots[i])
    for line in content:
        instr, nb = line.split()
        nb = int(nb)
        
        for _ in range(nb):
            if instr == 'R':
                knots[0].right()
            elif instr == 'L':
                knots[0].left()
            elif instr == 'U':
                knots[0].up()
            elif instr == 'D':
                knots[0].down()
    
    print("Part2:", len(knots[-1].visited))

def main():
    with open("input.txt", 'r') as f:
        content = [str.removesuffix('\n') for str in f.readlines()]
        part1(content)
        part2(content)

if __name__ == "__main__":
    main()