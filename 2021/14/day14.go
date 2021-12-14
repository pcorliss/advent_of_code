package main

import (
	"fmt"
	"os"
	"strings"
)

func main() {
	// Load Input File
	inputStr, err := os.ReadFile("14/input.txt")
	if err != nil {
		panic(err)
	}

	fmt.Println("Day 14")
	fmt.Println("Part 01")
	fmt.Println("Result: ", Part1(string(inputStr)))

	fmt.Println("Part 02")
	fmt.Println("Result: ", Part2(string(inputStr)))
}

func StringToInstructions(input string) (string, map[string]string) {
	instructions := make(map[string]string)
	start := ""
	lines := strings.Split(input, "\n")
	for i, line := range lines {
		if i == 0 {
			start = line
			continue
		}
		if len(line) == 0 {
			continue
		}
		parts := strings.Split(line, " -> ")
		instructions[parts[0]] = parts[1]
	}
	return start, instructions
}

func Expand(in string, instructions map[string]string) string {
	out := ""
	for i := 0; i < len(in)-1; i++ {
		key := in[i : i+2]
		a := in[i : i+1]
		out += a + instructions[key]
	}
	out += in[len(in)-1:]
	return out
}

func ExpandCommon(input string, steps int) int {
	s, instructions := StringToInstructions(input)
	for i := 0; i < steps; i++ {
		s = Expand(s, instructions)
	}

	charCount := make(map[string]int)
	for i := 0; i < len(s); i++ {
		charCount[s[i:i+1]]++
	}
	min := 0
	minChar := ""
	max := 0
	maxChar := ""
	for k, v := range charCount {
		if min == 0 || min > v {
			minChar, min = k, v
		}
		if max == 0 || max < v {
			maxChar, max = k, v
		}
	}

	// Avoids error when print is commented out
	_ = maxChar
	_ = minChar
	// fmt.Println("Length: ", len(s))
	// fmt.Println("MaxChar:", maxChar, max)
	// fmt.Println("MinChar:", minChar, min)
	return max - min
}

func Part1(input string) int {
	return ExpandCommon(input, 10)
}

func Part2(input string) int {
	return 0
	// return ExpandCommon(input, 40)
}
