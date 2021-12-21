package main

import (
	"fmt"
	"os"
	"strings"
)

func main() {
	// Load Input File
	inputStr, err := os.ReadFile("20/input.txt")
	if err != nil {
		panic(err)
	}

	fmt.Println("Day 20")
	fmt.Println("Part 01")
	fmt.Println("Result: ", Part1(string(inputStr)))

	fmt.Println("Part 02")
	fmt.Println("Result: ", Part2(string(inputStr)))
}

type Point struct {
	x int
	y int
}

type Grid struct {
	points map[Point]bool
	min    Point
	max    Point
}

func StringToGrid(input string) ([512]bool, Grid) {
	grid := Grid{make(map[Point]bool), Point{}, Point{}}
	lookup := [512]bool{}
	lines := strings.Split(input, "\n")
	for i, line := range lines {
		if i == 0 {
			for j, val := range strings.Split(line, "") {
				lookup[j] = val == "#"
			}
			continue
		}
		if i == 1 {
			continue
		}

		y := i - 2
		grid.min.x = 0
		grid.min.y = 0
		for x, val := range strings.Split(line, "") {
			grid.points[Point{x, y}] = val == "#"
			if grid.max.x < x {
				grid.max.x = x
			}
			if grid.max.y < y {
				grid.max.y = y
			}
		}
	}
	return lookup, grid
}

var diffs = []Point{
	{-1, -1}, // NW
	{0, -1},  // North
	{1, -1},  // NE
	{-1, 0},  // East
	{0, 0},   // Self
	{1, 0},   // West
	{-1, 1},  // SW
	{0, 1},   // South
	{1, 1},   // SE
}

func Neighbors(p Point) []Point {
	points := []Point{}
	for _, diff := range diffs {
		points = append(points, Point{p.x + diff.x, p.y + diff.y})
	}
	return points
}

func GridToString(g Grid) string {
	lines := make([]string, g.max.y-g.min.y+1)
	for y, yIdx := g.min.y, 0; y <= g.max.y; y++ {
		lines[yIdx] = ""
		for x := g.min.x; x <= g.max.x; x++ {
			if g.points[Point{x, y}] {
				lines[yIdx] += "#"
			} else {
				lines[yIdx] += "."
			}
		}
		yIdx++
	}

	return strings.Join(lines, "\n")
}

func Step(g Grid, l [512]bool) Grid {
	newGrid := Grid{make(map[Point]bool), Point{}, Point{}}
	for y := g.min.y - 1; y <= g.max.y+1; y++ {
		for x := g.min.x - 1; x <= g.max.x+1; x++ {
			bin := 0
			p := Point{x, y}
			for i, n := range Neighbors(p) {
				if g.points[n] {
					bin += 1 << (8 - i)
				}
			}
			if l[bin] {
				newGrid.points[p] = true
				if newGrid.max.x < p.x {
					newGrid.max.x = p.x
				}
				if newGrid.max.y < p.y {
					newGrid.max.y = p.y
				}
				if newGrid.min.x > p.x {
					newGrid.min.x = p.x
				}
				if newGrid.min.y > p.y {
					newGrid.min.y = p.y
				}
			}
		}
	}
	return newGrid
}

func Part1(input string) int {
	lookup, grid := StringToGrid(inputStr)
	grid = Step(grid, lookup)
	grid = Step(grid, lookup)
	return len(grid.points)
}

func Part2(input string) int {
	return 0
}
