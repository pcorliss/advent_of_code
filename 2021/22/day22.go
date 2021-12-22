package main

import (
	"fmt"
	"os"
	"strconv"
	"strings"
)

func main() {
	// Load Input File
	inputStr, err := os.ReadFile("22/input.txt")
	if err != nil {
		panic(err)
	}

	fmt.Println("Day 22")
	fmt.Println("Part 01")
	fmt.Println("Result: ", Part1(string(inputStr)))

	fmt.Println("Part 02")
	fmt.Println("Result: ", Part2(string(inputStr)))
}

type Rge struct {
	x  int
	xp int

	y  int
	yp int

	z  int
	zp int

	state bool
}

func StringToInstructions(input string) []Rge {
	nums := []Rge{}
	lines := strings.Split(input, "\n")
	for _, line := range lines {
		parts := strings.Split(line, " ")
		rge := Rge{}
		rge.state = parts[0] == "on"
		for _, r := range strings.Split(parts[1], ",") {
			pieces := strings.Split(r, "=")
			vals := strings.Split(pieces[1], "..")
			a, _ := strconv.Atoi(vals[0])
			b, _ := strconv.Atoi(vals[1])
			switch pieces[0] {
			case "x":
				rge.x = a
				rge.xp = b
			case "y":
				rge.y = a
				rge.yp = b
			case "z":
				rge.z = a
				rge.zp = b
			default:
				panic("Unhandled piece")
			}
		}
		nums = append(nums, rge)
	}
	return nums
}

type Point struct {
	x int
	y int
	z int
}

func Cubes(insts []Rge, minmax int) int {
	cubes := make(map[Point]bool)
	count := 0
	for _, inst := range insts {
		for x := inst.x; x <= inst.xp; x++ {
			if x > minmax || x < -minmax {
				continue
			}
			for y := inst.y; y <= inst.yp; y++ {
				if y > minmax || y < -minmax {
					continue
				}
				for z := inst.z; z <= inst.zp; z++ {
					if z > minmax || z < -minmax {
						continue
					}

					p := Point{x, y, z}
					if !cubes[p] && inst.state {
						cubes[p] = true
						count++
					} else if cubes[p] && !inst.state {
						cubes[p] = false
						count--
					}
				}
			}
		}
	}
	return count
}

func Part1(input string) int {
	inst := StringToInstructions(input)
	return Cubes(inst, 50)
}

func Part2(input string) int {
	return 0
}
