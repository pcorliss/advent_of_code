package main

import (
	"fmt"
	"os"
	"strings"
)

func main() {
	// Load Input File
	inputStr, err := os.ReadFile("08/input.txt")
	if err != nil {
		panic(err)
	}

	fmt.Println("Day 08")
	fmt.Println("Part 01")
	fmt.Println("Result: ", Part1(string(inputStr)))

	fmt.Println("Part 02")
	fmt.Println("Result: ", Part2(string(inputStr)))
}

type signal struct {
	sigs []string
	outs []string
}

func StringToSignals(input string) []signal {
	signals := []signal{}
	lines := strings.Split(input, "\n")
	for _, line := range lines {
		parts := strings.Split(line, " | ")
		signals_slice := strings.Split(parts[0], " ")
		output_slice := strings.Split(parts[1], " ")
		s := signal{signals_slice, output_slice}
		signals = append(signals, s)
	}
	return signals
}

func Part1(input string) int {
	signals := StringToSignals(input)
	count := 0
	for _, s := range signals {
		for _, out := range s.outs {
			l := len(out)
			if l == 7 || l == 2 || l == 3 || l == 4 {
				count++
			}
		}
	}
	return count
}

func Part2(input string) int {
	return 0
}
