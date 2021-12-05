package main

import (
	"fmt"
	"os"
	"strconv"
	"strings"
)

func main() {
	// Load Input File
	inputStr, err := os.ReadFile("05/input.txt")
	if err != nil {
		panic(err)
	}

	fmt.Println("Day 05")
	fmt.Println("Part 01")
	fmt.Println("Result: ", Part1(string(inputStr)))

	fmt.Println("Part 02")
	fmt.Println("Result: ", Part2(string(inputStr)))
}

type Point struct {
	x int
	y int
}

type Line struct {
	a Point
	b Point
}

func quickInt(str string) int {
	n, err := strconv.Atoi(str)
	if err != nil {
		panic(err)
	}
	return n
}

func StringToLines(input string) []Line {
	lines := []Line{}
	strLines := strings.Split(input, "\n")
	for _, strLine := range strLines {
		points := strings.Split(strLine, " -> ")
		coordsA := strings.Split(points[0], ",")
		a := Point{quickInt(coordsA[0]), quickInt(coordsA[1])}
		coordsB := strings.Split(points[1], ",")
		b := Point{quickInt(coordsB[0]), quickInt(coordsB[1])}
		lines = append(lines, Line{a, b})
	}
	return lines
}

func Part1(input string) int {
	lines := StringToLines(input)
	pointCount := make(map[Point]int)

	for _, line := range lines {
		if line.a.x == line.b.x {
			yA := line.a.y
			yB := line.b.y
			if yA > yB {
				yA, yB = yB, yA
			}
			for y := yA; y <= yB; y++ {
				pointCount[Point{line.a.x, y}]++
			}
		} else if line.a.y == line.b.y {
			xA := line.a.x
			xB := line.b.x
			if xA > xB {
				xA, xB = xB, xA
			}
			for x := xA; x <= xB; x++ {
				pointCount[Point{x, line.a.y}]++
			}
		}
	}

	intersections := 0
	for _, count := range pointCount {
		if count > 1 {
			intersections++
		}
	}

	return intersections
}

func Part2(input string) int {
	lines := StringToLines(input)
	pointCount := make(map[Point]int)

	for _, line := range lines {
		if line.a.x == line.b.x {
			yA := line.a.y
			yB := line.b.y
			if yA > yB {
				yA, yB = yB, yA
			}
			for y := yA; y <= yB; y++ {
				pointCount[Point{line.a.x, y}]++
			}
		} else if line.a.y == line.b.y {
			xA := line.a.x
			xB := line.b.x
			if xA > xB {
				xA, xB = xB, xA
			}
			for x := xA; x <= xB; x++ {
				pointCount[Point{x, line.a.y}]++
			}
		} else {
			// fmt.Println("Diag:", line)
			xA := line.a.x
			xB := line.b.x
			xDir := 1
			if xA > xB {
				xDir = -1
			}
			yA := line.a.y
			yB := line.b.y
			yDir := 1
			if yA > yB {
				yDir = -1
			}
			for x, y := xA, yA; x != xB && y != yB; x, y = x+xDir, y+yDir {
				pointCount[Point{x, y}]++
				// fmt.Println(x, y)
			}
			pointCount[Point{xB, yB}]++
		}
	}

	intersections := 0
	for _, count := range pointCount {
		if count > 1 {
			intersections++
		}
	}

	return intersections
}
