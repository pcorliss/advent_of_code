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
		a, _ := strconv.Atoi(tRange[0])
		b, _ := strconv.Atoi(tRange[1])
		if a > b {
			fmt.Println(pieces, a, b)
			panic("Out of Order")
			// tRange[0], tRange[1] = tRange[1], tRange[0]
		}
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
		if p.x > t.x_end || p.y < t.y_start {
			return false, 0
		}
	}
}

func MaxVel(t Target) (Point, int, int) {
	maxPoint := Point{}
	minX, maxX := 0, 0
	minY, maxYY := 0, 0
	maxY := 0
	count := 0
	// fmt.Println(t.x_end, -t.y_start, t)
	for x := 0; x <= t.x_end; x++ {
		for y := t.y_start; y <= -t.y_start; y++ {
			boo, max := IntersectsTarget(Point{x, y}, t)
			if boo {
				// fmt.Println("Intersection:", max, maxY, x, y)
				if minX == 0 || x < minX {
					minX = x
				}
				if minY == 0 || y < minY {
					minY = y
				}
				if maxX == 0 || x > maxX {
					maxX = x
				}
				if maxYY == 0 || y > maxYY {
					maxYY = y
				}
			}
			if boo {
				count++
			}
			if boo && max > maxY {
				maxY = max
				maxPoint = Point{x, y}
			}
		}
	}
	// fmt.Println(minX, maxX, minY, maxYY)
	return maxPoint, maxY, count
}

func Part1(input string) int {
	target := StringToTarget(input)
	_, maxY, _ := MaxVel(target)
	return maxY
}

func Part2(input string) int {
	target := StringToTarget(input)
	_, _, count := MaxVel(target)
	return count
}
