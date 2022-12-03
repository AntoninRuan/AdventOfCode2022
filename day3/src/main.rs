use std::fs::File;
use std::io::{BufRead, BufReader};

fn main() {
    let filename = "input.txt";

    let file = File::open(filename).unwrap();
    let reader = BufReader::new(file);

    let mut lines = Vec::new();

    for line in reader.lines() {
        lines.push(line.unwrap());
    }

    part1(&lines);
    part2(&lines)

}

fn calc_char_value(c : char) -> u32 {
    let value: u32;

    if c as u32 > 90 { // char lowercase
        value = c as u32 - 'a' as u32 + 1;
    } else { // char uppercase
        value = c as u32 - 'A' as u32 + 27;
    }
    return value;
}

fn part1(lines: &Vec<String>) {

    let mut sum = 0;

    for line in lines {
        let chars: Vec<char> = line.chars().collect();

        let half = chars.len() / 2;

        let mut left: Vec<char> = Vec::new();
        let mut right: Vec<char> = Vec::new();
        for (i, c) in chars.iter().enumerate() {
            if i < half {
                left.push(*c);
            } else {
                right.push(*c)
            }
        }

        let mut common: char = 'a';
        for c in left {
            if right.contains(&c) {
                common = c;
            }
        }

        sum += calc_char_value(common);

    }

    println!("Part 1: {}", sum);

}

fn part2 (lines: &Vec<String>) {

    let mut current_group = ["", "", ""];
    let mut sum = 0;

    for (index, line) in lines.iter().enumerate() {

        if index % 3 == 2 { // End of group
            current_group[index % 3] = line;
            let mut common: char = 'a';
            for c in current_group[0].chars() {
                if current_group[1].contains(c) && current_group[2].contains(c) {
                    common = c;
                }
            }

            sum += calc_char_value(common);

        } else { // Middle of group
            current_group[index % 3] = line;
        }

    }

    println!("Part 2: {}", sum);

}