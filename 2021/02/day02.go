package main

import (
	"fmt"
	"os"
	"strconv"
	"strings"
)

func main() {
	// Load Input File
	inputStr, err := os.ReadFile("02/input.txt")
	if err != nil {
		panic(err)
	}

	fmt.Println("Day 02")
	fmt.Println("Part 01")
	fmt.Println("Result: ", Part1(string(inputStr)))

	fmt.Println("Part 02")
	fmt.Println("Result: ", Part2(string(inputStr)))
}

type Dir struct {
	dir string
	mag int
}

func StringToDirs(input string) []Dir {
	out := []Dir{}
	lines := strings.Split(input, "\n")
	for _, val := range lines {
		segments := strings.Split(val, " ")
		n, err := strconv.Atoi(segments[1])
		if err != nil {
			panic(err)
		}
		out = append(out, Dir{segments[0], n})
	}
	return out
}

func Part1(input string) int {
	directions := StringToDirs(input)
	depth := 0
	pos := 0
	for _, direction := range directions {
		switch direction.dir {
		case "up":
			depth -= direction.mag
		case "down":
			depth += direction.mag
		case "forward":
			pos += direction.mag
		}
	}
	fmt.Println("Pos: ", pos, "Depth: ", depth)
	return depth * pos
}

func Part2(input string) int {
	directions := StringToDirs(input)
	depth := 0
	pos := 0
	aim := 0
	for _, direction := range directions {
		switch direction.dir {
		case "up":
			aim -= direction.mag
		case "down":
			aim += direction.mag
		case "forward":
			pos += direction.mag
			depth += direction.mag * aim
		}
	}
	fmt.Println("Pos: ", pos, "Depth: ", depth, "Aim: ", aim)
	return depth * pos
}
