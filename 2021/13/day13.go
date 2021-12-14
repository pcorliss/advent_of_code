package main

import (
	"fmt"
	"os"
	"strconv"
	"strings"
)

func main() {
	// Load Input File
	inputStr, err := os.ReadFile("13/input.txt")
	if err != nil {
		panic(err)
	}

	fmt.Println("Day 13")
	fmt.Println("Part 01")
	fmt.Println("Result: ", Part1(string(inputStr)))

	fmt.Println("Part 02")
	fmt.Println("Result: ")
	Part2(string(inputStr))
}

type Point struct {
	x int
	y int
}

type Fold struct {
	axis string
	n    int
}

type Grid struct {
	points map[Point]bool
	folds  []Fold
	width  int
	height int
}

func StringToGrid(input string) Grid {
	points := make(map[Point]bool)
	grid := Grid{points, []Fold{}, 0, 0}
	lines := strings.Split(input, "\n")
	maxX := 0
	maxY := 0
	for _, line := range lines {
		if len(line) == 0 {
			continue
		}
		if strings.HasPrefix(line, "fold along ") {
			parts := strings.Split(line, " ")
			foldParts := strings.Split(parts[2], "=")
			n, err := strconv.Atoi(foldParts[1])
			if err != nil {
				panic(err)
			}
			axis := foldParts[0]
			grid.folds = append(grid.folds, Fold{axis, n})
			continue
		}
		parts := strings.Split(line, ",")
		x, err := strconv.Atoi(parts[0])
		if err != nil {
			panic(err)
		}
		y, err := strconv.Atoi(parts[1])
		if err != nil {
			panic(err)
		}

		if x > maxX {
			maxX = x
		}
		if y > maxY {
			maxY = y
		}

		p := Point{x, y}
		grid.points[p] = true
	}
	grid.width = maxX + 1
	grid.height = maxY + 1
	return grid
}

func GridToString(g Grid) string {
	out := ""
	for y := 0; y < g.height; y++ {
		for x := 0; x < g.width; x++ {
			if g.points[Point{x, y}] {
				out += "#"
			} else {
				out += "."
			}
		}
		if y < g.height-1 {
			out += "\n"
		}
	}
	return out
}

func FoldGrid(g Grid) Grid {
	fold, folds := g.folds[0], g.folds[1:]
	points := make(map[Point]bool)
	newGrid := Grid{points, folds, g.width, g.height}

	if fold.axis == "y" {
		newGrid.height = fold.n
	} else {
		newGrid.width = fold.n
	}

	for p := range g.points {
		x := p.x
		y := p.y
		if fold.axis == "y" && y > fold.n {
			diff := y - fold.n
			y = fold.n - diff
		}
		if fold.axis == "x" && x > fold.n {
			diff := x - fold.n
			x = fold.n - diff
		}
		newGrid.points[Point{x, y}] = true
		// fmt.Println("Point: ", x, y)
	}

	return newGrid
}

func Part1(input string) int {
	g := StringToGrid(input)
	g = FoldGrid(g)
	return len(g.points)
}

func Part2(input string) {
	g := StringToGrid(input)
	for range g.folds {
		// fmt.Println(i, ":")
		g = FoldGrid(g)
		// fmt.Println(GridToString(g))
	}
	fmt.Println(GridToString(g))
}
