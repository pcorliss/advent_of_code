package main

import (
	"fmt"
	"os"
	"strings"
)

func main() {
	// Load Input File
	inputStr, err := os.ReadFile("12/input.txt")
	if err != nil {
		panic(err)
	}

	fmt.Println("Day 12")
	fmt.Println("Part 01")
	fmt.Println("Result: ", Part1(string(inputStr)))

	fmt.Println("Part 02")
	fmt.Println("Result: ", Part2(string(inputStr)))
}

func smallCave(name string) bool {
	chars := strings.Split(name, "")
	return chars[0] == strings.ToLower(chars[0])
}

func largeCave(name string) bool {
	return !smallCave(name)
}

type Edge struct {
	a string
	b string
}

type Graph struct {
	edges map[Edge]bool
}

func StringToGraph(input string) Graph {
	graph := Graph{make(map[Edge]bool)}
	lines := strings.Split(input, "\n")
	for _, line := range lines {
		parts := strings.Split(line, "-")
		a, b := parts[0], parts[1]
		graph.edges[Edge{a, b}] = true
		if a != "start" && b != "end" {
			graph.edges[Edge{b, a}] = true
		}
	}
	return graph
}

func Part1(input string) int {
	return 0
}

func Part2(input string) int {
	return 0
}
