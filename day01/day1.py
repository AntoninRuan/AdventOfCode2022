def generate_inv(content):
    elf_invs = []
    current_inv = []
    for line in content:
        if line:
            current_inv.append(int(line))
        else:
            elf_invs.append(current_inv)
            current_inv = []
    elf_invs.append(current_inv)
    return elf_invs

def part1(content):
    elf_invs = generate_inv(content)
    total_carry = [sum(inv) for inv in elf_invs]
    print(max(total_carry))
    part2(total_carry)

def part2(total_carry):
    sor = sorted(total_carry)[::-1]
    result = sum(sor[0:3])
    print(result)


def main():
    with open("input.txt", 'r') as file:
        content = file.readlines()
        content = [str.removesuffix('\n') for str in content]
        part1(content)


if __name__ == "__main__":
    main()
