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
	margin := 3
	for y := g.min.y - margin; y <= g.max.y+margin; y++ {
		for x := g.min.x - margin; x <= g.max.x+margin; x++ {
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

func TrimBorder(g Grid) Grid {
	trimmedMin := false
	trimmedMax := false

	for i := 0; !trimmedMin || !trimmedMax; i++ {
		minP := Point{g.min.x + i, g.min.y + i}
		maxP := Point{g.max.x - i, g.max.y - i}
		if !trimmedMin && !g.points[minP] {
			g.min = minP
			trimmedMin = true
		}
		if !trimmedMax && !g.points[maxP] {
			g.max = maxP
			trimmedMax = true
		}
	}
	return g
}

func TrimBorderMargin(g Grid, margin int) Grid {
	g.min = Point{g.min.x + margin, g.min.y + margin}
	g.max = Point{g.max.x - margin, g.max.y - margin}
	return g
}

func CountTrimmedGrid(g Grid) int {
	count := 0
	for y := g.min.y; y <= g.max.y; y++ {
		for x := g.min.x; x <= g.max.x; x++ {
			if g.points[Point{x, y}] {
				count++
			}
		}
	}
	return count
}

// ######
// ######
// ######
// ###
// ###
// ###

// ......
// ......
// ..XXXX
// ..X
// ..X
// ..X

// 5960 - too high
// 8194 - too high (after trimming)
// 5786
func Part1(input string) int {
	lookup, grid := StringToGrid(input)
	grid = Step(grid, lookup)
	// fmt.Println("Step1:")
	// fmt.Println(GridToString(grid))
	grid = Step(grid, lookup)
	grid = TrimBorder(grid)
	// fmt.Println("Step2:")
	// fmt.Println(GridToString(grid))
	return CountTrimmedGrid(grid)
}

// 82760 - too high
// 19058 - too high
// 12287 - too low
// 16757
func Part2(input string) int {
	lookup, grid := StringToGrid(input)
	for i := 0; i < 50; i++ {
		grid = Step(grid, lookup)
		if i%2 == 0 && lookup[0] {
			grid = TrimBorderMargin(grid, 4)
		}
	}
	// fmt.Println("Step1:")
	// fmt.Println(GridToString(grid))
	// fmt.Println("Step2:")
	// fmt.Println(GridToString(grid))
	return CountTrimmedGrid(grid)
}
