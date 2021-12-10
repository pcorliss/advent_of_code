package main

import (
	"fmt"
	"os"
	"strings"
)

func main() {
	// Load Input File
	inputStr, err := os.ReadFile("10/input.txt")
	if err != nil {
		panic(err)
	}

	fmt.Println("Day 10")
	fmt.Println("Part 01")
	fmt.Println("Result: ", Part1(string(inputStr)))

	fmt.Println("Part 02")
	fmt.Println("Result: ", Part2(string(inputStr)))
}

func LinesToChars(input string) [][]string {
	out := [][]string{}
	lines := strings.Split(input, "\n")
	for _, line := range lines {
		chars := strings.Split(line, "")
		out = append(out, chars)
	}
	return out
}

var pair = map[string]string{
	"]": "[",
	")": "(",
	">": "<",
	"}": "{",
	"[": "]",
	"(": ")",
	"<": ">",
	"{": "}",
}

func Corrupt(line []string) string {
	str := ""
	stack := []string{}
	for _, char := range line {
		switch char {
		case "[", "(", "{", "<":
			stack = append(stack, char)
		case "]", ")", "}", ">":
			last_idx := len(stack) - 1
			// fmt.Println("Stack: ", stack, "Char: ", char)
			if stack[last_idx] == pair[char] {
				stack = stack[:last_idx]
				// fmt.Println("Popped Stack: ", stack)
			} else {
				// fmt.Println("Wrong Char, expected:", pair[stack[last_idx]], "Got: ", pair[char], char)
				return char
			}
		default:
			panic("Unhandled char")
		}
	}
	return str
}

var scoreLookup = map[string]int{
	"]": 57,
	")": 3,
	">": 25137,
	"}": 1197,
}

func Part1(input string) int {
	score := 0
	for _, chars := range LinesToChars(input) {
		char := Corrupt(chars)
		// fmt.Println("Line: ", chars, "Corrupt:", char, "Score: ", scoreLookup[char])
		score += scoreLookup[char]
	}

	return score
}

func Part2(input string) int {
	return 0
}
