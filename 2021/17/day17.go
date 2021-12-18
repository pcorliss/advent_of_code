package main

import (
	"fmt"
	"os"
	"strconv"
	"strings"
)

func main() {
	// Load Input File
	inputStr, err := os.ReadFile("17/input.txt")
	if err != nil {
		panic(err)
	}

	fmt.Println("Day 17")
	fmt.Println("Part 01")
	fmt.Println("Result: ", Part1(string(inputStr)))

	fmt.Println("Part 02")
	fmt.Println("Result: ", Part2(string(inputStr)))
}

type Point struct {
	x int
	y int
}

type Target struct {
	x_start int
	x_end   int
	y_start int
	y_end   int
}

func StringToTarget(input string) Target {
	target := Target{}
	targets := strings.Split(input, ": ")
	parts := strings.Split(targets[1], ", ")
	for _, part := range parts {
		pieces := strings.Split(part, "=")
		tRange := strings.Split(pieces[1], "..")
		if tRange[0] > tRange[1] {
			tRange[0], tRange[1] = tRange[1], tRange[0]
		}
		a, _ := strconv.Atoi(tRange[0])
		b, _ := strconv.Atoi(tRange[1])
		if pieces[0] == "x" {
			target.x_start = a
			target.x_end = b
		} else {
			target.y_start = a
			target.y_end = b
		}
	}
	return target
}

func PointInTarget(p Point, t Target) bool {
	return p.x >= t.x_start && p.x <= t.x_end && p.y >= t.y_start && p.y <= t.y_end
}

func IntersectsTarget(vel Point, t Target) (bool, int) {
	p := Point{0, 0}
	i := 0
	maxY := 0
	for {
		p.x += vel.x
		p.y += vel.y
		if p.y > maxY {
			maxY = p.y
		}
		vel.y--
		if vel.x > 0 {
			vel.x--
		} else if vel.x < 0 {
			vel.x++
		}
		// fmt.Println("P:", p, "Vel:", vel, "Tar:", t)
		if PointInTarget(p, t) {
			// fmt.Println("Intersects!")
			return true, maxY
		}
		i++
		// if i > 160 {
		// 	panic("Too many iterations!!!")
		// }
		if p.x > t.x_end || p.y < t.y_end {
			return false, 0
		}
	}
}

func MaxVel(t Target) (Point, int) {
	maxPoint := Point{}
	maxY := 0
	fmt.Println(t.x_end, -t.y_start, t)
	for x := 0; x < t.x_end; x++ {
		for y := 0; y < -t.y_start; y++ {
			boo, max := IntersectsTarget(Point{x, y}, t)
			// if boo {
			// 	fmt.Println("Intersection:", max, maxY, x, y)
			// }
			if boo && max > maxY {
				maxY = max
				maxPoint = Point{x, y}
			}
		}
	}
	return maxPoint, maxY
}

func Part1(input string) int {
	target := StringToTarget(input)
	_, maxY := MaxVel(target)
	return maxY
}

func Part2(input string) int {
	return 0
}
