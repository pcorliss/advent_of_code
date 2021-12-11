package main

import (
	"fmt"
	"os"
	"strconv"
	"strings"
)

func main() {
	// Load Input File
	inputStr, err := os.ReadFile("11/input.txt")
	if err != nil {
		panic(err)
	}

	fmt.Println("Day 11")
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
	points  map[Point]int
	width   int
	height  int
	flashes int
}

func StringToGrid(input string) Grid {
	points := make(map[Point]int)
	grid := Grid{points, 0, 0, 0}
	lines := strings.Split(input, "\n")
	lastX := 0
	lastY := 0
	for y, line := range lines {
		for x, val := range strings.Split(line, "") {
			n, err := strconv.Atoi(val)
			if err != nil {
				panic(err)
			}
			p := Point{x, y}
			grid.points[p] = n
			lastX = x
		}
		lastY = y
	}
	grid.width = lastX + 1
	grid.height = lastY + 1
	return grid
}

var diffs = []Point{
	{0, -1},  // North
	{1, 0},   // West
	{0, 1},   // South
	{-1, 0},  // East
	{1, -1},  // NE
	{-1, -1}, // NW
	{1, 1},   // SE
	{-1, 1},  // SW
}

func Neighbors(p Point, w int, h int) []Point {
	points := []Point{}
	for _, diff := range diffs {
		if p.x+diff.x >= w || p.x+diff.x < 0 {
			continue
		}
		if p.y+diff.y >= h || p.y+diff.y < 0 {
			continue
		}
		points = append(points, Point{p.x + diff.x, p.y + diff.y})
	}
	return points
}

func Step(g Grid) Grid {
	points := make(map[Point]int, g.width*g.height)
	newGrid := Grid{points, g.width, g.height, g.flashes}
	toFlash := []Point{}
	flashed := make(map[Point]bool)
	for p, val := range g.points {
		points[p] = val + 1
		if points[p] > 9 {
			toFlash = append(toFlash, p)
			// fmt.Println("Initial Pass Flash: ", p)
		}
	}

	for i := 0; i < len(toFlash); i++ {
		p := toFlash[i]
		if flashed[p] {
			continue
		}
		flashed[p] = true
		points[p] = 0
		for _, n := range Neighbors(p, g.width, g.height) {
			if flashed[n] {
				continue
			}
			points[n]++
			if points[n] > 9 {
				// fmt.Println("Second Pass Flash: ", p)
				toFlash = append(toFlash, n)
			}
		}
	}

	newGrid.flashes += len(flashed)
	return newGrid
}

func Part1(input string) int {
	grid := StringToGrid(input)
	for i := 0; i < 100; i++ {
		grid = Step(grid)
	}
	return grid.flashes
}

func Part2(input string) int {
	grid := StringToGrid(input)
	for i := 0; true; i++ {
		lastFlash := grid.flashes
		grid = Step(grid)
		if (grid.flashes - lastFlash) == len(grid.points) {
			return i + 1
		}
		if i > 1000 {
			panic("Too many iterations!!!")
		}
	}
	return 0
}
