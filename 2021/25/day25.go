package main

import (
	"fmt"
	"os"
	"strings"
)

func main() {
	// Load Input File
	inputStr, err := os.ReadFile("25/input.txt")
	if err != nil {
		panic(err)
	}

	fmt.Println("Day 25")
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
	points map[Point]int
	min    Point
	max    Point
}

func StringToGrid(input string) Grid {
	grid := Grid{make(map[Point]int), Point{0, 0}, Point{0, 0}}
	for y, line := range strings.Split(input, "\n") {
		for x, val := range strings.Split(line, "") {
			switch val {
			case "v":
				grid.points[Point{x, y}] = 1
			case ">":
				grid.points[Point{x, y}] = 2
			default:
			}
			if grid.max.x < x {
				grid.max.x = x
			}
			if grid.max.y < y {
				grid.max.y = y
			}
		}
	}
	return grid
}

func GridToString(g Grid) string {
	lines := make([]string, g.max.y-g.min.y+1)
	for y, yIdx := g.min.y, 0; y <= g.max.y; y++ {
		lines[yIdx] = ""
		for x := g.min.x; x <= g.max.x; x++ {
			val := g.points[Point{x, y}]
			switch val {
			case 1:
				lines[yIdx] += "v"
			case 2:
				lines[yIdx] += ">"
			default:
				lines[yIdx] += "."
			}
		}
		yIdx++
	}

	return strings.Join(lines, "\n")
}

func Step(g Grid) (Grid, int) {
	// East Facing Consider
	steps := 0
	newGrid := Grid{make(map[Point]int), g.min, g.max}
	for pos, val := range g.points {
		if val == 2 {
			newX := (pos.x + 1) % (g.max.x + 1)
			newPos := Point{newX, pos.y}
			if _, exists := g.points[newPos]; exists {
				newGrid.points[pos] = val
			} else {
				newGrid.points[newPos] = val
				steps++
			}
		} else {
			newGrid.points[pos] = val
		}
	}
	g = newGrid
	newGrid = Grid{make(map[Point]int), g.min, g.max}
	for pos, val := range g.points {
		if val == 1 {
			newY := (pos.y + 1) % (g.max.y + 1)
			newPos := Point{pos.x, newY}
			if _, exists := g.points[newPos]; exists {
				newGrid.points[pos] = val
			} else {
				newGrid.points[newPos] = val
				steps++
			}
		} else {
			newGrid.points[pos] = val
		}
	}

	// East Facing Move
	// South Facing Consider
	// South Facing Move
	return newGrid, steps
}

func Part1(input string) int {
	prevSteps := -1
	grid := StringToGrid(input)
	i := 0
	for i = 0; i < 1000 && prevSteps != 0; i++ {
		grid, prevSteps = Step(grid)
	}

	return i
}

func Part2(input string) int {
	return 0
}
