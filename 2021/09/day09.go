package main

import (
	"fmt"
	"os"
	"strconv"
	"strings"
)

func main() {
	// Load Input File
	inputStr, err := os.ReadFile("09/input.txt")
	if err != nil {
		panic(err)
	}

	fmt.Println("Day 09")
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
	width  int
	height int
}

func StringToGrid(input string) Grid {
	points := make(map[Point]int)
	grid := Grid{points, 0, 0}
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

func Neighbors(p Point, w int, h int) []Point {
	points := []Point{}
	diffs := []Point{
		{0, -1}, // North
		{1, 0},  // West
		{0, 1},  // South
		{-1, 0}, // East
	}
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

func LowPoints(g Grid) []Point {
	low := []Point{}
	for p, v := range g.points {
		count := 0
		neig := Neighbors(p, g.width, g.height)
		for _, n := range neig {
			if g.points[n] > v {
				count++
			}
		}
		// fmt.Println("P:", p, "V:", v, "N:", neig, "C:", count)
		if len(neig) == count {
			low = append(low, p)
		}
	}
	return low
}

func Part1(input string) int {
	risk := 0
	g := StringToGrid(input)
	low := LowPoints(g)
	for _, l := range low {
		risk += g.points[l] + 1
	}
	return risk
}

func Part2(input string) int {
	return 0
}
