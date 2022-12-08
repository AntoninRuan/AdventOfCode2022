package day08;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.stream.Collectors;

public class day8 {

    public static void main(String[] args) {
        
        File file = new File("day08/example.txt");
        
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(new FileInputStream(file)))) {
            
            String lines[] = reader.lines().collect(Collectors.toList()).toArray(String[]::new);
    
            
            int[][] grid = new int[lines.length][lines[0].length()];

            for (int i = 0; i < lines.length; i ++) {
                for (int j = 0; j < lines[i].length(); j ++) {
                    grid[i][j] = Integer.parseInt(String.valueOf(lines[i].charAt(j)));
                }
            }

            part1(grid);
            part2(grid);

        } catch (IOException e){
            e.printStackTrace();
        }
        
    }

    private static void part1(int[][] grid) {
        int result = 0;
        for (int i = 0; i < grid.length; i ++) {
            for (int j = 0; j < grid[i].length; j ++) {
                if (isVisible(grid, i, j))
                    result ++;
            }
        }
        
        System.out.println("Part1: " + result);
    }

    private static Pair<Boolean, Integer> isVisibleTop(int[][] grid, int x, int y) {
        int value = grid[x][y];
        if (x == 0)
            return new Pair<Boolean, Integer>(true, 0);

        for (int i = x-1; i >= 0; i --) {
            if (grid[i][y] >= value) 
                return new Pair<Boolean,Integer>(false, x - i);
        }

        return new Pair<Boolean,Integer>(true, x);
    }

    private static Pair<Boolean, Integer> isVisibleBottom(int[][] grid, int x, int y) {
        int value = grid[x][y];
        if (x == grid.length - 1)
            return new Pair<Boolean,Integer>(true, 0);

        for (int i = x+1; i < grid.length; i ++) {
            if (grid[i][y] >= value)
                return new Pair<Boolean,Integer>(false, i-x);
        }

        return new Pair<Boolean,Integer>(true, grid.length - 1 - x);
    }

    private static Pair<Boolean, Integer> isVisibleRight(int[][] grid, int x, int y) {
        int value = grid[x][y];
        if(y == grid[x].length - 1)
            return new Pair<Boolean,Integer>(true, 0);

        for (int j = y + 1; j < grid[x].length; j ++) {
            if (grid[x][j] >= value)
                return new Pair<Boolean,Integer>(false, j-y);
        }

        return new Pair<Boolean,Integer>(true, grid[x].length - 1 - y);
    }

    private static Pair<Boolean, Integer> isVisibleLeft(int[][] grid, int x, int y) {
        int value = grid[x][y];
        if (y == 0)
            return new Pair<Boolean,Integer>(true, 0);

        for (int j = y - 1; j >= 0; j --) {
            if (grid[x][j] >= value)
                return new Pair<Boolean,Integer>(false, y-j);
        }
        return new Pair<Boolean,Integer>(true, y);
    }

    private static boolean isVisible(int[][] grid, int x, int y) {
        return isVisibleTop(grid, x, y).getKey() || isVisibleBottom(grid, x, y).getKey() || isVisibleLeft(grid, x, y).getKey() || isVisibleRight(grid, x, y).getKey();
    }

    private static void part2(int[][] grid) {
        int max = Integer.MIN_VALUE;
        for (int i = 0; i < grid.length; i ++) {
            for(int j = 0; j < grid[i].length; j ++) {
                int tmp = scenicScore(grid, i, j);
                if (tmp > max)
                    max = tmp;
            }
        }
        
        System.out.println("Part2: " + max);
    }
    
    private static int scenicScore(int[][] grid, int x, int y) {
        return isVisibleTop(grid, x, y).getValue() * isVisibleBottom(grid, x, y).getValue() * isVisibleLeft(grid, x, y).getValue() * isVisibleRight(grid, x, y).getValue();
    }

}