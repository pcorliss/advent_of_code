package main

import (
	"fmt"
	"os"
	"sort"
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

// Totally uneccessary
func ReverseStack(stack []string) []string {
	l := len(stack)
	for i := 0; i < l/2; i++ {
		stack[i], stack[l-i-1] = stack[l-i-1], stack[i]
	}
	return stack
}

func FinishLine(line []string) []string {
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
				panic("Corrupted Line")
			}
		default:
			panic("Unhandled char")
		}
	}
	closingStack := []string{}
	l := len(stack)
	for i := l - 1; i >= 0; i-- {
		closingStack = append(closingStack, pair[stack[i]])
	}
	return closingStack
}

var stackScoreLookup = map[string]int{
	"]": 2,
	")": 1,
	">": 4,
	"}": 3,
}

func StackScore(stack []string) int {
	score := 0
	for _, char := range stack {
		score *= 5
		score += stackScoreLookup[char]
	}
	return score
}

func Part2(input string) int {
	// Discard Corrupt Lines
	scores := []int{}
	for _, chars := range LinesToChars(input) {
		char := Corrupt(chars)
		if len(char) == 0 {
			stack := FinishLine(chars)
			score := StackScore(stack)
			scores = append(scores, score)
		}
	}

	l := len(scores)
	sort.Slice(scores, func(i, j int) bool {
		return scores[i] > scores[j]
	})
	mid := scores[l/2]

	return mid
}
