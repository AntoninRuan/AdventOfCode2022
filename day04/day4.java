package day04;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.stream.Collectors;

public class day4 {

    public static void main(String... args) {

        File file = new File("day04/input.txt");
        
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(new FileInputStream(file)))) {
            
            String lines[] = reader.lines().collect(Collectors.toList()).toArray(String[]::new);
    
            part1(lines);
            part2(lines);
        } catch (IOException e){
            e.printStackTrace();
        }
    
    }

    private static int[] rangeToBounds(String range) {
        String[] splitted = range.split("-");
        return new int[] {Integer.parseInt(splitted[0]), Integer.parseInt(splitted[1])};
    }

    private static boolean contains(String range1, String range2) {
        int[] r1 = rangeToBounds(range1);
        int[] r2 = rangeToBounds(range2);

        return r1[0] <= r2[0] && r1[1] >= r2[1];
    }

    private static void part1(String[] lines) {

        int result = 0;

        for (String line : lines) {

            String[] pair = line.split(",");
            if (contains(pair[0], pair[1]) || contains(pair[1], pair[0]))
                result += 1;

        }

        System.out.println("Part1: " + result);

    }

    private static boolean overlap(String range1, String range2) {
        int[] r1 = rangeToBounds(range1), r2 = rangeToBounds(range2);

        return (r1[1] >= r2[0] && r1[0] <= r2[0]) || (r2[1] >= r1[0] && r2[0] <= r1[0]);
    }

    private static void part2(String[] lines) {
        int result = 0;
        for (String line : lines) {
            String[] pair = line.split(",");
            if (overlap(pair[0], pair[1]))
                result += 1;
        }

        System.out.println("Part2: " + result);
    }

}